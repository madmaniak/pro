class global.Getter

  @list: {}

  constructor: (@scope = [[]], @params = {}, @belongs_to) ->
    @v = 0
    Dispatcher.on "#{@constructor.base}_change", @change
    unless @belongs_to
    # root in Store
      @belongs_to = id: 1, type: @constructor.path
      @belongs_to[@constructor.base] = @
      Store.collections[@constructor.path] = 1: @belongs_to

  all: ->
    if @_v != @v
      @_v = @v
      @_all = L.reduce @scope, (collection, page) ->
        if page then collection.concat(page) else collection
      , []
    else @_all

  collection: ->
    if @_v2 != @v
    then @_v2 = @v; @_collection = Store.get @constructor.base, @all()
    else @_collection

  create: (object) ->
    Store.add @constructor.base, object, [@belongs_to]
    render()

  add: (id) ->
    console.log id
    L.last(@scope).push(id); @v++
    i = @reorder(@all().length - 1)
    L.wait_for_real_id [{id: id}], (old_id, new_id) =>
      if @all()[i] != old_id
        i = L.indexOf(@all(), old_id)
      @_find_and_splice(i, true, new_id)
    @_create_relations(id)

  _create_relations: (id) ->
    object = Store.get(@constructor.base, id)[0]
    L.each @constructor.relations, (ns, relation) ->
      if !object[relation] or L.isArray object[relation]
        object[relation] = new Getter.list[ns](object[relation], {}, object)

  change: (id) =>
    if (i = L.indexOf(@all(), id)) != -1
    # id in scope?
      # still exists?
      if Store.get(@constructor.base, id)[0]
      then @reorder(i)
      else @_find_and_splice(i)

  reorder: (i) ->
    c = @collection()
    if direction = @_direction c[i-1], c[i], c[i+1]
    # wrong order?
      split = i + direction
      destination =
        if direction < 0
        then @_new_index(c[0..split], c[i])
        else i + @_new_index(c[split..-1], c[i])
      @move i, destination
    destination || i

  # which way unsorted element should go
  _direction: (left, object, right) ->
    if right and @compare(object, right) then 1
    else if left and @compare(left, object) then -1
    else 0

  move: (from, to) ->
    value = @_find_and_splice(from)[0]
    @_find_and_splice(to, false, value)

  _find_and_splice: (i, rm, value) ->
    [page, index] = @_i(i)
    @_splice @scope[page], index, rm, value

  _splice: (collection, i, rm = true, value) ->
    @v++
    if value
    then collection.splice(i, rm, value)
    else collection.splice(i, rm)

  # returns page number and partial index
  _i: (i) ->
    for page, j in @scope
      if i >= page.length and j < @scope.length - 1
        i -= page.length
      else return [j, i]

  # is a > b considering [attribute, boolean:descending]?
  compare: (a, b) ->
    for order in @constructor.order
      return !order[1] if a[order[0]] > b[order[0]]
      return  order[1] if a[order[0]] < b[order[0]]
    false

  # binary search for proper index
  _new_index: (collection, object) ->
    l = 0
    r = collection.length - 1
    m = H.half_way(l, r)
    while true
      return l   if @compare(collection[l], object)
      return r+1 if @compare(object, collection[r])
      if @compare(collection[m], object)
      then r = m - 1
      else l = m + 1
      m = H.half_way(l, r)

H =
  half_way: (l, r) ->
    l + Math.floor (r - l)/2

require './static'
require './dynamic'
