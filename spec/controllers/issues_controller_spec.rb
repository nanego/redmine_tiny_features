require "spec_helper"

describe IssuesController, type: :controller do
  render_views

  fixtures :projects, :users, :members, :member_roles, :roles,
           :issues, :journals, :journal_details, :enabled_modules,
           :trackers, :issue_statuses, :enumerations, :custom_fields,
           :custom_values, :custom_fields_projects, :projects_trackers

  before do
    User.current = User.find(1)
    @request.session[:user_id] = 1 # admin
  end

  describe "range custom-field format" do
    it "can sum several range fields" do
      field = IssueCustomField.generate!(:field_format => 'range', :is_for_all => true)
      CustomValue.create!(:customized => Issue.find(1), :custom_field => field, :value => '20')
      CustomValue.create!(:customized => Issue.find(2), :custom_field => field, :value => '30')
      get(:index, :params => { :t => ["cf_#{field.id}"] })
      assert_response :success
      assert_select '.query-totals'
      assert_select ".total-for-cf-#{field.id} span.value", :text => '50'
    end
  end

end
