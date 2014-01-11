module Opi
  class Response < Rack::Response

    def initialize
      @status, @body = 200, ["{}","\n"]
      @header = Rack::Utils::HeaderHash.new({
        'Content-Type' => 'application/json; charset=utf-8'
        # 'Server' => 'TBD/1.0'
      })
    end

  end
end