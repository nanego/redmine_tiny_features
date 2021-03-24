require "spec_helper"

describe "roles/permissions.html.erb", type: :view do
	fixtures :roles, :users

	it "Should contain two links check all and uncheck everything in the role filtering block" do
    	User.current = User.find(1)
    	assign(:roles, roles)
    	assign(:permissions, Redmine::AccessControl.permissions.select { |p| !p.public? })

    	render

    	assert_select "form#roles-form"
    	assert_select 'a[href=?][onclick=?]', '#', "checkAll('roles-form', true); return false;"
    	assert_select 'a[href=?][onclick=?]', '#', "checkAll('roles-form', false); return false;"
    end  	
end