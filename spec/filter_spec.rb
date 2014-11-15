require_relative './spec_helper'

describe Opi::API do
  subject { Class.new(Opi::API) }

  def app
    subject.new
  end

  it 'can execute before filters on a resource' do
    subject.resource(:posts) do
      before :test
      get{ {:message => @test} }
    end

    subject.helpers do
      def test; @test = 'ok'; end
    end

    get '/posts'
    expect(last_response.body).to include({:message => 'ok'}.to_json)
  end

  it 'can execute before filters on an action' do
    subject.resource(:posts) do
      get nil, :before => :test do
        {:message => @test}
      end
    end

    subject.helpers do
      def test; @test = 'ok'; end
    end

    get '/posts'
    expect(last_response.body).to include({:message => 'ok'}.to_json)
  end

  it 'allows errors to be raised in before filters' do
    subject.resource(:posts) do
      get nil, :before => :test do
        {:message => @test}
      end
    end

    subject.helpers do
      def test; @test = 'ok'; error!('401', 'Forbidden'); end
    end

    get '/posts'
    expect(last_response.body).to include({:error => '401'}.to_json)
  end

end
