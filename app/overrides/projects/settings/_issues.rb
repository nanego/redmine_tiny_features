Deface::Override.new :virtual_path => "projects/settings/_issues",
                     :name => "add-link-to-values",
                     :insert_after => "erb[loud]:contains('custom_field_name_tag(custom_field)')",
                     :text => <<EOS
<% if custom_field.field_format == 'enumeration' %>
  <span>
    <%= link_to l('field_possible_values'),
                project_edit_custom_field_enumerations_path(@project, custom_field_id: custom_field.id), 
                remote: true %>
  </span>
<% end %>
EOS
