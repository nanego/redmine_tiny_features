require "spec_helper"

describe IssuesController, type: :controller do
  include ApplicationHelper
  include IssuesHelper
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

  before do
    @controller = IssuesController.new
    @request    = ActionDispatch::TestRequest.create
    @request.session[:user_id] = 1
  end

  describe "colorization of issues" do

    it "should show the colorization of issues by status if the user selects this mode" do
      User.find(1).update_attribute(:issue_display_mode, User::BY_STATUS)
      IssueStatus.find(1).update_attribute(:color, "green") # status new
      IssueStatus.find(2).update_attribute(:color, "orange") # status Assigned
      IssueStatus.find(5).update_attribute(:color, "grey")  # status Closed
      IssueStatus.find(6).update_attribute(:color, "red") # status Rejected

      columns = ['project', 'status', 'priority']
      get :index, :params => { :set_filter => 1,
                              :f => ["authorized_viewers" => ""],
                              :op => { "issue_templates" => "=" },
                              :c => columns }

      expect(Issue.count).to eq 14
      assert_select "table tbody tr", :count => 14
      assert_select "table tbody tr.status-green", :count => Issue.where(status_id: 1).count
      assert_select "table tbody tr.status-grey", :count => Issue.where(status_id: 5).count
      assert_select "table tbody tr.status-orange", :count => Issue.where(status_id: 2).count
      assert_select "table tbody tr.status-red", :count => Issue.where(status_id: 6).count
    end

    it "should switch the display mode of issue for user in project/issue index" do
      post :switch_display_mode, :params =>  { :path =>"http://localhost:3000/projects/ecookbook/issues" }
      expect(User.find(1).issue_display_mode).to eq User::BY_STATUS
    end

    it "should switch the display mode of issue for user in issue index" do
      post :switch_display_mode, :params =>  { :path =>"http://localhost:3000/issues" }
      expect(User.find(1).issue_display_mode).to eq User::BY_STATUS
    end

    it "should display the link of colorization by status in issue index" do
      get :index
      assert_select 'a', :text => 'Colorization According to status'
    end

    it "should display the link of colorization by status in project/issue index" do
      get :index, :params =>  { :project_id => "ecookbook" }
      assert_select 'a', :text => 'Colorization According to status'
    end

    it "should display the link of colorization by priority in issue index, when issue_display_mode of user is by status" do
      User.find(1).update_attribute(:issue_display_mode, User::BY_STATUS)
      get :index
      assert_select 'a', :text => 'Colorization According to priority'
    end

    it "should display the link of colorization by priority in project/issue index, when issue_display_mode of user is by status" do
      User.find(1).update_attribute(:issue_display_mode, User::BY_STATUS)
      get :index, :params =>  { :project_id => "ecookbook" }
      assert_select 'a', :text => 'Colorization According to priority'
    end

  end

end
