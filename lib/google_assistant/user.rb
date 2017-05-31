# frozen_string_literal: true

module GoogleAssistant
  class User
    attr_reader :id, :profile, :access_token

    def initialize(opts)
      @id = opts["userId"]
      @profile = opts["profile"] || {}
      @access_token = opts["accessToken"]
      @locale = opts["locale"]
    end

    def display_name
      profile["displayName"]
    end

    def given_name
      profile["givenName"]
    end

    def family_name
      profile["familyName"]
    end
  end
end
