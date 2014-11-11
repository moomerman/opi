module Opi
  class Route
    attr_reader :method, :path, :options, :before, :after, :block

    def initialize(method, path, options, before, after, block)
      @method = method
      @path = clean_path(path)
      @options = options
      @before = before
      @after = after
      @block = block
    end

    private
      def clean_path(path)
        path = path.gsub(/\/\//, '/')
        path = path.gsub(/\/$/, '') unless path == '/'
        path
      end

  end
end
