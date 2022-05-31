require 'redmine/field_format'

module Redmine
  module FieldFormat

    class EnumerationFormat < RecordList
      def possible_values_records(custom_field, object = nil)
        enumerations = custom_field.enumerations.active
        if object.present? && object.try(:project).present?
          disabled_ids = DisabledCustomFieldEnumeration.disabled_ids_for(object.project)
          enumerations = enumerations.where("id NOT IN (?)", disabled_ids) if disabled_ids.present?
        end
        enumerations
      end
    end

    class RangeFormat < Numeric
      add 'range'

      self.form_partial = 'custom_fields/formats/range'

      def label
        "label_range"
      end

      field_attributes :steps, :min_value, :max_value

      def edit_tag(view, tag_id, tag_name, custom_value, options = {})
        edit_tag = view.range_field_tag(tag_name,
                                        custom_value.value || custom_value.custom_field.default_value,
                                        options.merge(id: tag_id,
                                                      min: custom_value.custom_field.min_value,
                                                      max: custom_value.custom_field.max_value,
                                                      step: custom_value.custom_field.steps))
        edit_tag
      end

      def cast_single_value(custom_field, value, customized = nil)
        value.to_i
      end

      def validate_single_value(custom_field, value, customized = nil)
        errs = super
        errs << ::I18n.t('activerecord.errors.messages.not_a_number') unless /^[+-]?\d+$/.match?(value.to_s.strip)
        errs
      end

      def query_filter_options(custom_field, query)
        { :type => :integer }
      end

      def group_statement(custom_field)
        order_statement(custom_field)
      end
    end

  end
end

class CustomField < ActiveRecord::Base
  safe_attributes("steps", "min_value", "max_value")
end
