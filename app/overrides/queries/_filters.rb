Deface::Override.new :virtual_path  => "queries/_filters",
                     :name          => "add-select2-to-elements-that-use-the-users-list ",
                     :insert_after => "div.add-filter",
                     :text       => <<SELECT2
<script>
  // declaration this functions here, in order to generate the path by rails

  function useRedminePluginSelect2(){
    return <%= Setting.plugin_redmine_tiny_features.key?('use_select2') %>
  }

  function updateSelect2ForElements() {
    var activeSelect2 = useRedminePluginSelect2()
    var activePagination = '<%= Setting["plugin_redmine_tiny_features"]["paginate_issue_filters_values"].present? %>';

    if (activeSelect2 && activePagination === 'true'){
      // check if values_author_id_1 defined
      if ($('#values_author_id_1').length > 0) {
        setConfigurationForSelect2($('#values_author_id_1'), '<%= author_values_pagination_path %>');
      }
      if ($('#values_last_updated_by_1').length > 0) {
        setConfigurationForSelect2($('#values_last_updated_by_1'), '<%= author_values_pagination_path %>');
      }
      if ($('#values_updated_by_1').length > 0) {
        setConfigurationForSelect2($('#values_updated_by_1'), '<%= author_values_pagination_path %>');
      }
      if ($('#values_user_id_1').length > 0) {
        setConfigurationForSelect2($('#values_user_id_1'), '<%= author_values_pagination_path %>');
      }

      if ($('#values_assigned_to_id_1').length > 0) {
        setConfigurationForSelect2($('#values_assigned_to_id_1'), '<%= assigned_to_values_pagination_path %>');
      }
    }
  }
</script>
SELECT2