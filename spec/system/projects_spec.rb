require "spec_helper"

RSpec.describe "ProjectController", type: :system do

  fixtures :users, :user_preferences, :projects, :members, :roles, :member_roles

  before do
    log_user('admin', 'admin')
  end

  describe "Option to hide/show the members section on the overview page of each project" do
    let(:project_test) { Project.find(1) }

    it "Should hide members section when the option is activated" do

      Setting.send "plugin_redmine_tiny_features=", {
        "hide_members_section_in_overview_project" => "1",
      }

      visit "/projects/#{project_test.identifier}"
      expect(page).to_not have_selector('div.members')

    end

    it "Should display members section when the option is deactivated" do

      Setting.send "plugin_redmine_tiny_features=", {
        "hide_members_section_in_overview_project" => "",
      }

      visit "/projects/#{project_test.identifier}"
      expect(page).to have_selector('div.members')
    end

  end
end
