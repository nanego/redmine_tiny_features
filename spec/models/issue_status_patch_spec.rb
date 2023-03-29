require 'spec_helper'

describe "RedmineTinyFeaturesIssueStatusPatch" do
  fixtures :issue_statuses

  context "#color" do
    it "should be a safe attribute color" do
      issue_status = IssueStatus.find(1)
      expect(issue_status.color).to eq("")
      issue_status.safe_attributes = {"color" => "green"}
      issue_status.save
      expect(issue_status.color).to eq("green")
    end

    it "should add by default the first color" do
      issue_status = IssueStatus.create(:name => "test", :position => 7, :is_closed =>false, :default_done_ratio => 1)
      expect(issue_status.color).to eq(IssueStatus::valid_color_list.collect(&:first).first)
    end
  end
end