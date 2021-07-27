$(document).ready(function(){

  addDataShowsForPermission();

  $('#content').on('change', 'input[data-disables], input[data-enables], input[data-shows]', toggleVisibilityOnChange);
  toggleVisibilityInit();

  function toggleVisibilityOnChange() {
    var checked = $(this).is(':checked');
    if(!checked) {
      $($(this).data('shows')).css('visibility', 'hidden');
    }
    else {
      $($(this).data('shows')).css('visibility', 'visible');
    }

  }

  function addDataShowsForPermission() {
    $('[class^="role-"]').each(function(){
      //get roleId after delete role-
      roleid = $(this).attr('class').substring(5);
      st = "." + $(this).attr('value') + "-" + roleid + "_shown";
      $(this).attr('data-shows', st);
    });
  }

  function toggleVisibilityInit() {
    $('input[data-disables], input[data-enables], input[data-shows]').each(toggleVisibilityOnChange);
  }
});
