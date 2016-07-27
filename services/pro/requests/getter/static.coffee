class Collection.Static extends Collection

  constructor: ->
    super
    @key_values = L.map @constructor.order, 0

  load: ->     @go {}, (scope) => @scope = scope
  more: ->     @go ids: @scope
  page: (i, params = {}) ->
    new @constructor undefined, L.merge(params, page: i), @belongs_to

  prev: ->
    key = @_get_key L.first(@scope)
    @go before: key, (scope) => @scope = L.reverse(scope).concat @scope

  next: ->
    key = @_get_key L.last(@scope)
    @go after: key, (scope) => @scope = @scope.concat scope

  _get_key: (id) ->
    object = @_object(id); key = []
    for attr in @key_values
      if v = object[attr] then key.push(v) else return id
    key

  go: (params, scope_f) ->
    @done = false
    query = L.merge(params || {}, @params)
    rk    = @constructor.path + L.stringify(query)

    Dispatcher.once Requests.perform(@constructor.path, query), (reply) =>
      # Cache.set rk, reply.raw
      scope_f?.call(@, reply.scope); @v++
      if @constructor.relations
        L.each Store.get(@constructor.base, reply.scope), (object) =>
          @_create_relations(object.id)
      @done = true
    @
