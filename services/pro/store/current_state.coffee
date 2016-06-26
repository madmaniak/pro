module.exports =
  add: (name, object, relations) ->
    [ name, object, L.map relations, (rel) -> Store.get_current(rel) ]

  update: (object, transition, params) ->
    [ @get_current(object), transition, params ]
