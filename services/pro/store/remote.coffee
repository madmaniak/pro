module.exports.Remote =
  add: (name, object, relations) ->
    tmp_id = L.uniqueId("tmp")
    object['id'] = tmp_id
    object['type'] = name

    Dispatcher.send {
      object
      relations: L.map(relations, L.reference)
      event: 'services/pro/store/add'
    }

  update: (object, transition, params) ->
    Dispatcher.send {
      params
      transition
      ref: L.reference(object)
      event: 'services/pro/store/update'
      version: object.version
    }

  delete: (object) ->
    Dispatcher.send {
      ref: L.reference(object)
      event: 'services/pro/store/delete'
    }
