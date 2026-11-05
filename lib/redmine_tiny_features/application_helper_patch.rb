require_dependency 'application_helper'

module RedmineTinyFeatures
  module ApplicationHelperPatch
    # strip_tags encodes quotes since Rails 8.1.4.1: drop the whole entity, as anchors drop quotes
    # TODO: remove this patch and its spec once all deployed Redmine versions include #44718
    def sanitize_anchor_name(anchor)
      super(anchor.gsub(/&(?:quot|#39);/, ''))
    end
  end
end

ApplicationHelper.prepend RedmineTinyFeatures::ApplicationHelperPatch
