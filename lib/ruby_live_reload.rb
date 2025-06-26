require "optparse"

require "puma"
require "rack/handler/puma"
require "rack"

require "filewatcher"
require "faraday"


requires = Dir.glob "ruby_live_reload/**/*.rb", base: __dir__

requires.each do |lib|
  require_relative lib
end


module RubyLiveReload

  def self.run(argv = "")
    options = Options.parse(argv)

    if message = options.message
      print message
    else 
      Server.run! options
    end
  end

end

RubyLiveReload.run ARGV
