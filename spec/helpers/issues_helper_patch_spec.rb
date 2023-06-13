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
    it "displays journal details from method IssuesHelper#show_detail without html (Note of name of user (#739) deleted)" do
      detail = JournalDetail.new(:property => 'note', :prop_key => 2, :old_value => 1)
      expect(show_detail(detail, true)).to eq "Note added by John Smith (#1) deleted"
    end

    it "displays journal details from method IssuesHelper#show_detail with HTML highlights (Note of name of user (#739) deleted)" do
      detail = JournalDetail.new(:property => 'note', :prop_key => 2, :old_value => 1)
      expect(show_detail(detail, false)).to eq "Note added by John Smith (#<del>1</del>) deleted"
    end

    context "User has been deleted" do
      it "displays journal details from method IssuesHelper#show_detail with anonymous author" do
        detail = JournalDetail.new(:property => 'note', :prop_key => 999, :old_value => 1)
        expect(show_detail(detail, true)).to eq "Note added by Anonymous (#1) deleted"
      end
    end

  end
end
