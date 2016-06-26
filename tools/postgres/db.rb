require 'sequel'

Sequel.extension(:pg_json)
Sequel.extension(:pg_json_ops)

db_link = \
  "#{ENV['pg_user']}:#{ENV['pg_pass']}@#{ENV['pg_host']}:#{ENV['pg_port']}/#{ENV['app']}"

$db = Sequel.connect "postgres://#{db_link}"
