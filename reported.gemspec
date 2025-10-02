# frozen_string_literal: true

require_relative 'lib/reported/version'

Gem::Specification.new do |spec|
  spec.name        = 'reported'
  spec.version     = Reported::VERSION
  spec.authors     = ['Brice TEXIER']
  spec.email       = ['brice@codeur.com']
  spec.homepage    = 'https://github.com/codeur/reported'
  spec.summary     = 'CSP reports collection for Rails apps'
  spec.description = 'A Rails engine that collects, stores and notifies on Slack about CSP violation reports'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/codeur/reported/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'false'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.required_ruby_version = '>= 3.4'

  spec.add_dependency 'rails', '>= 5.2', '< 8'
end
