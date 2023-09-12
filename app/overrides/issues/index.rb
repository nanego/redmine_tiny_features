Deface::Override.new :virtual_path => 'issues/index',
	                     :name => 'add-pagination-links-full-to-custom-queries',
	                     :insert_before => 'erb[loud]:contains("render_query_totals(@query)")',
	                     :text => <<-SHOW_PARAMETER
	<% if @issue_pages.multiple_pages? && User.current.pref.show_pagination_at_top_results %>
		'<span class="pagination"><%= pagination_links_full @issue_pages, @issue_count %></span>'
	<% end %>
SHOW_PARAMETER
