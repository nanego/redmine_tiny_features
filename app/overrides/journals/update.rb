Deface::Override.new :virtual_path  => "journals/update",
                     :name          => "reload-the-page-after-note-delete",
                     :insert_after  => "erb[silent]:contains(\"if @journal.frozen?\")",
                     :text          => <<UPDATEHISTORY
  // remove the container div of div (journal), before this modifications the container div remains in the page
  $("#change-<%= @journal.id %>").parent().remove();

  // update indice of all journals after delete
  $('.journal-link').each(function(i){
    $(this).attr("href","#note-" + (i + 1));
    $(this).html("#" + (i + 1));
  });

  $('[id^=note-]').each(function(index) {
    $(this).attr("id","note-" + (index + 1));
  });

  // update copy-link of all journals after delete
  $(".icon-copy-link[data-clipboard-text*='note']").each(function(i) {
      str = $(this).data('clipboard-text');
      index = $(this).data('clipboard-text').indexOf('note');
      newstr = str.substr(0, index)+ 'note-' + (i + 1);
      $(this).attr("data-clipboard-text", newstr);
  });

  $("#tab-content-history").append("<%= escape_javascript(append_deleted_journal_to_history(@journal)) %>")

  // show the new journal when tab note is not selected, because of by default style='display: none;'
  if (!$("#tab-notes").hasClass("selected")) {
    $('[id^=change-][style*="display: none"]').each(function() {
      $(this).removeAttr('style');
    });
  }

UPDATEHISTORY
