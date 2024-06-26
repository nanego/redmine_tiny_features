Deface::Override.new :virtual_path => "enumerations/_form",
                     :name => "add-color-select-to-issues-Priorities-form",
                     :insert_after => "p:contains('is_default')",
                     :text => <<-EOS
                       <% if @enumeration.type == 'IssuePriority' %>
                         <p>
                           <%= f.select :color, priorities_colors_list %>
                         </p>
                       <% end %>
                     EOS
