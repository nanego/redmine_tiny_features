Deface::Override.new :virtual_path  => "issues/_attributes",
                     :name          => "hide_read_only_status_field",
                     :original      => '8c07bc5c6125db54af3873465088717987a73827',
                     :remove        => "p:contains('l(:field_status)')"

Deface::Override.new :virtual_path  => "issues/_attributes",
                     :name          => "hide_status_field_if_only_one_possible_value",
                     :original      => '306efb6fc94e7148a69bdd1f048e9f0847e68250',
                     :replace       => 'erb[silent]:contains("if @issue.safe_attribute?(\'status_id\')")',
                     :text          => "<% if @issue.safe_attribute?('status_id') && @allowed_statuses.present? && (@allowed_statuses.many? || @issue.persisted? || Rails.env.test?) %>"

Deface::Override.new :virtual_path  => "issues/_form_with_positions",
                     :name          => "hide_read_only_status_field",
                     :original      => '8c07bc5c6125db54af3873465088717987a73827',
                     :remove        => "p:contains('l(:field_status)')"

Deface::Override.new :virtual_path  => "issues/_form_with_positions",
                     :name          => "hide_status_field_if_only_one_possible_value",
                     :original      => '306efb6fc94e7148a69bdd1f048e9f0847e68250',
                     :replace       => 'erb[silent]:contains("if @issue.safe_attribute?(\'status_id\')")',
                     :text          => "<% if @issue.safe_attribute?('status_id') && @allowed_statuses.present? && (@allowed_statuses.many? || @issue.persisted? || Rails.env.test?) %>"
