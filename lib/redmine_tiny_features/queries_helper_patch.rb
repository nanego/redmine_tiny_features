require_dependency 'queries_helper'

module RedmineTinyFeatures::QueriesHelperPatch
  ## Sort columns by displayed names
  def query_available_inline_columns_options(query)
    (query.available_inline_columns - query.columns).reject(&:frozen?)
                                                    .sort_by { |column| column.caption.parameterize }
                                                    .collect { |column| [column.caption, column.name] }
  end

  ## Get group by coolumns sort by displayed names
  def group_by_column_select_tag(query)
    options = [[]] + query.groupable_columns
                          .sort_by { |column| column.name.parameterize } # Patch: sort by displayed names
                          .collect { |c| [c.caption, c.name.to_s] }

    select_tag('group_by', options_for_select(options, @query.group_by))
  end
end

QueriesHelper.prepend RedmineTinyFeatures::QueriesHelperPatch
