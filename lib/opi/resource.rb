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
        "#{child_root}/#{path}",
        self.options.merge(options),
        self.before_filters.dup,
        self.after_filters.dup,
        block
      )
    end

    private
      def route(method, path, options={}, block)
        path = ":#{path}" if path.is_a? Symbol # TODO: maybe not?
        routes.push Route.new(
          method,
          "#{self.root}/#{path}",
          self.options.merge(options),
          self.before_filters,
          self.after_filters,
          block
        )
      end

      def child_root
        return self.root if self.root.empty?
        parent_resource = self.root.split('/').last.gsub(/s$/, '')
        return "#{self.root}/:#{parent_resource}_id"
      end

  end
end
