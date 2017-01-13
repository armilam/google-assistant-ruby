require "minitest/autorun"
require "test_helper"
require "google_assistant"
require "google_assistant/intent"
require "google_assistant/dialog_state"

describe GoogleAssistant do
  include TestHelper

  class FakeResponse
    attr_reader :headers

    def initialize
      @headers = {}
    end
  end

  describe "::respond_to" do

    it "creates a new Assistant and calls respond_to on it" do
      params = load_json_fixture(:main_intent_request)
      response = FakeResponse.new

      assistant = nil
      called_intent = false

      GoogleAssistant.respond_to(params, response) do |a|
        assistant = a

        a.intent.main { called_intent = true }
      end

      assert(called_intent)
      assert(assistant.is_a?(GoogleAssistant::Assistant))
      assert_equal(params, assistant.params)
      assert_equal("v1", response.headers["Google-Assistant-API-Version"])
      assert_equal(response, assistant.response)
    end
  end
end
