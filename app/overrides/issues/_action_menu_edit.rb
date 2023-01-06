Deface::Override.new :virtual_path  => 'issues/_action_menu_edit',
                     :name          => 'prevents-render-edit-partial-render-it-only-on-click-button-edit',
                     :remove        => "erb[loud]:contains(\"render :partial => 'edit'\")"