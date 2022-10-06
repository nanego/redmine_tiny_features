require 'spec_helper'

describe "TrackerPatch" do
  fixtures :trackers

  it "should Tracker#prevent_issue_copy" do
    tracker = Tracker.find(1)
    tracker.safe_attributes = ({ "prevent_issue_copy" => 1 })
    assert tracker.prevent_issue_copy

    tracker.safe_attributes = ({ "prevent_issue_copy" => 0 })
    assert !tracker.prevent_issue_copy
  end
end
