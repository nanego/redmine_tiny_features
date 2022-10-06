class AddTrackersPreventCopyIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :trackers, :prevent_issue_copy, :boolean, :default => false
  end
end
