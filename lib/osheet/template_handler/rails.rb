# Rails 2.X Template
if Rails.version =~ /^2/
  require 'action_view/base'
  require 'action_view/template'

  module ActionView
    module TemplateHandlers
      class OsheetHandler < TemplateHandler
        include Compilable

        def compile(template)
          # template.format => 'xls' (or xlsx or whatever they specify)
          %{::Osheet::Workbook.new {#{template.source}\n }.to_data}
        end

      end
    end
  end

  ::ActionView::Template.register_template_handler :osheet, ActionView::TemplateHandlers::OsheetHandler
end

# Rails 3.X Template
if Rails.version =~ /^3/
  require 'action_view/base'
  require 'action_view/template'

  module Osheet
    class ActionViewHandler < ::ActionView::Template::Handler
      include ::ActionView::Template::Handlers::Compilable

      self.default_format = Osheet::MIME_TYPE
      def compile(template)
        # template.format => 'xls' (or xlsx or whatever they specify)
        %{::Osheet::Workbook.new {\n#{template.source.inspect}\n }.to_data}
      end

    end
  end

  ::ActionView::Template.register_template_handler :osheet, Osheet::ActionViewHandler
end