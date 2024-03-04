module RedmineTinyFeatures
  class Hooks < Redmine::Hook::ViewListener
    # adds our css on each page
    def view_layouts_base_html_head(context)
      stylesheet_link_tag("tiny_features", :plugin => "redmine_tiny_features") +
        javascript_include_tag('redmine_tiny_features.js', plugin: 'redmine_tiny_features')
    end

    def controller_journals_edit_post(context = {})
      if Setting["plugin_redmine_tiny_features"]["journalize_note_deletion"].present?
        journal = context[:journal]
        if context[:journal].notes.blank?
          journal.issue.init_journal(User.current).note_removed(journal)
        end
      end
    end
  end

  class ModelHook < Redmine::Hook::Listener
    def after_plugins_loaded(_context = {})
      require_relative 'custom_field_enumeration_patch'
      require_relative 'custom_field_patch'
      require_relative 'field_format_patch'
      require_relative 'issue_query_patch'
      require_relative 'issue_patch'
      require_relative 'issue_status_patch'
      require_relative 'issue_statuses_helper_patch'
      require_relative 'issues_helper_patch'
      require_relative 'issues_controller_patch'
      require_relative 'journal_patch'
      require_relative 'mailer_patch'
      require_relative 'principal_patch'
      require_relative 'project_query_patch'
      require_relative 'project_patch'
      require_relative 'projects_helper_patch'
      require_relative 'queries_helper_patch'
      require_relative 'query_patch'
      require_relative 'queries_controller_patch'
      require_relative 'roles_controller_patch'
      require_relative 'tracker_patch'
      require_relative 'time_entry_query_patch'
      require_relative 'user_patch'
      require_relative 'users_helper_patch'
      require_relative 'user_preference_patch'
      require_relative 'issues_pdf_helper_patch'
    end
  end
end
