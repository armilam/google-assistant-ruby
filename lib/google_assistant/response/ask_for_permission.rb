require "google_assistant/response/base"

module GoogleAssistant
  module Response
    class AskForPermission < Base

      attr_accessor :context, :permissions

      def initialize(context, permissions, conversation)
        @context = context
        @permissions = [*permissions].compact
        super(conversation)
      end

      def to_json
        response = super(true)

        expected_intent = build_expected_intent(StandardIntents::PERMISSION, permissions, context)
        expected_inputs = build_expected_inputs(expected_intent: expected_intent)
        response[:expected_inputs] = expected_inputs

        response
      end
    end
  end
end
