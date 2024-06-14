require_dependency 'enumerations_helper'

module RedmineTinyFeatures
  module EnumerationsHelperPatch
    def valid_priority_color_list
      IssuePriority.valid_priority_color_list.collect {|o| [l(o.last), o.first]}
    end

    def plugin_test_mode?
      Rails.env.test? && $testing_plugin
    end
  end
end

EnumerationsHelper.prepend RedmineTinyFeatures::EnumerationsHelperPatch
ActionView::Base.send(:include, EnumerationsHelper)
