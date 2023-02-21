require_dependency 'issue_status'

class IssueStatus < ActiveRecord::Base
  safe_attributes 'color', 'suggested_status_ids', 'status_ids'

  has_many :issue_suggested_statuses, :class_name => "SuggestedIssueStatuses", :foreign_key => "suggested_status_id", dependent: :delete_all
  has_many :statuses, :through => :issue_suggested_statuses
  has_many :suggested_issue_statuses, :class_name => "SuggestedIssueStatuses", :foreign_key => "status_id", dependent: :delete_all
  has_many :suggested_statuses, :through => :suggested_issue_statuses

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
