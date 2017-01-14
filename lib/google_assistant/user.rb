module GoogleAssistant
  class User
    attr_reader :id

    def initialize(opts)
      @id = opts["user_id"]
    end
  end
end
