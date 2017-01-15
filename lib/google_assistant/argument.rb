# frozen_string_literal: true

module GoogleAssistant
  class Argument
    attr_reader :name, :raw_text, :text_value

    def self.from(opts)
      case opts["name"]
      when "permission_granted"
        PermissionArgument.new(opts)
      when "text"
        TextArgument.new(opts)
      else
        Argument.new(opts)
      end
    end

    def initialize(opts)
      @name = opts["name"]
      @raw_text = opts["raw_text"]
      @text_value = opts["text_value"]
    end
  end

  class TextArgument < Argument
    alias_method :value, :text_value
  end

  class PermissionArgument < Argument

    def permission_granted?
      text_value == "true"
    end
  end
end
