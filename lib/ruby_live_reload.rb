require 'optparse'
require 'sinatra/base'
require 'filewatcher'

# https://github.com/sinatra/sinatra/blob/main/examples/chat.rb
# https://blog.appsignal.com/2024/11/27/server-sent-events-and-websockets-in-rack-for-ruby.html
# https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#sending_events_from_the_server

module RubyLiveReload

  Options = Struct.new(:host, :port, keyword_init: true)

  $args = Options.new(host: '127.0.0.1', port: 8080)

  OptionParser.new do |opts|
    opts.banner = "Usage: bsync.rb [options]"

    opts.on("-h HOST", "--host HOST", "Hostname") do |host|
      $args.host = host
    end
  end.parse!

  class Server < Sinatra::Base

    set :bind, $args.host
    set :server_settings, { max_threads: 64, quiet: true }

    set :clients, Set.new
    
    on_start do
      puts "===== Started watching file changes ====="

      Thread.new do
        @filewatcher = Filewatcher.new File.join(Dir.pwd, "**", "*.*")

        @filewatcher.watch do |changes| 
          settings.clients.each do |client|
            client << "data: " + changes.to_s + "\n\n"
          rescue 
            client.close
          end
        end
      end
    end

    get '/ruby-live-reload-sse', provides: 'text/event-stream' do
      stream :keep_open do |client|
        if settings.clients.add? client
          client.callback do
            settings.clients.delete client
          end
        end

        sleep 5
      rescue
        settings.clients.delete client
        client.close
      end
    end

    get '*' do
      path = File.join(Dir.pwd, params['splat'])
      is_asset = !(["html", "htm", "xhtml"].include? File.extname(path))

      if File.file?(path) && is_asset
        send_file path
      end

      response = if File.file? File.join(path, "index.html")
        content_type :html

        File.read File.join(path, "index.html")
      else 
        children = Dir.glob("*", base: path).sort_by { |s| [File.directory?(s).to_s, s.downcase] }
        links = children.map do |child| 
          <<-LI
            <li>
              <a href='#{child}'>
                #{child + (File.directory?(child) ? '/' : '')}
              </a>
            </li>
          LI
        end.join

        content_type :html

        <<-LISTING
          <!DOCTYPE html>
          <html lang="en">
          <head>
            <meta charset="UTF-8">
            <title>RLR Directory Listing</title>
          </head>
          <body>
            <h1>Ruby Live Reload</h1>

            <p>#{path}</p>
            <ul>
                #{links}
            </ul>
          </body>
          </html>
        LISTING
      end
      
      client_js = <<-JS
        <script>
          const source = new EventSource("/ruby-live-reload-sse")

          source.onmessage = (m) => {
            location.reload()
          }

          source.onerror = (m) => {
            console.group('Ruby Live Reload')
              console.error(m)
            console.groupEnd()
          }
        </script>
      JS

      response.sub /<body>/, "<body>#{client_js}"
    end

    run!
  end

end
