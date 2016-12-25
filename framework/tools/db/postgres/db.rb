require 'logger'
require 'sequel'
require 'sequel-seek-pagination'

Sequel.extension(:pg_json)
Sequel.extension(:pg_json_ops)
Sequel::Database.extension(:seek_pagination)

db_link = \
  "#{ENV['pg_user']}:#{ENV['pg_pass']}@#{ENV['pg_host']}:#{ENV['pg_port']}/#{ENV['pg_db']}"

$db = Sequel.connect "postgres://#{db_link}"
$db.loggers << Logger.new($stdout)
$db.extension(:pg_streaming)
$db.stream_all_queries = true
