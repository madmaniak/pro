require 'connection_pool'
require 'disque'

require_relative '../postgres/db'
require_relative 'helpers/monkey_patches'
require_relative 'helpers/load_models'
require_relative 'helpers/load_services'

connect_disque = ->{ Disque.new(["#{ENV['disque_host']}:#{ENV['disque_port']}"]) }
$dis = ConnectionPool.new(size: 8, timeout: 2) { connect_disque.call }
dis = connect_disque.call

services = $services.reduce({}){ |h, (name, service)|
  h[name] = service.new; h
}

NAME = 0
ID = 1
PAYLOAD = 2

loop do
  jobs = dis.que(:getjob, :from, *$services.keys)
  jobs.each do |job| services[job[NAME]].run(job[PAYLOAD]) end
end
