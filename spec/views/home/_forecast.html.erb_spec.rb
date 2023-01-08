# frozen_string_literal: true

require "rails_helper"

describe "home/_forecast.html.erb", type: :view do
  describe "renders the forecast partial" do
    it "display error" do
      assign(:forecast, error: "Location not found")
      render
      expect(rendered).to match(/Location not found/)
    end

    it "display forecast" do
      assign(:forecast, hourly: [["2023-01-07T00:00", 36.8], ["2023-01-07T01:00", 36.3]],
                        daily: [["2023-01-07", 36.8, 36.3], ["2023-01-08", 36.8, 36.3]],
                        address: "New York", cached: false)
      render
      expect(rendered).to match(/2023-01-07T00:00/)
      expect(rendered).to match(/2023-01-07T01:00/)
      expect(rendered).to match(/2023-01-07/)
      expect(rendered).to match(/2023-01-08/)
      expect(rendered).to match(/36.8/)
      expect(rendered).to match(/36.3/)
      expect(rendered).to match(/New York/)
      expect(rendered).to match(/Cached: false/)
    end
  end
end
