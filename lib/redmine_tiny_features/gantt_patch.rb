# frozen_string_literal: true

module RedmineTinyFeatures
  module GanttPatch

    def collapse_gantt_chart_at_project_level?
      projects.count > 1 &&
        Setting["plugin_redmine_tiny_features"]["collapse_gantt_chart_at_project_level"].present?
    end

    # Override methods to render projects collapsed when the setting is enabled
    #
    def html_subject(params, subject, object)
      content = html_subject_content(object) || subject
      tag_options = {}
      case object
      when Issue
        tag_options[:id] = "issue-#{object.id}"
        tag_options[:class] = "issue-subject hascontextmenu"
        tag_options[:title] = object.subject
        has_children =
          if object.leaf?
            false
          else
            children = object.children & project_issues(object.project)
            fixed_version_id = object.fixed_version_id
            children.any? { |child| child.fixed_version_id == fixed_version_id }
          end
      when Version
        tag_options[:id] = "version-#{object.id}"
        tag_options[:class] = "version-name"
        has_children = object.fixed_issues.exists?
      when Project
        tag_options[:class] = "project-name"
        has_children = object.issues.exists? || object.versions.exists?
      end

      puts "params :"
      puts params.inspect

      if object
        tag_options[:data] = {
          :collapse_expand => {
            :top_increment => params[:top_increment],
            :obj_id => "#{object.class}-#{object.id}".downcase,
          },
          :number_of_rows => number_of_rows,
        }
      end

      if has_children

        # CUSTOMIZATION STARTS HERE
        #

        # Check if we should collapse projects
        collapse_projects = object.is_a?(Project) &&
                            collapse_gantt_chart_at_project_level?

        if collapse_projects && object != @project
          # Render project collapsed: use angle-right icon and no 'open' class
          content = view.content_tag(:span,
                                     view.sprite_icon('angle-right').html_safe,
                                     :class => 'icon icon-collapsed expander') + content
        else
          # Default behavior: render expanded with angle-down icon and 'open' class
          content = view.content_tag(:span,
                                     view.sprite_icon('angle-down').html_safe,
                                     :class => 'icon icon-expanded expander') + content
          tag_options[:class] += ' open'
        end

        #
        # CUSTOMIZATION ENDS HERE

      else
        if params[:indent]
          params = params.dup
          params[:indent] += 18
        end
      end

      style = "position: absolute;top:#{params[:top]}px;left:#{params[:indent]}px;"

      ## ADD CUSTOM STYLES TO HIDE LINES
      style += "display:none;" if (object.is_a?(Issue) || object.is_a?(Version)) && collapse_gantt_chart_at_project_level?

      style += "width:#{params[:subject_width] - params[:indent]}px;" if params[:subject_width]
      tag_options[:style] = style
      output = view.content_tag(:div, content, tag_options)
      @subjects << output
      output
    end

    def html_task(params, coords, markers, label, object)
      output = +''
      data_options = {}
      if object
        data_options[:collapse_expand] = "#{object.class}-#{object.id}".downcase
        data_options[:number_of_rows] = number_of_rows
      end
      css = "task " +
            case object
            when Project
              "project"
            when Version
              "version"
            when Issue
              object.leaf? ? 'leaf' : 'parent'
            else
              ""
            end
      # Renders the task bar, with progress and late
      if coords[:bar_start] && coords[:bar_end]
        width = coords[:bar_end] - coords[:bar_start] - 2
        style = +""
        style << "top:#{params[:top]}px;"
        style << "left:#{coords[:bar_start]}px;"
        style << "width:#{width}px;"
        html_id = "task-todo-issue-#{object.id}" if object.is_a?(Issue)
        html_id = "task-todo-version-#{object.id}" if object.is_a?(Version)
        content_opt = {:style => style,
                       :class => "#{css} task_todo",
                       :id => html_id,
                       :data => {}}
        if object.is_a?(Issue)
          rels = issue_relations(object)
          if rels.present?
            content_opt[:data] = {"rels" => rels.to_json}
          end
        end
        content_opt[:data].merge!(data_options)
        output << view.content_tag(:div, '&nbsp;'.html_safe, content_opt)
        if coords[:bar_late_end]
          width = coords[:bar_late_end] - coords[:bar_start] - 2
          style = +""
          style << "top:#{params[:top]}px;"
          style << "left:#{coords[:bar_start]}px;"
          style << "width:#{width}px;"
          output << view.content_tag(:div, '&nbsp;'.html_safe,
                                     :style => style,
                                     :class => "#{css} task_late",
                                     :data => data_options)
        end
        if coords[:bar_progress_end]
          width = coords[:bar_progress_end] - coords[:bar_start] - 2
          style = +""
          style << "top:#{params[:top]}px;"
          style << "left:#{coords[:bar_start]}px;"
          style << "width:#{width}px;"
          html_id = "task-done-issue-#{object.id}" if object.is_a?(Issue)
          html_id = "task-done-version-#{object.id}" if object.is_a?(Version)
          output << view.content_tag(:div, '&nbsp;'.html_safe,
                                     :style => style,
                                     :class => "#{css} task_done",
                                     :id => html_id,
                                     :data => data_options)
        end
      end
      # Renders the markers
      if markers
        if coords[:start]
          style = +""
          style << "top:#{params[:top]}px;"
          style << "left:#{coords[:start]}px;"
          style << "width:15px;"
          output << view.content_tag(:div, '&nbsp;'.html_safe,
                                     :style => style,
                                     :class => "#{css} marker starting",
                                     :data => data_options)
        end
        if coords[:end]
          style = +""
          style << "top:#{params[:top]}px;"
          style << "left:#{coords[:end]}px;"
          style << "width:15px;"
          output << view.content_tag(:div, '&nbsp;'.html_safe,
                                     :style => style,
                                     :class => "#{css} marker ending",
                                     :data => data_options)
        end
      end
      # Renders the label on the right
      if label
        style = +""
        style << "top:#{params[:top]}px;"
        style << "left:#{(coords[:bar_end] || 0) + 8}px;"
        style << "width:15px;"

        ## CUSTOMIZATION START HERE
        #

        ## ADD CUSTOM STYLES TO HIDE LINES
        style += "display:none;" if (object.is_a?(Issue) || object.is_a?(Version)) && collapse_gantt_chart_at_project_level?

        #
        # CUSTOMIZATION ENDS HERE

        output << view.content_tag(:div, label,
                                   :style => style,
                                   :class => "#{css} label",
                                   :data => data_options)
      end
      # Renders the tooltip
      if object.is_a?(Issue) && coords[:bar_start] && coords[:bar_end]
        s = view.content_tag(:span,
                             view.render_issue_tooltip(object).html_safe,
                             :class => "tip")
        s += view.content_tag(:input, nil, :type => 'checkbox', :name => 'ids[]',
                              :value => object.id, :style => 'display:none;',
                              :class => 'toggle-selection')
        style = +""
        style << "position: absolute;"
        style << "top:#{params[:top]}px;"
        style << "left:#{coords[:bar_start]}px;"
        style << "width:#{coords[:bar_end] - coords[:bar_start]}px;"
        style << "height:12px;"
        output << view.content_tag(:div, s.html_safe,
                                   :style => style,
                                   :class => "tooltip hascontextmenu",
                                   :data => data_options)
      end
      @lines << output
      output
    end

  end
end

Redmine::Helpers::Gantt.prepend RedmineTinyFeatures::GanttPatch

module Redmine
  module Helpers
    class Gantt
      def render_object_row(object, options)
        class_name = object.class.name.downcase
        send(:"subject_for_#{class_name}", object, options) unless options[:only] == :lines || options[:only] == :selected_columns
        send(:"line_for_#{class_name}", object, options) unless options[:only] == :subjects || options[:only] == :selected_columns
        column_content_for_issue(object, options) if options[:only] == :selected_columns && options[:column].present? && object.is_a?(Issue)

        # CUSTOMIZATION HERE SO WE DON'T ADD SPACES IF LINE IS NOT VISIBLE (Project collapsed)
        options[:top] += options[:top_increment] unless collapse_gantt_chart_at_project_level? && (object.is_a?(Issue) || object.is_a?(Version))

        @number_of_rows += 1
        if @max_rows && @number_of_rows >= @max_rows
          raise MaxLinesLimitReached
        end
      end
    end
  end
end