require 'bundler/setup'
require_relative 'configs_to_env'

require_relative '../db/postgres/db'
require_relative 'create_db'
require_relative 'update_tables'
require_relative 'update_actions'

require_relative '../consumers/ruby/helpers/monkey_patches'
require_relative '../consumers/ruby/helpers/load_services'

if ARGV.include? 'c'
  require_relative '../consumers/ruby/console'
else
  require_relative 'frontend_init'
  exec 'foreman start'
end
