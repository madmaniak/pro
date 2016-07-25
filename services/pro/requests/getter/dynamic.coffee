class Getter.Dynamic extends Getter.Static

  prev: ->
    if @dynamic_prev
      @go dynamic: @all(), (scope) =>
        @_splice @scope, 0, false, scope
        L.each [scope.length-1..0], (i) => @reorder(i)
        @_dynamic_flags(scope)
    else super

  next: ->
    if @dynamic_next
      @go dynamic: all = @all(), (scope) =>
        @_splice @scope, @scope.length, false, scope
        L.each [all.length...all.length + scope.length], (i) => @reorder(i)
        @_dynamic_flags(scope)
    else super

  _dynamic_flags: (scope) ->
    all = @all()
    @dynamic_prev = false if L.includes scope, all[0]
    @dynamic_next = false if L.includes scope, L.last(all)

  reorder: (i) ->
    i = super(i)
    if i == @collection().length - 1
      @dynamic_next = true
    else if i == 0
      @dynamic_prev = true
