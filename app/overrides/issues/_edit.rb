#encoding: utf-8
Deface::Override.new :virtual_path  => "issues/_edit",
                     :name          => "add-warning-above-notes-textarea-if-issue-closed",
                     :insert_before => "erb[loud]:contains('text_area')",
                     :partial       => "issues/edit_closed"
