require "minitest/autorun"
require "google_assistant/dialog_state"

describe GoogleAssistant::DialogState do
  let(:state_hash) { { "state" => "some state", "data" => { "some data" => "a value" } } }
  subject { GoogleAssistant::DialogState.new(state_hash) }

  describe "#initialize" do

    describe "when given a string" do
      let(:state_hash) { "{\"state\":\"a state\",\"data\":{\"data key\":\"data value\"}}" }

      it "parses the string to a hash" do
        assert_equal("a state", subject.state)
        assert_equal({ "data key" => "data value" }, subject.data)
      end

      describe "when the string cannot be parsed as JSON" do
        let(:state_hash) { "this is definitely not a hash" }

        it "uses the default state" do
          assert_nil(subject.state)
          assert_equal({}, subject.data)
        end
      end
    end

    describe "when given a hash" do
      let(:state_hash) { { "state" => "a state", "data" => { "data key" => "data value"} } }

      it "uses the hash for the state and data" do
        assert_equal("a state", subject.state)
        assert_equal({ "data key" => "data value" }, subject.data)
      end
    end

    describe "when not given a state or conversation token" do
      let(:state_hash) { nil }

      it "uses the default state" do
        assert_nil(subject.state)
        assert_equal({}, subject.data)
      end
    end
  end

  describe "#state" do

    it "returns the state" do
      assert_equal(state_hash["state"], subject.state)
    end
  end

  describe "#state=" do

    it "set the state" do
      subject.state = "a new state"
      assert_equal("a new state", subject.state)
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
