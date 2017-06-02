require "minitest/autorun"
require "google_assistant/device"

describe GoogleAssistant::Device do
  let(:params) do
    {
      "location" => {
        "coordinates" => {
          "latitude" => 37.422,
          "longitude" => -122.084
        },
        "formattedAddress" => "1600 Amphitheatre Parkway, Mountain View, CA 94043, United States",
        "zipCode" => "94043",
        "city" => "Mountain View"
      }
    }
  end
  subject { GoogleAssistant::Device.new(params) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params["location"], subject.location)
      assert_equal(params["location"]["coordinates"], subject.coordinates)
    end
  end

  describe "#city" do

    it "returns the city from the hash" do
      assert_equal(params["location"]["city"], subject.city)
    end
  end

  describe "#zip_code" do

    it "returns the zip_code from the hash" do
      assert_equal(params["location"]["zipCode"], subject.zip_code)
    end
  end

  describe "#formatted_address" do

    it "returns the formatted_address from the hash" do
      assert_equal(params["location"]["formattedAddress"], subject.formatted_address)
    end
  end

  describe "#latitude" do

    it "returns the latitude from the hash" do
      assert_equal(params["location"]["coordinates"]["latitude"], subject.latitude)
    end
  end

  describe "#longitude" do

    it "returns the longitude from the hash" do
      assert_equal(params["location"]["coordinates"]["longitude"], subject.longitude)
    end
  end
end
