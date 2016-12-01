require './dialog'
require './cache'
require './collection'

global.Requests =

  counter: 1

  perform: (event, params = {}) ->
    params.event = event
    params.r     = @counter++
    Dialog.send params
    "#{params.r}_request"

  receive: (data) ->
    parsed = JSON.parse(data)
    parsed.raw = data
    Store.patch parsed.data if parsed.data
    Dispatcher.trigger parsed.event, parsed           if parsed.event
    Dispatcher.trigger("#{parsed.r}_request", parsed) if parsed.r
    render()
    parsed
