require 'redmine'
require 'redmine_tiny_features/hooks'

Rails.application.config.to_prepare do
  require_dependency 'redmine_tiny_features/field_format_patch'
  require_dependency 'redmine_tiny_features/project_patch'
  require_dependency 'redmine_tiny_features/projects_helper_patch'
  require_dependency 'redmine_tiny_features/queries_helper_patch'
  require_dependency 'redmine_tiny_features/issues_controller_patch'
  require_dependency 'redmine_tiny_features/roles_controller_patch'
  require_dependency 'redmine_tiny_features/principal_patch'
  require_dependency 'redmine_tiny_features/query_patch'
  require_dependency 'redmine_tiny_features/queries_controller_patch'
  require_dependency 'redmine_tiny_features/issue_query_patch'
  require_dependency 'redmine_tiny_features/time_entry_query_patch'
  require_dependency 'redmine_tiny_features/journals_controller_patch'
  require_dependency 'redmine_tiny_features/issue_patch'
  require_dependency 'redmine_tiny_features/issues_helper_patch'
  require_dependency 'redmine_tiny_features/journal_patch'
end

Redmine::Plugin.register :redmine_tiny_features do
  name 'Redmine Tiny Features plugin'
  author 'Vincent ROBERT'
  description 'This is a Redmine plugin used to test small features before committing them to Redmine core'
  version '1.0.0'
  url 'https://github.com/nanego/redmine_tiny_features'
  author_url 'https://github.com/nanego'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  permission :manage_project_enumerations, {}
  settings partial: 'settings/redmine_plugin_tiny_features_settings',
           default: {
               'warning_message_on_closed_issues': '1',
               'open_issue_when_editing_closed_issues': '',
               'simplified_version_form': '1',
               'default_project': '',
               'paginate_issue_filters_values': Rails.env.test? ? '0' : '1'
           }
end
