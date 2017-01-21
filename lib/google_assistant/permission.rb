# frozen_string_literal: true

module GoogleAssistant
  module Permission
    NAME = "NAME"
    DEVICE_PRECISE_LOCATION = "DEVICE_PRECISE_LOCATION"
    DEVICE_COARSE_LOCATION = "DEVICE_COARSE_LOCATION"

    def self.valid?(permissions)
      permissions = [*permissions]
      permissions.all? do |permission|
        [NAME, DEVICE_PRECISE_LOCATION, DEVICE_COARSE_LOCATION].include?(permission)
      end
    end
  end
end
