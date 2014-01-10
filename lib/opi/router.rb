class Router
  attr_accessor :routes

  WILDCARD_PATTERN = /\/\*/
  NAMED_SEGMENTS_PATTERN = /\/:([^$\/]+)/
  NAMED_SEGMENTS_REPLACEMENT_PATTERN = /\/:([^$\/]+)/

  def initialize(routes=[])
    @routes = routes
  end

  def route(method, path)
    method_routes = self.routes.find_all{|x| x[:method] == method}
    method_routes.each do |route|
      if route[:path] =~ WILDCARD_PATTERN
        src = "\\A#{route[:path].gsub('*','(.*)')}\\Z"
        if match = path.match(Regexp.new(src))
          return [route, match[1].split('/')]
        end
      elsif route[:path] =~ NAMED_SEGMENTS_PATTERN
        src = "\\A#{route[:path].gsub(NAMED_SEGMENTS_REPLACEMENT_PATTERN, '/(?<\1>[^$/]+)')}\\Z"
        if match = path.match(Regexp.new(src))
          return [route, Hash[match.names.zip(match.captures)]]
        end
      elsif path == route[:path]
        return [route]
      end
    end
    nil
  end

end