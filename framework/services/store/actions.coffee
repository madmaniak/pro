global.Actions = {}

Dispatcher.on L.ns(__dirname, "update"), (data) ->
  if object = Store.get_ref(data.ref)
    object.v = data.v - 1
    LocalStore.update object, data.transition, data.params

Dispatcher.on L.ns(__dirname, "delete"), (data) ->
  LocalStore.delete object if object = Store.get_ref(data.ref)
