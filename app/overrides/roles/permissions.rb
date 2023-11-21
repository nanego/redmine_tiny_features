Deface::Override.new :virtual_path => 'roles/permissions',
                     :name => 'add-check-all-links',
                     :insert_top => "div.hide-when-print p:first",
                     :text => <<EOF 
 <p><%= check_all_links 'roles-form' %></p> 
EOF

Deface::Override.new :virtual_path => 'roles/permissions',
                     :name          => "Add-id-to-new-roles-form",
                     :replace       => "erb[loud]:contains('form_tag({}, :method => :get)')",
                     :text          => <<eos
<%= form_tag({}, :method => :get, :id => "roles-form") do %>
eos

Deface::Override.new :virtual_path => 'roles/permissions',
                     :name => 'add-general-data-box',
                     :insert_top => "div.autoscroll",
                     :partial    => "roles/general_data"

Deface::Override.new :virtual_path => 'roles/permissions',
                     :name => 'add-trackers-permissions-box',
                     :insert_after => ".permissions",
                     :partial    => "roles/trackers_permissions"
