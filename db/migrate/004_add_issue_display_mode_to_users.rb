class AddIssueDisplayModeToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :issue_display_mode, :string, :default => '', :null => false unless column_exists?(:users, :issue_display_mode)
    add_column :issue_statuses, :color, :string, :default => '', :null => false unless column_exists?(:issue_statuses, :color)
  end

  def self.down
    remove_column :users, :issue_display_mode
    remove_column :issue_statuses, :color
  end
end
