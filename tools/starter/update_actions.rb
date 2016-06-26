Dir['{app,components,services}/**/*/action.coffee'].each do |action|
  name = action[0...-14].gsub('/', '_')
  puts "Adding #{name} function to database"
  body = IO.read(action).split("\n")[1..-1].join("\n")
  $db.run %{
    CREATE OR REPLACE FUNCTION #{name}(ref json, params json)
    RETURNS jsonb AS $$
  object = plv8.execute('SELECT data FROM ' + ref[0] + ' WHERE id = ' + ref[1])[0]['data']
#{body}
  return object
    $$ LANGUAGE plcoffee IMMUTABLE STRICT;
  }
end
