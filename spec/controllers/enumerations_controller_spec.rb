require 'spec_helper'

describe EnumerationsController do
  include ApplicationHelper
  render_views

  fixtures :users, :enumerations

  before do
    @controller = EnumerationsController.new
    @request    = ActionDispatch::TestRequest.create
    @request.session[:user_id] = 1
  end

  it "should add the option of color" do
    get :new, :params => {:type => "IssuePriority" }

    assert_select "select#enumeration_color" do |element|
      assert_select element, "option", 4
    end
  end

  it "should create priority with color" do
    expect {
      post(
          :create,
          :params  => {
            :enumeration => {
              :type       => "IssuePriority",
              :name       => "test",
              :color      => "green",
              :active     =>"1",
              :is_default => "0"
            }
          }
        )
    }.to change{ Enumeration.count }.by(1)
  end
end