require "minitest/autorun"
require "test_helper"
require "google_assistant"

describe GoogleAssistant do
  include TestHelper

  class FakeResponse
    attr_reader :headers

    def initialize
      @headers = {}
    end
  end

  let(:response) { FakeResponse.new }
  let(:params) { load_json_fixture(:main_intent_request) }
  subject { GoogleAssistant.new(params, response) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params, subject.params)
      assert_equal(response, subject.response)
    end
  end

  describe "#respond_to" do

    it "yields to a block with the assistant" do
      subject.respond_to do |assistant|
        assert(assistant.is_a?(GoogleAssistant))
      end
    end

    it "sets google assistant version header on the response" do
      subject.respond_to {}
      assert_equal("v1", response.headers["Google-Assistant-API-Version"])
    end

    describe "when on the MAIN intent" do
      let(:params) { load_json_fixture(:main_intent_request) }

      it "calls the main intent block" do
        called_block = nil
        subject.respond_to do |assistant|
          assistant.intent.main { called_block = "main" }
          assistant.intent.text { called_block = "text" }
        end

        assert_equal("main", called_block)
      end
    end

    describe "when on the TEXT intent" do
      let(:params) { load_json_fixture(:text_intent_request) }

      it "calls the text intent block" do
        called_block = nil
        subject.respond_to do |assistant|
          assistant.intent.main { called_block = "main" }
          assistant.intent.text { called_block = "text" }
        end

        assert_equal("text", called_block)
      end
    end
  end
end
