require_dependency 'enumerations_helper'

module RedmineTinyFeatures
  module EnumerationsHelperPatch
    def priorities_colors_list
      IssuePriority::COLOR_LIST.collect { |color| [l("label_#{color}"), color] }
    end
  end
end

EnumerationsHelper.prepend RedmineTinyFeatures::EnumerationsHelperPatch
ActionView::Base.send(:include, EnumerationsHelper)
