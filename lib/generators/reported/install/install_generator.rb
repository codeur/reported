# frozen_string_literal: true

require 'rails/generators'

module Reported
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates Reported initializer for your application'

      def copy_initializer
        template 'reported.rb', 'config/initializers/reported.rb'

        Rails.logger.debug 'Reported initializer created at config/initializers/reported.rb'
      end

      def show_readme
        readme 'README' if behavior == :invoke
      end
    end
  end
end
