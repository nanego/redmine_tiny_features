require_dependency 'project'

module RedmineTinyFeatures::ProjectPatch

end

class Project

  has_many :disabled_custom_field_enumerations, :dependent => :delete_all

  def module_enabled    
    EnabledModule.where("project_id = ? ", self.id).order(:name).map { |e_m| l("project_module_#{e_m.name}") }
  end

end
