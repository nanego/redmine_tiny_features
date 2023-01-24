require "spec_helper"
require "active_support/testing/assertions"

def log_user(login, password)
  visit '/my/page'
  expect(current_path).to eq '/login'

  if Redmine::Plugin.installed?(:redmine_scn)
    click_on("ou s'authentifier par login / mot de passe")
  end

  within('#login-form form') do
    fill_in 'username', with: login
    fill_in 'password', with: password
    find('input[name=login]').click
  end
  expect(current_path).to eq '/my/page'
end

RSpec.describe "creating an issue", type: :system do
  include ActiveSupport::Testing::Assertions

  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions,
           :workflows

  before do
    log_user('jsmith', 'jsmith')
  end

  describe "simplified version form" do
    it "creates an issue and a new target version without advanced options" do
      with_settings :plugin_redmine_tiny_features => { 'simplified_version_form' => '1' } do
        assert_difference 'Issue.count' do
          assert_difference 'Version.count' do
            visit '/projects/ecookbook/issues/new'
            fill_in 'Subject', :with => 'With a new version'
            click_on 'New version'
            within '#ajax-modal' do
              expect(page).to have_selector("a", text: "Show more options")
              expect(page).to_not have_selector("label", text: "Description")
              fill_in 'Name', :with => '4.0'
              click_on 'Create'
            end
            click_on 'Create'
          end
        end
      end

      issue = Issue.order('id desc').first
      expect(issue.fixed_version).to_not be_nil
      expect(issue.fixed_version.name).to eq '4.0'
    end

    it "creates an issue with a new target version which uses some advanced fields" do
      with_settings :plugin_redmine_tiny_features => { 'simplified_version_form' => '1' } do
        assert_difference 'Issue.count' do
          assert_difference 'Version.count' do
            visit '/projects/ecookbook/issues/new'
            fill_in 'Subject', :with => 'With a new version'
            click_on 'New version'
            within '#ajax-modal' do
              expect(page).to have_selector("a", text: "Show more options")
              expect(page).to_not have_selector("label", text: "Description")
              fill_in 'Name', :with => '4.1'
              click_on 'Show more options'
              fill_in 'Description', :with => 'This branch adds some new features'
              click_on 'Create'
            end
            click_on 'Create'
          end
        end
      end

      issue = Issue.order('id desc').first
      expect(issue.fixed_version).to_not be_nil
      expect(issue.fixed_version.description).to eq 'This branch adds some new features'
    end

    it "does not hide any field if the feature is disabled in plugin settings" do
      with_settings :plugin_redmine_tiny_features => { 'simplified_version_form' => '0' } do
        visit '/projects/ecookbook/issues/new'
        fill_in 'Subject', :with => 'With a new version'
        click_on 'New version'
        within '#ajax-modal' do
          expect(page).to_not have_selector("a", text: "Show more options")
          expect(page).to have_selector("label", text: "Description")
        end
      end
    end
  end

  describe "default project" do
    it "does NOT change default project if plugin setting is not set" do
      with_settings :plugin_redmine_tiny_features => { 'default_project' => '' } do
        visit 'issues/new'
        expect(page).to have_select('issue[project_id]', selected: 'eCookbook')
      end
    end

    it "uses default project if plugin setting is set" do
      with_settings :plugin_redmine_tiny_features => { 'default_project' => '2' } do
        visit 'issues/new'
        expect(page).to have_select('issue[project_id]', selected: 'OnlineStore')
      end
    end

    it "does NOT change project if we are in a project" do
      with_settings :plugin_redmine_tiny_features => { 'default_project' => '2' } do
        visit 'projects/3/issues/new'
        expect(page).to have_select('issue[project_id]', selected: '  » eCookbook Subproject 1')
      end
    end
  end

  describe "option prevent copy issues" do
    it "Show link copy when its tracker allows copy issues page(issue/show)" do
      visit 'issues/2'
      expect(page).to have_selector('a', class: 'icon-copy', text: 'Copy')
    end

    it "Show link copy when its tracker allows copy issues page(issue/index)" do
      visit 'issues/'

      find('tr#issue-2>td.buttons>a.icon-actions').click
      expect(page).to have_selector('a.icon-copy')
    end

    it "Hide link copy when its tracker prevents copy issues page(issue/show)" do
      tracker_test = Tracker.find(2)
      tracker_test.prevent_issue_copy = true
      tracker_test.save

      visit 'issues/2'
      expect(page).to_not have_selector('a', class: 'icon-copy', text: 'Copy')
    end

    it "Hide link copy when its tracker prevents copy issues page(issue/index)" do
      tracker_test = Tracker.find(2)
      tracker_test.prevent_issue_copy = true
      tracker_test.save

      visit 'issues/'
      find('tr#issue-2>td.buttons>a.icon-actions').click
      expect(page).to_not have_selector('a.icon-copy')
    end
  end

  describe "Load the issue's edit" do
    it "Load the form when the option (load_issue_edit) is unselected" do
      visit 'issues/2'
      expect(page).to have_selector('#issue-form', visible: :hidden)
    end

    it "only on click button edit and the option (load_issue_edit) is selected" do
      Setting.send "plugin_redmine_tiny_features=", {
        "warning_message_on_closed_issues" => "1",
        "default_open_status" => "2",
        "default_project" => "1",
        "load_issue_edit" => "1",
      }
      visit 'issues/2'
      expect(page).to_not have_selector('#issue-form', visible: :hidden)
      find('.icon-edit',  match: :first).click
      # wait for render form
      sleep 10      
      expect(page).to have_selector('#issue-form')
    end
  end
end
