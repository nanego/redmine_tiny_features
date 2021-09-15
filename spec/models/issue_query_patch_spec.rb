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
    issue_query = IssueQuery.new
    expect(issue_query.available_filters["author_id"][:values]).to be_empty
    expect(issue_query.available_filters["assigned_to_id"][:values]).to be_empty
    expect(issue_query.available_filters["updated_by"][:values]).to be_empty
    expect(issue_query.available_filters["last_updated_by"][:values]).to be_empty
  end
end