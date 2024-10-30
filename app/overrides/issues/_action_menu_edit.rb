Deface::Override.new :virtual_path => 'issues/_action_menu_edit',
                     :name         => 'load-edit-partial-asynchronously',
                     :replace      => "erb[loud]:contains(\"render :partial => 'edit'\")",
                     :partial      => 'issues/load_issue_show_asynchronously'