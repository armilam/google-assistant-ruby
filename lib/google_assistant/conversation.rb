# frozen_string_literal: true

class GoogleAssistant
  class Conversation
    class Type
      TYPE_UNSPECIFIED = 0
      NEW = 1
      ACTIVE = 2
      EXPIRED = 3
      ARCHIVED = 4
    end

    attr_reader :id, :type, :raw_token, :token, :dialog_state

    def initialize(opts)
      @id = opts["conversation_id"]
      @type = opts["type"]
      @dialog_state = DialogState.new(opts["conversation_token"])
    end

    def state
      dialog_state.state
    end

    def state=(state)
      dialog_state.state = state
    end

    def data
      dialog_state.data
    end

    def data=(data)
      dialog_state.data = data
    end
  end
end
