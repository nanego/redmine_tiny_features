Deface::Override.new :virtual_path  => "issues/_attributes",
                     :name          => "hide_read_only_status_field",
                     :original      => '8c07bc5c6125db54af3873465088717987a73827',
                     :remove        => "p:contains('l(:field_status)')"

Deface::Override.new :virtual_path  => "issues/_form_with_positions",
                     :name          => "hide_read_only_status_field",
                     :original      => '8c07bc5c6125db54af3873465088717987a73827',
                     :remove        => "p:contains('l(:field_status)')"