class HttpClient
  class ClientError < StandardError
    def body
      cause.response[:body] if cause.response
    end

    def status
      cause.response[:status] if cause.response
    end
  end

  Response = Struct.new(:headers, :body)

  USER_AGENT = 'Sai HTML Client'

  def initialize(service)
    @connection = Faraday.new service.endpoint, headers: { user_agent: USER_AGENT } do |c|
      c.request :basic_auth, service.username, service.password
      c.request :json

      %w( raise_error follow_redirects dates mashify ).each do |middleware|
        c.response middleware.to_sym
      end
      c.response :json, content_type: /\bjson$/

      c.adapter Faraday.default_adapter
      c.use :instrumentation
    end
  end

  def self.get(url)
    Faraday.get(url).body
  end

  def get(path, options = {})
    response(@connection.get(path, options))
  rescue Faraday::ClientError => e
    raise ClientError, e
  end

  def post(path, options = {})
    response(@connection.post(path, options))
  rescue Faraday::ClientError => e
    raise ClientError, e
  end

  def put(path, options = {})
    response(@connection.put(path, options))
  rescue Faraday::ClientError => e
    raise ClientError, e
  end

  private

  def response(r)
    Response.new(r.headers, r.body)
  end
end
