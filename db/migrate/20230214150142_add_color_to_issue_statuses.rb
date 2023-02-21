class AddColorToIssueStatuses < ActiveRecord::Migration[5.2]
  def self.up
    add_column :issue_statuses, :color, :string, :default => '', :null => false
  end

  def self.down
    remove_column :issue_statuses, :color
  end
end
