require_dependency 'issue_statuses_helper'

module RedmineTinyFeatures
  module IssueStatusesHelperPatch
    def valid_color_list
      IssueStatus.valid_color_list.collect {|o| [l(o.last), o.first]}
    end
  end
end

IssueStatusesHelper.prepend RedmineTinyFeatures::IssueStatusesHelperPatch
ActionView::Base.send(:include, IssueStatusesHelper)
