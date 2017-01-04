require "minitest/autorun"
require "google_assistant/argument"

describe GoogleAssistant::Argument do
  let(:params) { { "name" => "a name", "raw_text" => "some raw text", "text_value" => "some text value" } }
  subject { GoogleAssistant::Argument.new(params) }

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params["name"], subject.name)
      assert_equal(params["raw_text"], subject.raw_text)
      assert_equal(params["text_value"], subject.text_value)
    end
  end
end
