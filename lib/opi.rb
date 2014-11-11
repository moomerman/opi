require 'rack'
require 'colored'
require 'json'
require 'logger'

require_relative './opi/version'
require_relative './opi/loader'

require_relative './opi/api'
require_relative './opi/request'
require_relative './opi/response'
require_relative './opi/resource'
require_relative './opi/route'
require_relative './opi/router'
require_relative './opi/context'

module Opi
end
