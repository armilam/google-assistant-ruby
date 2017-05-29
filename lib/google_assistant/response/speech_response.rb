# frozen_string_literal: true

require "google_assistant/response/base"

module GoogleAssistant
  module Response
    class SpeechResponse < Base

      attr_accessor :message

      def initialize(message)
        @message = message
        super()
      end

      def to_json
        raise GoogleAssistant::InvalidMessage if message.nil? || message.empty?

        response = super(false)

        speech_response = if is_ssml?(message)
          { ssml: message }
        else
          { textToSpeech: message }
        end
        response[:finalResponse] = { speechResponse: speech_response }

        response
      end
    end
  end
end
