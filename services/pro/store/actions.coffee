global.Actions = {}

Dispatcher.on "services/pro/store/update", (data) ->
  Actions[data.transition](o = Store.get_ref(data.ref), data.params)
  o.v = data.v
  render()
