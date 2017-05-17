global.Router = global.R =

  cache: {}
  getters: {}
  setters: {}

  param: (key) ->
    v = decodeURI(@params[key] || '')
    if @getters[key]
    then @cache[key] ||= @getters[key](v)
    else v

  init: (@root) ->
    Router.read()

  read: ->
    [@view, @params] = @split_path document.location.pathname
    @_safe_params()

  split_path: (path) ->
    list = L.compact path.split("/")
    view = @_existance if list.length % 2 then list.shift() else @root
    params = L.fromPairs L.chunk(list, 2)
    [ view, params ]

  # Views is a list of components which are meant to be a top views
  # It should be given by framework
  _existance: (view) ->
    if L.includes(Views, view) then view else 'not_found'

  _safe_params: ->
    @safe_params = L.fromPairs L.reject L.toPairs(@params), (pair) ->
      /^_/.test pair[0]

  to_path: (view = @view, params = @safe_params) ->
    '/' + L(params)
      .toPairs()
      .reject (p) -> !p[1]
      .flatten()
      .tap (array) =>
        array.unshift(view) if view and view != @root
      .join('/')

  url: (view, objects) ->
    if objects
      attributes = L.reduce L.concat({}, objects), (map, el) ->
        map[el.type] = el.id
        map
    @to_path view, L.defaults attributes || {}, @safe_params

  go: (path) ->
    history.pushState {}, null, path
    Dispatcher.trigger "url_changed"

  write: (values...) ->
    # accept arguments keeping key, value, key, value order
    # or a hash as a first argument
    # serialize using setters
    # if no argument given just refresh url and rerender

    if values.length
      if values.length == 1
        L.each values[0], (v, k) ->
          R.params[k] = if R.setters[k] then R.setters[k](v) else v
      else
        L.each values, (k, i) ->
          unless i % 2
            v = values[i+1]
            R.params[k] = if R.setters[k] then R.setters[k](v) else v

    window.history.replaceState {},
      window.location.pathname, @to_path(@view, @params)
    Dispatcher.trigger "url_changed"

  toggle: (flag, state) ->
    @write flag, if state?
    then ( 1 if state )
    else ( 1 if !@params[flag] )

global.onpopstate = -> Dispatcher.trigger "url_changed"
Dispatcher.on "url_changed", ->
  Router.cache = {}
  Router.read()
  global.render()
