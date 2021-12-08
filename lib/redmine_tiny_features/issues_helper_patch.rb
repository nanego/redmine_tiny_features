require_dependency 'issues_helper'

module RedmineTinyFeatures
  module IssuesHelper

    def show_detail(detail, no_html = false, options = {})
      case detail.property
      when 'note'
        label = l(:label_note)
      else
        # Process standard properties
        super
      end
    end

  end
end

IssuesHelper.prepend RedmineTinyFeatures::IssuesHelper
ActionView::Base.prepend IssuesHelper
