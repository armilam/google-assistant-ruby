require "minitest/autorun"
require "test_helper"
require "google_assistant"
require "google_assistant/intent"

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

  describe "#intent" do

    describe "with a MAIN intent request" do
      let(:params) { load_json_fixture(:main_intent_request) }

      it "returns an instance of Intent with MAIN intent" do
        assert_equal(GoogleAssistant::Intent, subject.intent.class)
        assert_equal(GoogleAssistant::StandardIntents::MAIN, subject.intent.intent_string)
      end
    end

    describe "with a TEXT intent request" do
      let(:params) { load_json_fixture(:text_intent_request) }

      it "returns an instance of Intent with TEXT intent" do
        assert_equal(GoogleAssistant::Intent, subject.intent.class)
        assert_equal(GoogleAssistant::StandardIntents::TEXT, subject.intent.intent_string)
      end
    end
  end

  describe "#arguments" do

    describe "when the arguments list is empty" do
      let(:params) { load_json_fixture(:empty_arguments_request) }

      it "returns an empty array" do
        assert_equal([], subject.arguments)
      end
    end

    describe "when there is one argument" do
      let(:params) { load_json_fixture(:single_argument_request) }

      it "returns a single-item array containing an Argument object" do
        assert_equal(1, subject.arguments.size)

        argument = subject.arguments.first

        assert_equal("text", argument.name)
        assert_equal("this is some raw text", argument.raw_text)
        assert_equal("this is a text value", argument.text_value)
      end
    end
  end

  describe "#conversation" do
    let(:params) { load_json_fixture(:text_intent_request) }

    it "returns a Conversation object with the given params" do
      conversation = subject.conversation

      assert_equal("1234567890", conversation.id)
      assert_equal(2, conversation.type)
      assert_equal("{\"state\":null,\"data\":{}}", conversation.raw_token)
    end
  end

  describe "#tell" do

    describe "when given an SSML message" do

      it "returns a JSON hash response with SSML" do
        message = "<speak>An SSML message</speak>"

        expected_response = {
          json: {
            expect_user_response: false,
            final_response: {
              speech_response: { ssml: message }
            }
          }
        }

        assert_equal(expected_response, subject.tell(message))
      end
    end

    describe "when given a plain text message" do

      it "returns a JSON hash response with text" do
        message = "A plain text message"

        expected_response = {
          json: {
            expect_user_response: false,
            final_response: {
              speech_response: { text_to_speech: message }
            }
          }
        }

        assert_equal(expected_response, subject.tell(message))
      end
    end
  end

  describe "#ask" do

    describe "when given a nil input prompt" do

      it "raises an error" do
        assert_raises RuntimeError do
          subject.ask(nil)
        end
      end
    end

    describe "when given an SSML string input prompt" do

      it "returns a JSON hash response with SSML" do
        response = subject.ask("<speak>Some SSML input prompt</speak>")

        expected_response = {
          json: {
            conversation_token: "{\"state\":null,\"data\":{}}",
            expect_user_response: true,
            expected_inputs: [
              {
                input_prompt: {
                  initial_prompts: [{ ssml: "<speak>Some SSML input prompt</speak>" }],
                  no_input_prompts: []
                },
                possible_intents: [{ intent: "assistant.intent.action.TEXT" }]
              }
            ]
          }
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when given a plain text string input prompt" do

      it "returns a JSON hash response with text" do
        response = subject.ask("Some text input prompt")

        expected_response = {
          json: {
            conversation_token: "{\"state\":null,\"data\":{}}",
            expect_user_response: true,
            expected_inputs: [
              {
                input_prompt: {
                  initial_prompts: [{ text_to_speech: "Some text input prompt" }],
                  no_input_prompts: []
                },
                possible_intents: [{ intent: "assistant.intent.action.TEXT" }]
              }
            ]
          }
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when given a hash input prompt" do

      it "returns a JSON hash response" do
        input_prompt = { input_prompt: :some_input_prompt }
        response = subject.ask(input_prompt)

        expected_response = {
          json: {
            conversation_token: "{\"state\":null,\"data\":{}}",
            expect_user_response: true,
            expected_inputs: [
              {
                input_prompt: input_prompt,
                possible_intents: [{ intent: "assistant.intent.action.TEXT" }]
              }
            ]
          }
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when given a nil dialog state" do

      it "builds a default blank state" do
        dialog_state = "{\"state\":null,\"data\":{\"something_interesting\":\"test value\"}}"
        response = subject.ask("Some input prompt", dialog_state)

        expected_response = {
          json: {
            conversation_token: dialog_state,
            expect_user_response: true,
            expected_inputs: [
              {
                input_prompt:  {
                  initial_prompts: [{ text_to_speech: "Some input prompt" }],
                  no_input_prompts: []
                },
                possible_intents: [{ intent: "assistant.intent.action.TEXT" }]
              }
            ]
          }
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when given an array dialog state" do

      it "raises an error" do
        assert_raises RuntimeError do
          subject.ask("input", [])
        end
      end
    end
  end

  describe "#build_input_prompt" do

    describe "when is_ssml is true" do

      it "returns a hash with ssml" do
        prompt = subject.build_input_prompt(true, "<speak>Say something</speak>", ["<speak>Did you say something?</speak>"])

        expected_prompt = {
          initial_prompts: [{ ssml: "<speak>Say something</speak>" }],
          no_input_prompts: [{ ssml: "<speak>Did you say something?</speak>" }]
        }

        assert_equal(expected_prompt, prompt)
      end
    end

    describe "when is_ssml is false" do

      it "returns a hash with text_to_speech" do
        prompt = subject.build_input_prompt(false, "Say something", ["Did you say something?"])

        expected_prompt = {
          initial_prompts: [{ text_to_speech: "Say something" }],
          no_input_prompts: [{ text_to_speech: "Did you say something?" }]
        }

        assert_equal(expected_prompt, prompt)
      end
    end
  end
end
