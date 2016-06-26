global.Actions = {}

Dispatcher.on "services/pro/store/update", (data) ->
  Actions[data.transition](Store.get_ref(data.ref), data.params)
  render()
