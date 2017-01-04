require "minitest/autorun"
require "google_assistant/intent"

describe GoogleAssistant::Intent do
  let(:intent_string) { "any old string" }
  subject { GoogleAssistant::Intent.new(intent_string) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(intent_string, subject.intent_string)
    end
  end

  describe "#main" do
    let(:intent_string) { GoogleAssistant::StandardIntents::MAIN }

    it "sets the main intent block" do
      it_was_called = false
      subject.main do
        it_was_called = true
      end

      subject.call

      assert(it_was_called)
    end
  end

  describe "#text" do
    let(:intent_string) { GoogleAssistant::StandardIntents::TEXT }

    it "sets the text intent block" do
      it_was_called = false
      subject.text do
        it_was_called = true
      end

      subject.call

      assert(it_was_called)
    end
  end

  describe "#call" do

    describe "when the main intent" do
      let(:intent_string) { GoogleAssistant::StandardIntents::MAIN }

      it "calls the main intent block" do
        called_intent = nil

        subject.main do
          called_intent = "main"
        end

        subject.text do
          called_intent = "text"
        end

        subject.call

        assert_equal("main", called_intent)
      end
    end

    describe "when the text intent" do
      let(:intent_string) { GoogleAssistant::StandardIntents::TEXT }

      it "calls the text intent block" do
        called_intent = nil

        subject.main do
          called_intent = "main"
        end

        subject.text do
          called_intent = "text"
        end

        subject.call

        assert_equal("text", called_intent)
      end
    end

    describe "when the given intent block isn't set" do
      let(:intent_string) { GoogleAssistant::StandardIntents::MAIN }

      it "calls the main intent block" do
        called_intent = nil

        subject.text do
          called_intent = "text"
        end

        subject.call

        assert_nil(called_intent)
      end
    end
  end
end
