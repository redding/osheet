require 'osheet/style'
require 'osheet/xmlss_writer'

class Osheet::XmlssWriter
  class StyleSettings

    attr_reader :styles, :value

    def initialize(styles)
      @styles = styles
      @value = @styles.inject({}) do |value, style|
        merged_settings(value, style_settings(style))
      end
    end

    def [](setting); @value[setting]; end

    # call the given block passing it the setting if that setting
    # exists and is not empty
    def setting(s, &block)
      block.call if self.value[s] && !self.value[s].empty?
    end

    protected

    def merged_settings(current, add)
      # concat values for keys in both sets
      current.keys.each do |k|
        current[k].merge!(add.delete(k) || {})
      end
      # merge keys for anything not in the current
      current.merge(add)
    end

    def style_settings(osheet_style_obj)
      settings = {}
      Osheet::Style::SETTINGS.each do |setting|
        if !(v = osheet_style_obj.send(setting)).empty?
          settings[setting] = self.send("#{setting}_settings", v)
        end
      end
      settings
    end

    def align_settings(osheet_align_directives)
      osheet_align_directives.inject({}) do |settings, directive|
        case directive
        when :left, :center, :right
          settings[:horizontal] = directive
        when :top, :bottom
          settings[:vertical] = directive
        when :middle
          settings[:vertical] = :center
        when :wrap
          settings[:wrap_text] = true
        when ::Fixnum
          settings[:rotate] = directive
        end
        settings
      end
    end

    def font_settings(osheet_font_directives)
      osheet_font_directives.inject({}) do |settings, directive|
        case directive
        when ::Fixnum
          settings[:size] = directive
        when ::String
          if directive =~ /^#/
            settings[:color] = directive
          else
            settings[:name] = directive
          end
        when :bold, :italic, :shadow
          settings[directive] = true
        when :subscript, :superscript
          settings[:alignment] = directive
        when :strikethrough
          settings[:strike_through] = true
        when :underline
          settings[:underline] = :single
        when :double_underline
          settings[:underline] = :double
        when :accounting_underline
          settings[:underline] = :single_accounting
        when :double_accounting_underline
          settings[:underline] = :double_accounting
        end
        settings
      end
    end

    def bg_settings(osheet_bg_directives)
      osheet_bg_directives.inject({}) do |settings, directive|
        case directive
        when ::String
          if directive =~ /^#/
            settings[:color] = directive
          end
        when ::Symbol
          if ::Xmlss::Style::Interior.pattern_set.include?(directive)
            settings[:pattern] = directive
          end
        when ::Hash
          directive.each do |pattern, color|
            if ::Xmlss::Style::Interior.pattern_set.include?(pattern) && color =~ /^#/
              settings[:pattern] = pattern
              settings[:pattern_color] = color
            end
          end
        end

        if !settings[:color].nil? && settings[:pattern].nil?
          settings[:pattern] = :solid
        end

        settings
      end
    end

    def border_settings(osheet_border_directives)
      osheet_border_directives.inject({}) do |settings, directive|
        case directive
        when ::String
          if directive =~ /^#/
            settings[:color] = directive
          end
        when ::Symbol
          if ::Xmlss::Style::Border.position_set.include?(directive)
            settings[:position] = directive
          elsif ::Xmlss::Style::Border.weight_set.include?(directive)
            settings[:weight] = directive
          elsif ::Xmlss::Style::Border.line_style_set.include?(directive)
            settings[:line_style] = directive
          end
        end
        settings
      end
    end

    ::Osheet::Style::BORDER_POSITIONS.each do |p|
      define_method("border_#{p}_settings") do |cmds|
        border_settings(cmds+[p])
      end
    end

  end
end
