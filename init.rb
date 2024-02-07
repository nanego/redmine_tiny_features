require 'redmine'
require_relative 'lib/redmine_tiny_features/hooks'

Redmine::Plugin.register :redmine_tiny_features do
  name 'Redmine Tiny Features plugin'
  author 'Vincent ROBERT'
  description 'This is a Redmine plugin used to test small features before committing them to Redmine core'
  version '1.0.0'
  url 'https://github.com/nanego/redmine_tiny_features'
  author_url 'https://github.com/nanego'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'

  permission :always_see_user_email_addresses, {}

  settings partial: 'settings/redmine_plugin_tiny_features_settings',
           default: {
             'warning_message_on_closed_issues': '1',
             'open_issue_when_editing_closed_issues': '',
             'simplified_version_form': '1',
             'default_project': '',
             'paginate_issue_filters_values': Rails.env.test? || !(Redmine::Plugin.installed?(:redmine_base_select2)) ? '0' : '1',
             'journalize_note_deletion': Rails.env.test? ? '0' : '1',
             'use_select2': Rails.env.test? || !(Redmine::Plugin.installed?(:redmine_base_select2)) ? '0' : '1',
             'load_issue_edit_form_asynchronously': Rails.env.test? ? '0' : '1',
             'disable_email_hiding': '',
           }
end
