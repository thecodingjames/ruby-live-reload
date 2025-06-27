module RubyLiveReload
  class Options

    private

    attr_writer :bind, :port, :directory, :threads, :proxy, :message, :verbose

    def initialize
      @bind = "127.0.0.1"
      @port = 8080
      @directory = Dir.pwd
      @threads = 16
      @proxy = nil
      @message = nil
      @verbose = false
    end

    public 

    attr_reader :bind, :port, :directory, :threads, :proxy, :message, :verbose

    def self.parse(args)

      unless [String, Array].include? args.class 
        raise <<~ERROR.strip
          Provide an array or a space-separated string of arguments: ["-p", 9090, "--bind", "198.168.0.42"] or "-p 9090 --bind 192.168.0.42"
        ERROR
      end

      args = args.split " " if args.is_a? String

      instance = Options.new

      parser = OptionParser.new do |options|
        options.banner = "Usage: rlr [instance]"
        options.release = VERSION

        options.on("-b HOST", "--bind HOST", "Hostname") do |bind|
          instance.send :bind=, bind
        end

        options.on("-p PORT", "--port PORT", "Port") do |port|
          instance.send :port=, port
        end

        options.on("-t THREADS", "--threads THREADS", "Threads") do |threads|
          instance.send :threads=, threads
        end

        options.on("--proxy URL", "Url of the proxied app") do |proxy|
          instance.send :proxy=,  proxy
        end

        options.on("-d PATH", "--directory PATH", "Path") do |path|
          directory = File.join(Dir.pwd, path) unless path.start_with?("/")
          # TODO Validate path is a directory

          instance.send :directory=, directory
        end

        options.on("-v", "--version", "Version") do
          instance.send :message=, VERSION
        end

        options.on("--verbose", "Show verbose output to console") do
          instance.send :verbose=, true
        end

      end

      begin
        parser.parse(args)
      rescue OptionParser::ParseError => e
        instance.send :message=, <<~_
          #{e.message}

          #{parser.to_s}
        _
      end

      return instance
    end
  end

end
