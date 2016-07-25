module.exports =
  add: (name, object, relations) ->
    object['id'] = L.uniqueId("tmp")
    object['type'] = name

    Dispatcher.once Requests.perform(L.ns(__dirname, 'add'),
      object: L.assign {}, object
      relations: L.map(relations, L.reference)
    ), (data) ->
      change = data.change
      # find object with tmp_id
      object = Store.get(change.collection, change.tmp_id)[0]
      old_id = object.id
      object.id = change.id
      # store object with real id
      Store.collections[change.collection][change.id] = object
      delete Store.collections[change.collection][change.tmp_id]
      Dispatcher.trigger "#{change.tmp_id}_to_id", old_id, object.id
    arguments

  update: (object, transition, params) ->
    Requests.perform L.ns(__dirname, 'update'), {
      params
      transition
      ref: L.reference(object)
      v: object.v
    }
    arguments

  delete: (object) ->
    Requests.perform L.ns(__dirname, 'delete'), ref: L.reference(object)
    arguments
