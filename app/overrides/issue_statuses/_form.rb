Deface::Override.new :virtual_path  => "issue_statuses/_form",
                     :name          => "add-color-select-to-issues_statues-form",
                     :insert_after  => "p[1]",
                     :text          => "<p><%= f.select :color, valid_color_list %></p>"

