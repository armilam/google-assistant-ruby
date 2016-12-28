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

    attr_reader :id, :type, :token

    def initialize(opts)
      @id = opts["conversation_id"]
      @type = opts["type"]
      @token = parse_token(opts["conversation_token"])
    end

    private

    def parse_token(token)
      JSON.parse(token)
    rescue JSON::ParserError, TypeError
      token
    end
  end
end
