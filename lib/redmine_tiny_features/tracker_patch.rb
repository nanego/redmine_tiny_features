class Tracker < ActiveRecord::Base
  safe_attributes('prevent_issue_copy')
end
