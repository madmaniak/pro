path = '../../../../app/'

$stdout.puts 'server.document-root = "' +
  if File.exist? "#{path}/index.html"
    path
  else
    path[3..-1] # one directory closer (in framework)
  end + '"'
