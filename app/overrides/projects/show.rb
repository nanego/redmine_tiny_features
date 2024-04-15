Deface::Override.new :virtual_path  => 'projects/show',
                     :name          => 'hide-members-on-project-overview',
                     :surround      => "erb[loud]:contains('members_box')",
                     :text          => <<-EOS
<% if !Setting["plugin_redmine_tiny_features"]["hide_members_section_in_overview_project"].present? %>
  <%= render_original %>
<% end %>
EOS