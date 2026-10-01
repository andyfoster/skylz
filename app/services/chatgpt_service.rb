class ChatgptService
  include HTTParty

  class IncompleteDraft < StandardError; end

  attr_reader :api_url, :options, :model, :message

  def initialize(message, model = 'gpt-3.5-turbo')
    api_key = ENV['OPENAI_API_KEY']
    raise 'Set OPENAI_API_KEY to use skill generation' if api_key.to_s.strip.empty?
    @options = {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}"
      }
    }
    @api_url = 'https://api.openai.com/v1/chat/completions'
    @model = model
    @message = message
  end

  def call
    body = {
      model:,
      response_format: { type: 'json_object' },
      max_tokens: 2000,
      messages: [
        {
          role: 'system',
          content: <<~PROMPT
            Help the user draft an entry in their skill diary. Return only a JSON object
            with exactly these fields:
            - "reason": a string describing when to use the skill.
            - "notes": a string with context and useful notes; Markdown is allowed.
            - "steps": an array of concise instruction strings, without step numbers.
              Prefix section headings with an asterisk. Use the right hand/side when
              a choice is necessary, and make directions relative to the practitioner.
            - "tags": an array of short category strings. Omit the skill set itself.
            Write directions as brief reminders to someone studying the supplied skill set.
            Keep the whole draft under 700 words. Escape newlines inside JSON strings.
          PROMPT
        },
        { role: 'user', content: "Skill: #{message}" }
      ]
    }
    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 30)
    raise response['error']['message'] unless response.code == 200

    choice = response['choices']&.first
    raise IncompleteDraft unless choice && choice['finish_reason'] == 'stop'

    content = choice.dig('message', 'content')
    raise IncompleteDraft if choice.dig('message', 'refusal').present? || content.to_s.strip.empty?

    content
  end

  class << self
    def call(message, model = 'gpt-3.5-turbo')
      new(message, model).call
    end
  end
end

