module RubyLiveReload
  module Server

    def self.options
      @options
    end

    def self.clients
      @clients
    end

    def self.run!(options)
      @options = options
      @clients = Set.new

      puts <<~_
        Ruby Live Reload running with #{@options.threads} threads!
        Watching #{@options.directory}

        http://#{@options.bind}:#{@options.port}

        Ctrl-c to stop
      _

      #
      # Filewatcher setup
      #
      filewatcher = nil
      filewatcher_thread = Thread.new do
        filewatcher = Filewatcher.new File.join(@options.directory, "**", "*.*")

        filewatcher.watch do |changes| 
          @clients.each do |client|
            p "sent to " + client.to_s
            RackApps::SSE.changes client, changes
          end
        end
      rescue Exception => e
        p e
        filewatcher.stop
      end

      #
      # Rack setup
      #

      app = Rack::Builder.new do
         
        map "/favicon.ico" do
          run RackApps::Favicon.new
        end

        map "/ruby-live-reload-sse" do
          run RackApps::SSE.new
        end

        run RackApps::Main.new
      end

      Rack::Handler::Puma.run(
        app, 
        Silent: true, 
        Host: @options.bind,
        Port: @options.port,
        max_threads: @options.threads
      )

      #
      # Clean up
      #
      filewatcher&.stop()
      filewatcher_thread&.join

      @clients.each do |client|
        client.close
      end

      puts "Stopped!"
    end

  end
end
