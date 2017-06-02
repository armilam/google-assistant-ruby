# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "google_assistant/assistant"
require "google_assistant/intent"
require "google_assistant/dialog_state"

describe GoogleAssistant::Assistant do
  include TestHelper

  let(:response) { FakeResponse.new }
  let(:params) { load_json_fixture(:main_intent_request) }
  subject { GoogleAssistant::Assistant.new(params, response) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params, subject.params)
      assert_equal(response, subject.response)
    end
  end

  describe "#respond_to" do

    it "yields to a block with the assistant" do
      subject.respond_to do |assistant|
        assert(assistant.is_a?(GoogleAssistant::Assistant))
      end
    end

    it "sets google assistant version header on the response" do
      subject.respond_to {}
      assert_equal("v2", response.headers["Google-Assistant-API-Version"])
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

        assert_equal("TEXT", argument.name)
        assert_equal("this is some raw text", argument.raw_text)
        assert_equal("this is a text value", argument.text_value)
      end
    end
  end

  describe "#permission_granted?" do
    let(:params) { load_json_fixture(:user_name_granted) }

    it "returns true" do
      assert(subject.permission_granted?)
    end

    describe "when permission is not granted" do
      let(:params) { load_json_fixture(:permission_denied) }

      it "returns false" do
        assert(!subject.permission_granted?)
      end
    end

    describe "when response is not a permission response" do
      let(:params) { load_json_fixture(:text_intent_request) }

      it "returns false" do
        assert(!subject.permission_granted?)
      end
    end
  end

  describe "#conversation" do
    let(:params) { load_json_fixture(:text_intent_request) }

    it "returns a Conversation object with the given params" do
      conversation = subject.conversation

      assert_equal("1234567890", conversation.id)
      assert_equal(2, conversation.type)
      assert_equal(GoogleAssistant::DialogState, conversation.dialog_state.class)
    end
  end

  describe "#user" do
    let(:params) { load_json_fixture(:main_intent_request) }

    it "returns a User object with the given params" do
      user = subject.user

      assert_equal("qwERtyUiopaSdfGhJklzXCVBNm/tF=", user.id)
    end
  end

  describe "#device" do
    let(:params) { load_json_fixture(:coarse_location_granted) }

    it "returns a Device object with the given params" do
      device = subject.device

      assert_equal(params["device"]["location"], device.location)
    end
  end

  describe "#tell" do

    describe "when given an SSML message" do

      it "returns a JSON hash response with SSML" do
        message = "<speak>An SSML message</speak>"

        expected_response = {
          expectUserResponse: false,
          finalResponse: {
            speechResponse: { ssml: message }
          }
        }

        assert_equal(expected_response, subject.tell(message))
      end
    end

    describe "when given a plain text message" do

      it "returns a JSON hash response with text" do
        message = "A plain text message"

        expected_response = {
          expectUserResponse: false,
          finalResponse: {
            speechResponse: { textToSpeech: message }
          }
        }

        assert_equal(expected_response, subject.tell(message))
      end
    end

    describe "when given an empty message" do

      it "raises GoogleAssistant::InvalidMessage" do
        message = ""

        assert_raises GoogleAssistant::InvalidMessage do
          subject.tell(message)
        end
      end
    end

    describe "when given a nil message" do

      it "raises GoogleAssistant::InvalidMessage" do
        message = nil

        assert_raises GoogleAssistant::InvalidMessage do
          subject.tell(message)
        end
      end
    end
  end

  describe "#ask" do

    describe "when given a nil input prompt" do

      it "raises an error" do
        assert_raises GoogleAssistant::InvalidInputPrompt do
          subject.ask(nil, nil)
        end
      end
    end

    describe "when given an SSML string input prompt" do

      it "returns a JSON hash response with SSML" do
        response = subject.ask("<speak>Some SSML input prompt</speak>")

        expected_response = {
          conversationToken: "{\"state\":null,\"data\":{}}",
          expectUserResponse: true,
          expectedInputs: [
            {
              inputPrompt: {
                initialPrompts: [{ ssml: "<speak>Some SSML input prompt</speak>" }],
                noInputPrompts: []
              },
              possibleIntents: [{ intent: "actions.intent.TEXT" }]
            }
          ]
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when given a plain text string input prompt" do

      it "returns a JSON hash response with text" do
        response = subject.ask("Some text input prompt")

        expected_response = {
          conversationToken: "{\"state\":null,\"data\":{}}",
          expectUserResponse: true,
          expectedInputs: [
            {
              inputPrompt: {
                initialPrompts: [{ textToSpeech: "Some text input prompt" }],
                noInputPrompts: []
              },
              possibleIntents: [{ intent: "actions.intent.TEXT" }]
            }
          ]
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when the conversation dialog state has data" do

      it "includes the state and data" do
        dialog_state = subject.conversation.dialog_state
        dialog_state.state = "a state"
        dialog_state.data = { "a data key" => "the data value" }
        response = subject.ask("Some input prompt")

        expected_response = {
          conversationToken: { state: "a state", data: { "a data key" => "the data value" } }.to_json,
          expectUserResponse: true,
          expectedInputs: [
            {
              inputPrompt:  {
                initialPrompts: [{ textToSpeech: "Some input prompt" }],
                noInputPrompts: []
              },
              possibleIntents: [{ intent: "actions.intent.TEXT" }]
            }
          ]
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when given a string no_inputPrompt" do

      it "returns a JSON hash response with text" do
        response = subject.ask(
          "Some text input prompt",
          "A no input prompt"
        )

        expected_response = {
          conversationToken: "{\"state\":null,\"data\":{}}",
          expectUserResponse: true,
          expectedInputs: [
            {
              inputPrompt: {
                initialPrompts: [{ textToSpeech: "Some text input prompt" }],
                noInputPrompts: [{ textToSpeech: "A no input prompt" }]
              },
              possibleIntents: [{ intent: "actions.intent.TEXT" }]
            }
          ]
        }

        assert_equal(expected_response, response)
      end
    end

    describe "when given an array of strings for no_inputPrompt" do

      it "returns a JSON hash response with text" do
        response = subject.ask(
          "Some text input prompt",
          [
            "A no input prompt",
            "<speak>Yet another no input prompt</speak>"
          ]
        )

        expected_response = {
          conversationToken: "{\"state\":null,\"data\":{}}",
          expectUserResponse: true,
          expectedInputs: [
            {
              inputPrompt: {
                initialPrompts: [{ textToSpeech: "Some text input prompt" }],
                noInputPrompts: [
                  { textToSpeech: "A no input prompt" },
                  { ssml: "<speak>Yet another no input prompt</speak>" }
                ]
              },
              possibleIntents: [{ intent: "actions.intent.TEXT" }]
            }
          ]
        }

        assert_equal(expected_response, response)
      end
    end
  end

  describe "#ask_for_permission" do

    describe "when given a nil context" do

      it "raises InvalidPermissionContext" do
        assert_raises GoogleAssistant::InvalidPermissionContext do
          subject.ask_for_permission(nil, GoogleAssistant::Permission::NAME)
        end
      end
    end

    describe "when given an empty context" do

      it "raises InvalidPermissionContext" do
        assert_raises GoogleAssistant::InvalidPermissionContext do
          subject.ask_for_permission("", GoogleAssistant::Permission::NAME)
        end
      end
    end

    describe "when given an invalid permission" do

      it "raises InvalidPermission" do
        assert_raises GoogleAssistant::InvalidPermission do
          subject.ask_for_permission("A context", "invalid permission")
        end
      end
    end

    describe "when given an empty array of permissions" do

      it "raises InvalidPermission" do
        assert_raises GoogleAssistant::InvalidPermission do
          subject.ask_for_permission("A context", [])
        end
      end
    end

    describe "when given a single permission" do

      it "returns a JSON hash response" do
        response = subject.ask_for_permission("A context", GoogleAssistant::Permission::NAME)

        expected_response = {
          conversationToken: "{\"state\":null,\"data\":{}}",
          expectUserResponse: true,
          expectedInputs: [
            {
              inputPrompt: {
                initialPrompts: [{ textToSpeech: "placeholder" }],
                noInputPrompts: []
              },
              possibleIntents: [
                {
                  intent: "actions.intent.PERMISSION",
                  inputValueData: {
                    "@type": "type.googleapis.com/google.actions.v2.PermissionValueSpec",
                    optContext: "A context",
                    permissions: ["NAME"]
                  }
                }
              ]
            }
          ]
        }

        assert_equal(expected_response, response)
      end
    end
  end
end
