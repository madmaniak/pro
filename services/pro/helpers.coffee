L.mixin combine: (base, layers...) ->
  L.reduce L.uniq(L.flatten(L.map(layers, L.functions))), (object, method) ->
    object[method] = L.pipe base, L.compact L.map( layers, method )
    object
  , base

# namespacer
L.mixin ns: (path, action) ->
  "#{path.split('/')[2...-1].join('/')}/#{action}"

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
