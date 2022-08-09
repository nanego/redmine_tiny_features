require 'issue_custom_field'

class IssueCustomField < CustomField

  def visibility_by_project_condition(project_key = nil, user = User.current, id_column = nil)
    sql = super
    id_column ||= id
    tracker_condition = "#{Issue.table_name}.tracker_id IN (SELECT tracker_id FROM #{table_name_prefix}custom_fields_trackers#{table_name_suffix} WHERE custom_field_id = #{id_column})"
    project_condition = "EXISTS (SELECT 1 FROM #{CustomField.table_name} ifa WHERE ifa.is_for_all = #{self.class.connection.quoted_true} AND ifa.id = #{id_column})" +
      " OR #{Issue.table_name}.project_id IN (SELECT project_id FROM #{table_name_prefix}custom_fields_projects#{table_name_suffix} WHERE custom_field_id = #{id_column})"

    "((#{sql}) AND (#{tracker_condition}) AND (#{project_condition}) AND (#{Issue.visible_condition(user, { skip_pre_condition: true })}))"
  end

end
