require "optparse"
require "sinatra/base"
require "filewatcher"
require "faraday"

# https://blog.appsignal.com/2024/11/27/server-sent-events-and-websockets-in-rack-for-ruby.html

module RubyLiveReload
  Options = Struct.new(:host, :port, :directory, :proxy, keyword_init: true)

  $args = Options.new(host: "127.0.0.1", port: 8080, directory: Dir.pwd)

  OptionParser.new do |opts|
    opts.banner = "Usage: rlr [options]"

    opts.on("-h HOST", "--host HOST", "Hostname") do |host|
      $args.host = host
    end

    opts.on("-p PORT", "--port PORT", "Port") do |port|
      $args.port = port
    end

    opts.on("--proxy URL", "Url of the proxied app") do |proxy|
      $args.proxy = proxy
    end

    opts.on("-d PATH", "--directory PATH", "Path") do |path|
      directory = File.join(Dir.pwd, path) unless path.start_with?("/")
      # TODO Validate path is a directory

      $args.directory = directory
    end
  end.parse!

  class Server < Sinatra::Base

    set :bind, $args.host
    set :port, $args.port
    set :server_settings, { max_threads: 64, quiet: true }

    set :clients, Set.new
    
    on_start do
      puts "===== Started watching file changes ====="

      @filewatcher_thread = Thread.new do
        @filewatcher = Filewatcher.new File.join($args.directory, "**", "*.*")

        @filewatcher.watch do |changes| 
          settings.clients.each do |client|
            client << "data: " + changes.to_s + "\n\n"
          rescue 
            client.close
            settings.clients.delete client
          end
        end

        settings.clients.each do |client|
          client.close
        end

        rescue
          exit # Watcher thread crash
      end
    end

    on_stop do
      @filewatcher&.stop()
      @filewatcher_thread.join
    end

    get "/ruby-live-reload-sse", provides: "text/event-stream" do
      stream :keep_open do |client|
        if settings.clients.add? client
          client.callback do
            settings.clients.delete client
          end
        end

        # Throttle Sinatra scheduler since Filewatcher is used to trigger SSE
        sleep 5
      rescue
        settings.clients.delete client
        client.close
      end
    end

    # Tweak to remove 404 if favicon is missing
    get "/favicon.ico" do
      path = File.join($args.directory, "favicon.ico")

      if File.exists? path
        send_file path
      end

      204
    end

    get "*" do
      headers \
        "Cache-Control" => "max-age=0, no-cache, no-store, must-revalidate",
        "Expires"=> "Thu, 01 Jan 1970 00:00:00 GMT",
        "Pragma" => "no-cache"

      splat = File.join params["splat"]
      path = File.join($args.directory, splat)
      is_asset = !([".html", ".htm", ".xhtml"].include? File.extname(path))

      if File.directory?(path) && !path.end_with?("/")
        # Add / to the end of URL so browser correctly handles relative paths
        redirect "#{splat}/"
      elsif File.file?(path) && is_asset
        send_file path
      end

      response = if $args.proxy
        # TODO Handle response other than HTML
        #      --wrap to enclose arbitrary text within HTML to allow snippet injection?
        #      What about arbitrary files? Images, CSS, etc?
        Faraday.get(File.join($args.proxy + splat)).body
      elsif File.file? path
        File.read path
      elsif File.file? File.join(path, "index.html")
        File.read File.join(path, "index.html")
      elsif File.directory?(path) && !response
        children = Dir.glob("*", base: path).sort_by { |s| [File.directory?(s).to_s, s.downcase] }
        links = children.map do |child| 
          <<-LI
            <li>
              <a href="#{child}">
                #{child + (File.directory?(child) ? "/" : "")}
              </a>
            </li>
          LI
        end.join

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
      elsif !response
        status 404

        <<-NOT_FOUND
          <!DOCTYPE html>
          <html lang="en">
          <head>
            <meta charset="UTF-8">
            <title></title>
          </head>
          <body>
            <h1>File Not Found</h1>

            <p>#{path}</p>
          </body>
          </html>
        NOT_FOUND
      end

      client_js = <<-JS
        <script>
            const source = new EventSource('/ruby-live-reload-sse')

            source.onmessage = (m) => {
              location.reload()
            }

            source.onerror = (m) => {
              console.group('Ruby Live Reload')
                console.warn('Cannot reach server, reconnecting...')
              console.groupEnd()
            }

            addEventListener("beforeunload", (event) => {
              source.close()

              return false // Do not show confirm dialog
            })
        </script>
      JS

      if response.sub!(/<body>/, "<body>#{client_js}")
        content_type :html
      end

      response
    end

    run!
  end

end
