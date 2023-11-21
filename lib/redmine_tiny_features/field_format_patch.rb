require 'redmine/field_format'

module RedmineTinyFeatures
  module FieldFormatPatch

    module EnumerationFormat
      def possible_values_records(custom_field, object = nil)
        enumerations = custom_field.enumerations.active
        if object.present? && object.try(:project).present?
          disabled_ids = DisabledCustomFieldEnumeration.disabled_ids_for(object.project)
          enumerations = enumerations.where("id NOT IN (?)", disabled_ids) if disabled_ids.present?
        end
        enumerations
      end
    end

    module List
      # Renders the edit tag as check box or radio tags
      def check_box_edit_tag(view, tag_id, tag_name, custom_value, options = {})
        opts = []
        unless custom_value.custom_field.multiple? || custom_value.custom_field.is_required?
          opts << ["(#{l(:label_none)})", '']
        end
        opts += possible_custom_value_options(custom_value)
        s = ''.html_safe
        tag_method = custom_value.custom_field.multiple? ? :check_box_tag : :radio_button_tag
        opts.each do |label, value|
          value ||= label
          checked = (custom_value.value.is_a?(Array) && custom_value.value.include?(value)) ||
            custom_value.value.to_s == value

          #################
          ##### START PATCH
          if custom_value.value.blank? && custom_value.custom_field.is_required? && custom_value.custom_field.default_value.present?
            checked = custom_value.custom_field.default_value == value
          end
          ## END PATCH
          #################

          tag = view.send(tag_method, tag_name, value, checked, :id => nil)
          s << view.content_tag('label', tag + ' ' + label)
        end
        if custom_value.custom_field.multiple?
          s << view.hidden_field_tag(tag_name, '', :id => nil)
        end
        css = "#{options[:class]} check_box_group"
        view.content_tag('span', s, options.merge(:class => css))
      end
    end
  end
end

Redmine::FieldFormat::EnumerationFormat.prepend RedmineTinyFeatures::FieldFormatPatch::EnumerationFormat
Redmine::FieldFormat::List.prepend RedmineTinyFeatures::FieldFormatPatch::List

module Redmine::FieldFormat
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
      edit_tag << view.content_tag(:span, custom_value.value, class: "range_selected_value")
      edit_tag << view.javascript_tag(
        <<~JAVASCRIPT
          $(document).on("input change", "##{tag_id}", function(e) {
            var value = $(this).val();
            $(this).next('.range_selected_value').html(value);
          })
        JAVASCRIPT
      )
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
