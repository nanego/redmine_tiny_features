Deface::Override.new :virtual_path => 'context_menus/issues',
                     :name         => 'hide-copy-issue-if-tracker-prevents-it',
                     :insert_bottom=> 'erb[loud]:contains("context_menu_link l(:button_copy), project_copy_issue_path(@project, @issue)")',
                     :text         => <<-HIDE_LINK
    if !@issue.tracker.prevent_copy_issues 
HIDE_LINK