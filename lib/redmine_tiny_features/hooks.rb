module RedmineTinyFeatures
  class Hooks < Redmine::Hook::ViewListener
    #adds our css on each page
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
end
