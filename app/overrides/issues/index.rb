Deface::Override.new :virtual_path => 'issues/index',
                     :name => 'add-pagination-links-full-to-custom-queries',
                     :insert_before => 'erb[loud]:contains("render_query_totals(@query)")',
                     :text => <<-SHOW_PARAMETER
                       <% if @issue_pages.multiple_pages? && User.current.pref.show_pagination_at_top_results %>
                         <span class="pagination">
                          <%= pagination_links_full @issue_pages, @issue_count %>
                         </span>
                       <% end %>
                     SHOW_PARAMETER

# Add a link to switch the issues display mode (colorize by status/priority)
# as the first item of the actions dropdown.
Deface::Override.new :virtual_path => 'issues/index',
                     :name => 'add-switch-display-mode-link',
                     :insert_after => 'erb[loud]:contains("actions_dropdown do")',
                     :text => <<-SWITCH_DISPLAY_MODE
                       <% current_mode = User.current.issue_display_mode == User::BY_STATUS ? l(:label_issue_display_by_priority) : l(:label_issue_display_by_status) %>
                       <%= link_to sprite_icon('circle-dot-filled', current_mode, style: :filled), switch_display_mode_path(:path => request.url), method: :post, class: 'icon' %>
                     SWITCH_DISPLAY_MODE
