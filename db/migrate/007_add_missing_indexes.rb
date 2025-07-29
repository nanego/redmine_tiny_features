class AddMissingIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :disabled_custom_field_enumerations, :custom_field_enumeration_id, name: :index_disabled_custom_field_enumeration_id, if_not_exists: true
    add_index :disabled_custom_field_enumerations, :project_id, if_not_exists: true
  end
end
