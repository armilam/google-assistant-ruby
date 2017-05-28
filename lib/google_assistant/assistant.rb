# frozen_string_literal: true

require "json"

module GoogleAssistant
  class Assistant
    InvalidIntent = Class.new(StandardError)
    InvalidMessage = Class.new(StandardError)
    InvalidInputPrompt = Class.new(StandardError)
    InvalidPermission = Class.new(StandardError)
    InvalidPermissionContext = Class.new(StandardError)
    MissingRequestInputs = Class.new(StandardError)
    MissingRequestIntent = Class.new(StandardError)

    attr_reader :params, :response

    def initialize(params, response)
      @params = params
      @response = response
    end

    def respond_to(&block)
      yield(self)

      response.headers["Google-Assistant-API-Version"] = "v2"

      intent.call
    end

    def intent
      @_intent ||= Intent.new(intent_string)
    end

    def arguments
      @_arguments ||= inputs[0]["arguments"].map do |argument|
        Argument.from(argument)
      end
    end

    def permission_granted?
      arguments.any? do |argument|
        argument.is_a?(PermissionArgument) &&
          argument.permission_granted?
      end
    end

    def conversation
      @_conversation ||= Conversation.new(conversation_params)
    end

    def user
      @_user ||= User.new(user_params)
    end

    def device
      @_device ||= Device.new(device_params)
    end

    def tell(message)
      response = Response::SpeechResponse.new(message)
      response.to_json
    end

    def ask(prompt, no_input_prompts = [])
      response = Response::InputPrompt.new(prompt, no_input_prompts, conversation)
      response.to_json
    end

    def ask_for_permission(context, permissions)
      response = Response::AskForPermission.new(context, permissions, conversation)
      response.to_json
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

    def build_ask_response(prompt, expected_intent)
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

    def build_response(dialog_state, expect_user_response, expected_input, final_response)
      response = {}

      response[:conversation_token] = dialog_state.to_json if dialog_state
      response[:expect_user_response] = expect_user_response
      response[:expected_inputs] = expected_input if expected_input
      response[:final_response] = final_response if !expect_user_response && final_response

      response
    end

    def build_expected_intent(intent, permissions = nil, context = nil)
      raise InvalidIntent if intent.nil? || intent.empty?

      expected_intent = { intent: intent }

      unless context.nil? || permissions.nil?
        expected_intent[:input_value_spec] = {
          permission_value_spec: {
            opt_context: context,
            permissions: permissions
          }
        }
      end

      expected_intent
    end

    def is_ssml?(text)
      text =~ /^<speak\b[^>]*>(.*?)<\/speak>$/
    end

    def prompt_type(text)
      is_ssml?(text) ? :ssml : :text_to_speech
    end

    def inputs
      raise MissingRequestInputs if params["inputs"].nil?
      params["inputs"]
    end

    def intent_string
      raise MissingRequestIntent if inputs[0]["intent"].nil?
      inputs[0]["intent"]
    end

    def conversation_params
      params["conversation"] || {}
    end

    def user_params
      params["user"] || {}
    end

    def device_params
      params["device"] || {}
    end
  end
end
