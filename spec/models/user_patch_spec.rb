require 'spec_helper'

describe "RedmineTinyFeaturesUserPatch" do
  fixtures :projects, :users, :roles, :members, :member_roles, :issues, :issue_statuses, :versions, :trackers,
           :projects_trackers, :issue_categories, :enabled_modules, :enumerations, :attachments, :workflows,
           :custom_fields, :custom_values, :custom_fields_projects, :custom_fields_trackers, :time_entries,
           :journals, :journal_details, :queries, :repositories, :changesets,
           :issue_relations, :watchers, :email_addresses

  before do
    User.current = User.find(1)
  end

  context "#issue_display_mode" do
    it "should be a safe attribute issue_display_mode" do
      user = User.find(1)
      expect(user.issue_display_mode).to eq("")
      user.safe_attributes = {"issue_display_mode" => "by_status"}
      user.save
      expect(user.issue_display_mode).to eq("by_status")
    end

    it "should add by default issue_display_mode by priority" do
      user = User.create(:login => "test", :firstname => 'test', :lastname => 'test',
              :mail => 'test.test@test.fr', :language => 'fr')
      
      expect(user.issue_display_mode).to eq("by_priority")
    end
  end

end
