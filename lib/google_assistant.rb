# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/google_assistant/**/*.rb"].each { |file| require file }
require "json"

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

    if is_ssml?(message)
      final_response[:speech_response][:ssml] = message
    else
      final_response[:speech_response][:text_to_speech] = message
    end

    build_response(nil, false, nil, final_response)
  end

  def ask(prompt:, no_input_prompt: [])
    return handle_error("Invalid input prompt") if prompt.nil?

    no_input_prompt = [*no_input_prompt].compact

    prompt = build_input_prompt(prompt, no_input_prompt)

    expected_intent = build_expected_intent(StandardIntents::TEXT)

    expected_inputs = [{
      input_prompt: prompt,
      possible_intents: [expected_intent]
    }]

    build_response(
      conversation.dialog_state,
      true,
      expected_inputs,
      nil
    )
  end

  private

  def build_input_prompt(initial_prompt, no_inputs = [])
    initial_prompts = [
      { prompt_type(initial_prompt) => initial_prompt }
    ]

    no_input_prompts = no_inputs.map do |prompt|
      { prompt_type(prompt) => prompt }
    end

    {
      initial_prompts: initial_prompts,
      no_input_prompts: no_input_prompts
    }
  end

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
    return handle_error("Invalid intent") if intent.nil? || intent.empty?

    { intent: intent }
  end

  def is_ssml?(text)
    return handle_error("Missing text") if text.nil?

    text =~ /^<speak\b[^>]*>(.*?)<\/speak>$/
  end

  def prompt_type(text)
    is_ssml?(text) ? :ssml : :text_to_speech
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
