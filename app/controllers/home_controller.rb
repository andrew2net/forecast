# frozen_string_literal: true

#
# Home controller
#
class HomeController < ApplicationController
  def index; end

  def forecast
    @forecast = OpenMeteo.fetch(params[:address])
    render partial: "forecast"
  end
end
