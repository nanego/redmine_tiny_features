require "spec_helper"

RSpec.describe "settings_redmine_tiny_features", type: :system do
  fixtures :users

  it "Should active the option paginate_issue_filters_values" do

    log_user('admin', 'admin')
    visit 'settings/plugin/redmine_tiny_features'

    find("input[name='settings[paginate_issue_filters_values]']").click
    find("input[name='commit']").click
    expect(Setting["plugin_redmine_tiny_features"]["paginate_issue_filters_values"]).to eq "1"

  end
end
