require_dependency 'issue_priority'

module RedmineTinyFeatures::IssuePriorityPatch
  def css_classes
    classes = super
    classes << " priority-#{color}" if color.present?
    classes
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
