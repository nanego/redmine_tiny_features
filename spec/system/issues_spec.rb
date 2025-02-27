require "spec_helper"
require "active_support/testing/assertions"

RSpec.describe "creating an issue", type: :system do
  include ActiveSupport::Testing::Assertions

  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions,
           :workflows

  context "logged as non-admin" do
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
              expect(page).to have_selector('#ajax-modal', wait: true)
              within '#ajax-modal' do
                expect(page).to have_selector("a", text: "Show more options")
                expect(page).to_not have_selector("label", text: "Description")
                fill_in 'Name', :with => '4.0'
                click_on 'Create'
              end
              expect(page).to_not have_selector('#ajax-modal', wait: true)
              click_on 'Create'
              expect(page).to have_content('created.')
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
              expect(page).to have_content('created.')
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
      it "shows the copy link when the tracker allows copying, on the issue/show page" do
        visit 'issues/2'
        expect(page).to have_selector('a', class: 'icon-copy', text: 'Copy')
      end

      it "shows the copy link when the tracker allows copying, on the issue/index page" do
        visit 'issues/'

        find('tr#issue-2>td.buttons>a.icon-actions').click
        expect(page).to have_selector('a.icon-copy')
      end

      it "hides the copy link when the tracker prevents copying, on the issue/show page" do
        tracker_test = Tracker.find(2)
        tracker_test.prevent_issue_copy = true
        tracker_test.save

        visit 'issues/2'
        expect(page).to_not have_selector('a', class: 'icon-copy', text: 'Copy')
      end

      it "hides the copy link when the tracker prevents copying, on the issue/index page" do
        tracker_test = Tracker.find(2)
        tracker_test.prevent_issue_copy = true
        tracker_test.save

        visit 'issues/'
        find('tr#issue-2>td.buttons>a.icon-actions').click
        expect(page).to_not have_selector('a.icon-copy')
      end
    end

    describe "Load the issue's edit" do
      it "preloads the form synchronously when the option (load_issue_edit_form_asynchronously) is NOT selected" do
        Setting.send "plugin_redmine_tiny_features=", {
          "warning_message_on_closed_issues" => "1",
          "default_open_status" => "2",
          "default_project" => "1",
          "load_issue_edit_form_asynchronously" => "0",
        }
        visit 'issues/2'
        expect(page).to have_selector('#issue-form', visible: :hidden)
      end

      it "loads the issue form asynchronously when the option (load_issue_edit_form_asynchronously) is selected" do
        Setting.send "plugin_redmine_tiny_features=", {
          "warning_message_on_closed_issues" => "1",
          "default_open_status" => "2",
          "default_project" => "1",
          "load_issue_edit_form_asynchronously" => "1",
        }
        visit 'issues/2'
        expect(page).to_not have_selector('#issue-form', visible: :hidden)
        find('.icon-edit', match: :first).click
        expect(page).to have_selector('#issue-form')
      end
    end

    describe "Group-by filter" do
      it "shows options in alphabetic order" do
        visit 'issues'

        # Click on option button
        page.all('legend')[1].click

        expect(page).to have_selector('select', id: 'group_by')

        options = page.all('#group_by option').map(&:text)
        expect(options).to eq (options.sort_by(&:parameterize))
      end
    end
  end

  context "logged as admin" do

    before do
      log_user('admin', 'admin')
    end

    describe "Pagination links at the top of issues results" do

      it "does not show pagination links when the option show_pagination_at_top_results is not selected and there are multi pages" do
        # create 70 issues
        70.times do |i|
          Issue.create(:project_id => 1, :tracker_id => 1, :author_id => 1,
                       :status_id => 1, :priority_id => 1,
                       :subject => "test_create#{i}",
                       :description => "description#{i}")
        end
        visit 'issues?query_id=5'
        expect(page).to have_selector('span.pagination', count: 1)
      end

      it "does not show pagination links when the option show_pagination_at_top_results is selected and there is only one page" do
        pref = User.find(1).preference
        pref.show_pagination_at_top_results = true
        pref.save
        visit 'issues?query_id=5'
        expect(page).to have_selector('span.pagination', count: 1)
      end

      it "shows pagination links when the option show_pagination_at_top_results is selected and there are multi pages" do
        pref = User.find(1).preference
        pref.show_pagination_at_top_results = true
        pref.save
        # create 70 issues
        70.times do |i|
          Issue.create(:project_id => 1, :tracker_id => 1, :author_id => 1,
                       :status_id => 1, :priority_id => 1,
                       :subject => "test_create#{i}",
                       :description => "description#{i}")
        end
        visit 'issues/'
        expect(page).to have_selector('span.pagination', count: 2)
      end
    end
  end

end
