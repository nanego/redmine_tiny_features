require_dependency 'query'
require_dependency 'project_query'

class ProjectQuery < Query
  self.available_columns << QueryColumn.new(:module_enabled, :sortable => false, :default_order => 'asc')
end

module RedmineTinyFeatures
  module ProjectQueryPatch

    def initialize_available_filters
      super

      module_values = EnabledModule.all.collect { |s| [l("project_module_#{s.name}"), s.name] }.sort_by { |v| v.first }.uniq
      add_available_filter("module_enabled", :type => :list_subprojects, :values => module_values)
    end

    def sql_for_module_enabled_field(field, operator, value)
      case operator
      when "!*", "*"
        module_enabled_table = EnabledModule.table_name
        project_table = Project.table_name
        #return only the projects for which a particular module or module group is activated
        "#{project_table}.id  #{ operator == '*' ? 'IN' : 'NOT IN' } (SELECT #{module_enabled_table}.project_id FROM #{module_enabled_table} " +
          "JOIN #{project_table} ON #{module_enabled_table}.project_id = #{project_table}.id " + ') '
      when "=", "!"        
        module_enabled_table = EnabledModule.table_name
        project_table = Project.table_name       
        #return only the projects for which a particular module or module group is activated
        "#{project_table}.id #{ operator == '=' ? 'IN' : 'NOT IN' } (SELECT #{module_enabled_table}.project_id FROM #{module_enabled_table} " +
          "JOIN #{project_table} ON #{module_enabled_table}.project_id = #{project_table}.id AND " +
          sql_for_field('name', '=', value, module_enabled_table, 'name') + ') '
      end
    end     
  end
end

ProjectQuery.prepend RedmineTinyFeatures::ProjectQueryPatch
