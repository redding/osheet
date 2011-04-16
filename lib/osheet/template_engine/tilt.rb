# TILT/Sinatra template engine

class OsheetTemplate < Tilt::Template

  def self.engine_initialized?
    defined? ::Osheet
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

Tilt.register 'osheet', OsheetTemplate

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
