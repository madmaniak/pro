require 'rubygems'
require 'bundler/setup'

require_relative 'string'
require_relative 'service'
require_relative 'disque'

require 'connection_pool'

connect_disque = ->{ Disque.new(['127.0.0.1:7711']) }
$dis = ConnectionPool.new(size: 6, timeout: 2) { connect_disque.call }
dis = connect_disque.call

module Front; end
module Front::App; end
module Front::Components; end
module Front::Services; end

service_names = Dir['../../{app,components,services}/**/*.rb'].map{ |file|
  require_relative file
  "front/#{file[6...-3]}" # rm ../../ and .rb and add front/
}

services = service_names.reduce({}){ |h, name|
  service = name.camelize.constantize.new
  h[name] = service; h
}

NAME = 0
ID = 1
PAYLOAD = 2

loop do
  if service_names.empty?
    sleep 3600
  else
    jobs = dis.que(:getjob, :from, *service_names)
    jobs.each do |job| services[job[NAME]].run(job[PAYLOAD]) end
  end
end
