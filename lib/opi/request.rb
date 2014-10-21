module Opi
  class Request < Rack::Request

    def user_agent
      @env['HTTP_USER_AGENT']
    end

    def accept
      @env['HTTP_ACCEPT'].to_s.split(',').map { |a| a.strip }
    end

    def path
      @path = @env["PATH_INFO"]
      @path = '/' if @path.nil? or @path.strip.empty?
      @path
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
