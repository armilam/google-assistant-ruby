require "minitest/autorun"
require "google_assistant/user"

describe GoogleAssistant::User do
  let(:params) do
    {
      "userId" => "some user id",
      "accessToken" => "iuaweLJ7igJgkyUGl7gujy52i8Iu609unjBJbk6",
      "profile" => {
        "displayName" => "Johnny",
        "givenName" => "John",
        "familyName" => "Smith"
      }
    }
  end
  subject { GoogleAssistant::User.new(params) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params["userId"], subject.id)
      assert_equal(params["accessToken"], subject.access_token)
      assert_equal(params["profile"], subject.profile)
    end
  end

  describe "#display_name" do

    it "returns the display_name from the hash" do
      assert_equal(params["profile"]["displayName"], subject.display_name)
    end
  end

  describe "#given_name" do

    it "returns the given_name from the hash" do
      assert_equal(params["profile"]["givenName"], subject.given_name)
    end
  end

  describe "#family_name" do

    it "returns the family_name from the hash" do
      assert_equal(params["profile"]["familyName"], subject.family_name)
    end
  end
end
