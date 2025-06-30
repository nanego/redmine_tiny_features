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

  it "should respond to find_watcher_id_filter_values" do
    issue_query = IssueQuery.new
    expect(issue_query.respond_to?('find_watcher_id_filter_values')).to eq true
  end

  context "available_filter" do

    before do
      User.current = User.find(1)
    end

    describe "paginate_issue_filters_values" do
      it "should contain empty values for available_filter author_id, assigned_to_id, updated_by, last_updated_by" do
        Setting["plugin_redmine_tiny_features"] = {
          "warning_message_on_closed_issues" => "1",
          "default_open_status" => "2",
          "default_project" => "1",
          "use_select2" => "1",
          "paginate_issue_filters_values" => "1"
        }

        issue_query = IssueQuery.new
        expect(issue_query.available_filters["author_id"][:values]).to be_empty
        expect(issue_query.available_filters["assigned_to_id"][:values]).to be_empty
        expect(issue_query.available_filters["updated_by"][:values]).to be_empty
        expect(issue_query.available_filters["last_updated_by"][:values]).to be_empty
        expect(issue_query.available_filters["watcher_id"][:values]).to be_empty
      end

      it "should not contain empty values for available_filter author_id, assigned_to_id, updated_by, last_updated_by,watcher_id (use_select2 deactivated only)" do

        Setting["plugin_redmine_tiny_features"] = {
          "warning_message_on_closed_issues" => "1",
          "default_open_status" => "2",
          "default_project" => "1",
          "paginate_issue_filters_values" => "1"
        }

        issue_query = IssueQuery.new
        expect(issue_query.available_filters["author_id"][:values]).not_to be_empty
        expect(issue_query.available_filters["assigned_to_id"][:values]).not_to be_empty
        expect(issue_query.available_filters["updated_by"][:values]).not_to be_empty
        expect(issue_query.available_filters["last_updated_by"][:values]).not_to be_empty
        expect(issue_query.available_filters["watcher_id"][:values]).not_to be_empty
      end

      it "should not contain empty values for available_filter author_id, assigned_to_id, updated_by, last_updated_by,watcher_id (use_select2 and paginate_issue_filters_values deactivated)" do

        Setting["plugin_redmine_tiny_features"] = {
          "warning_message_on_closed_issues" => "1",
          "default_open_status" => "2",
          "default_project" => "1",
        }

        issue_query = IssueQuery.new
        expect(issue_query.available_filters["author_id"][:values]).not_to be_empty
        expect(issue_query.available_filters["assigned_to_id"][:values]).not_to be_empty
        expect(issue_query.available_filters["updated_by"][:values]).not_to be_empty
        expect(issue_query.available_filters["last_updated_by"][:values]).not_to be_empty
        expect(issue_query.available_filters["watcher_id"][:values]).not_to be_empty
      end
    end

    describe "show_all_users_in_author_filter" do

      it "shows only members of projects if the function is NOT activated" do
        Setting["plugin_redmine_tiny_features"] = {
          "paginate_issue_filters_values" => "0",
          "display_all_users_in_author_filter" => "0"
        }
        issue_query = IssueQuery.new

        all_active_users = User.active
        member_of_any_projects = User.member_of(Project.visible.to_a)
        added_users_count = 2 # Me & Anonymous

        expect(issue_query.available_filters["author_id"][:values].size).to eq member_of_any_projects.size + added_users_count
        expect(issue_query.available_filters["author_id"][:values].size).to_not eq all_active_users.size + added_users_count
      end

      it "shows ALL active users if the function IS activated" do
        Setting["plugin_redmine_tiny_features"] = {
          "paginate_issue_filters_values" => "0",
          "display_all_users_in_author_filter" => "1"
        }
        issue_query = IssueQuery.new

        all_active_users = User.all
        member_of_any_projects = User.member_of(Project.visible.to_a)
        added_users_count = 2 # Me & Anonymous

        expect(issue_query.available_filters["author_id"][:values].size).to_not eq member_of_any_projects.size + added_users_count
        expect(issue_query.available_filters["author_id"][:values].size).to eq all_active_users.size + added_users_count
      end

    end
  end
end
