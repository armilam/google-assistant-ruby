module GoogleAssistant
  class User
    attr_reader :id, :profile, :access_token

    def initialize(opts)
      @id = opts["user_id"]
      @profile = opts["profile"] || {}
      @access_token = opts["access_token"]
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
