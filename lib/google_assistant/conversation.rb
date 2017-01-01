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
      if token.is_a?(Hash)
        token["data"]
      else
        token
      end
    end

    def state
      if token.is_a?(Hash)
        token["state"]
      else
        token
      end
    end

    private

    def parse_token(token)
      JSON.parse(token)
    rescue JSON::ParserError, TypeError
      token
    end
  end
end
