require "minitest/autorun"
require "google_assistant/argument"

describe GoogleAssistant::Argument do
  let(:params) { { "name" => "a name", "raw_text" => "some raw text", "text_value" => "some text value" } }
  subject { GoogleAssistant::Argument.new(params) }

  describe "#from" do
    subject { GoogleAssistant::Argument.from(params) }

    describe "when name is permission_granted" do
      let(:params) { { "name" => "permission_granted" } }

      it "returns a PermissionArgument object" do
        assert_equal(GoogleAssistant::PermissionArgument, subject.class)
      end
    end

    describe "when name is text" do
      let(:params) { { "name" => "text" } }

      it "returns a TextArgument object" do
        assert_equal(GoogleAssistant::TextArgument, subject.class)
      end
    end

    describe "when name is something unknown" do
      let(:params) { { "name" => "a name" } }

      it "returns an Argument object" do
        assert_equal(GoogleAssistant::Argument, subject.class)
      end
    end
  end

  describe "#initialize" do

    it "sets the class's attributes" do
      assert_equal(params["name"], subject.name)
      assert_equal(params["raw_text"], subject.raw_text)
      assert_equal(params["text_value"], subject.text_value)
    end
  end
end

describe GoogleAssistant::TextArgument do
  let(:params) { { "name" => "text", "text_value" => "some text value" } }
  subject { GoogleAssistant::Argument.from(params) }

  describe "#value" do

    it "returns the value of text_value" do
      assert_equal(params["text_value"], subject.value)
    end
  end
end

describe GoogleAssistant::PermissionArgument do
  let(:params) { { "name" => "permission_granted", "text_value" => text_value } }
  subject { GoogleAssistant::Argument.from(params) }

  describe "#permission_granted?" do

    describe "when text_value is true" do
      let(:text_value) { "true" }

      it "returns true" do
        assert(subject.permission_granted?)
      end
    end

    describe "when text_value is false" do
      let(:text_value) { "false" }

      it "returns false" do
        assert_equal(false, subject.permission_granted?)
      end
    end
  end
end
