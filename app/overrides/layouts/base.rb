# The account dropdown trigger only exists in Redmine 7.0+
if Redmine::VERSION::MAJOR >= 7
  Deface::Override.new :virtual_path => 'layouts/base',
                       :name => 'account-menu-caret',
                       :insert_bottom => 'a.dropdown-trigger',
                       :text => <<-EOS
                         <% if Setting["plugin_redmine_tiny_features"]["account_menu_caret"] == '1' %>
                           <span class="tiny-features-account-caret" aria-hidden="true"></span>
                         <% end %>
                       EOS
end
