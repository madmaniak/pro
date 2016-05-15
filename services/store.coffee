global.Store =

  collections: {}

  get: (scope) ->
    return [] if L.isEmpty(scope)
    data = @_parseScope(scope)
    L.at @collections[data.name], data.value

  update: (collections) ->
    L.mergeWithArrays @collections, collections
    render()

  delete: (scope) ->
    data = @_parseScope(scope)
    delete @collections[data.name][data.value]
    render()

  add: (scope) ->
    data = @_parseScope(scope)
    tmp_id = L.uniqueId("tmp")
    data.value['id'] = tmp_id
    data.value['type'] = data.name

    @update L.toHash [data.name, tmp_id, data.value]

  _parseScope: (scope) ->
    name = L.keys(scope)[0]
    value = scope[name]
    { name, value }

