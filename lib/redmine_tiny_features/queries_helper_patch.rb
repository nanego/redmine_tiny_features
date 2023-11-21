require_dependency 'queries_helper'

module RedmineTinyFeatures::QueriesHelperPatch
  ## Sort columns by displayed names
  def query_available_inline_columns_options(query)
    (query.available_inline_columns - query.columns).reject(&:frozen?)
                                                    .sort_by { |column| column.caption.parameterize }
                                                    .collect { |column| [column.caption, column.name] }
  end
end

QueriesHelper.prepend RedmineTinyFeatures::QueriesHelperPatch
