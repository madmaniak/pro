Dialog =

  init: ->
    @primusI = Primus.connect 'http://localhost:8087'
    @primusO = Primus.connect 'http://localhost:8088'
    @pairConnections()
    @listenToData()
    @sendData()

  pairConnections: ->
    @_get_id()
    @primusO.on 'open', =>
      @primusO.write @_get_id()

  _get_id: ->
    @id || @primusI.id (id) => @id = id

  listenToData: ->
    @primusO.on 'data', (data) ->
      console.log data
      parsed = JSON.parse(data)
      Dispatcher.trigger parsed.event, parsed.data if parsed.event
      Store.patch parsed.data

  sendData: ->
    Dispatcher.send = (data) =>
      console.log data
      @primusI.write data

Dialog.init()
