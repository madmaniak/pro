global.Router =

  ##root: "view_name"

  read: ->
    list = L.compact document.location.pathname.split("/")
    @view = if list.length % 2 then list.shift() else @root
    @params = L.fromPairs L.chunk(list, 2)
    @_safeParams()

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

  toggle: (flag, value = 1) ->
    value = String(value)
    if @params[flag] == value
    then delete @params[flag]
    else @params[flag] = value
    @go @toPath(@view, @params)

Router.read()
window.onpopstate = -> Dispatcher.trigger "url_changed"
Dispatcher.on "url_changed", -> Router.read()
