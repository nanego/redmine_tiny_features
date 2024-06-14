class AddColorToEnumerations < ActiveRecord::Migration[5.2]
  def change
    add_column :enumerations, :color, :string, :default => '', :null => false
  end
end
