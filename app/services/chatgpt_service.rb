# @note: This service is used to call the OpenAI API to generate a response to a message
# @note: The API key is stored in the credentials file
# @param message [String] The message to generate a response for
# @param model [String] The model to use for the response [gpt-3.5-turbo, gpt-3.5-turbo-0301]
# @return [String] The generated response
# @example
#   ChatgptService.call('What is your name?', 'gpt-3.5-turbo')
#   => "\n\nI am an AI language model created by OpenAI, so I don't have a name. You can call me OpenAI or AI assistant."
# API Docs: https://platform.openai.com/docs/api-reference/chat/create
class ChatgptService
  include HTTParty

  attr_reader :api_url, :options, :model, :message

  def initialize(message, model = 'gpt-3.5-turbo')
    api_key = "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"
    # api_key = Rails.application.credentials.open_ai_key
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
      messages: [
          {
      role: "system",
      content: "You will help the user fill in their skill database for a given skill.\nThey will type in a skill name and you will return a JSON object will the following data that will be input into the form for them to use as a draft in their database. When there are left or right sides required, always the the skill with your right hand etc and have all the directions relative to that. It is a skill diary so don't put extra information in, just brief directions in the style someone might write to themselves. You will be given a \"skill set\" as well so don't include that in the tags and direct the information to someone studying that.\n\n- \"reason\" - When to use this skill\n- \"note\" (comprehensive notes on this skill and the context, extra resources etc.\n- \"steps\" [\"*set up\", \"secure your grip on opponent's left lapel with your right hand\", \"*position\", \"next steps...\"] (Step by step instructions for performing this skill. These will be printed one per line. DO NOT write 'step 1' etc. Section headers have an asterisk at the start \"*set up\"\n- \"tags\" - example grouping and categories that this skill will fit into."
    },
     { role: 'user', content: "skill name: " + message }]
    }
    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 10)
    raise response['error']['message'] unless response.code == 200

    response['choices'][0]['message']['content']
  end

  class << self
    def call(message, model = 'gpt-3.5-turbo')
      new(message, model).call
    end
  end
end

