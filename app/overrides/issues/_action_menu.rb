Deface::Override.new :virtual_path => 'issues/_action_menu',
                     :name         => 'hide-copy-issue-if-tracker-prevents-it',
                     :insert_bottom=> 'erb[loud]:contains("link_to l(:button_copy)")',
                     :text         => <<-HIDE_LINK
    && !@issue.tracker.prevent_copy_issues 
HIDE_LINK