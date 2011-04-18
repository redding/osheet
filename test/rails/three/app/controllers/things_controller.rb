class ThingsController < ApplicationController

  def index
    respond_to do |format|
      format.xls { }
    end
  end

end
