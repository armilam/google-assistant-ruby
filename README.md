# Google Assistant Ruby

Details to come. Basically, you can use this in rails like so:

```rb
class GoogleAssistantController < ApplicationController

  def conversation
    assistant_response = GoogleAssistant.new(params).respond_to do |assistant|
      assistant.intent.main do
        assistant.ask("<speak>I can speak! Can you hear me?</speak>")
      end

      assistant.intent.text do
        assistant.tell("<speak>I can respond, too!</speak>")
      end
    end

    render assistant_response
  end
end
```
