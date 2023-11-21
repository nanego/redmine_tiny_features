require_dependency 'users_helper'
module RedmineTinyFeatures
  module UsersHelperPatch
    def user_valid_issue_mode_options
      User.valid_issue_mode_options.collect {|o| [l(o.last), o.first]}
    end
  end
end

UsersHelper.prepend RedmineTinyFeatures::UsersHelperPatch
ActionView::Base.send(:include, UsersHelper)
