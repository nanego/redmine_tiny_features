Deface::Override.new :virtual_path  => "users/show",
                  :name         		=> "add-condition-disable_email_hiding",
                  :replace      		=> "erb[silent]:contains('unless @user.pref.hide_mail')",
                  :text         		=> <<STRING_EMAIL
<% unless @user.pref.hide_mail && Setting["plugin_redmine_tiny_features"]["disable_email_hiding"].blank? && !User.current.allowed_to?(:always_see_user_email_addresses, nil, :global => true) %>
STRING_EMAIL
