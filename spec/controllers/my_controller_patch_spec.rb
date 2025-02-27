require 'spec_helper'

describe MyController do
  include ApplicationHelper
  render_views

  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields, :auth_sources

  before do
    @controller = MyController.new
    @request = ActionDispatch::TestRequest.create
    @request.session = ActionController::TestSession.new
    @request.session[:user_id] = 2
    @response = ActionDispatch::TestResponse.new
  end

  it "should add the option of display mode an issue in my account" do
    get :account

    assert_select "select#user_issue_display_mode" do |element|
      assert_select element, "option", 2
    end
  end
end