require "bundler/inline"

gemfile do
    source "http://rubygems.org"

    gem "sinatra-contrib"
    gem "rackup"
    gem "puma"
end

require "sinatra/base"
require "sinatra/reloader"

class MySinatraApp < Sinatra::Base

    set :port, 8888

    configure :development do
        # You should use some kind of reloader 
        # so the app runs up-to-date code on refresh
        register Sinatra::Reloader
    end

    get "/" do
      # Make sure to return valid HTML
      # to allow the reload script snippet injection
      <<-HTML
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <title></title>
        </head>
        <body>
          Hello from Sinatra!
        </body>
        </html>
      HTML
    end

    run! if app_file == $0
end
