require_dependency 'custom_field'

module RedmineTinyFeatures
	module CustomFieldPatch
		def self.included(base)
			base.class_eval do
				has_many :enumerations, lambda {order(:position)},
								 :class_name => 'CustomFieldEnumeration',
								 :dependent => :destroy

				safe_attributes("steps", "min_value", "max_value")
			end
		end
	end
end

CustomField.send(:include, RedmineTinyFeatures::CustomFieldPatch)
