module Opi
  class API

    class << self

      def root
        @root ||= Resource.new
      end

      def method_missing(method, *args, &block)
        root.respond_to?(method) ? root.send(method, *args, &block) : super
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
      @router = Router.new(self.class.root)
    end

    def call(env)
      logger.debug env.inspect.cyan

      request = Request.new(env)
      response = Response.new

      begin
        Loader.reload!

        route, params = @router.route(request.method, request.path)
        request.params.merge!(params) if params and params.is_a? Hash
        request.params.merge!('splat' => params.join(',')) if params and params.is_a? Array

        start_time = Time.now
        logger.info " Started #{request.method} \"#{request.path}\" for #{request.ip} at #{start_time.strftime('%d %b %H:%M')}"
        logger.info " Parameters: #{request.params}"

        if route
          logger.debug "#{request.method} #{request.path} => route #{route.inspect}".green
          context = Context.new(env, logger, route, request, response)
          response = context.run
        else
          logger.debug "#{request.method} #{request.path} => route not found".red
          response.not_found!
        end

      rescue Exception => e
        logger.error "#{e.message.red}\n  #{e.backtrace[0..9].join("\n  ").yellow}"
        response.internal_server_error!(e)
      end

      logger.info " Completed #{response.status} in #{((Time.now - start_time)*1000).round(2)}ms"
      [response.status, response.header, response.body]
    end

  end

end
