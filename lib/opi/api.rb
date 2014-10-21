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
        router.routes.unshift({:method => method, :path => path, :options => options, :block => block})
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

      def router
        @router ||= Router.new
      end

      def helpers(&block)
        mod = Module.new
        mod.class_eval &block
        Context.send :include, mod
      end

    end

    attr_reader :logger

    def initialize(options={})
      puts "* Opi Version: #{Opi::VERSION} initializing".green
      @logger = options[:logger] || Logger.new(STDOUT)
      @logger.level = options[:debug] ? Logger::DEBUG : Logger::INFO
    end

    def call(env)
      logger.debug env.inspect.cyan

      request = Request.new(env)
      response = Response.new

      begin
        Loader.reload!

        route, params = self.class.router.route(request.method, request.path)
        request.params.merge!(params) if params and params.is_a? Hash
        request.params.merge!('splat' => params.join(',')) if params and params.is_a? Array

        start_time = Time.now
        logger.info " Started #{request.method} \"#{request.path}\" for #{request.ip} at #{start_time.to_s(:short)}"
        logger.info " Parameters: #{request.params}"
        
        if route
          logger.debug "#{request.method} #{request.path} => route #{route.inspect}".green
          context = Context.new(env, route, request, response, self.class.before_filters, self.class.after_filters)
          response = context.run
        else
          logger.debug "#{request.method} #{request.path} => route not found".red
          response.not_found!
        end

      rescue Exception => e
        response.internal_server_error!(e)
      end

      logger.info " Completed #{response.status} in #{((Time.now - start_time)*1000).round(2)}ms"
      [response.status, response.header, response.body]
    end

  end

end
