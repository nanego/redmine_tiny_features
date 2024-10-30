require "spec_helper"

describe IssuesController, type: :controller do
  include ApplicationHelper
  include IssuesHelper
  render_views

  fixtures :projects, :users, :members, :member_roles, :roles,
           :issues, :journals, :journal_details, :enabled_modules,
           :trackers, :issue_statuses, :enumerations, :custom_fields,
           :custom_values, :custom_fields_projects, :projects_trackers, :workflows

  let!(:priority_normal) { Enumeration.find_by(:type => "IssuePriority", :name => "Low") }
  let!(:priority_low) { Enumeration.find_by(:type => "IssuePriority", :name => "Normal") }
  let!(:priority_high) { Enumeration.find_by(:type => "IssuePriority", :name => "High") }
  let!(:priority_urgent) { Enumeration.find_by(:type => "IssuePriority", :name => "Urgent") }

  before do
    User.current = User.find(1)
    @request.session[:user_id] = 1 # admin

    priority_low.update_attribute(:color, "grey")
    priority_normal.update_attribute(:color, "green")
    priority_high.update_attribute(:color, "orange")
    priority_urgent.update_attribute(:color, "red")
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

  describe "colorization of issues" do

    it "should show the colorization of issues by status if the user selects this mode" do
      User.find(1).update_attribute(:issue_display_mode, User::BY_STATUS)
      IssueStatus.find(1).update_attribute(:color, "green") # status new
      IssueStatus.find(2).update_attribute(:color, "orange") # status Assigned
      IssueStatus.find(5).update_attribute(:color, "grey") # status Closed
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

    it "displays issues colorized by priority if the user selects this mode" do
      User.find(1).update_attribute(:issue_display_mode, User::BY_PRIORITY)

      columns = ['project', 'status', 'priority']
      get :index, :params => { :set_filter => 1,
                               :f => ["status_id" => ""],
                               :op => { "status_id" => "o" },
                               :c => columns }

      expect(Issue.count).to eq 14
      assert_select "table tbody tr", :count => 14
      assert_select "tr.priority-grey", :count => Issue.where(priority_id: priority_low.id).count
      assert_select "table tbody tr.priority-green", :count => Issue.where(priority_id: priority_normal.id).count
      assert_select "table tbody tr.priority-orange", :count => Issue.where(priority_id: priority_high.id).count
      assert_select "table tbody tr.priority-red", :count => Issue.where(priority_id: priority_urgent.id).count
    end

    it "should switch the display mode of issue for user in project/issue index" do
      post :switch_display_mode, :params => { :path => "http://localhost:3000/projects/ecookbook/issues" }
      expect(User.find(1).issue_display_mode).to eq User::BY_STATUS
    end

    it "should switch the display mode of issue for user in issue index" do
      post :switch_display_mode, :params => { :path => "http://localhost:3000/issues" }
      expect(User.find(1).issue_display_mode).to eq User::BY_STATUS
    end

    it "should display the link of colorization by status in issue index" do
      get :index
      assert_select 'a', :text => 'Colorization According to status'
    end

    it "should display the link of colorization by status in project/issue index" do
      get :index, :params => { :project_id => "ecookbook" }
      assert_select 'a', :text => 'Colorization According to status'
    end

    it "should display the link of colorization by priority in issue index, when issue_display_mode of user is by status" do
      User.find(1).update_attribute(:issue_display_mode, User::BY_STATUS)
      get :index
      assert_select 'a', :text => 'Colorization According to priority'
    end

    it "should display the link of colorization by priority in project/issue index, when issue_display_mode of user is by status" do
      User.find(1).update_attribute(:issue_display_mode, User::BY_STATUS)
      get :index, :params => { :project_id => "ecookbook" }
      assert_select 'a', :text => 'Colorization According to priority'
    end

  end

  describe "adding a new notes to an issue" do

    before do
      WorkflowPermission.delete_all
      WorkflowPermission.create!(:old_status_id => 1, :tracker_id => 1, :role_id => 1, :field_name => 'notes', :rule => 'required')
      @request.session[:user_id] = 2
    end

    it "creates a new issue if notes is required and empty" do
      expect {
        post :create, :params => {
          :project_id => 1,
          :issue => {
            :tracker_id => 1,
            :status_id => 1,
            :subject => 'issue with empty note',
          },
        }
      }.to change(Issue, :count).by(1)
    end

    it "doesn't update the issue if notes is required and empty" do
      subject_test = 'issue with empty note'

      put :update, params: {
        :id => 1, # Issue 1
        :issue => {
          :status_id => 1,
          :subject => subject_test,
        },
      }

      expect(Issue.find(1).subject).not_to eq(subject_test)
      expect(response).to be_successful
      expect(response.body).to match /Notes cannot be blank/
    end

    it "updates an issue if notes is required and empty, when use without permission" do
      subject_test = 'issue with empty note'

      put :update, params: {
        :id => 5, # Issue 5
        :issue => {
          :status_id => 1,
          :subject => subject_test,
        },
      }

      expect(Issue.find(5).subject).to eq(subject_test)
      expect(response).to be_a_redirect
      expect(response.body).to_not match /Notes cannot be blank/
    end

  end

  describe '#retrieve_previous_and_next_issue_ids' do

    let(:issue) { Issue.first }

    context 'with asynchronous loading enabled' do
      before do
        Setting.send "plugin_redmine_tiny_features=", {
          "warning_message_on_closed_issues" => "1",
          "default_open_status" => "2",
          "default_project" => "1",
          "load_issue_edit_form_asynchronously" => "1",
        }
      end

      it 'allows patched method to receive an argument' do
        controller.retrieve_previous_and_next_issue_ids(false)
      end

      it 'allows patched method to receive true as an argument' do
        controller.retrieve_previous_and_next_issue_ids(true)
      end

      it 'renders previous and next issue ids as JSON response' do
        get :load_previous_and_next_issue_ids, params: { id: issue.id }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to have_key('html')
      end
    end
  end

end
