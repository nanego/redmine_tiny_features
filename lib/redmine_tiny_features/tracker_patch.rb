class Tracker < ActiveRecord::Base
  safe_attributes('prevent_issue_copy')
  # Add notes to core fields
  CORE_FIELDS = CORE_FIELDS.dup | ["notes"]
  CORE_FIELDS_ALL = (CORE_FIELDS_UNDISABLABLE + CORE_FIELDS).freeze
end
