module Osheet::Dsl
  class Cell

    def initialize(&block)
      @data = nil
      @format = nil
      @rowspan = 1
      @colspan = 1
      instance_eval(&block) if block
    end

    def data(value); @data = value; end
    def format(value); @format = value; end
    def rowspan(value); @rowspan = value; end
    def colspan(value); @colspan = value; end

  end
end
