H =
  tmp_id: (object) -> /tmp/.exec object.id

  wait_for_real_id: (objects, action) ->
    !if object = L.find objects, H.tmp_id
      Dispatcher.once "#{object.id}_to_id", action

  all: (object, action, args) ->
    H.wait_for_real_id object, -> action.apply(null, args)

module.exports =
  add: (name, object, relations) ->
    if H.all relations, @add, arguments
      arguments
    else false

  update: (object) ->
    if H.all [object], @update, arguments
      arguments
    else false

  delete: (object) ->
    if H.all [object], @delete, arguments
      arguments
    else false
