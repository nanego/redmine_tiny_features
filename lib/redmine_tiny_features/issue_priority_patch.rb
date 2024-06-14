require_dependency 'issue_priority'

module RedmineTinyFeatures::IssuePriorityPatch
  def css_classes
    if !Rails.env.test? || plugin_test_mode?
      "priority-#{color}"
    else
      super
    end
  end
end

class IssuePriority < Enumeration

  COLOR_LIST = [
    ['green', :label_green],
    ['orange', :label_orange],
    ['red', :label_red],
    ['grey', :label_grey],
  ]

  validates_inclusion_of :color, :in => COLOR_LIST.collect(&:first)

  before_validation :set_color

  def set_color
    self.color = COLOR_LIST.collect(&:first).first if self.color.blank?
    true
  end

  def self.valid_priority_color_list
    COLOR_LIST
  end
end

IssuePriority.prepend RedmineTinyFeatures::IssuePriorityPatch