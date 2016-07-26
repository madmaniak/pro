class Getter.Dynamic extends Getter.Static

  prev: ->
    if @dynamic_prev
      @go dynamic: @scope, (scope) =>
        @scope = scope.concat @scope
        L.each [scope.length-1..0], (i) => @reorder(i)
        @_dynamic_flags(scope)
    else super

  next: ->
    if @dynamic_next
      @go dynamic: before = @scope, (scope) =>
        @scope = @scope.concat @scope
        L.each [before.length...before.length + scope.length], (i) => @reorder(i)
        @_dynamic_flags(scope)
    else super

  _dynamic_flags: (scope) ->
    @dynamic_prev = false if L.includes scope, @scope[0]
    @dynamic_next = false if L.includes scope, L.last(@scope)

  reorder: (i) ->
    i = super(i)
    if i == @collection().length - 1
      @dynamic_next = true
    else if i == 0
      @dynamic_prev = true
