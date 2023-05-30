require 'spec_helper'

describe IssueStatusesController do
  include ApplicationHelper
  render_views

  fixtures :users, :issue_statuses

  before do
    @controller = IssueStatusesController.new
    @request    = ActionDispatch::TestRequest.create
    @request.session[:user_id] = 1
  end

  it "should add the option of color" do
    get :new

    assert_select "select#issue_status_color" do |element|
      assert_select element, "option", 4
    end
  end
end