class ProjectCustomFieldEnumerationsController < ApplicationController

  before_action :find_custom_field

  def edit
    @disabled_enumeration_ids = DisabledCustomFieldEnumeration.disabled_ids_for(@project)
    render "projects/settings/enumerations"
  end

  def update
    disabled_enumerations_ids = params[:enumerations].select{ |k, v| v == "0" }.keys
    selected_enumerations_ids = params[:enumerations].reject{ |k, v| v == "0" }.keys

    DisabledCustomFieldEnumeration.where(project: @project, custom_field_enumeration_id: selected_enumerations_ids).destroy_all
    disabled_enumerations_ids.each do |custom_field_enumeration_id|
      DisabledCustomFieldEnumeration.find_or_create_by(project: @project, custom_field_enumeration_id: custom_field_enumeration_id)
    end

    render "projects/settings/update_enumerations"
  end

  private

  def find_custom_field
    @project = Project.find(params[:project_id])
    @custom_field = CustomField.find(params[:custom_field_id])
  end

end
