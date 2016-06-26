L.mixin combine: (base, layers...) ->
  L.reduce L.uniq(L.flatten(L.map(layers, L.functions))), (object, method) ->
    object[method] = L.pipe base, L.compact L.map( layers, method )
    object
  , base

L.mixin pipe: (context, methods) ->
  ->
    result = arguments
    L.each methods, (method) ->
      if method.length
        result = method.apply(context, result)
      else
        method.call(context)
    result

L.mixin reference: (object) -> [object.type, object.id]

L.mixin smartMerge: (object, values) ->
  L.mergeWith object, values, (old_v, new_v) ->
    L.union old_v, new_v if L.isArray(old_v)

L.mixin toHash: (array) ->
  hash = hash_i = {}
  keys = L.take array, array.length - 2

  L.each keys, (key) ->
    hash_i[key] = {}
    hash_i = hash_i[key]

  pair = L.takeRight(array, 2)
  hash_i[pair[0]] = pair[1]

  hash
