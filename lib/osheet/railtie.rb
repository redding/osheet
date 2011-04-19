module Osheet
  class Railtie < Rails::Railtie

    initializer "osheet.register" do |app|
      ::Osheet.register
    end

  end
end
