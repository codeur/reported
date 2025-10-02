require_relative "lib/reported/version"

Gem::Specification.new do |spec|
  spec.name        = "reported"
  spec.version     = Reported::VERSION
  spec.authors     = ["Codeur"]
  spec.email       = ["contact@codeur.com"]
  spec.homepage    = "https://github.com/codeur/reported"
  spec.summary     = "CSP reports collection for Rails apps"
  spec.description = "A Rails engine that collects, stores and notifies on Slack about CSP violation reports"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/codeur/reported"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.required_ruby_version = ">= 3.2.0"
  
  spec.add_dependency "rails", ">= 7.1"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "webmock"
end
