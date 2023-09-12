class AddShowPaginationAtTopResults < ActiveRecord::Migration[5.2]
  def change
    add_column :user_preferences, :show_pagination_at_top_results, :boolean, :default => false
  end
end