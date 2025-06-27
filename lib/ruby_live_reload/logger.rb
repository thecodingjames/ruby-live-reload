module RubyLiveReload
  module Logger
    def self.log(message)
      if Server.options.verbose
        puts message
      end
    end
  end
end
