require "minitest/autorun"
require "google_assistant/user"

describe GoogleAssistant::User do
  let(:params) { { "user_id" => "some user id" } }
  subject { GoogleAssistant::User.new(params) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params["user_id"], subject.id)
    end
  end
end
