Primus = require('../../tools/communication/primus/primus')

global.Dialog =

  init: ->
    url = "#{location.protocol}//#{location.hostname}"
    @primusI = Primus.connect "#{url}:8090"
    @primusO = Primus.connect "#{url}:8091"
    @pair_connections()
    @listen_to_data()

  pair_connections: ->
    @primusI.on 'open', =>
      @primusI.id (id) =>
        @primusO.write id
        render()

  listen_to_data: ->
    @primusO.on 'data', (data) ->
      return if /primus::ping/.exec(data)
      console.log data
      Requests.receive data

  send: (data) ->
    console.log data
    @primusI.write data

Dialog.init()
