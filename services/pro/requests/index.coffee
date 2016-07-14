require './dialog'

global.Requests =

  counter: 0

  perform: (event, data = {}) ->
    data.event = event
    data.r     = @counter++
    Dialog.send L.omit data, 'success'
    "#{data.r}_request"

  reply: (data) ->
    Dispatcher.trigger "#{data.r}_request", data
