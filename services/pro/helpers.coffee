L.mixin compose: (base, layers...) ->
  L.reduce L.uniq(L.flatten(L.map(layers, L.functions))), (object, method) ->
    object[method] = L.pipe base, L.compact L.map( layers, method )
    object
  , base

# namespacer
L.mixin ns: (path, action) ->
  "#{path[6..-1]}/#{action}"

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

L.mixin stringify: (hash) ->
    L.reduce(hash, (array, k,v) ->
      array.push "#{k}#{v}"
      array
    , []).sort().join()

L.mixin tmp_id: (object) -> /tmp/.exec object.id

L.mixin wait_for_real_id: (objects, action) ->
  !if object = L.find objects, L.tmp_id
    Dispatcher.once "#{object.id}_to_id", action
