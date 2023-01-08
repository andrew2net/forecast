# frozen_string_literal: true

require "rails_helper"

RSpec.describe "home/index.html.erb", type: :view do
  it "renders the index template" do
    render
    expect(rendered).to match(/Forecast/)
    expect(rendered).to match(/City or Zip code/)
    expect(rendered).to match(/turbo-frame="forecast"/)
  end
end
