module Opi
  class Context

    attr_reader :env, :logger, :route, :request, :response, :error

    def initialize(env, logger, route, request, response)
      @env = env
      @logger = logger
      @route = route
      @request = request
      @response = response
      @error = nil
    end

    def params
      {}.tap {|h| @request.params.each{|x| h[x.first.to_sym] = x.last}}
    end

    def error!(message, status)
      @error = {:message => message, :status => status}
    end

    def run
      run_before_filters
      return response if self.error

      run_action

      if self.error
        response.status = error[:status]
        response.body = [error[:message].to_json, "\n"]
      end

      response
    end

    private
      def run_before_filters
        skip = route.options[:skip] || []
        skip = [skip] unless skip.is_a? Array

        route_before = route.options[:before] || []
        route_before = [route_before] unless route_before.is_a? Array

        (route.before + route_before).each do |before|
          next if skip.include? before

          self.send before # execute before filter

          if self.error
            response.body = ["{\"error\":\"#{error[:message]}\"}", "\n"]
            response.status = error[:status]
          end
        end
      end

      def run_action
        action = instance_eval &route.block

        if action.respond_to? :success?
          if action.success?
            response.status = 200
            response.body = [action.result.to_json, "\n"]
          else
            response.status = 400
            response.body = [action.errors.symbolic.to_json, "\n"]
            logger.error "Reponse: #{action.errors.symbolic.to_json}".red
          end
        else
          response.status = 200
          response.body = [action.to_json, "\n"]
        end
      end
  end
end
