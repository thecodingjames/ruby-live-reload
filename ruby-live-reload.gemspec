require File.expand_path("../lib/ruby_live_reload/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ruby-live-reload"
  s.version     = RubyLiveReload::VERSION
  s.summary     = "A Ruby live server for web development"
  s.description = "Serve a web app and enable page refresh when files change"
  s.authors     = ["James Hoffman"]
  s.email       = "james@jhoffman.ca"
  s.homepage    = "https://github.com/thecodingjames/ruby-live-reload"
  s.license     = "MIT"

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  s.executables = ["ruby-live-reload", "rlr"]

  s.add_runtime_dependency "rake", "~> 13.2.0"
  s.add_runtime_dependency "minitest-reporters", "~> 1.7.1"
  s.add_runtime_dependency "sinatra", "~> 4.1.0"
  s.add_runtime_dependency "puma", "~> 6.5.0"
  s.add_runtime_dependency "rackup", "~> 2.2.0"
  s.add_runtime_dependency "filewatcher", "~> 2.0.0"
  s.add_runtime_dependency "faraday", "~> 2.12.0"
end
