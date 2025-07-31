Deface::Override.new :virtual_path  => "activities/index",
                     :name          => "add-select2-to-activity-users-list",
                     :replace       => "erb[loud]:contains(\"select_tag('user_id'\")",
                     :partial       => "activities/users"
