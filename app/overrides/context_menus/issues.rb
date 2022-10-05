Deface::Override.new :virtual_path => 'context_menus/issues',
                     :name         => 'hide-copy-issue-if-tracker-prevents-it',
                     :insert_bottom=> 'erb[loud]:contains("context_menu_link l(:button_copy)")',
                     :text         => <<-HIDE_LINK
    if @issue.present? && !@issue.tracker.prevent_copy_issues 
HIDE_LINK