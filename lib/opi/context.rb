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
      @request.params
    end

    def error!(message, status)
      @error = {:message => message, :status => status}
    end

    def run
      skip = route[:options][:skip] || []
      skip = [skip] if skip and !skip.is_a?(Array)

      self.before.each do |before|
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

      if action.is_a? Opi::Action
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