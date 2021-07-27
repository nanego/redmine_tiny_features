require "spec_helper"

describe "roles/permissions.html.erb", type: :view do
	fixtures :roles, :users

	it "Should contain two links check all and uncheck everything in the role filtering block" do
  	User.current = User.find(1)
  	assign(:roles, roles)
  	assign(:permissions, Redmine::AccessControl.permissions.select { |p| !p.public? })
  	#set settings by default for all roles
  	roles.each do |role|
  		role.permissions_all_trackers = { "view_issues"=>"1", "add_issues"=>"1", "edit_issues"=>"1", "add_issue_notes"=>"1", "delete_issues"=>"1" }
  		role.permissions_tracker_ids = { "view_issues"=>[], "add_issues"=>[], "edit_issues"=>[], "add_issue_notes"=>[], "delete_issues"=>[] }
  		role.save
  	end
  	render

  	assert_select "form#roles-form"
  	assert_select 'a[href=?][onclick=?]', '#', "checkAll('roles-form', true); return false;"
  	assert_select 'a[href=?][onclick=?]', '#', "checkAll('roles-form', false); return false;"
  end
end