require "json"
require "fake_response"

module TestHelper

  def load_json_fixture(fixture_name)
    file = File.read("test/fixtures/#{fixture_name}.json")
    JSON.parse(file)
  end
end
