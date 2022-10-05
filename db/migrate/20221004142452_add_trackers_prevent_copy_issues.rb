class AddTrackersPreventCopyIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :trackers, :prevent_copy_issues, :boolean, :default => false    
  end
end
