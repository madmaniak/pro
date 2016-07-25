global.LocalStore =

  add: (name, object, relations) ->
    Store.collections[name] ||= {}
    Store.collections[name][object.id] = object
    L.each relations, (relation) ->
      relation[name].add(object.id)

  update: (object, transition, params) ->
    Actions[transition](object, params)
    object.v = (object.v || 0) + 1
    @_change(object)
    render()

  delete: (object) ->
    delete Store.collections[object.type][object.id]
    @_change(object)
    render()

  patch: (collections) ->
    L.each collections, (objects, type) ->
      collection = Store.collections[type] ||= {}
      L.each objects, (object) ->
        object.type ||= type
        L.mergeWith (collection[object.id] ||= {}), object, (prev, next) ->
          if prev and L.isArray(next)
            L.each next, (n) -> prev.add(n)
            prev

  _change: (object) ->
    Dispatcher.trigger "#{object.type}_change", object.id

