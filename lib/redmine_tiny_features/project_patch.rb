require_dependency 'project'

class Project < ActiveRecord::Base

  has_many :disabled_custom_field_enumerations,  :dependent => :delete_all

end
