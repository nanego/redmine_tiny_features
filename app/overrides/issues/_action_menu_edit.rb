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
        renderPartialEdit();
      }
      $('#'+id).show();
      if (focus !== null) {
        $('#'+focus).focus();
      }
      $('html, body').animate({scrollTop: $('#'+id).offset().top}, 100);
    }

    function renderPartialEdit(){
      $('#update').html('<%= escape_javascript(render :partial => 'edit') %>');
      // as there are elements of wikitoolbar
      <% if Redmine::Plugin.installed?(:redmine_wysiwyg_editor) %>
        $('.jstEditor').each(initRedmineWysiwygEditor);
      <% end %>
      $(document).ready(setupFileDrop);
    } 
  </script>
<% else %>
  <%= render :partial => 'edit' %>
<% end %>
RENDER_PARTIAL
