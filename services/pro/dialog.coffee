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
      parsed_data = JSON.parse(data).data
      if parsed_data.event
        Dispatcher.trigger parsed_data.event, parsed_data
      else
        Store.patch parsed_data

  sendData: ->
    Dispatcher.send = (data) =>
      console.log data
      @primusI.write data

Dialog.init()
