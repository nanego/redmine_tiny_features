require "spec_helper"
require "active_support/testing/assertions"

describe UsersController, type: :controller do
  include ActiveSupport::Testing::Assertions

  render_views

  fixtures :users, :email_addresses

  before do
    @request.session[:user_id] = 1 #=> admin ; permissions are hard...
  end

  context "Disable emails hiding function" do

    it "should show user's email when the option is selected, even if the user hides his email" do
      Setting["plugin_redmine_tiny_features"]["disable_email_hiding"] = '1'
      expect(User.find(2).pref.hide_mail).to eq true
      get :show, params: { :id => 2 }

      expect(response.body).to include(User.find(2).mail)
    end

    it "should hide user's email when the option is unselected, if the user hides his email" do
      Setting["plugin_redmine_tiny_features"]["disable_email_hiding"] = ''
      expect(User.find(2).pref.hide_mail).to eq true
      get :show, params: { :id => 2 }

      expect(response.body).to_not include(User.find(2).mail)
    end

    it "should hide the option (Hide my email address) when the option is selected" do
      Setting["plugin_redmine_tiny_features"]["disable_email_hiding"] = '1'
      get :edit, params: { :id => 2 }
      expect(response.body).to_not include("Hide my email address")
    end

    it "should show the option (Hide my email address) when the option is unselected" do
      Setting["plugin_redmine_tiny_features"]["disable_email_hiding"] = ''
      get :edit, params: { :id => 2 }
      expect(response.body).to include("Hide my email address")
    end
  end

end