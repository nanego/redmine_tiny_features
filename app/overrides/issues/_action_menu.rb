Deface::Override.new :virtual_path => 'issues/_action_menu',
                     :name => 'hide-copy-issue-if-tracker-prevents-it',
                     :insert_bottom => 'erb[loud]:contains("link_to l(:button_copy)")',
                     :text => <<-HIDE_LINK
  && !@issue.tracker.prevent_issue_copy
HIDE_LINK
Deface::Override.new :virtual_path => 'issues/_action_menu',
                     :name         => 'render-partial-edit-only-on-click-button-edit',
                     :replace      => "erb[loud]:contains('l(:button_edit)')",
                     :text         => <<-RENDER_PARTIAL
<%= link_to l(:button_edit), edit_issue_path(@issue),
            :onclick => 'renderPartialEdit();showAndScrollTo("update", "issue_notes"); return false;',
            :class => 'icon icon-edit', :accesskey => accesskey(:edit) if @issue.editable? %>
<script>  
  function renderPartialEdit(){
    $('#update').html('<%= escape_javascript(render :partial => 'edit') %>');
    // as there are elements of wikitoolbar
    <% if Redmine::Plugin.installed?(:redmine_wysiwyg_editor) %>
      $('.jstEditor').each(initRedmineWysiwygEditor);
    <% end %>
    $(document).ready(setupFileDrop);
  } 
</script>
RENDER_PARTIAL

