require_dependency 'issues_helper'

module RedmineTinyFeatures
  module IssuesHelper

    def show_detail(detail, no_html = false, options = {})
      case detail.property
      when 'note'
        label ||= l(:label_note) + l(:label_of) +  User.find(detail.prop_key).name
        old_value ||= detail.old_value
        unless no_html
          label = content_tag('strong', l(:label_note)) + l(:label_of) + User.find(detail.prop_key).name
          old_value = content_tag("del", detail.old_value)
        end
        l(:text_note_deleted, :label => label, :old => old_value).html_safe
      else
        # Process standard properties
        super
      end
    end

    ## TODO Remove this patch: override the specific issues#index view instead of the widely used helper method
    def actions_dropdown(&block)
      content = capture(&block)

      ## START PATCH
      # insert link to switch issues display mode
      if controller.controller_name == 'issues' && controller.action_name == 'index'
        current_mode = User.current.issue_display_mode == User::BY_STATUS ? l(:label_issue_display_by_priority) : l(:label_issue_display_by_status)
        content.prepend link_to current_mode, switch_display_mode_path(:path => request.url), method: :post, :class => 'icon icon-projects'
      end
      ## END PATCH

      if content.present?
        trigger =
          content_tag('span', l(:button_actions), :class => 'icon-only icon-actions',
                      :title => l(:button_actions))
        trigger = content_tag('span', trigger, :class => 'drdn-trigger')
        content = content_tag('div', content, :class => 'drdn-items')
        content = content_tag('div', content, :class => 'drdn-content')
        content_tag('span', trigger + content, :class => 'drdn')
      end
    end

  end
end

IssuesHelper.prepend RedmineTinyFeatures::IssuesHelper
ActionView::Base.prepend IssuesHelper
