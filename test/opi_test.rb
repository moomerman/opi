require '../lib/opi'

module Test
  class API < Opi::API

    before :authorize!

    get '/' do
    end

    get '/fish' do
    end

    resource :posts do

      before :log

      post do
      end

      get do
      end

      get ':id' do
      end

      resource :events do

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

api = Test::API.new(debug: true)
api.call({
  "REQUEST_METHOD" => 'GET',
  "PATH_INFO" => '/posts/1',
  "REMOTE_ADDR" => '127.0.0.1',
  "rack.input" => ""
})
