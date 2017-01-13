# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/google_assistant/**/*.rb"].each { |file| require file }

module GoogleAssistant

  def self.respond_to(params, response, &block)
    Assistant.new(params, response).respond_to(&block)
  end
end
