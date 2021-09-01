require "spec_helper"
require "active_support/testing/assertions"

RSpec.describe "Synthesis of roles", type: :system do
  fixtures :roles, :users

  before do
    log_user('admin', 'admin')
    # settings by default for all roles
    roles.each do |role|
      role.permissions_all_trackers = { "view_issues" => "1", "add_issues" => "1", "edit_issues" => "1", "add_issue_notes" => "1", "delete_issues"=> "1" }
      role.permissions_tracker_ids = { "view_issues" => [], "add_issues" => [], "edit_issues" => [], "add_issue_notes" => [], "delete_issues" => [] }
      role.save
    end
  end

  it "Should contain general data" do
    visit 'roles/permissions'

    page.assert_selector('tr.assignable', count: 1)

    # for all the roles except Non members or Anonymous
    page.assert_selector("input[name^='assignable['", count: 3)

    # for every option of ROLE::ISSUES_VISIBILITY_OPTIONS
    Role::ISSUES_VISIBILITY_OPTIONS.each do |option|
      # ex: <tr class="visibility_all">
      str = 'tr.visibility_' + option.first
      page.assert_selector(str, count: 1)
    end

    # for all the roles except Anonymous
    roles.each do |role|
      Role::ISSUES_VISIBILITY_OPTIONS.each do |option|
        unless role.anonymous?
          # ex:<input type="radio" id="issues_visibility_1_all" name="issues_visibility[1]"  value="all">
          str = "input[id='issues_visibility_"+ role.id.to_s + '_' + option.first + "'][name='issues_visibility[" + role.id.to_s + "]'][value='"+ option.first + "']"
          page.assert_selector(str, count: 1)
        end
      end
    end
  end

  it "Should contain permissions of trackers" do
    visit 'roles/permissions'
    permissions = [:view_issues, :add_issues, :edit_issues, :add_issue_notes, :delete_issues]

    # permissions for all trackers
    permissions.each do |permission|
      # ex: <tr class="all-trackers-view_issues">
      str =  'tr.all-trackers-' + permission.to_s
      page.assert_selector(str, count: 1)
    end

    # permissions for every tracker
    Tracker.sorted.all.each do |tracker|
      permissions.each do |permission|
        # ex:<tr class="permission-add_issues2">
        str = 'tr.permission-' + permission.to_s + tracker.id.to_s
        page.assert_selector(str, count: 1)
        roles.each do |role|
          if role.setable_permissions.collect(&:name).include? permission
            # ex: <input class="add_issues_tracker_role_2" >
            str = 'input.'+ permission.to_s + '_tracker_role_' + role.id.to_s
            page.assert_selector(str, count: Tracker.count)
            expect(page).to have_css(str + '[disabled]')
            # ex: <input  name="permissions_tracker_ids[1][add_issues][]" value="1">
            str = "input[name='permissions_tracker_ids[" + role.id.to_s + "][" + permission.to_s + "][]'][value='"+ tracker.id.to_s + "']"
            page.assert_selector(str, count: 1)
          end
        end
      end
    end
  end

  it "Should enable the permission for every tracker when uncheck it in (all tracker)" do
    visit 'roles/permissions'
    find("input[name='permissions_all_trackers[1][view_issues]']").click
    Tracker.sorted.all.each do |tracker|
      str = "input[name='permissions_tracker_ids[1][view_issues][]'][value='"+ tracker.id.to_s + "']"
      expect(page).to_not have_css(str + '[disabled]')
    end
  end

  it "Should hide (issues_visibility options/general data) and permission of trackers when we uncheck (View Issues) of a role" do
    visit 'roles/permissions'
    #find('.view_issues-1_shown').should be_visible
    expect(page).to have_css('.view_issues-1_shown', visible: :visible)
    find("input[name='permissions[1][]'][value='view_issues']").click
    expect(page).to have_css('.view_issues-1_shown', visible: :hidden)
  end

  it "Should uncheck permissions_all_trackers for all the roles/test function(toggleCheckboxesBySelector)" do
    visit 'roles/permissions'

    find("tr.all-trackers-add_issues a" ).click
    expect(find("input[name='permissions_all_trackers[1][add_issues]']").checked?).to be(false)
    expect(find("input[name='permissions_all_trackers[2][add_issues]']").checked?).to be(false)
    expect(find("input[name='permissions_all_trackers[3][add_issues]']").checked?).to be(false)
    expect(find("input[name='permissions_all_trackers[4][add_issues]']").checked?).to be(false)
    expect(find("input[name='permissions_all_trackers[5][add_issues]']").checked?).to be(false)
  end

  it "Should change the setting from permissions_all_trackers to permissions_tracker_ids " do
    visit 'roles/permissions'

    find('input[data-disables=".view_issues_tracker_role_1"]').click
    find("input[name='permissions_tracker_ids[1][view_issues][]'][id='role_permissions_tracker_ids-1_1']").click
    find("input[name='permissions_tracker_ids[1][view_issues][]'][id='role_permissions_tracker_ids-1_3']").click
    # click on button save
    find("input[name='commit']").click

    expect(Role.find(1).permissions_all_trackers["view_issues"]).to eq "0"
    expect(Role.find(1).permissions_tracker_ids["view_issues"]).to eq ["1", "3"]
  end
end
