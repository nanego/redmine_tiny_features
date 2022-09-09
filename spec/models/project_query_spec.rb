require 'spec_helper'

describe "ProjectQuery" do
  fixtures :users, :projects, :enabled_modules

  before do
    User.current = User.find(1)
  end

  def find_projects_with_query(query)
    Project.where(
      query.statement
    ).all
  end

  it "should ProjectQuery have available_filters module_enabled" do
    query = ProjectQuery.new
    expect(query.available_filters).to include 'module_enabled'
  end

  describe "should filter projects with module_enabled" do
    let!(:module_test) { "wiki" }

    it "operator equal =" do
      # projects for which the module wiki is enabled
      ids = EnabledModule.where(name: module_test).map{|e_m| e_m.project_id }
      query = ProjectQuery.new(:name => '_', :filters => { 'module_enabled' => { :operator => '=', :values => [module_test] } })
      result = find_projects_with_query(query)

      expect(result.count).to eq (ids.count)
      expect(result.to_a).to eq(Project.where(id: ids))
    end

    it "operator not equal !" do
      ids = EnabledModule.where(name: module_test).map{|e_m| e_m.project_id }
      query = ProjectQuery.new(:name => '_', :filters => { 'module_enabled' => { :operator => '!', :values => [module_test] } })
      result = find_projects_with_query(query)
      
      expect(result.count).to eq ((Project.count - ids.count))
      expect(result.to_a).not_to eq(Project.where(id: ids))
    end

    it "operator all *" do
      query = ProjectQuery.new(:name => '_', :filters => { 'module_enabled' => { :operator => '*', :values => [''] } })
      result = find_projects_with_query(query)

      expect(result.count).to eq (EnabledModule.all.map{ |e_m| e_m.project_id }.uniq.count)
    end

    it "operator any !*" do
      query = ProjectQuery.new(:name => '_', :filters => { 'module_enabled' => { :operator => '!*', :values => [''] } })
      result = find_projects_with_query(query)

      expect(result.count).to eq ((Project.all.map(&:id).uniq - EnabledModule.all.map{ |e_m| e_m.project_id }.uniq).count)
    end
  end
end
