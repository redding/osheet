require 'rack/test'
require 'webrat'

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat.configure do |config|
    config.mode = :rack
  end

  class << self

    def should_respond_with_osheet_data(context_s="the app")
      context "Requesting xls from #{context_s}" do
        before { @response = visit "/index.xls" }

        should "respond with osheet data" do
          correct_response_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Workbook xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"><Styles/><Worksheet ss:Name=\"from sinatra\"><Table><Row><Cell><Data ss:Type=\"Number\">1</Data></Cell></Row></Table></Worksheet></Workbook>"
          assert_equal 200, @response.status, "status is not '#{Rack::Utils::HTTP_STATUS_CODES[200]}'"
          assert @response.headers["Content-Type"].include?(Osheet::MIME_TYPE), "content type is not '#{Osheet::MIME_TYPE}'"
          assert_equal correct_response_body, @response.body.strip, "the response body is incorrect"
        end

      end
    end

  end

end
