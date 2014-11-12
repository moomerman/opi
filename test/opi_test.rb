require '../lib/opi'

module Test
  class API < Opi::API

    before :authorize!

    get '/' do
      {'get' => '/'}
    end

    get '/fish' do
    end

    resource :posts do

      before :log

      # POST /posts
      post do
      end

      # GET /posts
      get do
      end

      # GET /posts/:id
      get ':id' do
      end

      # GET /posts/latest
      get 'latest' do
      end

      resource :events do

        # GET /posts/:id/events
        get do
        end

        # GET /posts/:id/events/:id
        get :id do
        end

        # POST /posts/:id/events
        post do
        end

      end

    end

    helpers do
      def authorize!
        p "authorize!"
      end

      def log
        p "log!"
      end
    end
  end
end

require 'stringio'

api = Test::API.new(debug: true)
puts api.call({
  "REQUEST_METHOD" => 'GET',
  "PATH_INFO" => '/',
  "REMOTE_ADDR" => '127.0.0.1',
  "rack.input" => StringIO.new
}).join(', ')
