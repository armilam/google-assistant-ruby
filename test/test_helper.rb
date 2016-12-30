require "json"

module TestHelper

  def load_json_fixture(fixture_name)
    file = File.read("test/fixtures/#{fixture_name}.json")
    JSON.parse(file)
  end
end
