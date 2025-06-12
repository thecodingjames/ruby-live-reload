module RubyLiveReload
  class Options
    attr_reader :host, :port, :directory, :proxy

    def initialize
      @host = "127.0.0.1"
      @port = 8080
      @directory = Dir.pwd
    end

    def self.parse(args)
      options = Options.new

      OptionParser.new do |opts|
        opts.banner = "Usage: rlr [options]"

        opts.on("-h HOST", "--host HOST", "Hostname") do |host|
          options.host = host
        end

        opts.on("-p PORT", "--port PORT", "Port") do |port|
          options.port = port
        end

        opts.on("--proxy URL", "Url of the proxied app") do |proxy|
          options.proxy = proxy
        end

        opts.on("-d PATH", "--directory PATH", "Path") do |path|
          directory = File.join(Dir.pwd, path) unless path.start_with?("/")
          # TODO Validate path is a directory

          options.directory = directory
        end

        opts.on("-v", "--version", "Version") do
          puts RubyLiveReload::VERSION
          exit
        end
      end.parse!(args)

      return options
    end
  end

end
