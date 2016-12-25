global.Dialog =

  init: ->
    @primusI = Primus.connect 'http://localhost:8090'
    @primusO = Primus.connect 'http://localhost:8091'
    @pair_connections()
    @listen_to_data()

  pair_connections: ->
    @primusI.on 'open', =>
      @primusI.id (id) =>
        @primusO.write id
        render()

  listen_to_data: ->
    @primusO.on 'data', (data) ->
      console.log data
      Requests.receive data

  send: (data) ->
    console.log data
    @primusI.write data

Dialog.init()
