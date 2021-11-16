require_dependency 'principal'

class Principal < ActiveRecord::Base

  # Principals that are members of a collection of projects with pagination
  scope :member_of_with_pagination, (lambda do |projects, term, limit, page|
    limit = Principal.count if limit == 0 # this condition In order to get all users
    Principal.member_of_statement_with_search(projects, term).offset(page.to_i * limit.to_i).limit(limit)
  end)

  # the count of principals that are members of a collection of projects with search, (all or active)
  scope :count_member_of_with_search, (lambda do |projects, term, all = true|
    Principal.member_of_statement_with_search(projects, term, all).count
  end)

  def self.member_of_statement_with_search(projects, term, all = true)
    projects = [projects] if projects.is_a?(Project)

    # if all include active and locked users else include active users
    status = all ? [STATUS_LOCKED, STATUS_ACTIVE] : [STATUS_ACTIVE]

    if projects.blank?
      where("1=0")
    else
      ids = projects.map(&:id)
      reorder(status: :asc).
        order(*Principal.fields_for_order_statement).
        where(:type => ['User']).
        where("(LOWER(#{Principal.table_name}.lastname) || ' ' || LOWER(#{Principal.table_name}.firstname)) LIKE LOWER(:term)
              OR (LOWER(#{Principal.table_name}.firstname) || ' ' || LOWER(#{Principal.table_name}.lastname)) LIKE LOWER(:term)", term: "%#{term}%").
        where(:status => status).
        where("#{Principal.table_name}.id IN (SELECT DISTINCT user_id FROM #{Member.table_name} where project_id IN (?))", ids)
    end
  end

end
