# frozen_string_literal: true

module Reported
  class Engine < ::Rails::Engine
    isolate_namespace Reported

    config.generators do |g|
      g.test_framework :test_unit
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # Automatically add routes to the main application
    initializer "reported.add_routes" do |app|
      app.routes.prepend do
        post "/csp-reports", to: "reported/csp_reports#create"
      end
    end
  end
end
