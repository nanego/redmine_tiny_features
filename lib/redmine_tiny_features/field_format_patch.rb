require 'redmine/field_format'

module Redmine
  module FieldFormat

    class EnumerationFormat < RecordList

      def possible_values_records(custom_field, object=nil)
        disabled_ids = DisabledCustomFieldEnumeration.disabled_ids_for(object.project) if object.present? && object.try(:project).present?
        if disabled_ids.any?
          custom_field.enumerations.active.where("id NOT IN (?)", disabled_ids)
        else
          custom_field.enumerations.active
        end
      end

    end

  end
end
