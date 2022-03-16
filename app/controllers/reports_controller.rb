class ReportsController < ApplicationController
  def index
    @index_fecade = Reports::IndexFecade.new(params: params)
    render :index
  end
end
