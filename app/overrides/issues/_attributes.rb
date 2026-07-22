Deface::Override.new :virtual_path  => "issues/_attributes",
                     :name          => "hide_read_only_status_field",
                     :remove        => "p:contains('l(:field_status)')"

Deface::Override.new :virtual_path  => "issues/_attributes",
                     :name          => "hide_status_field_if_only_one_possible_value",
                     :replace       => 'erb[silent]:contains("if @issue.safe_attribute?(\'status_id\')")',
                     :text          => "<% if @issue.safe_attribute?('status_id') && @allowed_statuses.present? && (@allowed_statuses.many? || @issue.persisted? || Rails.env.test?) %>"

Deface::Override.new :virtual_path  => "issues/_form_with_positions",
                     :name          => "hide_read_only_status_field",
                     :remove        => "p:contains('l(:field_status)')"

Deface::Override.new :virtual_path  => "issues/_form_with_positions",
                     :name          => "hide_status_field_if_only_one_possible_value",
                     :replace       => 'erb[silent]:contains("if @issue.safe_attribute?(\'status_id\')")',
                     :text          => "<% if @issue.safe_attribute?('status_id') && @allowed_statuses.present? && (@allowed_statuses.many? || @issue.persisted? || Rails.env.test?) %>"
