require 'spec_helper'

describe EnumerationsController, type: :controller do
  include ApplicationHelper
  render_views

  fixtures :users, :enumerations

  before do
    @request.session[:user_id] = 1
  end

  it "adds a select tag with colors" do
    get :new, :params => { :type => "IssuePriority" }

    assert_select "select#enumeration_color" do |element|
      assert_select element, "option", 4
    end
  end

  it "creates a new priority with a color" do
    expect {
      post(
        :create,
        :params => {
          :enumeration => {
            :type => "IssuePriority",
            :name => "test",
            :color => "green",
            :active => "1",
            :is_default => "0"
          }
        }
      )
    }.to change { Enumeration.count }.by(1)
  end

  it "does not create a new priority with a invalid color" do
    expect {
      post(
        :create,
        :params => {
          :enumeration => {
            :type => "IssuePriority",
            :name => "test",
            :color => "light-blue", # invalid color
            :active => "1",
            :is_default => "0"
          }
        }
      )
    }.to_not change { Enumeration.count }
  end
end
