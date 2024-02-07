require_dependency 'issue_status'

module RedmineTinyFeatures::IssueStatusPatch

end

class IssueStatus < ActiveRecord::Base
  safe_attributes 'color', 'status_ids' #,'suggested_status_ids'

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

  def self.valid_color_list
    COLOR_LIST
  end

  def css_classes
    "status-#{color}"
  end
end
