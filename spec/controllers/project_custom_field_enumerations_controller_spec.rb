require 'spec_helper'

describe ProjectCustomFieldEnumerationsController, type: :controller do
  fixtures :users, :projects, :members, :roles, :member_roles

  let(:project) { Project.find(1) }
  let(:manager) { Role.find(1) } # jsmith (user 2) is manager of project 1
  let(:custom_field) { IssueCustomField.create!(name: 'Key/value list', field_format: 'enumeration') }
  let!(:enumeration) { custom_field.enumerations.create!(name: 'Value', position: 1) }

  let(:params) { { project_id: project.id, enumerations: { enumeration.id.to_s => "0" } } }

  before do
    @request.session[:user_id] = 2
  end

  it "disables the enumeration when the user has the permission" do
    manager.add_permission!(:manage_project_enumerations)

    put :update, params: params

    expect(response).to redirect_to(settings_project_path(project))
    expect(DisabledCustomFieldEnumeration.where(project: project, custom_field_enumeration_id: enumeration.id)).to exist
  end

  it "denies the update without the permission" do
    manager.remove_permission!(:manage_project_enumerations)

    put :update, params: params

    expect(response).to have_http_status(403)
    expect(DisabledCustomFieldEnumeration.where(project: project)).not_to exist
  end

  it "returns a 404 for an unknown project" do
    put :update, params: params.merge(project_id: 999)

    expect(response).to have_http_status(404)
  end
end
