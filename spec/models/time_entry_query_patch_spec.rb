require "spec_helper"

describe "TimeEntryQuery" do
  it "should respond to find_author_id_filter_values" do
    time_entry_query = TimeEntryQuery.new
    expect(time_entry_query.respond_to?('find_author_id_filter_values')).to eq true
  end

  it "should respond to find_user_id_filter_values" do
    time_entry_query = TimeEntryQuery.new
    expect(time_entry_query.respond_to?('find_user_id_filter_values')).to eq true
  end

  it "should contain empty values for available_filter author_id, user_id" do
    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues"=>"1",
      "default_open_status"=>"2",
      "default_project"=>"1",
      "use_select2"=>"1",
      "paginate_issue_filters_values"=>"1"
    }

    time_entry_query = TimeEntryQuery.new
    expect(time_entry_query.available_filters["author_id"][:values]).to be_empty
    expect(time_entry_query.available_filters["user_id"][:values]).to be_empty
  end
end
