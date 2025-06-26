module RubyLiveReload
  class Server
    def self.run!(options)
      puts <<~_
        Ruby Live Reload running with #{options.threads} threads!
        Watching #{options.directory}

        http://#{options.bind}:#{options.port}

        Ctrl-c to stop
      _

    # set :clients, Set.new
    # 
    # on_start do
      # puts "===== Started watching file changes ====="
# 
      # @filewatcher_thread = Thread.new do
        # @filewatcher = Filewatcher.new File.join(settings.directory, "**", "*.*")
# 
        # @filewatcher.watch do |changes| 
          # settings.clients.each do |client|
            # client << "data: " + changes.to_s + "\n\n"
          # rescue 
            # client.close
            # settings.clients.delete client
          # end
        # end
# 
        # settings.clients.each do |client|
          # client.close
        # end
# 
        # rescue
          # exit # Watcher thread crash
      # end
    # end
# 
    # on_stop do
      # @filewatcher&.stop()
      # @filewatcher_thread&.join
    # end

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
        Silent: false, 
        Host: options.bind,
        Port: options.port,
        max_threads: options.threads
      )
    end

  end
end
