module.exports =

  add: (name, object, relations) ->
    L.each relations, (relation) ->
      relation[name] ||= []
      relation[name].push object.id
    @collections[name] ||= {}
    @collections[name][object.id] = object

  update: (object, transition, params) ->
    Actions[transition](object, params)

  delete: (object) ->
    delete @collections[object.type][object.id]

  patch: (collections) ->
    L.smartMerge @collections, collections
