require_dependency 'roles_controller'

class RolesController

  def update_permissions
    @roles = Role.where(:id => params[:permissions].keys)
    @roles.each do |role|

      role.permissions = params[:permissions][role.id.to_s]
      if params[:assignable].present?
        role.assignable =  params[:assignable][role.id.to_s].present? ? true : false
      else
        role.assignable = false
      end

      if params[:issues_visibility].present? # This condition is because there are (redmine tests) that call the function without passing this parameter
        role.issues_visibility = params[:issues_visibility][role.id.to_s] if params[:issues_visibility][role.id.to_s].present?
      end

      # update permissions of trackers
      if params[:permissions_tracker_ids].present? # This condition is because there are (redmine tests) that call the function without passing this parameter
        params[:permissions_tracker_ids][role.id.to_s]&.each do |permission|
          role.set_permission_trackers(permission.first, permission.second)
        end
      end

      if params[:permissions_all_trackers].present? # This condition is because there are (redmine tests) that call the function without passing this parameter
        params[:permissions_all_trackers][role.id.to_s]&.each do |permission|
          role.set_permission_trackers(permission.first, :all) if permission.second == "1"
        end
      end
      role.save
    end
    flash[:notice] = l(:notice_successful_update)
    redirect_to roles_path
  end

end
