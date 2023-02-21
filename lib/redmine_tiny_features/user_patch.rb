require_dependency 'project' # see: http://www.redmine.org/issues/11035
require_dependency 'principal'
require_dependency 'user'

class User < Principal

  #mark 'staff' as safe attribute
  #as it can be updated through the standard form
  safe_attributes 'issue_display_mode'

  BY_PRIORITY = 'by_priority'
  BY_STATUS = 'by_status'

  ISSUE_DISPLAY_MODE_OPTIONS = [
    [self::BY_PRIORITY, :label_issue_mode_by_priority],
    [self::BY_STATUS, :label_issue_mode_by_status],
  ]

  validates_inclusion_of :issue_display_mode, :in => ISSUE_DISPLAY_MODE_OPTIONS.collect(&:first)

  before_validation :set_issue_display_mode

  def set_issue_display_mode
    self.issue_display_mode = ISSUE_DISPLAY_MODE_OPTIONS.collect(&:first).first if self.issue_display_mode.blank?
    true
  end

  def self.valid_issue_mode_options
    ISSUE_DISPLAY_MODE_OPTIONS
  end
end
