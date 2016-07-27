class global.Getter

  @list: {}

  constructor: (@scope = [], @params = {}, @belongs_to) ->
    @v = 0
    Dispatcher.on "#{@constructor.base}_change", @change
    unless @belongs_to
    # root in Store
      @belongs_to = id: 1, type: @constructor.path
      @belongs_to[@constructor.base] = @
      Store.collections[@constructor.path] = 1: @belongs_to

  collection: ->
    if @_v == @v
    then @_collection
    else @_v = @v; @_collection = Store.get @constructor.base, @scope

  create: (object, relations = []) ->
    Store.add @constructor.base, object, relations.concat @belongs_to
    render()

  add: (id) ->
    @scope.push(id); @v++
    i = @reorder(@scope.length - 1)
    object = @_object(id)
    L.wait_for_real_id [object], =>
      if @scope[i] != id
        i = @index_of(object, id)
      @scope.splice(i, true, object.id); @v++
    @_create_relations(id)

  _create_relations: (id) ->
    object = @_object(id)
    L.each @constructor.relations, (ns, relation) ->
      if !object[relation] or L.isArray object[relation]
        object[relation] = new Getter.list[ns](object[relation], {}, object)

  change: (id) =>
    if object = @_object(id)
    # still exists?
      # id in scope?
      if (i = @index_of(object)) != -1
      then @reorder(i)
      else @scope.splice(i); @v++

  reorder: (i) ->
    c = @collection()
    if direction = @_direction c[i-1], c[i], c[i+1]
    # wrong order?
      split = i + direction
      destination =
        if direction < 0
        then @proper_index(c[i], c, 0, split-1)
        else i + @proper_index(c[i], c, split)
      @move i, destination
    destination || i

  # which way unsorted element should go
  _direction: (left, object, right) ->
    if right and @compare(object, right) then 1
    else if left and @compare(left, object) then -1
    else 0

  move: (from, to) ->
    @scope.splice to, 0, @scope.splice(from, 1)[0]; @v++

  # is a >= b considering [attribute, boolean:descending]?
  compare: (a, b) ->
    for order in @constructor.order
      return !order[1] if a[order[0]] > b[order[0]]
      return  order[1] if a[order[0]] < b[order[0]]
      return !order[1] if L.isString(a[order[0]]) && L.isInteger(b[order[0]])
      return  order[1] if L.isString(b[order[0]]) && L.isInteger(a[order[0]])
    true

  # binary search for proper index
  proper_index: (object, collection, left, right) ->
    collection ||= @collection()
    l = left   ||  0
    r = right  ||  collection.length - 1
    m = H.half_way(l, r)
    while true
      return l   if @compare(collection[l], object)
      return r+1 if @compare(object, collection[r])
      if @compare(collection[m], object)
      then r = m - 1
      else l = m + 1
      m = H.half_way(l, r)

  index_of: (object, id = object.id) ->
    i = @proper_index object
    return i if @scope[i] == id
    j = 1
    while (i2 = i+j) < @scope.length
      return i2 if @scope[i2] == id or @scope[i-j] == id
      j++
    while (i2 = i-j) >= 0
      return i2 if @scope[i2] == id
      j++
    -1

  _object: (id) -> Store.get(@constructor.base, id)[0]

H =
  half_way: (l, r) ->
    l + Math.floor (r - l)/2

require './static'
require './dynamic'
