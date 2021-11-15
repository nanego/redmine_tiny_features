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
  if (!redminePluginDatetimeCustomFieldInstalled()) {
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
        buildFilterRow(field, operator, values);
      }
      $('#cb_'+fieldId).prop('checked', true);
      toggleFilter(field);
      toggleMultiSelectIconInit();
      $('#add_filter_select').val('').find('option').each(function() {
        if ($(this).attr('value') == field) {
          $(this).attr('disabled', true);
        }
      });

      addSelect2ToSelectTagsForTinyFeatures();
    }
  }
});

/*
  Override for addSelect2ToSelectTags, because of addFilter takes time ,we should wait for it to finish.
  We use this method of override by variable to ensure that it is executed even if the function addSelect2ToSelectTags of plugin
  redmine_datetime_custom_field installed loaded after  addSelect2ToSelectTags of this plugin
*/

addSelect2ToSelectTags = function(){
  $(document).ready(function(){
    addSelect2ToSelectTagsForTinyFeatures();
  });
}

function addSelect2ToSelectTagsForTinyFeatures() {
  if ((typeof $().select2) === 'function') {
    $('#filters select.value').select2({
      containerCss: {width: '300px', minwidth: '300px'},
      width: 'style'
    });
    updateSelect2ForElements();
  }
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