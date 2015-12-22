module SessionHelper
  def retrieve_access_token
    user = create(:user_login)
    post '/api/v1/auth/login', { email:  user.email, password: user.password, format: :json }
    expect(response.status).to eq 200
    parsed_response = JSON.parse response.body
    expect(parsed_response['auth_meta']['token']).to_not be_nil
    parsed_response['auth_meta']['token']
  end
end
