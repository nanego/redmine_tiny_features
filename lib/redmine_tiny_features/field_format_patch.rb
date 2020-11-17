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

  end
end
