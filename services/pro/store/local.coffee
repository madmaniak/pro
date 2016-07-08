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

    L.smartMerge @collections, hashed_collections
