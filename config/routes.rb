resources :projects do
  get :custom_field_enumerations, :controller => 'project_custom_field_enumerations', action: "edit", as: 'edit_custom_field_enumerations'
  put :custom_field_enumerations, :controller => 'project_custom_field_enumerations', action: 'update', as: 'update_custom_field_enumerations'
end
