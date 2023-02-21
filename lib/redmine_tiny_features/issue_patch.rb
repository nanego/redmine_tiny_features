require_dependency 'issue'

module RedmineTinyFeatures
  module IssuePatch
    # Returns a string of css classes that apply to the issue
    def css_classes(user = User.current)
      s = super
      # restore priorities by position, broken by recent redmine commits
      # see: http://www.redmine.org/projects/redmine/repository/revisions/10079
      if user.issue_display_mode == User::BY_STATUS
        s << " #{status.try(:css_classes)}"
      else
        s.gsub!(/ priority-\d+/, " priority-#{priority.position}") unless Rails.env.test?
      end

      s
    end
  end
end


class Issue < ActiveRecord::Base
  prepend RedmineTinyFeatures::IssuePatch

  def self.by_priority(project, with_subprojects = false, year = nil)
    count_and_group_by(:project => project, :association => :priority, :with_subprojects => with_subprojects, :year => year)
  end
end