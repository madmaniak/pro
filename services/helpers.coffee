L.mixin toHash: (array) ->
  hash = hash_i = {}
  keys = L.take array, array.length - 2

  L.each keys, (key) ->
    hash_i[key] = {}
    hash_i = hash_i[key]

  pair = L.takeRight(array, 2)
  hash_i[pair[0]] = pair[1]

  hash

L.mixin mergeWithArrays: (object, values) ->
  L.mergeWith object, values, (old_v, new_v) ->
    old_v.concat(new_v) if L.isArray(old_v)
