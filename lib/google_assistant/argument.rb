module GoogleAssistant
  class Argument
    attr_reader :name, :raw_text, :text_value

    def initialize(opts)
      @name = opts["name"]
      @raw_text = opts["raw_text"]
      @text_value = opts["text_value"]
    end
  end
end
