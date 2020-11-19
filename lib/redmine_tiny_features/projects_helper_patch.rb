require_dependency 'projects_helper'

module PluginRedmineTinyFeatures
  module ProjectsHelper
    def project_settings_tabs
      super.tap do |tabs|
        # if User.current.allowed_to?(:manage_project_lists_of_values, @project)
          tabs << {
            name: 'enumerations',
            action: :edit,
            partial: 'projects/settings/enumerations',
            label: :label_enumerations
          }
        # end
      end
    end
  end
end

ProjectsHelper.prepend PluginRedmineTinyFeatures::ProjectsHelper
ActionView::Base.send(:include, ProjectsHelper)
