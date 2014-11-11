module Opi
  class Resource
    attr_reader :root, :options, :resources, :before_filters, :after_filters, :routes

    def initialize(root='', options={}, before=[], after=[], block=nil)
      @root = root
      @options = options
      @before_filters = before
      @after_filters = after
      @resources = []
      @routes = []
      instance_eval &block if block
    end

    def get(path=nil, options={}, &block)
      route 'GET', path, options, block
    end

    def post(path=nil, options={}, &block)
      route 'POST', path, options, block
    end

    def put(path=nil, options={}, &block)
      route 'PUT', path, options, block
    end

    def delete(path=nil, options={}, &block)
      route 'DELETE', path, options, block
    end

    def before(method)
      before_filters << method
    end

    def after(method)
      after_filters << method
    end

    def resource(path, options={}, &block)
      resources << Resource.new(
        "#{self.root}/#{path}",
        self.options.merge(options),
        self.before_filters.dup,
        self.after_filters.dup,
        block
      )
    end

    private
      def route(method, path, options={}, block)
        full_path = "#{self.root}/#{path}".gsub(/\/\//, '/')
        full_path.gsub!(/\/$/, '') unless full_path == '/'
        routes.unshift({
          :method => method,
          :path => full_path,
          :options => self.options.merge(options),
          :before => self.before_filters,
          :after => self.after_filters,
          :block => block
        })
      end

  end
end
