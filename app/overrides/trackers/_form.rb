Deface::Override.new :virtual_path  => "trackers/_form",
                     :name          => "add-prevent-copy-issues",
                     :insert_after  => "p:eq(2)",
                     :text          => <<-EOS
<p><%= f.check_box :prevent_copy_issues %></p>
EOS

