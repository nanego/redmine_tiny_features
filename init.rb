require 'redmine'
require 'redmine_tiny_features/hooks'

Redmine::Plugin.register :redmine_tiny_features do
  name 'Redmine Tiny Features plugin'
  author 'Vincent ROBERT'
  description 'This is a Redmine plugin for testing small features before committing them to Redmine core'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
end
