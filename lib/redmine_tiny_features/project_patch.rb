require_dependency 'project'

class Project < ActiveRecord::Base

  has_many :disabled_custom_field_enumerations, :dependent => :delete_all

  def module_enabled    
    EnabledModule.where("project_id = ? ", self.id).order(:name).map { |e_m| l("project_module_#{e_m.name}") }
  end

end

module RedmineTinyFeatures
  module ProjectPatch

    # Returns a SQL conditions string used to find all projects for which +user+ has the given +permission+
    #
    # Valid options:
    # * :skip_pre_condition => true       don't check that the module is enabled (eg. when the condition is already set elsewhere in the query)
    # * :project => project               limit the condition to project
    # * :with_subprojects => true         limit the condition to project and its subprojects
    # * :member => true                   limit the condition to the user projects
    def allowed_to_condition(user, permission, options={})
      perm = Redmine::AccessControl.permission(permission)
      if options[:skip_pre_condition]
        base_statement = "1=1"
      else
        base_statement = if perm && perm.read?
                            "#{Project.table_name}.status <> #{Project::STATUS_ARCHIVED}"
                          else
                            "#{Project.table_name}.status = #{Project::STATUS_ACTIVE}"
                          end
        if perm && perm.project_module
          # If the permission belongs to a project module, make sure the module is enabled
          base_statement +=
            " AND EXISTS (SELECT 1 AS one FROM #{EnabledModule.table_name} em" \
            " WHERE em.project_id = #{Project.table_name}.id" \
            " AND em.name='#{perm.project_module}')"
        end
      end
      if project = options[:project]
        project_statement = project.project_condition(options[:with_subprojects])
        base_statement = "(#{project_statement}) AND (#{base_statement})"
      end

      if user.admin?
        base_statement
      else
        statement_by_role = {}
        unless options[:member]
          role = user.builtin_role
          if role.allowed_to?(permission)
            s = "#{Project.table_name}.is_public = #{connection.quoted_true}"
            if user.id
              group = role.anonymous? ? Group.anonymous : Group.non_member
              principal_ids = [user.id, group.id].compact
              s =
                "(#{s} AND #{Project.table_name}.id NOT IN " \
                "(SELECT project_id FROM #{Member.table_name} " \
                "WHERE user_id IN (#{principal_ids.join(',')})))"
            end
            statement_by_role[role] = s
          end
        end
        user.project_ids_by_role.each do |role, project_ids|
          if role.allowed_to?(permission) && project_ids.any?
            statement_by_role[role] = "#{Project.table_name}.id IN (#{project_ids.join(',')})"
          end
        end
        if statement_by_role.empty?
          "1=0"
        else
          if block_given?
            statement_by_role.each do |role, statement|
              if s = yield(role, user)
                statement_by_role[role] = "(#{statement} AND (#{s}))"
              end
            end
          end
          "((#{base_statement}) AND (#{statement_by_role.values.join(' OR ')}))"
        end
      end
    end

  end
end

Project.singleton_class.prepend RedmineTinyFeatures::ProjectPatch
