class ThingsController < ApplicationController

  def index
    times = 5
    puts "instance vars: #{self.instance_variables.inspect}"
    puts "params: #{params.inspect}"
    respond_to do |format|
      format.html { }
      format.xls {
        puts "HERE"
      }
    end
  end

end
