module Opi
  class Context

    attr_reader :env, :route, :request, :response, :before, :after, :error

    def initialize(env, route, request, before, after)
      @env = env
      @route = route
      @request = request
      @response = Response.new
      @before = before
      @after = after
      @error = nil
    end

    def params
      {}.tap {|h| @request.params.each{|x| h[x.first.to_sym] = x.last}}
    end

    def error!(message, status)
      @error = {:message => message, :status => status}
    end

    def run
      skip = route[:options][:skip] || []
      skip = [skip] unless skip.is_a? Array

      route_before = route[:options][:before] || []
      route_before = [route_before] unless route_before.is_a? Array

      (self.before + route_before).each do |before|
        next if skip.include? before

        self.send before # execute before filter

        if self.error
          response.body = ["{\"error\":\"#{error[:message]}\"}", "\n"]
          response.status = error[:status]
          return response
        end
      end

      # before filters must have succeeded
      action = instance_eval &route[:block]

      if action.respond_to? :success?
        if action.success?
          response.status = 200
          response.body = [action.result.to_json, "\n"]
        else
          response.status = 400
          response.body = [action.errors.symbolic.to_json, "\n"]
        end
      else
        response.status = 200
        response.body = [action.to_json, "\n"]
      end

      response
    end

  end
end