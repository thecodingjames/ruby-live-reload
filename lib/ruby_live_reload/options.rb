module RubyLiveReload
  class Options

    private

    attr_writer :host, :port, :directory, :proxy, :message

    def initialize
      @host = "127.0.0.1"
      @port = 8080
      @directory = Dir.pwd
      @proxy = nil
      @message = nil
    end

    public 

    attr_reader :host, :port, :directory, :proxy, :message

    def self.parse(args)

      unless [String, Array].include? args.class 
        raise <<~ERROR.strip
          Provide an array or a space-separated string of arguments: ["-p", 9090, "--host", "198.168.0.42"] or "-p 9090 --host 192.168.0.42"
        ERROR
      end

      args = args.split " " if args.is_a? String

      instance = Options.new

      OptionParser.new do |options|
        options.banner = "Usage: rlr [instance]"
        options.release = VERSION

        options.on("-b HOST", "--bind HOST", "Hostname") do |host|
          instance.send :host=, host
        end

        options.on("-p PORT", "--port PORT", "Port") do |port|
          instance.send :port=, port
        end

        options.on("--proxy URL", "Url of the proxied app") do |proxy|
          instance.send :proxy=,  proxy
        end

        options.on("-d PATH", "--directory PATH", "Path") do |path|
          directory = if path.start_with?("/")
            path
          else
            File.join(Dir.pwd, path)
          end

          # TODO Validate path is a directory

          instance.send :directory=, directory
        end

        options.on("-v", "--version", "Version") do
          instance.send :message=, VERSION
        end

      end.parse(args)

      return instance
    end
  end

end
