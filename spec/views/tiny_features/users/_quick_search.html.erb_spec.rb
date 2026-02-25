require "spec_helper"

describe "tiny_features/users/_quick_search.html.erb", type: :view do

  fixtures :users

  helper :routes

  let(:query) { UserQuery.new(name: '_') }

  before do
    assign(:query, query)
  end

  context "when setting is enabled" do
    before { Setting["plugin_redmine_tiny_features"]["users_quick_search"] = '1' }

    it "renders the search form" do
      render partial: 'tiny_features/users/quick_search'
      expect(rendered).to include('id="users-quick-search"')
      expect(rendered).to include('id="users-quick-search-input"')
    end

    it "includes the hidden fields for the name filter" do
      render partial: 'tiny_features/users/quick_search'
      expect(rendered).to include('name="f[]"')
      expect(rendered).to include('name="op[name]"')
      expect(rendered).to include('name="v[name][]"')
    end

    it "leaves the input empty when no name filter is active" do
      render partial: 'tiny_features/users/quick_search'
      expect(rendered).to include('value=""')
    end

    it "pre-fills the input with the active name filter value" do
      query.filters = { 'name' => { operator: '~', values: ['jsmith'] } }
      render partial: 'tiny_features/users/quick_search'
      expect(rendered).to include('value="jsmith"')
    end
  end

  context "when setting is disabled" do
    before { Setting["plugin_redmine_tiny_features"]["users_quick_search"] = '' }

    it "renders nothing" do
      render partial: 'tiny_features/users/quick_search'
      expect(rendered).not_to include('users-quick-search')
    end
  end
end
