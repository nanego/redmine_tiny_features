require_dependency 'projects_helper'

module RedmineTinyFeatures
  module ProjectsHelperPatch
    def project_settings_tabs
      super.tap do |tabs|
        if User.current.allowed_to?(:manage_project_enumerations, @project)
          tabs << {
            name: 'enumerations',
            action: :edit,
            partial: 'projects/settings/enumerations',
            label: :label_enumerations
          }
        end
      end
    end
  end
end

ProjectsHelper.prepend RedmineTinyFeatures::ProjectsHelperPatch
ActionView::Base.send(:include, ProjectsHelper)
