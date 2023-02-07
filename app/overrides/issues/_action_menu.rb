Deface::Override.new :virtual_path => 'issues/_action_menu',
                     :name => 'hide-copy-issue-if-tracker-prevents-it',
                     :insert_bottom => 'erb[loud]:contains("link_to l(:button_copy)")',
                     :text => <<-HIDE_LINK
  && !@issue.tracker.prevent_issue_copy
HIDE_LINK

Deface::Override.new :virtual_path => 'issues/_action_menu',
                     :name         => 'replace-edit-issue-button-and-call-loadIssueEditForm',
                     :replace      => "erb[loud]:contains('l(:button_edit)')",
                     :text         => <<-REPLACE_BUTTON
<% if Setting.plugin_redmine_tiny_features.key?('do_not_preload_issue_edit_form') %>
  <%= link_to l(:button_edit), edit_issue_path(@issue),
  :onclick => 'loadIssueEditForm(); return false;',
  :class => 'icon icon-edit', :accesskey => accesskey(:edit) if @issue.editable? %>
  <script>
    function loadIssueEditForm(id){
      if ($('#issue-form').length < 1) {
        $.ajax({
          url: "<%= render_form_by_ajax_path(@issue.id) %>",
          success: function(response) {
            $('#update').append(response.html);
            showAndScrollTo("update", "issue_notes");
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
      showAndScrollTo("update", "issue_notes");
    }
  </script>
<% else %>
  <%= link_to l(:button_edit), edit_issue_path(@issue),
            :onclick => 'showAndScrollTo("update", "issue_notes"); return false;',
            :class => 'icon icon-edit', :accesskey => accesskey(:edit) if @issue.editable? %>
<% end %>
REPLACE_BUTTON
