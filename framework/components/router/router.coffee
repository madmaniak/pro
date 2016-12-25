global.Router =

  init: (@root) ->
    Router.read()

  read: ->
    list = L.compact document.location.pathname.split("/")
    @view = @_existance if list.length % 2 then list.shift() else @root
    @params = L.fromPairs L.chunk(list, 2)
    @_safeParams()
    @_path()

  _existance: (view) ->
    if _T[view.toUpperCase()] then view else 'not_found'

  _safeParams: ->
    @safeParams = L.fromPairs L.reject L.toPairs(@params), (pair) ->
      /^_/.test pair[0]

  toPath: (view = @view, params = @safeParams) ->
    '/' + L(params)
      .toPairs()
      .flatten()
      .tap (array) =>
        array.unshift(view) if view and view != @root
      .join('/')

  _path: ->
    @path =
      if document.location.pathname == "/"
      then "/#{@view}"
      else document.location.pathname

  url: (view, objects) ->
    if objects
      attributes = L.reduce L.concat({}, objects), (map, el) ->
        map[el.type] = el.id
        map
    @toPath view, L.defaults attributes || {}, @safeParams

  go: (path) ->
    history.pushState {}, null, path
    Dispatcher.trigger "url_changed"

  write: ->
    window.history.replaceState {},
      window.location.pathname, @toPath(@view, @params)
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
    @go @toPath(@view, @params)

global.onpopstate = -> Dispatcher.trigger "url_changed"
Dispatcher.on "url_changed", -> Router.read(); global.render()
