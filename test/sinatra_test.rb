require "test/helper"
require "test/app_helper"
require 'test/sinatra/app'

class SinatraTest < Test::Unit::TestCase

  def app
    @app ||= SinatraApp
  end

  should_respond_with_osheet_data "a Sinatra app"

end