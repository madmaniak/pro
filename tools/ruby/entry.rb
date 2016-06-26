require 'rubygems'
require 'bundler/setup'
require 'connection_pool'

require_relative 'string'
require_relative 'service'
require_relative 'disque'

require_relative 'custom'


connect_disque = ->{ Disque.new(["#{ENV['disque_host']}:#{ENV['disque_port']}"]) }
$dis = ConnectionPool.new(size: 8, timeout: 2) { connect_disque.call }
dis = connect_disque.call

module Front; end
module Front::App; end
module Front::Components; end
module Front::Services; end

DONT_LOAD_REGEXP = /migration/

service_names = Dir['../../{app,components,services}/**/*.rb'].map{ |file|
  unless file =~ DONT_LOAD_REGEXP
    require_relative file
    "front/#{file[6...-3]}" # rm ../../ and .rb and add front/
  end
}.compact

services = service_names.reduce({}){ |h, name|
  service = name.camelize.constantize.new
  h[name] = service; h
}

Dir['../../{app,components,services}/**/migration'].map{ |migration|
  require_relative migration
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
