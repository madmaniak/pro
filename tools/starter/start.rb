require 'bundler/setup'
require_relative 'configs_to_env'

require_relative '../postgres/db'
require_relative 'create_db'
require_relative 'update_tables'
require_relative 'update_actions'

require_relative 'frontend_init'

if ARGV.include? 'c'
  require_relative '../ruby/helpers/monkey_patches'
  require_relative '../ruby/helpers/load_services'
  require_relative '../ruby/console'
else
  exec 'foreman start'
end
