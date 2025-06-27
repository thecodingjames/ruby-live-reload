module RubyLiveReload
  module RackApps

    # Avoid 404 if favicon is missing
    class Favicon

      def call(env)
        request = Rack::Request.new(env)
        # path = File.join(settings.directory, "favicon.ico")

        # if File.exist? path
          # send_file path
        # end

        [204, {}, []]
      end

    end

  end
end
