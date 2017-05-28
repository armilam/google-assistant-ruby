module GoogleAssistant
  module Response
    class Base

      attr_reader :conversation

      def initialize(conversation = nil)
        @conversation = conversation
      end

      def to_json(expect_user_response)
        response = {}
        response[:conversation_token] = conversation.dialog_state.to_json if conversation&.dialog_state
        response[:expect_user_response] = expect_user_response

        response
      end

      protected

      def build_input_prompt(prompt, no_input_prompts)
        raise GoogleAssistant::Assistant::InvalidInputPrompt if prompt.nil? || prompt.empty?

        initial_prompts = [
          { prompt_type(prompt) => prompt }
        ]

        no_input_prompts = no_input_prompts.map do |no_input_prompt|
          { prompt_type(no_input_prompt) => no_input_prompt }
        end

        {
          initial_prompts: initial_prompts,
          no_input_prompts: no_input_prompts
        }
      end

      def build_expected_inputs(prompt: "placeholder", no_input_prompts: [], expected_intent:)
        prompt = build_input_prompt(prompt, no_input_prompts)

        expected_inputs = [{
          input_prompt: prompt,
          possible_intents: [expected_intent]
        }]
      end

      def build_expected_intent(intent, permissions = nil, context = nil)
        raise InvalidIntent if intent.nil? || intent.empty?

        expected_intent = { intent: intent }

        unless permissions.nil?
          raise GoogleAssistant::Assistant::InvalidPermissionContext if context.nil? || context.empty?
          raise GoogleAssistant::Assistant::InvalidPermission if permissions.empty?
          raise GoogleAssistant::Assistant::InvalidPermission unless GoogleAssistant::Permission.valid?(permissions)

          expected_intent[:input_value_spec] = {
            permission_value_spec: {
              opt_context: context,
              permissions: permissions
            }
          }
        end

        expected_intent
      end

      private

      def prompt_type(text)
        is_ssml?(text) ? :ssml : :text_to_speech
      end

      def is_ssml?(text)
        text =~ /^<speak\b[^>]*>(.*?)<\/speak>$/
      end
    end
  end
end
