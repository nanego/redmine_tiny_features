require "spec_helper"

describe "IssuesHelperPatch" do
  include ApplicationHelper
  include IssuesHelper
  include CustomFieldsHelper
  include ERB::Util
  include ActionView::Helpers::TagHelper

  fixtures :issues, :users

  before do
    set_language_if_valid('en')
    User.current = nil
  end

  describe "issue history" do
    it "should IssuesHelper#show_detail with no_html should (Note of name of user (#739) deleted)" do
      detail = JournalDetail.new(:property => 'note',:prop_key => 1, :old_value => 1)
      expect(show_detail(detail, true)).to eq "Note  of #{User.find(1).name} (#1) deleted"
    end

    it "should IssuesHelper#show_detail with no_html should (Note of name of user (#739) deleted) HTML highlights" do
      detail = JournalDetail.new(:property => 'note',:prop_key => 1, :old_value => 1)
      expect(show_detail(detail, false)).to eq "<strong>Note  </strong>of #{User.find(1).name} (#<del>1</del>) deleted"
    end

  end
end