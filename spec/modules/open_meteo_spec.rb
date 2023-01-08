# frozen_string_literal: true

require "modules/open_meteo"
require "active_support/cache"

describe OpenMeteo do
  let(:address) { "New York" }
  subject { described_class.new(address) }

  it "find location", vcr: "get_location" do
    location = subject.location
    expect(location).to be_a Hash
    expect(location).to include("latitude", "longitude")
  end

  it "handle unknown location", vcr: "get_location_unknown" do
    subject.instance_variable_set(:@address, "unknown location")
    location = subject.location
    expect(location).to eq error: "Location not found"
  end

  it "fetch weather", vcr: "get_weather" do
    weather = subject.fetch
    expect(weather).to be_a Hash
    expect(weather).to include(:hourly, :daily, :cached)
  end

  describe "fetches weather from cache" do
    it "when cache is empty", vcr: "get_weather" do
      weather = subject.fetch
      expect(weather[:cached]).to be false
    end

    it "when cache is not empty" do
      memory_store = ActiveSupport::Cache.lookup_store(:memory_store)
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
      location = { "latitude" => 40.71427, "longitude" => -74.00597, "postcodes" => ["10001"] }
      Rails.cache.write("open_meteo/location/#{address}", location)
      Rails.cache.write("open_meteo/#{location['postcodes'].first}", { hourly: [], daily: [] })
      weather = subject.fetch
      expect(weather[:error]).to be_nil
      expect(weather[:cached]).to be true
    end
  end
end
