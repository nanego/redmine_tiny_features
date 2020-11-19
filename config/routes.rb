resources :projects do
  put :custom_field_enumerations, :controller => 'project_custom_field_enumerations', action: 'update', as: 'update_custom_field_enumerations'
end
