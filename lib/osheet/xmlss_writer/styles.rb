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
      #puts "kv: #{k.inspect}, #{v.inspect}"
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

end
