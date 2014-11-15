require 'spec_helper'

describe Opi::API do
  subject { Class.new(Opi::API) }

  def app
    subject.new
  end

  it 'can create simple routes' do
    subject.get('/test') { {:message => 'ok'} }

    get '/test'
    expect(last_response.body).to include({:message => 'ok'}.to_json)
  end

end
