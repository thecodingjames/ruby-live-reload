module RubyLiveReload
  module RackApps
    class SSE

      def self.heartbeat(client)
        send client, "heartbeat"
      end

      def self.changes(client, changes)
        send client, "changes", changes.to_s
      end

      # https://blog.appsignal.com/2024/11/27/server-sent-events-and-websockets-in-rack-for-ruby.html
      def call(env)
        stream = proc do |client|
          thread = Thread.new do
            Logger.log "New client " + client.to_s
            Server.clients.add client

            loop do
              break unless SSE.heartbeat client
              sleep 3
            end
          end
        end

        headers = {
          "content-type" => "text/event-stream",
          "connection"   => "keep-alive",
        }

        [200, headers, stream]
      end

      private 

      def self.send(client, event, payload = "")
        client << <<~_
          event: #{event}
          data:  #{payload}\n
        _

        return true
      rescue
        Server.clients.delete client
        client.close

        return false
      end
    end
  end
end
