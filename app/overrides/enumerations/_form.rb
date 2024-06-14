Deface::Override.new :virtual_path  => "enumerations/_form",
                     :name          => "add-color-select-to-issues-Priorities-form",
                     :insert_after  => "p[1]",
                     :text          => "<% if @enumeration.type == 'IssuePriority' %><p><%= f.select :color, valid_priority_color_list %></p><% end %>"
