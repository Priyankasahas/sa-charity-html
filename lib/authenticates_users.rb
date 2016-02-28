require 'http_client'

class AuthenticatesUsers
  class InvalidCredentials < StandardError; end

  def self.authenticate(service, email, password)
    fail InvalidCredentials, 'require email and password to authenticate' unless email && password

    connection = HttpClient.new(service)
    response = connection.post '/authentication', email: email, password: password

    if response.body.user
      details = response.body.user
      User.build(details)
    end
  rescue HttpClient::ClientError => e
    raise e unless e.status == 404 # 404 is failed authentication, all other codes we pass upstream
  end
end
