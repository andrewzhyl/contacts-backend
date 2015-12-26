require 'rails_helper'

describe API::V1::Auth do

  describe 'POST #signup' do

    context 'with valid credentials' do

      it 'returns user id' do
        #build a user but does not save it into the database
        user = build(:user_regular)
        post '/api/v1/auth/signup', { user: { email: user.email, password: user.password }, format: :json }
        puts response.body.inspect
        expect(response.status).to eq 200
        parsed_response = JSON.parse response.body
        expect(parsed_response['user']['id']).to_not be_nil
      end

      it 'invalid email' do
        post '/api/v1/auth/signup', { user: { email: '111111', password: "pass" }, format: :json }
        puts response.status
        puts response.body.inspect
        expect(response.status).to eq 401
        parsed_response = JSON.parse response.body
        expect(parsed_response['errors']).to_not be_nil
        expect(parsed_response['errors']['email'][0]).to eq "是无效的"
      end

      it 'invalid password' do
        post '/api/v1/auth/signup', { user: { email: "email@email.com", password: "pass" }, format: :json }
        puts response.status
        puts response.body.inspect
        expect(response.status).to eq 401
        parsed_response = JSON.parse response.body
        expect(parsed_response['errors']).to_not be_nil
        expect(parsed_response['errors']['password'][0]).to eq "过短（最短为 6 个字符）"
      end

    end

    context 'with invalid credentials' do

      it 'does not have email' do
        post '/api/v1/auth/signup', { user: { password: "pass" }, format: :json }
        expect(response.status).to eq 400
        parsed_response = JSON.parse response.body
        expect(parsed_response['error']).to_not be_nil
        expect(parsed_response['error']).to eq "user[email] 缺失"
      end

      it 'does not have password' do
        post '/api/v1/auth/signup', { user: { email: "email@email.com" }, format: :json }
        expect(response.status).to eq 400
        parsed_response = JSON.parse response.body
        expect(parsed_response['error']).to eq "user[password] 缺失"
      end

    end

  end


  describe 'POST #login' do
    context 'with valid credentials' do

      it 'returns token with 3 parts separated by comas' do
        user = create(:user_regular)
        post '/api/v1/auth/login', { email: user.email, password: user.password, format: :json }
        expect(response.status).to eq 200
        parsed_response = JSON.parse response.body
        puts parsed_response.inspect
        expect(parsed_response['token']).to_not be_nil
        expect(parsed_response['token'].split('.').count).to eq 3
      end

      it 'returns id and username of the user' do
        user = create(:user_regular)
        post '/api/v1/auth/login', { email: user.email, password: user.password, format: :json }
        expect(response.status).to eq 200
        parsed_response = JSON.parse response.body
        expect(parsed_response['user']['id']).to eq user.id
        expect(parsed_response['user']['username']).to eq user.username
      end

    end

    context 'with invalid credentials' do

      it 'does not return token' do
        user = create(:user_regular)
        post '/api/v1/auth/login', { email: "no_" + user.email, password: user.password, format: :json }
        expect(response.status).to eq 401
      end

    end
  end

  describe 'POST #token_status' do

    context 'with valid token' do

      it 'returns OK code' do
        user = create(:user_regular)
        token = TokenProvider.issue_token({ user_id: user.id })
        post '/api/v1/auth/token_status', { token: token, format: :json }
        expect(response.status).to eq 200
      end

    end

  end

end
