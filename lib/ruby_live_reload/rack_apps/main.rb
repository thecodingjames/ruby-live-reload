module RubyLiveReload
  module RackApps

    class Main
      def call(env)
        [200, {'content-type' => 'text/plain'}, ['RLR works!']]
      end
    end

  end
end

    # get "*" do
      # headers \
        # "Cache-Control" => "max-age=0, no-cache, no-store, must-revalidate",
        # "Expires"=> "Thu, 01 Jan 1970 00:00:00 GMT",
        # "Pragma" => "no-cache"
# 
      # splat = File.join params["splat"]
      # path = File.join(settings.directory, splat)
      # is_asset = !([".html", ".htm", ".xhtml"].include? File.extname(path))
# 
      # if File.directory?(path) && !path.end_with?("/")
        # # Add / to the end of URL so browser correctly handles relative paths
        # redirect "#{splat}/"
      # elsif File.file?(path) && is_asset
        # send_file path
      # end
# 
      # response = if settings.proxy
        # # TODO Handle response other than HTML
        # #      --wrap to enclose arbitrary text within HTML to allow snippet injection?
        # #      What about arbitrary files? Images, CSS, etc?
        # Faraday.get(File.join(settings.proxy + splat)).body
      # elsif File.file? path
        # File.read path
      # elsif File.file? File.join(path, "index.html")
        # File.read File.join(path, "index.html")
      # elsif File.directory?(path) && !response
        # children = Dir.glob("*", base: path).sort_by { |s| [File.directory?(s).to_s, s.downcase] }
        # links = children.map do |child| 
          # <<-LI
            # <li>
              # <a href="#{child}">
                # #{child + (File.directory?(child) ? "/" : "")}
              # </a>
            # </li>
          # LI
        # end.join
# 
        # <<-LISTING
          # <!DOCTYPE html>
          # <html lang="en">
          # <head>
            # <meta charset="UTF-8">
            # <title>RLR Directory Listing</title>
          # </head>
          # <body>
            # <h1>Ruby Live Reload</h1>
# 
            # <p>#{path}</p>
            # <ul>
                # #{links}
            # </ul>
          # </body>
          # </html>
        # LISTING
      # elsif !response
        # status 404
# 
        # <<-NOT_FOUND
          # <!DOCTYPE html>
          # <html lang="en">
          # <head>
            # <meta charset="UTF-8">
            # <title></title>
          # </head>
          # <body>
            # <h1>File Not Found</h1>
# 
            # <p>#{path}</p>
          # </body>
          # </html>
        # NOT_FOUND
      # end
# 
      # client_js = <<-JS
        # <script>
            # const source = new EventSource('/ruby-live-reload-sse')
# 
            # source.onmessage = (m) => {
              # location.reload()
            # }
# 
            # source.onerror = (m) => {
              # console.group('Ruby Live Reload')
                # console.warn('Cannot reach server, reconnecting...')
              # console.groupEnd()
            # }
# 
            # addEventListener("beforeunload", (event) => {
              # source.close()
# 
              # return false // Do not show confirm dialog
            # })
        # </script>
      # JS
# 
      # if response.sub!(/<body>/, "<body>#{client_js}")
        # content_type :html
      # end
# 
      # response
    # end
# 
  # end
