module GoogleAssistant
  class User
    attr_reader :id, :profile

    def initialize(opts)
      @id = opts["user_id"]
      @profile = opts["profile"] || {}
    end

    def display_name
      profile["display_name"]
    end

    def given_name
      profile["given_name"]
    end

    def family_name
      profile["family_name"]
    end
  end
end
