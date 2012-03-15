require 'osheet/style'
require 'osheet/xmlss_writer'
require 'osheet/xmlss_writer/style_settings'

class Osheet::XmlssWriter
  class StyleCache

    attr_reader :styles

    def initialize(osheet_workbook, xmlss_workbook)
      @osheet_workbook = osheet_workbook
      @xmlss_workbook  = xmlss_workbook
      @styles = {}
    end

    def [](key); @styles[key];      end
    def empty?;  @styles.empty?;    end
    def size;    @styles.keys.size; end

    def keys
      @styles.keys
    end

    def get(style_class, format)
      # generate the style key and get the get the cached style or
      # build and cache and return a style for the key
      return nil if (key = self.key(style_class, format.key)).empty?
      @styles[key] ||
      build_and_cache(key, @osheet_workbook.styles.for(style_class), format)
    end

    protected

    # build a unique key for styling based off the style and format keys
    def key(class_value, format_key)
      (class_value || '').strip.split(/\s+/).collect do |c|
        ".#{c}"
      end.join('') + (format_key.nil? || format_key.empty? ? '' : "..#{format_key}")
    end

    # build and cache an xmlss style
    def build_and_cache(key, styles, format)
      settings = StyleSettings.new(styles)
      @styles[key] = @xmlss_workbook.style(key) {
        settings.setting(:align) { @xmlss_workbook.alignment(settings[:align]) }
        settings.setting(:font) { @xmlss_workbook.font(settings[:font]) }
        settings.setting(:bg) { @xmlss_workbook.interior(settings[:bg]) }

        border_set = ::Osheet::Style::BORDERS.inject([]) do |set, bp|
          settings.setting(bp) { set << settings[bp] }
          set
        end
        if !border_set.empty?
          @xmlss_workbook.borders {
            border_set.each { |setting| @xmlss_workbook.border(setting) }
          }
        end

        @xmlss_workbook.number_format(format.style)
      }
    end

  end
end
