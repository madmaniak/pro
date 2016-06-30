module.exports =
  add: (name, object, relations) ->
    object['id'] = L.uniqueId("tmp")
    object['type'] = name

    Dispatcher.send {
      object: L.assign {}, object
      relations: L.map(relations, L.reference)
      event: 'services/pro/store/add'
    }
    arguments

  update: (object, transition, params) ->
    Dispatcher.send {
      params
      transition
      ref: L.reference(object)
      event: 'services/pro/store/update'
      v: object.v
    }
    arguments

  delete: (object) ->
    Dispatcher.send {
      ref: L.reference(object)
      event: 'services/pro/store/delete'
    }
    arguments

# response from the server on add
Dispatcher.on 'real_id', (data) ->
  change = data.change
  # find object with tmp_id
  object = Store.get(change.collection, change.tmp_id)[0]
  object.id = change.id
  # store object with real id
  Store.collections[change.collection][change.id] = object
  Dispatcher.trigger "#{change.tmp_id}_to_id"
