require 'rails_helper'

describe API::V1::Users do

  describe 'GET /api/v1/users/:id' do
    let(:user) { create(:user_regular) }

    it 'responds successfully' do
      # get_with_token "/api/v1/users/#{user.id}"
      # parsed_response = JSON.parse response.body
      # puts parsed_response

      # expect(response).to be_success
      # expect(response.status).to eq(200)
    end
  end

end
