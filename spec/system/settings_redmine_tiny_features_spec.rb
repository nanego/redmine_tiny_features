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

  it "activates the option load_issue_edit_form_asynchronously" do
    log_user('admin', 'admin')
    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues" => "1",
      "default_open_status" => "2",
      "default_project" => "1",
    }
    visit 'settings/plugin/redmine_tiny_features'

    find("input[name='settings[load_issue_edit_form_asynchronously]']").click
    find("input[name='commit']").click

    expect(Setting["plugin_redmine_tiny_features"]["load_issue_edit_form_asynchronously"]).to eq '1'
    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues" => "1",
      "default_open_status" => "2",
      "default_project" => "1",
      "load_issue_edit_form_asynchronously" => "0",
    }
  end

  it "activates the option hide_members_section_on_project_overview" do
    log_user('admin', 'admin')

    visit 'settings/plugin/redmine_tiny_features'

    find("input[name='settings[hide_members_section_on_project_overview]']").click
    find("input[name='commit']").click

    expect(Setting["plugin_redmine_tiny_features"]["hide_members_section_on_project_overview"]).to eq '1'
    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues" => "1",
      "default_open_status" => "2",
      "default_project" => "1",
      "hide_members_section_on_project_overview" => "0",
    }
  end
end
