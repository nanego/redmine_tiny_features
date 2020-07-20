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

  it "creates an issue and a new target version without advanced options" do
    log_user('jsmith', 'jsmith')

    assert_difference 'Issue.count' do
      assert_difference 'Version.count' do
        visit '/projects/ecookbook/issues/new'
        fill_in 'Subject', :with => 'With a new version'
        click_on 'New version'
        within '#ajax-modal' do
          fill_in 'Name', :with => '4.0'
          click_on 'Create'
        end
        click_on 'Create'
      end
    end

    issue = Issue.order('id desc').first
    expect(issue.fixed_version).to_not be_nil
    expect(issue.fixed_version.name).to eq '4.0'
  end

  it "creates an issue with a new target version which uses some advanced fields" do
    log_user('jsmith', 'jsmith')

    assert_difference 'Issue.count' do
      assert_difference 'Version.count' do
        visit '/projects/ecookbook/issues/new'
        fill_in 'Subject', :with => 'With a new version'
        click_on 'New version'
        within '#ajax-modal' do
          fill_in 'Name', :with => '4.1'
          click_on 'Show more options'
          fill_in 'Description', :with => 'This branch adds some new features'
          click_on 'Create'
        end
        click_on 'Create'
      end
    end

    issue = Issue.order('id desc').first
    expect(issue.fixed_version).to_not be_nil
    expect(issue.fixed_version.description).to eq 'This branch adds some new features'
  end

end

