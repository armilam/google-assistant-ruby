module GoogleAssistant
  class Device
    attr_reader :location, :coordinates

    def initialize(opts)
      @location = opts["location"] || {}
      @coordinates = @location["coordinates"] || {}
    end

    def city
      location["city"]
    end

    def zip_code
      location["zip_code"]
    end

    def formatted_address
      location["formatted_address"]
    end

    def latitude
      coordinates["latitude"]
    end

    def longitude
      coordinates["longitude"]
    end
  end
end
