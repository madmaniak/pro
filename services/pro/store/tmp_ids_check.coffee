H =
  all: (objects, action, args) ->
    L.wait_for_real_id objects, -> action.apply(null, args)

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
