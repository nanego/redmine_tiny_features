class ProjectCustomFieldEnumerationsController < ApplicationController

  def update
    @project = Project.find(params[:project_id])

    disabled_enumerations_ids = params[:enumerations].select{ |k, v| v == "0" }.keys
    selected_enumerations_ids = params[:enumerations].reject{ |k, v| v == "0" }.keys

    DisabledCustomFieldEnumeration.where(project: @project, custom_field_enumeration_id: selected_enumerations_ids).destroy_all
    disabled_enumerations_ids.each do |custom_field_enumeration_id|
      DisabledCustomFieldEnumeration.find_or_create_by(project: @project, custom_field_enumeration_id: custom_field_enumeration_id)
    end

    respond_to do |format|
      format.html {
        flash[:notice] = l(:notice_successful_update)
        redirect_to settings_project_path(@project, params[:tab])
      }
      format.api  { render_api_ok }
    end
  end

end
