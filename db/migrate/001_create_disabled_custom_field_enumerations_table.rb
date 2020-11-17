class CreateDisabledCustomFieldEnumerationsTable < ActiveRecord::Migration[5.2]
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :disabled_custom_field_enumerations
      create_table :disabled_custom_field_enumerations do |t|
        t.column :project_id, :integer, :null => false
        t.column :custom_field_enumeration_id, :integer, :null => false
      end
      add_index :disabled_custom_field_enumerations, [:project_id, :custom_field_enumeration_id], :unique => true, name: "uniq_disabled_custom_field_enumeration"
    end
  end

  def self.down
    drop_table :disabled_custom_field_enumerations
  end
end
