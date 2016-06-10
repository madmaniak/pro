L.mixin combine: (services...) ->
  L.reduce L.union.apply(null, L.map(services, L.functions)), (object, method) ->
    object[method] = ->
      args = arguments
      L.each services, (service) ->
        service[method]?.apply(service, args)
    object
  , {}

L.mixin reference: (object) -> [object.type, object.id]

L.mixin toHash: (array) ->
  hash = hash_i = {}
  keys = L.take array, array.length - 2

  L.each keys, (key) ->
    hash_i[key] = {}
    hash_i = hash_i[key]

  pair = L.takeRight(array, 2)
  hash_i[pair[0]] = pair[1]

  hash
