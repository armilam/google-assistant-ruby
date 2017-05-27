# frozen_string_literal: true

module GoogleAssistant
  class StandardIntents

    # Assistant fires MAIN intent for queries like [talk to $action].
    MAIN = "assistant.intent.action.MAIN"

    # Assistant fires TEXT intent when action issues ask intent.
    TEXT = "assistant.intent.action.TEXT"

    # Assistant fires PERMISSION intent when action invokes askForPermission.
    PERMISSION = "assistant.intent.action.PERMISSION"

    # Assistant fires SIGN_IN intent when requesting user to sign in
    SIGN_IN = "assistant.intent.action.SIGN_IN"
  end

  class Intent
    attr_reader :intent_string

    def initialize(intent_string)
      @intent_string = intent_string
    end

    def main(&block)
      intents[StandardIntents::MAIN] = block
    end

    def text(&block)
      intents[StandardIntents::TEXT] = block
    end

    def permission(&block)
      intents[StandardIntents::PERMISSION] = block
    end

    def sign_in(&block)
      intents[StandardIntents::SIGN_IN] = block
    end

    def call
      block = intents[intent_string]
      return if block.nil?

      block.call
    end

    private

    def intents
      @_intents ||= {}
    end
  end
end
