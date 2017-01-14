global.Router =

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

  write: ->
    window.history.replaceState {},
      window.location.pathname, @to_path(@view, @params)
    @read()

  toggle: (flag, state) ->
    if state?
      if state
        @params[flag] = 1
      else
        delete @params[flag]
    else
      if @params[flag]
        delete @params[flag]
      else
        @params[flag] = 1
    @go @to_path(@view, @params)

global.onpopstate = -> Dispatcher.trigger "url_changed"
Dispatcher.on "url_changed", -> Router.read(); global.render()
