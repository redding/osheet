class ThingsController < ApplicationController

  def index
    @times = 2
    respond_to do |format|
      format.xls { }
    end
  end

end
