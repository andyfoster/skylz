require 'rails_helper'

RSpec.describe ChatgptService do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return('test-placeholder')
  end

  def api_response(choice)
    double('response', code: 200, :[] => [choice])
  end

  it 'requests JSON output with consistent form fields' do
    content = { reason: 'Practice', notes: 'Notes', steps: ['First'], tags: ['tag'] }.to_json
    allow(HTTParty).to receive(:post) do |_url, options|
      body = JSON.parse(options[:body])
      expect(body['response_format']).to eq('type' => 'json_object')
      expect(body['messages'].first['content']).to include('"notes"', 'JSON')
      api_response('finish_reason' => 'stop', 'message' => { 'content' => content })
    end
    expect(described_class.call('Test')).to eq(content)
  end

  it 'rejects truncated output before it reaches the JSON parser' do
    allow(HTTParty).to receive(:post).and_return(api_response('finish_reason' => 'length', 'message' => { 'content' => '{' }))
    expect { described_class.call('Test') }.to raise_error(ChatgptService::IncompleteDraft)
  end

  it 'rejects missing response content' do
    allow(HTTParty).to receive(:post).and_return(api_response('finish_reason' => 'stop', 'message' => { 'content' => nil }))
    expect { described_class.call('Test') }.to raise_error(ChatgptService::IncompleteDraft)
  end
end
