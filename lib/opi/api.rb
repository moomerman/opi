module Opi
  class API

    class << self
      def get(path, options={}, &block)
        route 'GET', path, options, block
      end

      def post(path, options={}, &block)
        route 'POST', path, options, block
      end

      def put(path, &block)
        route 'PUT', path, options, block
      end

      def delete(path, options={}, &block)
        route 'DELETE', path, options, block
      end

      def route(method, path, options={}, block)
        # TODO: remove&replace existing routes (on reload)
        routes.unshift({:method => method, :path => path, :options => options, :block => block})
      end

      def before(method)
        before_filters << method
      end

      def after(method)
        after_filters << method
      end

      def before_filters
        @before_filters ||= []
      end

      def after_filters
        @after_filters ||= []
      end

      def routes
        @routes ||= []
      end

      def helpers(&block)
        mod = Module.new
        mod.class_eval &block
        Context.send :include, mod
      end

    end

    def call(env)
      begin
        Loader.reload!

        request = Request.new(env)

        route = self.class.routes.detect{|x| x[:method] == request.method and x[:path] == request.path}

        return [404, {'Content-Type' => 'application/json'}, ["{\"error\":\"404 Not Found\"}", "\n"]] unless route

        context = Context.new(env, route, request, self.class.before_filters, self.class.after_filters)
        response = context.run

        [response.status, response.header, response.body]
      rescue Exception => e
        return [500, {'Content-Type' => 'application/json'}, ["{\"error\":\"500 Internal Server Error\", \"message\":\"#{e.message}\"}", "\n"]]
      end
    end

  end

end
