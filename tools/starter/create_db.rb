begin
  $db.test_connection
rescue Sequel::DatabaseConnectionError => e
  if e.message =~ /database .* does not exist/
    ENV['PGPASSWORD'] = ENV['pg_pass']
    created = system "createdb -h #{ENV['pg_host']} -p #{ENV['pg_port']} -U #{ENV['pg_user']} -E UTF8 -T template0 #{ENV['app']}"
    if created
      puts "Database #{ENV['app']} created."
      $db.run("CREATE EXTENSION plv8; CREATE EXTENSION plcoffee;")
      puts "plv8 extensions added to the database."
    else
      abort "There is no #{ENV['app']} database and it can't be created."
    end
  else
    abort e.message
  end
end
