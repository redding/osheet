module Osheet

  module AssertTestHelpers

    def assert_style(style, selectors)
      with_backtrace(caller) do
        assert_equal selectors, style.selectors, 'unexpected style selectors'
      end
    end

    def assert_partial(workbook_partials, name)
      with_backtrace(caller) do
        partial = workbook_partials[name.to_s]
        assert_not_nil partial, "could not find a partial named `#{name}`"
        assert_equal name.to_s, partial.name, 'wrong partial name'
      end
    end

    def assert_template(workbook_templates, element, name)
      with_backtrace(caller) do
        elem_templates = workbook_templates[element.to_s]
        assert_not_nil elem_templates, "could not find any `#{element}` templates"
        template = elem_templates[name.to_s]
        assert_not_nil template, "could not find a `#{element}` template named `#{name}`"
        assert_equal element.to_s, template.element, 'wrong template element'
        assert_equal name.to_s, template.name, 'wrong template name'
      end

    end

  end

end
