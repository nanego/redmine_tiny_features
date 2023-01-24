Deface::Override.new :virtual_path  => 'issues/_action_menu_edit',
                       :name          => 'prevents-render-edit-partial-render-it-only-on-click-button-edit',
                       :replace       => "erb[loud]:contains(\"render :partial => 'edit'\")",
                       :text          => <<-RENDER_PARTIAL
<% # Put the condition here, not at the beginning of the file, so that we can check the configuration each time we download the page,
 # if we put the condition at the beginning of the file it does not execute only once, (start application) %>
<% if Setting.plugin_redmine_tiny_features.key?('load_issue_edit') %>

  <script>
    // override this method,for calling renderPartialEdit before it, only in case of link edit
    function showAndScrollTo(id, focus) {
      if (id =='update'){
        renderPartialEdit(id);
      } else {
        $('#'+id).show();
      }      
      if (focus !== null) {
        $('#'+focus).focus();
      }
      $('html, body').animate({scrollTop: $('#'+id).offset().top}, 100);
    }

    function renderPartialEdit(id){
      $.ajax({
        url: "<%= render_form_by_ajax_path(@issue.id) %>",
        success: function(response) {
          $('#update').append(response.html);
          // to avoid displaying the edit label before the render form
          $('#'+id).show();
          $( document ).ready(function() {
            // for datepicker element, 
            <% include_calendar_headers_tags %>
            // for wikitoolbar element in mode Textile,
            setupFileDrop();
            // But for mode visual there is no need to call because it is already called in { $(document).ajaxSuccess/redmine_wysiwyg_editor }
          });
        },error: function(response) {
          console.error(response);
        },
      });
      
    } 
  </script>
<% else %>
  <%= render :partial => 'edit' %>
<% end %>
RENDER_PARTIAL
