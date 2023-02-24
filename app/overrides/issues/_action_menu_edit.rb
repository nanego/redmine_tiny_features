Deface::Override.new :virtual_path  => 'issues/_action_menu_edit',
                     :name          => 'prevents-render-edit-partial-render-it-only-on-edit-button-click',
                     :replace       => "erb[loud]:contains(\"render :partial => 'edit'\")",
                     :text          => <<-RENDER_PARTIAL
<% unless Setting.plugin_redmine_tiny_features.key?('load_issue_edit_form_asynchronously') %>
  <%= render :partial => 'edit' %>
<% else %>
  <%# These header tags are not included if the partial is not preloaded %>
  <% content_for :header_tags do %>
    <%= javascript_include_tag 'attachments' %>
  <% end %>
  <script>
    function loadIssueEditForm(id){
      if ($('#issue-form').length < 1) {
        $.ajax({
          url: "<%= render_form_by_ajax_path(@issue.id) %>",
          beforeSend: function(){
            $('#ajax-indicator').addClass('bottom');
          },
          success: function(response) {
            $('#ajax-indicator').removeClass('bottom');
            if(response){
              $('#update').append(response.html);
              $(document).ready(function() {
                // for datepicker element,
                <% include_calendar_headers_tags %>
                // for wikitoolbar element in mode Textile,
                setupFileDrop();
                // But for mode visual there is no need to call because it is already called in { $(document).ajaxSuccess/redmine_wysiwyg_editor }
              });
            }
          },error: function(response) {
            $('#ajax-indicator').removeClass('bottom');
            console.error(response);
          },
        });
      }
    }
    $(document).ready(function() {
      loadIssueEditForm();
    });
  </script>
<% end %>
RENDER_PARTIAL
