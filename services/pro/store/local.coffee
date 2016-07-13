global.LocalStore =

  add: (name, object, relations) ->
    L.each relations, (relation) ->
      relation[name] ||= []
      relation[name].push object.id
    Store.collections[name] ||= {}
    Store.collections[name][object.id] = object
    render()

  update: (object, transition, params) ->
    Actions[transition](object, params)
    object.v = (object.v || 0) + 1
    render()

  delete: (object) ->
    delete Store.collections[object.type][object.id]
    render()

  patch: (collections) ->
    hashed_collections = # index by 'id' and add redundant 'type' to each object
      L.reduce collections, (hash, objects, type) ->
        hash[type] = collection = L.groupBy objects, 'id'
        L.each collection, (objects, id) ->
          collection[id] = L.reduce objects, (h, object) ->
            object.type ||= type
            L.smartMerge object, h
          , {}
        hash
      , {}

    L.smartMerge Store.collections, hashed_collections
    render()
