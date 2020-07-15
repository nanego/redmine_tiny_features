#encoding: utf-8
Deface::Override.new :virtual_path => "versions/_form",
                     :name         => "show-hide-advanced-fields",
                     :insert_after => "div.box.tabular p:first-child",
                     :partial      => "versions/form_show_hidden_advanced_fields"