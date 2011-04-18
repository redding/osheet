require "test/helper"
require "test/app_helper"
require 'test/sinatra/app'

class SinatraTest < Test::Unit::TestCase

  def app
    @app ||= SinatraApp
  end

  context "Requesting xls from a Sinatra app" do
    before { @response = visit "/index.xls" }

    should "respond with osheet data" do
      assert_osheet_response 'sinatra', @response
    end
  end

end