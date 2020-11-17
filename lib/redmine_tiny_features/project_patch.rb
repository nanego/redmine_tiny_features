require_dependency 'issue'

class Project < ActiveRecord::Base

  has_many :disabled_custom_field_enumerations

end
