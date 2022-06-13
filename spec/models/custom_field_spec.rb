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

    describe "Update the table disabled_custom_field_enumerations in case of cascade deleting" do
      let(:project) { Project.find(1) }
      let(:field) { CustomField.create(:name => 'Test', :field_format => 'enumeration') }
      let(:c_f_e1) { CustomFieldEnumeration.create(name: 'val1', position: 1, active: true, custom_field_id: field.id) }
      let(:c_f_e2) { CustomFieldEnumeration.create(name: 'val2', position: 2, active: true, custom_field_id: field.id) }

      before do
        CustomFieldEnumeration.create(name: 'val3', position: 3, active: true, custom_field_id: field.id)
        DisabledCustomFieldEnumeration.create(project: project, custom_field_enumeration_id: c_f_e1.id)
        DisabledCustomFieldEnumeration.create(project: project, custom_field_enumeration_id: c_f_e2.id)
        expect(DisabledCustomFieldEnumeration.count).to eq(2)
      end

      it "Should update the table disabled_custom_field_enumerations when deleting a project" do
        project.destroy
        expect(DisabledCustomFieldEnumeration.count).to eq(0)
      end

      it "Should update the table disabled_custom_field_enumerations when deleting a customField" do
        field.destroy
        expect(DisabledCustomFieldEnumeration.count).to eq(0)
      end

      it "Should update the table disabled_custom_field_enumerations when deleting a CustomFieldEnumeration" do
        c_f_e1.destroy
        expect(DisabledCustomFieldEnumeration.count).to eq(1)
      end
    end
  end
end
