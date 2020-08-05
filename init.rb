require 'redmine'
require 'redmine_tiny_features/hooks'

Redmine::Plugin.register :redmine_tiny_features do
  name 'Redmine Tiny Features plugin'
  author 'Vincent ROBERT'
  description 'This is a Redmine plugin used to test small features before committing them to Redmine core'
  version '1.0.0'
  url 'https://github.com/nanego/redmine_tiny_features'
  author_url 'https://github.com/nanego'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  settings partial: 'settings/redmine_plugin_tiny_features_settings',
           default: {
               'warning_message_on_closed_issues': '1',
               'simplified_version_form': '1'
           }
end
