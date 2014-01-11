module Opi
  class Response < Rack::Response

    def initialize
      @status, @body = 200, ["{}","\n"]
      @header = Rack::Utils::HeaderHash.new({
        'Content-Type' => 'application/json; charset=utf-8'
        # 'Server' => 'TBD/1.0'
      })
    end

    def not_found!
      @status = 404
      @body = ["{\"error\":\"404 Not Found\"}", "\n"]
    end

    def internal_server_error!(exception)
      @status = 500
      @body = ["{\"error\":\"500 Internal Server Error\", \"message\":\"#{exception.message}\"}", "\n"]
    end

  end
end