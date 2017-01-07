# frozen_string_literal: true

class GoogleAssistant
  class DialogState
    DEFAULT_STATE = { "state" => nil, "data" => {} }.freeze

    def initialize(state_hash_or_conversation_token = nil)
      if state_hash_or_conversation_token.is_a?(String)
        @raw_token = state_hash_or_conversation_token
        @state_hash = parse_token(state_hash_or_conversation_token)
      elsif state_hash_or_conversation_token.is_a?(Hash)
        @state_hash = state_hash_or_conversation_token
      else
        @state_hash = DEFAULT_STATE.dup
      end
    end

    def state
      state_hash["state"]
    end

    def state=(state)
      state_hash["state"] = state
    end

    def data
      state_hash["data"]
    end

    def data=(data)
      raise "DialogState data must be a hash" unless data.is_a?(Hash)

      state_hash["data"] = data
    end

    def to_json
      state_hash.to_json
    end

    private

    attr_reader :state_hash, :raw_token

    def parse_token(token)
      JSON.parse(token)
    rescue JSON::ParserError, TypeError
      DEFAULT_STATE.dup
    end
  end
end
