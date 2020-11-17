class DisabledCustomFieldEnumeration < ActiveRecord::Base

  belongs_to :project
  belongs_to :custom_field_enumeration

  def self.disabled_ids_for(project)
    DisabledCustomFieldEnumeration.where(project: project).pluck(:custom_field_enumeration_id)
  end

end
