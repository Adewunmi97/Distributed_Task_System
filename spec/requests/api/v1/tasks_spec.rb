# spec/requests/api/v1/tasks_spec.rb

require 'rails_helper'

RSpec.describe 'Api::V1::Tasks', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  describe 'GET /api/v1/tasks' do
    before do
      create_list(:task, 3, creator: user)
    end

    it 'returns tasks' do
      get '/api/v1/tasks', headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_response[:data].size).to eq(3)
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        get '/api/v1/tasks'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/tasks' do
    let(:valid_params) do
      {
        task: {
          title: 'New Task',
          description: 'Task Description'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a task' do
        expect {
          post '/api/v1/tasks', params: valid_params, headers: headers
        }.to change(TaskRecord, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response[:data][:title]).to eq('New Task')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { task: { title: '' } } }

      it 'returns unprocessable entity' do
        post '/api/v1/tasks', params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors]).to be_present
      end
    end
  end
end