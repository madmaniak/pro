class Getter.Static extends Getter

  constructor: ->
    super
    @key_values = L.map @constructor.order, 0

  load: ->     @go {}, (scope) => @v++; @scope = [scope]
  more: ->     @go ids: @all()
  page: (i) -> @go page: i, (scope) => @v++; @scope[i] = scope

  prev: (page) ->
    if key = @_get_key L.first(@scope[page] || @all())
      @go before: key, (scope) =>
        @_splice @scope, (page-1) || 0, !!page, L.reverse(scope)

  next: (page) ->
    if key = @_get_key L.last(@scope[page] || @all())
      @go after: key, (scope) =>
        @_splice @scope, (page+1) || @scope.length, !!page, scope

  _get_key: (id) ->
    object = Store.get(@constructor.base, id)[0]
    key = []
    for attr in @key_values
      if v = object[attr] then key.push(v) else return id
    key

  go: (params, scope_f) ->
    @done = false
    query = L.merge(params || {}, @params)
    rk    = @constructor.path + L.stringify(query)

    Dispatcher.once Requests.perform(@constructor.path, query), (reply) =>
      # Cache.set rk, reply.raw
      scope_f?(reply.scope)
      if @constructor.relations
        L.each Store.get(@constructor.base, reply.scope), (object) =>
          @_create_relations(object.id)
      @done = true
