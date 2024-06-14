require_dependency 'enumerations_controller'

module RedmineTinyFeatures::EnumerationsControllerPatch

end

class EnumerationsController

  def enumeration_params
    # can't require enumeration on #new action
    cf_ids = @enumeration.available_custom_fields.map {|c| c.multiple? ? {c.id.to_s => []} : c.id.to_s}
    params.permit(:enumeration => [:name, :active, :is_default, :position, :color, :custom_field_values => cf_ids])[:enumeration]
  end

end
