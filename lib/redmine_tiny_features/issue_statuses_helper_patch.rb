require_dependency 'issue_statuses_helper'

module RedmineTinyFeatures
  module IssueStatusesHelper
    def valid_color_list
      IssueStatus.valid_color_list.collect {|o| [l(o.last), o.first]}
    end
  end
end

IssueStatusesHelper.prepend RedmineTinyFeatures::IssueStatusesHelper
ActionView::Base.send(:include, IssueStatusesHelper)