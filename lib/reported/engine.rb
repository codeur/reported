module Reported
  class Engine < ::Rails::Engine
    isolate_namespace Reported

    config.generators do |g|
      g.test_framework :test_unit
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
