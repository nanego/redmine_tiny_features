require_dependency 'user_preference'

module RedmineTinyFeatures::UserPreferencePatch

end

class UserPreference
  safe_attributes 'show_pagination_at_top_results'
end
