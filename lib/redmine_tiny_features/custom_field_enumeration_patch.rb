require_dependency 'custom_field_enumeration'

module RedmineTinyFeatures
	module CustomFieldEnumerationPatch
		def self.included(base)
			base.class_eval do
				has_many :disabled_custom_field_enumerations,  :dependent => :delete_all
			end
		end
	end
end

CustomFieldEnumeration.send(:include, RedmineTinyFeatures::CustomFieldEnumerationPatch)
