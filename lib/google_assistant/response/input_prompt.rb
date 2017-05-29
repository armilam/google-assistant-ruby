# frozen_string_literal: true

require "google_assistant/response/base"

module GoogleAssistant
  module Response
    class InputPrompt < Base

      attr_accessor :prompt, :no_input_prompts

      def initialize(prompt, no_input_prompts, conversation)
        @prompt = prompt
        @no_input_prompts = [*no_input_prompts].compact
        super(conversation)
      end

      def to_json
        response = super(true)

        expected_intent = build_expected_intent(StandardIntents::TEXT)
        expected_inputs = build_expected_inputs(prompt: prompt, no_input_prompts: no_input_prompts, expected_intent: expected_intent)
        response[:expectedInputs] = expected_inputs

        response
      end
    end
  end
end
