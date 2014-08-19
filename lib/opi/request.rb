module Opi
  class Request < Rack::Request

    def user_agent
      @env['HTTP_USER_AGENT']
    end

    def accept
      @env['HTTP_ACCEPT'].to_s.split(',').map { |a| a.strip }
    end

    def path
      @env["REQUEST_PATH"] || @env["PATH_INFO"]
    end

    def uri
      @env["REQUEST_URI"]
    end

    def method
      @env['REQUEST_METHOD']
    end

    def path_components
      @path_components ||= path.split('/')
    end

  end
end