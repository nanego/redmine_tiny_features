Deface::Override.new :virtual_path  => "journals/update",
                     :name          => "reload-the-page-after-note-delete",
                     :insert_after  => "erb[silent]:contains(\"if @journal.frozen?\")",
                     :text          => "window.location.reload()"
