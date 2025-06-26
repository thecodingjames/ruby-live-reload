module RubyLiveReload
  module RackApps

    # Avoid 404 if favicon is missing
    class Favicon < RackApps::Base

      def call(env)
        # path = File.join(settings.directory, "favicon.ico")

        # if File.exist? path
          # send_file path
        # end

        [204, {}, []]
      end

    end

  end
end
