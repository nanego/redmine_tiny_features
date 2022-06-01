require "spec_helper"

describe "IssueQuery" do
  it "should respond to find_updated_by_filter_values" do
    issue_query = IssueQuery.new
    expect(issue_query.respond_to?('find_updated_by_filter_values')).to eq true
  end

  it "should respond to find_last_updated_by_filter_values" do
    issue_query = IssueQuery.new
    expect(issue_query.respond_to?('find_last_updated_by_filter_values')).to eq true
  end

  it "should contain empty values for available_filter author_id, assigned_to_id, updated_by, last_updated_by" do

    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues"=>"1",
      "default_open_status"=>"2",
      "default_project"=>"1",
      "use_select2"=>"1",
      "paginate_issue_filters_values"=>"1"
    }

    issue_query = IssueQuery.new
    expect(issue_query.available_filters["author_id"][:values]).to be_empty
    expect(issue_query.available_filters["assigned_to_id"][:values]).to be_empty
    expect(issue_query.available_filters["updated_by"][:values]).to be_empty
    expect(issue_query.available_filters["last_updated_by"][:values]).to be_empty
  end

  it "should not contain empty values for available_filter author_id, assigned_to_id, updated_by, last_updated_by (use_select2 deactivated only)" do

    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues"=>"1",
      "default_open_status"=>"2",
      "default_project"=>"1",
      "use_select2"=>"0",
      "paginate_issue_filters_values"=>"1"
    }

    issue_query = IssueQuery.new
    expect(issue_query.available_filters["author_id"][:values]).not_to be_empty
    expect(issue_query.available_filters["assigned_to_id"][:values]).not_to be_empty
    expect(issue_query.available_filters["updated_by"][:values]).not_to be_empty
    expect(issue_query.available_filters["last_updated_by"][:values]).not_to be_empty
  end

  it "should not contain empty values for available_filter author_id, assigned_to_id, updated_by, last_updated_by (use_select2 and paginate_issue_filters_values deactivated)" do

    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues"=>"1",
      "default_open_status"=>"2",
      "default_project"=>"1",
      "use_select2"=>"0",
      "paginate_issue_filters_values"=>"0"
    }

    issue_query = IssueQuery.new
    expect(issue_query.available_filters["author_id"][:values]).not_to be_empty
    expect(issue_query.available_filters["assigned_to_id"][:values]).not_to be_empty
    expect(issue_query.available_filters["updated_by"][:values]).not_to be_empty
    expect(issue_query.available_filters["last_updated_by"][:values]).not_to be_empty
  end

end
