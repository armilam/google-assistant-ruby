# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/google_assistant/**/*.rb"].each { |file| require file }

class GoogleAssistant
  attr_reader :params
  attr_reader :response

  def initialize(params, response)
    @params = params
    @response = response
  end

  def respond_to(&block)
    yield(self)

    response.headers["Google-Assistant-API-Version"] = "v1"

    intent.call
  end

  def intent
    @_intent ||= Intent.new(intent_string)
  end

  def arguments
    @_arguments ||= inputs[0]["arguments"].map do |argument|
      Argument.new(argument)
    end
  end

  def conversation
    @_conversation ||= Conversation.new(conversation_params)
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

  def ask(input_prompt)
    if input_prompt.nil?
      return handle_error("Invalid input prompt")
    end

    if input_prompt.is_a?(String)
      input_prompt = build_input_prompt(is_ssml(input_prompt), input_prompt)
    end

    expected_intent = build_expected_intent(StandardIntents::TEXT)

    expected_inputs = [{
      input_prompt: input_prompt,
      possible_intents: [expected_intent]
    }]

    build_response(
      conversation.dialog_state,
      true,
      expected_inputs,
      nil
    )
  end

  def build_input_prompt(is_ssml, initial_prompt, no_inputs = [])
    if is_ssml
      initial_prompts = [
        { ssml: initial_prompt }
      ]

      no_input_prompts = no_inputs.map do |no_input_prompt|
        { ssml: no_input_prompt }
      end

      {
        initial_prompts: initial_prompts,
        no_input_prompts: no_input_prompts
      }
    else
      initial_prompts = [
        { text_to_speech: initial_prompt }
      ]

      no_input_prompts = no_inputs.map do |no_input_prompt|
        { text_to_speech: no_input_prompt }
      end

      {
        initial_prompts: initial_prompts,
        no_input_prompts: no_input_prompts
      }
    end
  end

  private

  def build_response(dialog_state, expect_user_response, expected_input, final_response)
    response = {}

    response[:conversation_token] = dialog_state.to_json if dialog_state
    response[:expect_user_response] = expect_user_response
    response[:expected_inputs] = expected_input if expected_input
    response[:final_response] = final_response if !expect_user_response && final_response

    {
      json: response
    }
  end

  def build_expected_intent(intent)
    if intent.nil? || intent == ""
      return handle_error("Invalid intent")
    end

    { intent: intent }
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

  def conversation_params
    params["conversation"] || {}
  end

  def handle_error(message)
    raise message
  end
end
