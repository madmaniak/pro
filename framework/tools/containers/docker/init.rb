require 'yaml'

config = YAML.load(File.read('framework/tools/containers/docker/docker-compose.yml'))
services = Dir['**/*/docker.yml'].inject({}) { |h, c| h.merge(YAML.load(File.read(c))) }

config['services'] = services

puts "Found #{services.count} services:"
services.keys.each { |s| puts "* #{s}" }

puts "Writing docker-compose.yml..."
File.write('docker-compose.yml', config.to_yaml)

puts "Symlinking Dockerfiles..."
system 'ln -sf framework/tools/bundler/webpack/Dockerfile Dockerfile.assets'
system 'ln -sf framework/tools/consumers/ruby/Dockerfile Dockerfile.consumer'
