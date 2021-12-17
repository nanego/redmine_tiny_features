require_dependency 'issues_helper'

module RedmineTinyFeatures
  module IssuesHelper

    def show_detail(detail, no_html = false, options = {})
      case detail.property
      when 'note'
        label ||= l(:label_note)
        old_value ||= detail.old_value
        unless no_html
          label = content_tag('strong', l(:label_note))
          old_value = content_tag("del", detail.old_value)
        end
        l(:text_journal_deleted, :label => label, :old => old_value).html_safe + '  ' +  l(:label_of) + '  ' + User.find(detail.prop_key).name
      else
        # Process standard properties
        super
      end
    end

  end
end

IssuesHelper.prepend RedmineTinyFeatures::IssuesHelper
ActionView::Base.prepend IssuesHelper
