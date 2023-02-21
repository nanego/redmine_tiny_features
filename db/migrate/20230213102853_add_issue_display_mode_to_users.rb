class AddIssueDisplayModeToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :issue_display_mode, :string, :default => '', :null => false
  end

  def self.down
    remove_column :users, :issue_display_mode
  end
end
