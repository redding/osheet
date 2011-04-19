require 'rack/test'
require 'webrat'

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat.configure do |config|
    config.mode = :rack
  end

  def assert_osheet_response(app, response)
    assert_equal 200, response.status, "status is not '#{Rack::Utils::HTTP_STATUS_CODES[200]}'"
    assert response.headers["Content-Type"].include?(Osheet::MIME_TYPE), "content type is not '#{Osheet::MIME_TYPE}'"
    assert_osheet_data(app, response.body)
  end

  def assert_osheet_data(app, body)
    correct_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Workbook xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"><Styles/><Worksheet ss:Name=\"from #{app}\"><Table><Row><Cell><Data ss:Type=\"Number\">1</Data></Cell><Cell><Data ss:Type=\"Number\">2</Data></Cell></Row></Table></Worksheet></Workbook>"
    assert_equal correct_body, body.strip, "incorrect osheet data"
  end

end

module Osheet
  module RailsTestHelpers

    module StartStop
      def test_rails_app(version, action, host, port)
        case action
        when :start
          puts
          # puts "starting Rails #{version} app on port #{port}..."
          @test_app_pid = Open4.popen4(case version
          when :two
            "ruby test/rails/two/script/server -p #{port}"
          when :three
            pwd = `pwd`.strip
            cmd = "test/rails/three/script/rails server --pid=#{pwd}/test/rails/three/tmp/pids/test_server.pid --config=#{pwd}/test/rails/three/config.ru -p 3003"
            cmd
          end)[0]
          puts "\nwaiting for rails #{version} app to start (#{@test_app_pid})"
          sleep 3
          while !(g = Open4.popen4("</dev/tcp/#{host}/#{port}")[3].gets).nil?
            puts "waiting for rails #{version} app to start (#{@test_app_pid}): #{g.inspect}"
            sleep 0.1
          end
        when :stop
          puts
          # puts "\nstopping Rails #{version} app on port #{port}..."
          Process.kill(9, @test_app_pid)
          while Open4.popen4("</dev/tcp/#{host}/#{port}")[3].gets.nil?
            puts "\nwaiting for rails #{version} app to stop (#{@test_app_pid})"
            sleep 0.5
          end
        end
      end
    end

    def self.included(receiver)
      receiver.send :extend, StartStop
    end

  end
end
