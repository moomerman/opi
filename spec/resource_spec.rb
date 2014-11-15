require_relative './spec_helper'

describe Opi::API do
  subject { Class.new(Opi::API) }

  def app
    subject.new
  end

  it 'can route to a resource' do
    subject.resource(:posts) do
      get do
        {:message => 'ok'}
      end
    end

    get '/posts'
    expect(last_response.body).to include({:message => 'ok'}.to_json)
  end

  it 'can route to an id of a resource' do
    subject.resource(:posts) do
      get ':id' do
        {:message => params[:id]}
      end
    end

    get '/posts/1'
    expect(last_response.body).to include({:message => '1'}.to_json)
  end

  it 'can route to an id of a resource with a symbol' do
    subject.resource(:posts) do
      get :id do
        {:message => params[:id]}
      end
    end

    get '/posts/1'
    expect(last_response.body).to include({:message => '1'}.to_json)
  end

  it 'can route to a collection of a resource' do
    subject.resource(:posts) do
      get :latest do
        {:message => 'ok'}
      end
    end

    get '/posts/latest'
    expect(last_response.body).to include({:message => 'ok'}.to_json)
  end

  it 'can route to a nested resource' do
    subject.resource(:posts) do
      resource :events do
        get do
          {:message => params[:post_id]}
        end
      end
    end

    get '/posts/1/events'
    expect(last_response.body).to include({:message => '1'}.to_json)
  end

end
