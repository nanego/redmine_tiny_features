Deface::Override.new :virtual_path => 'issues/_action_menu',
                     :name => 'hide-copy-issue-if-tracker-prevents-it',
                     :insert_bottom => 'erb[loud]:contains("link_to l(:button_copy)")',
                     :text => <<-HIDE_LINK
  && !@issue.tracker.prevent_issue_copy
HIDE_LINK
Deface::Override.new :virtual_path  => 'issues/_action_menu',
                       :name        => 'call-renderPartialEdit-before-showAndScrollTo',
                       :replace     => "erb[loud]:contains('l(:button_edit)')",
                       :text        => <<-REPLACE_BUTTON

<% # Put the condition here, not at the beginning of the file, so that we can check the configuration each time we download the page,
  # if we put the condition at the beginning of the file it does not execute only once, (start application) %>
<% if Setting.plugin_redmine_tiny_features.key?('do_not_preload_issue_edit_form') %>
  <%= link_to l(:button_edit), edit_issue_path(@issue),
  :onclick => 'renderPartialEdit(); return false;',
  :class => 'icon icon-edit', :accesskey => accesskey(:edit) if @issue.editable? %>
  <script>
    var isloaded = false;
    function renderPartialEdit(id){
      if (!isloaded) {
        $.ajax({
          url: "<%= render_form_by_ajax_path(@issue.id) %>",
          success: function(response) {
            $('#update').append(response.html);
            showAndScrollTo("update", "issue_notes");
            isloaded = true;
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
    } 
  </script>
<% else %>
  <%= link_to l(:button_edit), edit_issue_path(@issue),
            :onclick => 'showAndScrollTo("update", "issue_notes"); return false;',
            :class => 'icon icon-edit', :accesskey => accesskey(:edit) if @issue.editable? %>
<% end %>
REPLACE_BUTTON
