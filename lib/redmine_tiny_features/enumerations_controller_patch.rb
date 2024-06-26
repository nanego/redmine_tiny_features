require_dependency 'enumerations_controller'

module RedmineTinyFeatures::EnumerationsControllerPatch

  def enumeration_params
    cf_ids = @enumeration.available_custom_fields.map {|c| c.multiple? ? {c.id.to_s => []} : c.id.to_s}
    # Add color parameter
    params.permit(:enumeration => [:name, :active, :is_default, :position, :color, :custom_field_values => cf_ids])[:enumeration]
  end

end

EnumerationsController.prepend RedmineTinyFeatures::EnumerationsControllerPatch
