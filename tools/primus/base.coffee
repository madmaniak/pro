global.L = require('lodash')
Primus = require('primus')
disque = require('thunk-disque')
global.Disque = disque.createClient()

module.exports.createPrimus = (port) ->
  primus = Primus.createServer
    port: port
    parser: 'binary'
    compression: true
    transformer: "engine.io"
