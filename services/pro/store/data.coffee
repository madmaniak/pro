global.Data =
  collections: {}

  add: (name, object, relations) ->
    L.each relations, (relation) ->
      relation[name] ||= []
      relation[name].push object.id
    @patch L.toHash [name, object.id, object]

  get: (name, ids) ->
    return [] unless name
    L.at @collections[name], ids

  update: (object, transition, params) ->
    Actions[transition](object, params)

  delete: (object) ->
    delete @collections[object.type][object.id]

  patch: (collections) ->
    L.merge @collections, collections
