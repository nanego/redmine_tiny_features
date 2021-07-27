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

      role.issues_visibility = params[:issues_visibility][role.id.to_s] if params[:issues_visibility][role.id.to_s].present?
      # update permissions of trackers
      params[:permissions_tracker_ids][role.id.to_s].each do |permission|
        role.set_permission_trackers(permission.first, permission.second)
      end

      params[:permissions_all_trackers][role.id.to_s].each do |permission|
        role.set_permission_trackers(permission.first, :all) if permission.second == "1"
      end

      role.save
    end
    flash[:notice] = l(:notice_successful_update)
    redirect_to roles_path
  end

end
