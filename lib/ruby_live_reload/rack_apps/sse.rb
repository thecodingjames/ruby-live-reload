module RubyLiveReload
  module RackApps
    class SSE

      # https://blog.appsignal.com/2024/11/27/server-sent-events-and-websockets-in-rack-for-ruby.html
      def call(env)
        # get "/ruby-live-reload-sse", provides: "text/event-stream" do
          # stream :keep_open do |client|
            # if settings.clients.add? client
              # client.callback do # on connection closed
                # settings.clients.delete client
              # end
            # end
    # 
            # # Throttle Sinatra scheduler since Filewatcher is used to trigger SSE
            # sleep 1
    # 
            # # Heartbeat will detect disconnected client and free the thread
            # client << "event: heartbeat\n"
          # rescue
            # settings.clients.delete client
            # client.close
          # end
        # end
        [200, {'content-type' => 'text/plain'}, ['SSE']]
      end
    end
  end
end
