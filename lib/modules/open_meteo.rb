# frozen_string_literal: true

require "json"
require "net/http"

#
# Fetches weather data from OpenMeteo API
#
class OpenMeteo
  def initialize(address)
    @address = address
  end

  def self.fetch(address)
    new(address).fetch
  end

  #
  # Fetches location and weather data from OpenMeteo API
  #
  # @return [Hash] weather data or error message
  #
  def fetch
    return location if location[:error]

    zip_code = location["postcodes"].first
    cached = true
    resp = Rails.cache.fetch("open_meteo/#{zip_code}", expires_in: 30.minutes) do
      cached = false
      fetch_forecast
    end
    resp.merge cached:, address: location_address
  rescue StandardError => e
    { error: e.message }
  end

  #
  # Generates location address from location data
  #
  # @return [String] location address
  #
  def location_address
    location.values_at("admin2", "name", "admin1", "state", "country").compact.join(", ")
  end

  #
  # Return location data or error message
  #
  # @return [Hash] location data or error message
  #
  def location
    @location ||= fetch_location || { error: "Location not found" }
  end

  #
  # Fetches location from OpenMeteo API
  #
  # @return [Hash] location data or error message
  #
  def fetch_location
    return if @address.blank?

    Rails.cache.fetch("open_meteo/location/#{@address}", expires_in: 1.day) do
      uri = URI "https://geocoding-api.open-meteo.com/v1/search?name=#{@address}"
      response = Net::HTTP.get uri
      JSON.parse(response)["results"]&.first
    end
  end

  #
  # Fetches weather data from OpenMeteo API
  #
  # @return [<Type>] <description>
  #
  def fetch_forecast
    latitude, longitude, timezone = location.values_at("latitude", "longitude", "timezone")
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}" \
          "&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit" \
          "&timezone=#{timezone}"
    response = Net::HTTP.get URI(url)
    data = JSON.parse(response)
    %w[hourly daily].each_with_object({}) do |type, memo|
      memo[type.to_sym] = data[type].values.transpose
    end
  end
end
