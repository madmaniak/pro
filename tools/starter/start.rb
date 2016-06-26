require_relative 'configs_to_env'

require_relative '../postgres/db'
require_relative 'create_db'
require_relative 'load_models'
require_relative 'update_tables'
require_relative 'update_actions'

if ARGV.include? 'c'
  require_relative '../ruby/console'
else
  exec 'foreman start'
end
