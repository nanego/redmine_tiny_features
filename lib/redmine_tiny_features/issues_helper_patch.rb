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

    ## TODO Remove this patch: override the specific issues#index view instead of the widely used helper method
    def actions_dropdown(&block)
      return super unless controller.controller_name == 'issues' && controller.action_name == 'index'

      # insert link to switch issues display mode, let the core render the dropdown itself
      current_mode = User.current.issue_display_mode == User::BY_STATUS ? l(:label_issue_display_by_priority) : l(:label_issue_display_by_status)
      switch_link = link_to current_mode, switch_display_mode_path(:path => request.url), method: :post, :class => 'icon icon-projects'
      super() { switch_link + capture(&block).to_s }
    end

  end
end

IssuesHelper.prepend RedmineTinyFeatures::IssuesHelperPatch
ActionView::Base.prepend IssuesHelper
