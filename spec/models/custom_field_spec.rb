require "spec_helper"

describe "CustomField" do
  describe "Range custom-field format" do

    it "validates Range custom-field before saving" do
      field = CustomField.new(:name => 'test_before_validation', :field_format => 'range')
      field.min_value = 0
      field.max_value = 20
      field.steps = 2
      field.searchable = true
      expect(field.save).to be_truthy

      field.reload

      expect(field.steps).to eq 2
      expect(field.max_value).to eq 20
      expect(field.searchable).to be_falsey # Integer values are not searchable
    end

    it "validates the default_value" do
      field = CustomField.new(:name => 'Test', :field_format => 'range')
      field.default_value = 'abc'
      expect(field.valid?).to be_falsey
      field.default_value = '6'
      expect(field.valid?).to be_truthy
    end

    it "validates possible values" do
      f = CustomField.new(:field_format => 'range')

      assert f.valid_field_value?(nil)
      assert f.valid_field_value?('')
      assert !f.valid_field_value?(' ')
      assert f.valid_field_value?('123')
      assert f.valid_field_value?(' 123 ')
      assert f.valid_field_value?('+123')
      assert f.valid_field_value?('-123')
      assert !f.valid_field_value?('9abc')
      assert f.valid_field_value?(123)
    end

  end
end
