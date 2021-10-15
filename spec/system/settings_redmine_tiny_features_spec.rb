require "spec_helper"

RSpec.describe "settings_redmine_tiny_features", type: :system do
  fixtures :users

  it "Should active the option empty_available_filters" do

    log_user('admin', 'admin')
    visit 'settings/plugin/redmine_tiny_features'

    find("input[name='settings[empty_available_filters]']").click
    find("input[name='commit']").click
    expect(Setting["plugin_redmine_tiny_features"]["empty_available_filters"]).to eq "1"

  end
end
