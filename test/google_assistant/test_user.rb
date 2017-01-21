require "minitest/autorun"
require "google_assistant/user"

describe GoogleAssistant::User do
  let(:params) do
    {
      "user_id" => "some user id",
      "profile" => {
        "display_name" => "Johnny",
        "given_name" => "John",
        "family_name" => "Smith"
      }
    }
  end
  subject { GoogleAssistant::User.new(params) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params["user_id"], subject.id)
    end
  end

  describe "#display_name" do

    it "returns the display_name from the hash" do
      assert_equal(params["profile"]["display_name"], subject.display_name)
    end
  end

  describe "#given_name" do

    it "returns the given_name from the hash" do
      assert_equal(params["profile"]["given_name"], subject.given_name)
    end
  end

  describe "#family_name" do

    it "returns the family_name from the hash" do
      assert_equal(params["profile"]["family_name"], subject.family_name)
    end
  end
end
