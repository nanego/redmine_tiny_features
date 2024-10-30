resources :projects do
  put :custom_field_enumerations, :controller => 'project_custom_field_enumerations', action: 'update', as: 'update_custom_field_enumerations'
end
get 'issues/render_form_by_ajax/:id', :controller => 'issues', :action => 'render_form_by_ajax', :as => 'render_form_by_ajax'
get 'issues/load_previous_and_next_issue_ids/:id', to: 'issues#load_previous_and_next_issue_ids', as: :load_previous_and_next_issue_ids
get 'queries/author_values_pagination', :controller => 'queries', :action => 'author_values_pagination', :as => 'author_values_pagination'
get 'queries/assigned_to_values_pagination', :controller => 'queries', :action => 'assigned_to_values_pagination', :as => 'assigned_to_values_pagination'

post 'issues/switch', to: 'issues#switch_display_mode', as: :switch_display_mode
