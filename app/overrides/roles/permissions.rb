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

