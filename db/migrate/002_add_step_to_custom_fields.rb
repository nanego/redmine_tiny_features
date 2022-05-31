class AddStepToCustomFields < ActiveRecord::Migration[5.2]
  def change
    add_column :custom_fields, :steps, :integer
    add_column :custom_fields, :min_value, :integer
    add_column :custom_fields, :max_value, :integer
  end
end
