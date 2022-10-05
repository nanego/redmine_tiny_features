class Tracker < ActiveRecord::Base	
	safe_attributes('prevent_copy_issues')
end