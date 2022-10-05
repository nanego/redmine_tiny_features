require 'spec_helper'

describe "TrackerPatch" do
  fixtures :trackers
  
  it "should Tracker#prevent_copy_issues" do
    tracker = Tracker.find(1)
    tracker.safe_attributes=({ "prevent_copy_issues" => 1 })
    assert tracker.prevent_copy_issues
    
    tracker.safe_attributes=({ "prevent_copy_issues" => 0 })
    assert !tracker.prevent_copy_issues
  end
end