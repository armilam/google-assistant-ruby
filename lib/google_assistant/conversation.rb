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

    attr_reader :id, :type, :raw_token, :token

    def initialize(opts)
      @id = opts["conversation_id"]
      @type = opts["type"]
      @raw_token = opts["conversation_token"]
      @token = parse_token(opts["conversation_token"])
    end

    def data
      token["data"] ||= {}
    end

    def state
      token["state"]
    end

    def state=(state)
      token["state"] = state
    end

    private

    def parse_token(token)
      JSON.parse(token)
    end
  end
end
