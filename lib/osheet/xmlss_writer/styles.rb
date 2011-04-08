require 'osheet/format'
module Osheet::XmlssWriter::Styles

  protected

  def style_id(style_class, oformat=nil)
    oformat ||= Osheet::Format.new(:general)
    (xmlss_style = style(style_class, oformat)).nil? ? '' : xmlss_style.id
  end

  def style(style_class, oformat=nil)
    oformat ||= Osheet::Format.new(:general)
    key = style_key(style_class, oformat.key)
    xmlss_style = @styles.find{|style| style.id == key}
    if !key.empty? && xmlss_style.nil?
      settings = style_settings(key)
      @styles << (xmlss_style = ::Xmlss::Style::Base.new(key) {
        if settings.has_key?(:align) && !settings[:align].empty?
          alignment(settings[:align])
        end
        if settings.has_key?(:font) && !settings[:font].empty?
          font(settings[:font])
        end
        if settings.has_key?(:bg) && !settings[:bg].empty?
          interior(settings[:bg])
        end
        ::Osheet::Style::BORDERS.each do |bp|
          if settings.has_key?(bp) && !settings[bp].empty?
            border(settings[bp])
          end
        end
        if oformat
          number_format(:format => oformat.style)
        end
      })
    end
    xmlss_style
  end

  def style_key(style_class, format_key)
    (style_class || '').strip.split(/\s+/).collect do |c|
      ".#{c}"
    end.join('') + (format_key.nil? || format_key.empty? ? '' : "..#{format_key}")
  end

  def style_settings(key)
    @ostyles.for(key).inject({}) do |style_settings, ostyle|
      merged_settings(style_settings, ostyle_settings(ostyle))
    end
  end

  def merged_settings(current, add)
    # concat values for keys in both sets
    current.keys.each do |k|
      current[k].merge!(add.delete(k) || {})
    end
    # merge keys for anything not in the current
    current.merge(add)
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
        when ::Fixnum
          [:size, font_cmd]
        when ::String
          if font_cmd =~ /^#/
            [:color, font_cmd]
          end
        when :bold, :italic, :shadow
          [font_cmd, true]
        when :subscript, :superscript
          [:alignment, font_cmd]
        when :strikethrough
          [:strike_through, true]
        when :underline
          [:underline, :single]
        when :double_underline
          [:underline, :double]
        when :accounting_underline
          [:underline, :single_accounting]
        when :double_accounting_underline
          [:underline, :double_accounting]
        end
      )
        font_settings[setting.first] = setting.last
      end
      font_settings
    end
  end

  def bg_settings(bg_cmds)
    bg_cmds.inject({}) do |bg_settings, bg_cmd|
      if (settings = case bg_cmd
        when ::String
          if bg_cmd =~ /^#/
            [[:color, bg_cmd]]
          end
        when ::Symbol
          if ::Xmlss::Style::Interior.pattern_set.include?(bg_cmd)
            [[:pattern, bg_cmd]]
          end
        when ::Hash
          bg_cmd.inject([]) do |set, kv|
            if ::Xmlss::Style::Interior.pattern_set.include?(kv.first) && kv.last =~ /^#/
              set << [:pattern, kv.first]
              set << [:pattern_color, kv.last]
            end
            set
          end
        end
      )
        settings.each do |setting|
          bg_settings[setting.first] = setting.last
        end
      end
      if !bg_settings[:color].nil? && bg_settings[:pattern].nil?
        bg_settings[:pattern] = :solid
      end
      bg_settings
    end
  end

  def border_settings(border_cmds)
    border_cmds.inject({}) do |border_settings, border_cmd|
      if (setting = case border_cmd
        when ::String
          if border_cmd =~ /^#/
            [:color, border_cmd]
          end
        when ::Symbol
          if ::Xmlss::Style::Border.position_set.include?(border_cmd)
            [:position, border_cmd]
          elsif ::Xmlss::Style::Border.weight_set.include?(border_cmd)
            [:weight, border_cmd]
          elsif ::Xmlss::Style::Border.line_style_set.include?(border_cmd)
            [:line_style, border_cmd]
          end
        end
      )
        border_settings[setting.first] = setting.last
      end
      border_settings
    end
  end
  ::Osheet::Style::BORDER_POSITIONS.each do |p|
    define_method("border_#{p}_settings") do |cmds|
      border_settings(cmds+[p])
    end
  end

end
