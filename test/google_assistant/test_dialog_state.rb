require "minitest/autorun"
require "google_assistant/dialog_state"

describe GoogleAssistant::DialogState do
  let(:state_hash) { { "state" => "some state", "data" => { "some data" => "a value" } } }
  subject { GoogleAssistant::DialogState.new(state_hash) }

  describe "#state" do

    it "returns the state" do
      assert_equal(state_hash["state"], subject.state)
      assert_equal(state_hash["data"], subject.data)
    end
  end

  describe "#data" do

    it "returns the data" do
      assert_equal(state_hash["data"], subject.data)
    end
  end

  describe "#data=" do

    it "sets the data" do
      new_data = { "new data" => "new value" }
      subject.data = new_data
      assert_equal(new_data, subject.data)
    end

    describe "when the data is not a hash" do

      it "raises an error" do
        assert_raises RuntimeError do
          subject.data = "not a hash"
        end
      end
    end
  end

  describe "#to_json" do

    it "returns the state_hash as json" do
      assert_equal(state_hash.to_json, subject.to_json)
    end
  end
end