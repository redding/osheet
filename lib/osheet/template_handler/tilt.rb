# TILT/Sinatra template engine
module Osheet
  class TiltHandler < Tilt::Template

    def self.engine_initialized?
      defined? ::Osheet::Workbook
    end

    def initialize_engine
      require_template_library 'osheet'
    end

    def prepare; end

    def precompiled_preamble(locals)
      "::Osheet::Workbook.new {\n#{super}"
    end

    def precompiled_template(locals)
      data.to_str
    end
    def precompiled_postamble(locals)
      "}.to_data"
    end

  end
end

Tilt.register 'osheet', Osheet::TiltHandler

if defined?(::Sinatra::Base)
  class ::Sinatra::Base

    # use this helper method to render Osheet views in Sinatra
    # => view files should be named: "#{template}.osheet"
    def osheet(template, options={}, locals={})
      options.merge! :layout => false, :default_content_type => ::Osheet::MIME_TYPE
      render :osheet, template, options, locals
    end

  end
end
