require 'connection_pool'

require_relative '../postgres/db'
require_relative '../starter/helpers/load_models'
require_relative '../starter/helpers/paths_resolver'
require_relative 'monkey_patches'
require_relative 'service'
require_relative 'getter'
require_relative 'disque'

connect_disque = ->{ Disque.new(["#{ENV['disque_host']}:#{ENV['disque_port']}"]) }
$dis = ConnectionPool.new(size: 8, timeout: 2) { connect_disque.call }
dis = connect_disque.call

module Front; end
module Front::App; end
module Front::Components; end
module Front::Services; end

service_names = \
  PathsResolver.resolve(:rb, blacklist: [:model], sort: :leafs_first).map{ |file|
    require "./#{file}"
    "front/#{file[0...-3]}" # rm .rb and add front/
  }

PathsResolver.free

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
