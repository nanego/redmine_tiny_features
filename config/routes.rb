resources :projects do
  put :custom_field_enumerations, :controller => 'project_custom_field_enumerations', action: 'update', as: 'update_custom_field_enumerations'
end
match 'issues/render_form_by_ajax/:id', :controller => 'issues', :action => 'render_form_by_ajax', :via => :get,  :as => 'render_form_by_ajax'
match 'queries/author_values_pagination', :controller => 'queries', :action => 'author_values_pagination' , :via => :get,  :as => 'author_values_pagination'
match 'queries/assigned_to_values_pagination', :controller => 'queries', :action => 'assigned_to_values_pagination' , :via => :get,  :as => 'assigned_to_values_pagination'

post 'issues/switch', to: 'issues#switch_display_mode', as: :switch_display_mode
