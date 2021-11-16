require_dependency 'query'
require_dependency 'time_entry_query'

class TimeEntryQuery < Query

  def find_assigned_to_id_filter_values(values)
    Principal.visible.where(:id => values).map {|p| [p.name, p.id.to_s]}
  end
  alias :find_author_id_filter_values :find_assigned_to_id_filter_values
  alias :find_user_id_filter_values :find_assigned_to_id_filter_values

end

module RedmineTinyFeatures
  module TimeEntryQueryPatch

      def initialize_available_filters
        super
        #  Add this condition,because of there are tests for available_filters in redmine core
        if  Setting["plugin_redmine_tiny_features"]["empty_available_filters"].present?
          add_available_filter(
            "user_id",
            :type => :list_optional, :values => lambda { [] }
          )
          add_available_filter(
            "author_id",
            :type => :list_optional, :values => lambda { [] }
          )
        end
      end
    end
end

TimeEntryQuery.prepend RedmineTinyFeatures::TimeEntryQueryPatch
