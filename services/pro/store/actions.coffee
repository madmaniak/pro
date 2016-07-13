global.Actions = {}

Dispatcher.on L.ns(__filename, "update"), (data) ->
  object = Store.get_ref(data.ref)
  object.v = data.v - 1
  LocalStore.update object, data.transition, data.params

Dispatcher.on L.ns(__filename, "delete"), (data) ->
  LocalStore.delete Store.get_ref(data.ref)
