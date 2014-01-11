# Opi - The very opinionated API service library

## Install the gem

gem 'opi'

## About

Opi is a very opinionated rack-compliant API service library.  In fact, it is
so opinionated it is very likely to offend.  But that is alright.

Opi was born out of frustration with writing too much boilerplate code for api
services.

**JSON-only**.  The server CANNOT respond with anything else other than JSON.
All error responses are JSON out of the box.  You CANNOT respond with HTML.
The response content type is hardcoded to JSON.

**No Controllers**.  Well.. there are route blocks which are the equivalent
of the controller but you are strongly encouraged to only ever execute actions
in these blocks (the server is looking out for those actions as responses).
The only role of the 'controller' here is to map HTTP inputs to Action inputs.

**No Sessions or Cookies**.  None.

But this has its advantages.  It is *fast* and *simple*.

## Example

This simple example doesn't really go into the detail of Actions but it does
demonstrate the routes, responses, before filters and helpers.

<code>api.rb</code>

```ruby
module Example
  class API < Opi::API

    before :authorize!

    get '/boom', :skip => :authorize! do
      raise 'boom'
    end

    get '/ping', :skip => :authorize! do
      {:pong => Time.now.to_i}
    end

    get '/users/:id' do
      params
    end

    post '/meaning' do
      {:answer => 42}
    end

    helpers do
      def authorize!
        error!('401 Unauthorized', 401) unless params[:secret] == '1234'
      end
    end

  end
end
```

<code>config.ru</code>

```ruby
require 'opi'

load './api.rb'
run Example::API.new
```

<code>output</code>

```bash
$ curl -i http://0.0.0.0:9292/ping
HTTP/1.1 200 OK
Content-Type: application/json
Transfer-Encoding: chunked

{"pong":1387810814}

$ curl -i http://0.0.0.0:9292/meaning
HTTP/1.1 401 Unauthorized
Content-Type: application/json
Transfer-Encoding: chunked

{"error":"401 Unauthorized"}

$ curl -i http://0.0.0.0:9292/meaning?secret=1234
HTTP/1.1 200 OK
Content-Type: application/json
Transfer-Encoding: chunked

{"answer":42}

$ curl -i http://0.0.0.0:9292/users/1?secret=1234
HTTP/1.1 200 OK
Content-Type: application/json
Transfer-Encoding: chunked

{"secret":"1234","id":"1"}

$ curl -i http://0.0.0.0:9292/nonexistant
HTTP/1.1 404 Not Found
Content-Type: application/json
Transfer-Encoding: chunked

{"error":"404 Not Found"}

$ curl -i http://0.0.0.0:9292/boom
HTTP/1.1 500 Internal Server Error
Content-Type: application/json
Transfer-Encoding: chunked

{"error":"500 Internal Server Error", "message":"boom"}
```