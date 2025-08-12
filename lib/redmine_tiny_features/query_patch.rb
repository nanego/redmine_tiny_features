module RedmineTinyFeatures::QueryPatch

end

class Query

  def principals
    @principal ||= begin
                     principals = if project
                                    scope = Principal.visible.member_of(project)
                                    unless project.leaf?
                                      scope = scope.or(
                                        Principal.visible.member_of(project.descendants.visible)
                                      )
                                    end
                                    scope
                                  else
                                    if Setting["plugin_redmine_tiny_features"]["display_all_users_in_author_filter"].to_i > 0
                                      Principal.visible
                                    else
                                      Principal.visible.member_of(all_projects)
                                    end
                                  end

                     principals.distinct
                               .where.not(type: ['GroupAnonymous', 'GroupNonMember'])
                               .sorted
                   end
  end

  def principals_with_pagination(term = '', limit = 0, page = 0)
    begin
      principals = []
      if project
        principals += Principal.member_of_with_pagination(project, term, limit, page).visible
        unless project.leaf?
          principals += Principal.member_of_with_pagination(project.descendants.visible, term, limit, page).visible
        end
      else
        if Setting["plugin_redmine_tiny_features"]["display_all_users_in_author_filter"].to_i > 0
          principals += Principal.member_of_with_pagination(nil, term, limit, page).visible
        else
          principals += Principal.member_of_with_pagination(all_projects, term, limit, page).visible
        end
      end
      principals.reject! { |p| p.is_a?(GroupBuiltin) }
      principals
    end
  end

  def count_principals_with_search(term = '', all = true)
    begin
      principals = 0
      if project
        principals += Principal.count_member_of_with_search(project, term, all)
        unless project.leaf?
          principals += Principal.count_member_of_with_search(project.descendants.visible, term, all)
        end
      else
        principals += Principal.count_member_of_with_search(all_projects, term, all)
      end

      principals
    end
  end

  # In order to use the same logic of redmine function users call principals
  def users_with_pagination(term = '', limit = 0, page = 0)
    principals_with_pagination(term, limit, page)
  end

  def count_author_values_with_search(term = '', all = true)
    term ||= ''
    count = count_principals_with_search(term, all)
    count += 1 if User.current.logged? && l(:label_me).include?(term)
    count += 1 if l(:label_user_anonymous).include?(term)
    count
  end

  def author_values_with_pagination(term = '', limit = 0, page = 0, maxPage = 0)
    term ||= ''
    my_string = "me"
    anonymous_string = l(:label_user_anonymous)
    author_values = []
    author_values << ["<< #{l(:label_me)} >>", my_string] if User.current.logged? && page.to_i == 0 && l(:label_me).include?(term)
    author_values +=
      users_with_pagination(term, limit, page).
        collect { |s| [s.name, s.id.to_s, l("status_#{User::LABEL_BY_STATUS[s.status]}")] }

    # anonymous_string.include?(term) for take into consideration the use anonymous
    with_user_anonymous = ((maxPage.to_i == (page.to_i + 1)) && (anonymous_string.include?(term)))

    author_values << [anonymous_string, User.anonymous.id.to_s] if with_user_anonymous
    author_values
  end

  def assigned_to_values_with_pagination(term = '', limit = 0, page = 0, maxPage = 0)
    term ||= ''
    my_string = "me"
    assigned_to_values = []
    assigned_to_values << ["<< #{l(:label_me)} >>", my_string] if User.current.logged? && page.to_i == 0 && l(:label_me).include?(term)
    assigned_to_values +=
      (Setting.issue_group_assignment? ? principals_with_pagination(term, limit, page) : users_with_pagination(term, limit, page)).
        collect { |s| [s.name, s.id.to_s, l("status_#{User::LABEL_BY_STATUS[s.status]}")] }
    assigned_to_values
  end

  def count_assigned_to_values_with_search(term = '', all = true)
    term ||= ''
    count = count_principals_with_search(term, all)
    count += 1 if User.current.logged? && l(:label_me).include?(term)
    count
  end

  # override this function to handle the case of me
  def available_filters_as_json
    json = {}
    available_filters.each do |field, filter|
      options = { :type => filter[:type], :name => filter[:name] }
      options[:remote] = true if filter.remote

      if has_filter?(field) || !filter.remote
        options[:values] = filter.values
        if options[:values] && values_for(field)
          missing = Array(values_for(field)).select(&:present?) - options[:values].map { |v| v[1] }

          if missing.any? && respond_to?(method = "find_#{field}_filter_values")
            # new instructions added by this plugin to handle the case of me -------
            me_found = false
            if missing.include?("me")
              missing[missing.index("me")] = User.current.id
              me_found = true
            end
            # -----------
            options[:values] += send(method, missing)
            # new instruction added by this plugin to handle the case of me -----
            options[:values][options[:values].index([User.current.name, User.current.id.to_s])] = ["<< #{l(:label_me)} >>", "me"] if me_found
            # -----------
          end
        end
      end
      json[field] = options.stringify_keys
    end
    json
  end
end
