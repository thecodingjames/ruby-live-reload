require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!

requires = Dir.glob "../lib/**/*.rb", base: __dir__

requires.each do |lib|
  require_relative lib
end
