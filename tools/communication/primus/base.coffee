global.L = require('lodash')
Primus = require('primus')
disque = require('thunk-disque')
global.Disque = disque.createClient(["#{process.env.disque_host}:#{process.env.disque_port}"])

module.exports.createPrimus = (port) ->
  primus = Primus.createServer
    port: port
    parser: 'binary'
    compression: true
    transformer: "uws"
