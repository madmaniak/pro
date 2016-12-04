class Collection.Dynamic extends Collection.Static

  prev: ->
    if @dynamic_prev
    then @go dynamic: @scope, @dynamic
    else super

  next: ->
    if @dynamic_next
    then @go dynamic: @scope, @dynamic
    else super

  dynamic: (scope) ->
    L.each scope, (id) => @add_id(id)
    @_dynamic_flags(scope)

  _dynamic_flags: (scope) ->
    @dynamic_prev = false if L.includes scope, @scope[0]
    @dynamic_next = false if L.includes scope, L.last(@scope)

  reorder: (i) ->
    i = super(i)
    if i == @elements().length - 1
      @dynamic_next = true
    else if i == 0
      @dynamic_prev = true
    i
