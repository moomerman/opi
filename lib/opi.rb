require 'rack'
require 'colored'
require 'json'
require 'mutations'

require_relative './opi/api'
require_relative './opi/request'
require_relative './opi/response'
require_relative './opi/action'
require_relative './opi/context'
require_relative './opi/loader'

module Opi
  VERSION = '1.0'
end