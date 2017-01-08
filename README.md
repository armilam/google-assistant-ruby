# Google Assistant Ruby

Write Google Assistant actions in Ruby.

GoogleAssistant parses Google Assistant requests and provides the framework to respond appropriately. It works with the Google Assistant API v1.

## Installation

Add this line to your application's Gemfile:

```rb
gem "google_assistant"
```

## Get started

### Rails 4 and higher

In your routes file, allow a `POST` request to your action. All requests from Google Assistant will come here.

```rb
Rails.application.routes.draw do
  post "/google_assistant" => "google_assistant#conversation"
end
```

Write your controller to handle the request. Use GoogleAssistant to respond to the requests.

```rb
class GoogleAssistantController < ApplicationController

  def conversation
    assistant_response = GoogleAssistant.new(params, response).respond_to do |assistant|
      assistant.intent.main do
        input_prompt = assistant.build_input_prompt(
          true,
          "<speak>Hi there! Say something, please.</speak>",
          ["<speak>If you said something, I didn't hear you.</speak>", "<speak>Did you say something?</speak>"]
        )

        assistant.ask(input_prompt)
      end

      assistant.intent.text do
        assistant.tell("<speak>I can respond, too!</speak>")
      end
    end

    render assistant_response
  end
end
```

## Usage

GoogleAssistant parses the request from the Google Assistant API and helps you build your response. It takes the `params` and `request` objects in Rails and Sinatra.

```rb
assistant_response = GoogleAssistant.new(params, response).respond_to do |assistant|
  # Response logic goes here
end
```

The Google Assistant API sends a request using the `MAIN` intent for the initial request from the user. This is when the user says "OK Google, talk to #{name_of_your_app}".

```rb
assistant_response = GoogleAssistant.new(params, response).respond_to do |assistant|
  assistant.intent.main do
    # Initial request's response goes here. You may want to introduce the app here.
  end
end
```

The Google Assistant API sends a request using the `TEXT` intent for subsequent requests from the user. When your app asks for input from the user, the conversation continues. When the user finishes the conversation with "Goodbye" or your app finishes the conversation with a `tell` response, the conversation ends and any new conversations start again with the `MAIN` intent.

```rb
assistant_response = GoogleAssistant.new(params, response).respond_to do |assistant|
  assistant.intent.text do
    # Respond to user input here.
  end
end
```

### Ask

Request user input by sending an `ask` response. To do so, build an input prompt and send it as an argument to `ask`.

```rb
assistant.intent.main do
  input_prompt = assistant.build_input_prompt(
    true,                                                         # true if your text is written with SSML, false otherwise.
    "<speak>Hi there! Say something, please.</speak>",            # The voice prompt the user will hear.
    [
      "<speak>If you said something, I didn't hear you.</speak>", # You can provide a number of "no input prompts". A random
      "<speak>Did you say something?</speak>"                     # one will be spoken if the user takes too long to respond.
    ]
  )

  assistant.ask(input_prompt)
end
```

### Tell

Send a final response, ending the conversation.

```rb
assistant.intent.text do
  assistant.tell("<speak>Thanks for talking! Goodbye!</speak>")   # Both SSML and plain text work here.
end
```

### User input

GoogleAssistant allows you to read the user's input using `assistant.arguments` so that you can respond appropriately.

```rb
assistant.intent.text do
  case assistant.arguments[0].text_value.downcase
  when "hello"
    respond_with = "Hi there!"
  when "goodbye"
    respond_with = "See you later!"
  else
    respond_with "I heard you say #{assistant.arguments[0].text_value}, but I don't know what that means."
  end

  assistant.tell(respond_with)
end
```

### Conversation state and data

You can keep data on the Conversation object. This data will be sent to the Google Assistant API, which will return that data back when the user responds. This way, you can keep ongoing information about the conversation without having to use a database to store that information.

You can also send a state value with your responses to keep track of where your conversation is at.

```rb
GoogleAssistant.new(params, response).respond_to do |assistant|
  assistant.intent.main do
    input_prompt = assistant.build_input_prompt(
      false,
      "What is your favorite color?",
      ["What did you say your favorite color is?"]
    )

    assistant.conversation.state = "asking favorite color"

    assistant.ask(input_prompt)
  end

  assistant.intent.text do
    if assistant.conversation.state == "asking favorite color"
      assistant.conversation.data["favorite_color"] = assistant.arguments[0].text_value

      input_prompt = assistant.build_input_prompt(
        false,
        "What is your lucky number?",
        ["What did you say your lucky number is?"]
      )

      assistant.conversation.state = "asking lucky number"

      assistant.ask(input_prompt)
    elsif assistant.conversation.state == "asking lucky number"
      favorite_color = assistant.conversation.data["favorite_color"]
      lucky_number = assistant.arguments[0].text_value

      assistant.tell("Your favorite color is #{favorite_color} and your lucky number is #{lucky_number}. Neat!")
    end
  end
end
```

### SSML

SSML is Google Assistant's markup language for text to speech. It provides options to pause, interpret dates and numbers, and more. You can provide SSML responses or plain text. See [Google's documentation on SSML](https://developers.google.com/actions/reference/ssml).

### More information

Check out Google's instructions at https://developers.google.com/actions/develop/sdk/getting-started. You'll need to add an `actions.json` file, but Google's instructions pretty much cover deploying a Google Assistant action.

Check out https://github.com/armilam/google_assistant_example for a simple example of this gem in action.
