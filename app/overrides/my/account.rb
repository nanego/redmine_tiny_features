Deface::Override.new :virtual_path  => "my/account",
                     :name          => "add-issue_mode-select-to-user-account-form",
                     :insert_top    => "div.splitcontentright fieldset:last",
                     :text          => "<p><%= f.select :issue_display_mode, user_valid_issue_mode_options %></p>"
                    