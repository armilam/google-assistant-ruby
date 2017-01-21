require "minitest/autorun"
require "google_assistant/permission"

describe GoogleAssistant::Permission do

  describe "::valid?" do

    describe "when given a single valid permission" do

      it "returns true" do
        permissions = [
          GoogleAssistant::Permission::NAME,
          GoogleAssistant::Permission::DEVICE_PRECISE_LOCATION,
          GoogleAssistant::Permission::DEVICE_COARSE_LOCATION
        ]

        permissions.each do |permission|
          assert(GoogleAssistant::Permission.valid?(permission))
        end
      end
    end

    describe "when given a single valid permission in an array" do

      it "returns true" do
        permissions = [
          GoogleAssistant::Permission::NAME,
          GoogleAssistant::Permission::DEVICE_PRECISE_LOCATION,
          GoogleAssistant::Permission::DEVICE_COARSE_LOCATION
        ]

        permissions.each do |permission|
          assert(GoogleAssistant::Permission.valid?([permission]))
        end
      end
    end

    describe "when given multiple valid permissions in an array" do

      it "returns true" do
        permissions = [
          GoogleAssistant::Permission::NAME,
          GoogleAssistant::Permission::DEVICE_PRECISE_LOCATION,
          GoogleAssistant::Permission::DEVICE_COARSE_LOCATION
        ]

        permissions.combination(2).each do |permission_combo|
          assert(GoogleAssistant::Permission.valid?(permission_combo))
        end

        assert(GoogleAssistant::Permission.valid?(permissions))
      end
    end

    describe "when given a single invalid permission" do

      it "returns false" do
        assert(!GoogleAssistant::Permission.valid?("not a valid permission"))
      end
    end

    describe "when given a single invalid permission in an array" do

      it "returns false" do
        assert(!GoogleAssistant::Permission.valid?(["not a valid permission"]))
      end
    end

    describe "when given an invalid permission in an array of otherwise valid permissions" do

      it "returns false" do
        permissions = [
          GoogleAssistant::Permission::NAME,
          "not a valid permission"
        ]

        assert(!GoogleAssistant::Permission.valid?(permissions))
      end
    end
  end
end
