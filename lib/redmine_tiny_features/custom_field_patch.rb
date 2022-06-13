require_dependency 'custom_field'

class CustomField < ActiveRecord::Base
	##### PATCH ,to call the destroy method of (CustomFieldEnumeration has :dependent => :delete_all)
	has_many :enumerations, lambda {order(:position)},
			:class_name => 'CustomFieldEnumeration',
			:dependent => :destroy
end