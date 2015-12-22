module RequestsHelper
  def get_with_token(path, params={}, headers={})
    headers.merge!('Authorization' => retrieve_access_token)
    get path, params, headers
  end

  def post_with_token(path, params={}, headers={})
    headers.merge!('Authorization' => retrieve_access_token)
    post path, params, headers
  end

  # similarly for xhr..
end
