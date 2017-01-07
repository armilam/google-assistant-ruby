class GoogleAssistant
  class DialogState
    DEFAULT_STATE = { state: nil, data: {} }

    def initialize(state_hash = nil)
      @state_hash = state_hash || DEFAULT_STATE
    end

    def state
      state_hash["state"]
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

    attr_reader :state_hash
  end
end
