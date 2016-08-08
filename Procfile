bus: disque-server
dialogI: sh -c 'cd ./tools/communication/primus && exec coffee entry.coffee'
dialogO: sh -c 'cd ./tools/communication/primus && exec coffee outgo.coffee'
static: sh -c 'cd ./tools/bundler/webpack && exec npm start'
ruby-1: sh -c 'ruby tools/consumers/ruby/entry.rb'
ruby-2: sh -c 'ruby tools/consumers/ruby/entry.rb'
ruby-3: sh -c 'ruby tools/consumers/ruby/entry.rb'
ruby-4: sh -c 'ruby tools/consumers/ruby/entry.rb'
adminer: php -S localhost:8000 -t tools/db/postgres/admin
