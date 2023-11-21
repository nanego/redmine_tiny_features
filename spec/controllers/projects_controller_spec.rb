require "spec_helper"
require "active_support/testing/assertions"

describe ProjectsController, type: :controller do
  include ActiveSupport::Testing::Assertions

  render_views

  fixtures :users, :projects, :enabled_modules

  before do
    @request.session[:user_id] = 1 #=> admin ; permissions are hard...
  end

  context "Add a filter on the projects page: module activated" do

    it "should query use module_enabled when index with column module_enabled" do
      columns = ['name', 'module_enabled']
      get :index, params: { :set_filter => 1, :c => columns }
      expect(response).to be_successful
      # query should use specified columns
      query = assigns(:query)
      
      assert_kind_of ProjectQuery, query
      expect(query.column_names.map(&:to_s)).to eq columns
    end

    it "should ensure that the changes are compatible with the CSV" do
      module_test = "issue_tracking"
      columns = ['name', 'module_enabled']

      get :index, params: { :set_filter => 1,
                            :f => ["module_enabled"],
                            :op => { "module_enabled" => "=" },
                            :v => { "module_enabled" => [module_test] },
                            :c => columns,
                            :format => 'csv' }

      expect(response).to be_successful
      expect(response.media_type).to include 'text/csv'

      lines = response.body.chomp.split("\n")

      expect(lines[0].split(',')[1]).to eq "Enabled modules"

      # projects for which the module Issue tracking is enabled
      ids = EnabledModule.where(name: module_test).map{ |e_m| e_m.project_id }
      # except the first line ( names of columns )
      expect(lines.count - 1).to eq(ids.count)
      
      project_csv = []

      lines.count.times do |count|
        project_csv.push( lines[count].split(',')[0]) if count > 0
        expect(lines[count].split(',').to_s).to include("Issue tracking") if count > 0
      end
      
      expect(project_csv.sort).to eq(Project.where(id: ids).map(&:name).sort)
    end
  end
end  
