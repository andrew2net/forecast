# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /forecast", vcr: "post_forecast" do
    it "returns http success" do
      get "/forecast", params: { address: "New York" }
      expect(response).to have_http_status(:success)
    end
  end
end
