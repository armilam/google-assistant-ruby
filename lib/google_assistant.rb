# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/google_assistant/**/*.rb"].each { |file| require file }

class GoogleAssistant
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def respond_to(&block)
    yield(self)

    intent.call
  end

  def intent
    @_intent ||= Intent.new(intent_string)
  end

  def tell(message)
    final_response = { speech_response: {} }

    if is_ssml(message)
      final_response[:speech_response][:ssml] = message
    else
      final_response[:speech_response][:text_to_speech] = message
    end

    build_response(nil, false, nil, final_response)
  end

  private

  def build_response(conversation_token, expect_user_response, expected_input, final_response)
    response = {}

    response[:conversation_token] = conversation_token if conversation_token
    response[:expect_user_response] = expect_user_response
    response[:expected_inputs] = expected_input if expected_input
    response[:final_response] = final_response if !expect_user_response && final_response

    {
      json: response.as_json
    }
  end

  def is_ssml(text)
    if text.nil?
      handle_error("Missing text")
      return false
    end

    text =~ /^<speak\b[^>]*>(.*?)<\/speak>$/
  end

  def inputs
    params["inputs"] || handle_error("Missing inputs from request body")
  end

  def intent_string
    inputs[0]["intent"] || handle_error("Missing intent from request body")
  end

  def handle_error(message)
    raise message
  end
end
