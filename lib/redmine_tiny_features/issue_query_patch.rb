require_dependency 'query'
require_dependency 'issue_query'

class IssueQuery < Query

  alias :find_updated_by_filter_values :find_assigned_to_id_filter_values
  alias :find_last_updated_by_filter_values :find_assigned_to_id_filter_values

end

module RedmineTinyFeatures
  module IssueQueryPatch
    if  !Rails.env.test?
      def initialize_available_filters
        super

        add_available_filter(
          "author_id",
          :type => :list, :values => lambda { [] }
        )
        add_available_filter(
          "assigned_to_id",
          :type => :list_optional, :values => lambda { [] }
        )
        add_available_filter(
          "updated_by",
          :type => :list, :values => lambda { [] }
        )
        add_available_filter(
          "last_updated_by",
          :type => :list, :values => lambda { [] }
        )
      end
    end
  end
end

IssueQuery.prepend RedmineTinyFeatures::IssueQueryPatch
