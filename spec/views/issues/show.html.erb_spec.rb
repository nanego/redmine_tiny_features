require "spec_helper"

describe "issues/show.html.erb", type: :view do

  fixtures :issues, :enumerations, :users, :projects, :issue_statuses, :trackers

  helper :projects
  helper :custom_fields
  helper :issue_relations
  helper :watchers
  helper :attachments
  helper :timelog
  helper :routes
  helper :queries
  helper :avatars

  let(:issue) { Issue.find(8) } #closed issue
  let(:open_issue) { Issue.find(3) } #open issue
  let(:project) { Project.find(1) }
  let(:user) { User.find(2) } #member of project(1)

  before do
    User.current = user
    assign(:user, user)
    assign(:project, project)
    assign(:priorities, IssuePriority.active)
    assign(:relation, IssueRelation.new)
  end

  it "contains a warning to prevent to re-open it if a new issue is more appropriate" do
    assign(:issue, issue)
    assign(:journals, issue.journals.includes(:user, :details).reorder("#{Journal.table_name}.id ASC").to_a)
    assign(:allowed_statuses, issue.new_statuses_allowed_to(User.current))
    assign(:time_entry, TimeEntry.new(:issue => issue, :project => issue.project))
    assign(:relations, issue.relations.select { |r| r.other_issue(issue) && r.other_issue(issue).visible? })

    controller.request.path_parameters[:id] = issue.id
    render

    assert_select "div#warning-issue-closed"
  end

  it "doest NOT contain a warning to prevent to re-open it when issue is open" do
    assign(:issue, open_issue)
    assign(:journals, open_issue.journals.includes(:user, :details).reorder("#{Journal.table_name}.id ASC").to_a)
    assign(:allowed_statuses, open_issue.new_statuses_allowed_to(User.current))
    assign(:time_entry, TimeEntry.new(:issue => open_issue, :project => open_issue.project))
    assign(:relations, open_issue.relations.select { |r| r.other_issue(issue) && r.other_issue(issue).visible? })

    controller.request.path_parameters[:id] = open_issue.id
    render

    assert_select "div#warning-issue-closed", false
  end

  it "doest not contains a warning to prevent to re-open it if feature is disabled" do
    with_settings :plugin_redmine_tiny_features => {'warning_message_on_closed_issues' => false} do
      assign(:issue, issue)
      assign(:journals, issue.journals.includes(:user, :details).reorder("#{Journal.table_name}.id ASC").to_a)
      assign(:allowed_statuses, issue.new_statuses_allowed_to(User.current))
      assign(:time_entry, TimeEntry.new(:issue => issue, :project => issue.project))
      assign(:relations, issue.relations.select { |r| r.other_issue(issue) && r.other_issue(issue).visible? })

      controller.request.path_parameters[:id] = issue.id
      render

      assert_select "div#warning-issue-closed", false
    end
  end

end
