Deface::Override.new :virtual_path  => "users/_preferences",
                    :name         	=> "add-condition-disable_email_hiding_before_check_box_hide_mail",
                    :surround       => 'p:contains("check_box :hide_mail")',
                    :text           => <<STRING_EMAIL
<% if Setting["plugin_redmine_tiny_features"]["disable_email_hiding"].blank? %>
  <%= render_original %>
<% end %>
STRING_EMAIL
