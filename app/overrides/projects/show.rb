Deface::Override.new :virtual_path => 'projects/show',
                     :name => 'hide-members-on-project-overview',
                     :surround => "erb[loud]:contains('members_box')",
                     :text => <<-EOS
                       <% unless Setting["plugin_redmine_tiny_features"]["hide_members_section_on_project_overview"] == '1' %>
                         <%= render_original %>
                       <% end %>
                     EOS
