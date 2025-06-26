require "minitest/test_task"

# Use same context as gemspec
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

# Call a task with the standard CLI args
# Ex: rake run -- -p 9090 -b 0.0.0.0
ARGV.slice!(0, 2)

Minitest::TestTask.create do |t|
  t.framework = %(require_relative "test/test_helper.rb")
end

task :run do
  require "ruby_live_reload"
end

task :rlr do
  load File.expand_path("../bin/rlr", __FILE__)
end

task :install do
  output = "ruby-live-reload"

  sh "gem build --output #{output}.gem"
  sh "gem install #{output}.gem"
end

