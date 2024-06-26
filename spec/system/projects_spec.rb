require "spec_helper"

RSpec.describe "ProjectController", type: :system do

  fixtures :users, :user_preferences, :projects, :members, :roles, :member_roles

  before do
    log_user('admin', 'admin')
  end

  describe "Option to hide/show the members section on the overview page of each project" do
    let(:project_test) { Project.find(1) }

    it "hides members section when the option is activated" do
      with_settings :plugin_redmine_tiny_features => { 'hide_members_section_on_project_overview' => '1' } do
        visit "/projects/#{project_test.identifier}"
        expect(page).to_not have_selector('div.members')
      end
    end

    it "displays members section when the option is deactivated" do
      with_settings :plugin_redmine_tiny_features => { 'hide_members_section_on_project_overview' => '' } do
        visit "/projects/#{project_test.identifier}"
        expect(page).to have_selector('div.members')
      end
    end

  end
end
