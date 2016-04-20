global.Dispatcher = require("backbone-events-standalone")

primusI = Primus.connect 'http://localhost:8087'
primusO = Primus.connect 'http://localhost:8088'
primusO.on 'open', ->
  primusI.id (id) -> primusO.write(id)

Dispatcher.send = (data) -> primusI.write data
primusO.on 'data', (data) -> Dispatcher.trigger data.event, data; console.log data
