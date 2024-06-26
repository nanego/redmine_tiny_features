require_dependency 'issue_priority'

module RedmineTinyFeatures::IssuePriorityPatch
  def css_classes
    default_classes = super
    color.present? ? "#{default_classes} priority-#{color}" : default_classes
  end
end

class IssuePriority < Enumeration

  COLOR_LIST = %w( green orange red grey )

  validates_inclusion_of :color, :in => COLOR_LIST

  before_validation :set_color

  def set_color
    self.color = COLOR_LIST.first if self.color.blank?
  end
end

IssuePriority.prepend RedmineTinyFeatures::IssuePriorityPatch
