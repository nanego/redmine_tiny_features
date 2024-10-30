require 'rails_helper'

RSpec.describe 'Issues AJAX requests', type: :request do

  fixtures :issues

  let(:issue) { Issue.first }

  describe 'GET /issues/render_form_by_ajax/:id' do
    it 'loads the edit form asynchronously' do
      get render_form_by_ajax_path(issue.id)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)).to have_key('html')
    end
  end

  describe 'GET /issues/load_previous_and_next_issue_ids/:id' do
    it 'loads previous and next issue ids asynchronously' do
      get load_previous_and_next_issue_ids_path(issue.id)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)).to have_key('html')
    end
  end
end
