require "spec_helper"

RSpec.describe "my_controller", type: :system do

  fixtures :users, :user_preferences

  before do
    log_user('admin', 'admin')
  end

  describe "Option show_pagination_at_top_results" do
    it "Should active the option show_pagination_at_top_results" do
      visit "/my/account"

      find("input[name='pref[show_pagination_at_top_results]']").click
      find("input[name='commit']").click

      expect(page).to have_content("Account was successfully updated.")

      expect(User.find(1).preference.show_pagination_at_top_results).to eq true
    end

    it "Should disable the option show_pagination_at_top_results" do
      pref = User.find(1).preference
      pref.show_pagination_at_top_results = true
      pref.save

      visit "/my/account"

      find("input[name='pref[show_pagination_at_top_results]']").click
      find("input[name='commit']").click

      expect(page).to have_content("Account was successfully updated.")

      expect(User.find(1).preference.show_pagination_at_top_results).to eq false
    end
  end
end
