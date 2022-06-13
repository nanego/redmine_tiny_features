require_dependency 'custom_field_enumeration'

class CustomFieldEnumeration < ActiveRecord::Base
	has_many :disabled_custom_field_enumerations,  :dependent => :delete_all
end