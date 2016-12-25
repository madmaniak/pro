bus: disque-server
dialogI: sh -c 'cd framework/tools/communication/primus && exec coffee entry.coffee'
dialogO: sh -c 'cd framework/tools/communication/primus && exec coffee outgo.coffee'
assets: sh -c 'cd framework/tools/bundler/webpack && exec npm run webpack-server'
static: sh -c 'cd framework/tools/static/lighttpd && exec lighttpd -D -f lightppd.conf'
ruby-1: sh -c 'ruby framework/tools/consumers/ruby/entry.rb'
ruby-2: sh -c 'ruby framework/tools/consumers/ruby/entry.rb'
ruby-3: sh -c 'ruby framework/tools/consumers/ruby/entry.rb'
ruby-4: sh -c 'ruby framework/tools/consumers/ruby/entry.rb'
adminer: php -S 0.0.0.0:8000 -t framework/tools/db/postgres/admin
