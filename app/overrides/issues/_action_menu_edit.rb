Deface::Override.new :virtual_path  => 'issues/_action_menu_edit',
                     :name          => 'prevents-render-edit-partial-render-it-only-on-edit-button-click',
                     :replace       => "erb[loud]:contains(\"render :partial => 'edit'\")",
                     :text          => <<-RENDER_PARTIAL
<% unless Setting.plugin_redmine_tiny_features.key?('do_not_preload_issue_edit_form') %>
  <%= render :partial => 'edit' %>
<% else %>
  <%# These header tags are not included if the partial is not preloaded %>
  <% content_for :header_tags do %>
    <%= javascript_include_tag 'attachments' %>
  <% end %>
<% end %>
RENDER_PARTIAL
