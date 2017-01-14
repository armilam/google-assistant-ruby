class FakeResponse
  attr_reader :headers

  def initialize
    @headers = {}
  end
end
