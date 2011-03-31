module Osheet::XmlssWriter::Styles

  protected

  def style(style_class, format=nil)
    key = style_key(style_class, format)
    xmlss_style = @styles.find{|style| style.id == key}
    if xmlss_style.nil?
      settings = style_settings(key)
      #puts "settings: #{settings.inspect}"
      @styles << (xmlss_style = ::Xmlss::Style::Base.new(key) {
        if settings.has_key?(:align) && !settings[:align].empty?
          alignment(settings[:align])
        end
        if settings.has_key?(:font) && !settings[:font].empty?
          font(settings[:font])
        end
      })
    end
    xmlss_style
  end

  def style_key(style_class, format)
    (style_class || '').strip.split(/\s+/).collect do |c|
      ".#{c}"
    end.join('') + "..#{format}"
  end

  def style_settings(key)
    @ostyles.for(key).inject({}) do |style_settings, ostyle|
      style_settings.merge(ostyle_settings(ostyle))
    end
  end

  def ostyle_settings(ostyle)
    ostyle_settings = {}
    ostyle.attributes.each do |k,v|
      unless v.empty?
        ostyle_settings[k] = send("#{k}_settings", v)
      end
    end
    ostyle_settings
  end

  def align_settings(align_cmds)
    align_cmds.inject({}) do |align_settings, align_cmd|
      if (setting = case align_cmd
        when :left, :center, :right
          [:horizontal, align_cmd]
        when :top, :bottom
          [:vertical, align_cmd]
        when :middle
          [:vertical, :center]
        when :wrap
          [:wrap_text, true]
        when ::Fixnum
          [:rotate, align_cmd]
        end
      )
        align_settings[setting.first] = setting.last
      end
      align_settings
    end
  end

  def font_settings(font_cmds)
    font_cmds.inject({}) do |font_settings, font_cmd|
      if (setting = case font_cmd
        when :underline
          [:underline, :single]
        when :double_underline
          [:underline, :double]
        when :subscript, :superscript
          [:alignment, font_cmd]
        when :bold, :italic
          [font_cmd, true]
        when :strikethrough
          [:strike_through, true]
        when ::Fixnum
          [:size, font_cmd]
        when ::String
          if font_cmd =~ /^#/
            [:color, font_cmd]
          end
        end
      )
        font_settings[setting.first] = setting.last
      end
      font_settings
    end
  end

end
