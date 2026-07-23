require_dependency 'issues_helper'

module RedmineTinyFeatures
  module IssuesHelperPatch

    def show_detail(detail, no_html = false, options = {})
      case detail.property
      when 'note'
        author = User.where(id: detail.prop_key).first || User.anonymous
        if no_html
          note_id = detail.old_value
        else
          note_id = content_tag("del", detail.old_value)
        end
        l(:text_note_deleted, :author => author.name, :note_id => note_id).html_safe
      else
        # Process standard properties
        super
      end
    end

  end
end

IssuesHelper.prepend RedmineTinyFeatures::IssuesHelperPatch
ActionView::Base.prepend IssuesHelper
