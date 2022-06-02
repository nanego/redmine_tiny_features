require "spec_helper"

RSpec.describe "settings_redmine_tiny_features", type: :system do
  fixtures :users

  it "Should active the option paginate_issue_filters_values" do
    if Redmine::Plugin.installed?(:redmine_base_select2)
      log_user('admin', 'admin')
      visit 'settings/plugin/redmine_tiny_features'

      find("input[name='settings[use_select2]']").click
      find("input[name='settings[paginate_issue_filters_values]']").click
      find("input[name='commit']").click
      expect(Setting["plugin_redmine_tiny_features"]["use_select2"]).to eq '1'
      expect(Setting["plugin_redmine_tiny_features"]["paginate_issue_filters_values"]).to eq "1"
    end
  end
end
