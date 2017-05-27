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

  describe "#permission" do
    let(:intent_string) { GoogleAssistant::StandardIntents::PERMISSION }

    it "sets the permission intent block" do
      it_was_called = false
      subject.permission do
        it_was_called = true
      end

      subject.call

      assert(it_was_called)
    end
  end

  describe "#sign_in" do
    let(:intent_string) { GoogleAssistant::StandardIntents::SIGN_IN }

    it "sets the sign_in intent block" do
      it_was_called = false
      subject.sign_in do
        it_was_called = true
      end

      subject.call

      assert(it_was_called)
    end
  end

  describe "#call" do

    before :each do
      subject.main { "main" }
      subject.text { "text" }
      subject.permission { "permission" }
      subject.sign_in { "sign_in" }
    end

    describe "when the main intent" do
      let(:intent_string) { GoogleAssistant::StandardIntents::MAIN }

      it "calls the main intent block" do
        called_intent = subject.call
        assert_equal("main", called_intent)
      end
    end

    describe "when the text intent" do
      let(:intent_string) { GoogleAssistant::StandardIntents::TEXT }

      it "calls the text intent block" do
        called_intent = subject.call
        assert_equal("text", called_intent)
      end
    end

    describe "when the permission intent" do
      let(:intent_string) { GoogleAssistant::StandardIntents::PERMISSION }

      it "calls the permission intent block" do
        called_intent = subject.call
        assert_equal("permission", called_intent)
      end
    end

    describe "when the sign_in intent" do
      let(:intent_string) { GoogleAssistant::StandardIntents::SIGN_IN }

      it "calls the sign_in intent block" do
        called_intent = subject.call
        assert_equal("sign_in", called_intent)
      end
    end

    describe "when the given intent block isn't set" do
      let(:intent_string) { GoogleAssistant::StandardIntents::MAIN }

      it "returns nil" do
        subject.main

        called_intent = subject.call
        assert_nil(called_intent)
      end
    end
  end
end
