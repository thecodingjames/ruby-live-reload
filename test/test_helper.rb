require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!

requires = Dir.glob "lib/ruby_live_reload/**/*", base: Dir.pwd

requires.each do |lib|
  require lib
end

class Minitest::Test
  include RubyLiveReload
end
