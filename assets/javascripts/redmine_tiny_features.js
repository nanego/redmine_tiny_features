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

// check if plugin redmine_datetime_custom_field installed
function redminePluginDatetimeCustomFieldInstalled() {
  return !(typeof buildDateTimeFilterRow === "undefined")
}

$(function() {
    addFilter = function (field, operator, values) {
      var fieldId = field.replace('.', '_');
      var tr = $('#tr_'+fieldId);

      var filterOptions = availableFilters[field];
      if (!filterOptions) return;

      if (filterOptions['remote'] && filterOptions['values'] == null) {
        $.getJSON(filtersUrl, {'name': field}).done(function(data) {
          filterOptions['values'] = data;
          addFilter(field, operator, values) ;
        });
        return;
      }

      if (tr.length > 0) {
        tr.show();
      } else {
        if (redminePluginDatetimeCustomFieldInstalled() && (filterOptions['type'] == "date" || filterOptions['type'] == "date_past" )) {
          buildDateTimeFilterRow(field, operator, values);
        } else {
          buildFilterRow(field, operator, values);
        }
      }
      $('#cb_'+fieldId).prop('checked', true);
      toggleFilter(field);
      if(!redminePluginDatetimeCustomFieldInstalled()){
        toggleMultiSelectIconInit();
      }
      $('#add_filter_select').val('').find('option').each(function() {
        if ($(this).attr('value') == field) {
          $(this).attr('disabled', true);
        }
      });
      addSelect2ToSelectTagsForTinyFeatures();
    }
});

function toggleMultiSelect(el) {
  if (el.attr('multiple')) {
    el.removeAttr('multiple');
    el.attr('size', 1);
  } else {
    el.attr('multiple', true);
    if (el.children().length > 10)
      el.attr('size', 10);
    else
      el.attr('size', 4);
  }
  // Patch
  addSelect2ToSelectTagsForTinyFeatures()
}

/*
  Override for addSelect2ToSelectTags, because of addFilter takes time ,we should wait for it to finish.
  We use this method of override by variable to ensure that it is executed even if the function addSelect2ToSelectTags of plugin
  redmine_datetime_custom_field installed loaded after  addSelect2ToSelectTags of this plugin
*/

function addSelect2ToSelectTagsForTinyFeatures() {
  $(document).ready(function(){
    if ((typeof $().select2) === 'function') {
      $('#filters select.value').select2({
        containerCss: {width: '300px', minwidth: '300px'},
        width: 'style'
      });
      updateSelect2ForElements();
    }
  })
}

function setConfigurationForSelect2(element, url) {
  element.select2({
    containerCss: {width: '268px', minwidth: '268px'},
    width: 'style',
    tags: false,
    language: {
        noResults: function () {
          return "Aucun résultat trouvé..";
        },
        searching: function() {
          return "Recherche...";
        },
        loadingMore: function() {
          return "Charger plus de résultats...";
        }
    },
    ajax: { url: url,
      dataType: 'json',
        delay: 250,
        method: 'GET',
        data: function (params) {
          return {
              term: params.term,
              page_limit: 20,
              page: params.page || 0
          };
        },
        processResults: function (data, params) {
          params.page = params.page || 0;
          maxPage = Math.ceil(data.total / 20);
          return {
              results: data.results,
                pagination: {
                  more: ((params.page * 20) < data.total) && (data.results.length < data.total) && (maxPage > params.page + 1)
              }
          };
        },
        cache: true
      },
    minimumInputLenght: 20,
  });
  // set by default the first value (me)
  if (element.select2('data').length == 0) {
    var newOption = new Option('<< moi >>', 'me', false, false);
    element.append(newOption).trigger('change');
  }
}

// Fix Copy/Paste issue when using Chrome or mwhen there is multiple form in the page
$(document).ready(function(){
  // override copyImageFromClipboard of core Redmine
  copyImageFromClipboard = function (e) {
    if (!$(e.target).hasClass('wiki-edit')) { return; }
    var clipboardData = e.clipboardData || e.originalEvent.clipboardData
    if (!clipboardData) { return; }
    if (clipboardData.types.some(function(t){ return /^text\/plain$/.test(t); })) { return; }

    var items = clipboardData.items
    for (var i = 0 ; i < items.length ; i++) {
      var item = items[i];
      /** for the case of paste image mixed with other DataTransferItem **/
          // if (item.type.indexOf("image") != -1) {
          // var blob = item.getAsFile();
      var blob = item.getAsFile();
      if (item.type.indexOf("image") != -1 && blob) {
        var date = new Date();
        var filename = 'clipboard-'
            + date.getFullYear()
            + ('0'+(date.getMonth()+1)).slice(-2)
            + ('0'+date.getDate()).slice(-2)
            + ('0'+date.getHours()).slice(-2)
            + ('0'+date.getMinutes()).slice(-2)
            + '-' + randomKey(5).toLocaleLowerCase()
            + '.' + blob.name.split('.').pop();
        var file = new Blob([blob], {type: blob.type});
        file.name = filename;
        /* for the case of more than one form on the same page */
        // var inputEl = $(this).find('input:file.filedrop');
        // get input file in the closest form
        var inputEl = $(this).closest("form").find('input:file.filedrop');
        handleFileDropEvent.target = e.target;
        addFile(inputEl, file, true);
      }
    }
  }
});
