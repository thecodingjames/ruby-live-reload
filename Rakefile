task :run do
  ruby "lib/ruby_live_reload.rb"
end

task :rlr do
  sh "bin/rlr"
end

task :install do
  output = "ruby-live-reload"

  sh "gem build --output #{output}.gem"
  sh "gem install #{output}.gem"
end

