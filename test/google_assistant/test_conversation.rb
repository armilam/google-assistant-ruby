require "minitest/autorun"
require "google_assistant/conversation"

describe GoogleAssistant::Conversation do
  let(:conversation_params) { { "conversation_id" => "abc123", "type" => 1, "conversation_token" => { "state" => "some state", "data" => { "some data" => "a value" } } } }
  subject { GoogleAssistant::Conversation.new(conversation_params) }

  describe "#initialize" do

    it "returns a Conversation object with the given params" do
      assert_equal("abc123", subject.id)
      assert_equal(1, subject.type)
      assert_equal(GoogleAssistant::DialogState, subject.dialog_state.class)
    end
  end

  describe "#state" do

    it "delegates to the dialog state object" do
      subject.dialog_state.state = "a new state"
      assert_equal("a new state", subject.state)
    end
  end

  describe "#state=" do

    it "delegates to the dialog state object" do
      subject.state = "a new state"
      assert_equal("a new state", subject.dialog_state.state)
    end
  end

  describe "#data" do

    it "delegates to the dialog state object" do
      subject.dialog_state.data = { "a new data" => "with a new value" }
      assert_equal({ "a new data" => "with a new value" }, subject.data)
    end
  end

  describe "#data=" do

    it "delegates to the dialog state object" do
      subject.data = { "a new data" => "with a new value" }
      assert_equal({ "a new data" => "with a new value" }, subject.dialog_state.data)
    end
  end
end
