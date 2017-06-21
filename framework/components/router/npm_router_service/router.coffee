module.exports = R =

  init: (opts = {}) ->
    @root   ||= opts.root    || 'main'
    @views  ||= opts.views   || [@root]
    @render ||= opts.render  || global.render
    @h      ||= opts.helpers || global._
    global.onpopstate = @url_changed
    @read()

  cache: {}
  getters: {}
  setters: {}

  # <MAIN API>

  param: (key) ->
    if @getters[key]
    then @cache[key] ||= @getters[key]( decodeURI(@params[key] || '') )
    else decodeURI(@params[key] || '')

  write: ->
    # accept arguments keeping key, value, key, value order
    # or a hash as a first argument
    # serialize using setters
    # if no argument given just refresh url and rerender

    if arguments.length
      if arguments.length == 1
        @h.each arguments[0], (v, k) ->
          R.params[k] = if R.setters[k] then R.setters[k](v) else v
      else
        @h.each arguments, (k, i) ->
          unless i % 2
            v = arguments[i+1]
            R.params[k] = if R.setters[k] then R.setters[k](v) else v

    window.history.replaceState {},
      window.location.pathname, @to_path(@view, @params)
    @url_changed()

  toggle: (flag, state) ->
    @write flag, if state?
    then ( 1 if state )
    else ( 1 if !@params[flag] )

  go: (path) ->
    history.pushState {}, null, path
    @url_changed()

  # </MAIN API>

  read: ->
    [@view, @params] = @split_path document.location.pathname
    @_safe_params()

  split_path: (path) ->
    list = @h.compact path.split("/")
    view = @_existance if list.length % 2 then list.shift() else @root
    params = @h.fromPairs @h.chunk(list, 2)
    [ view, params ]

  _existance: (view) ->
    if @h.includes(@views, view) then view else 'not_found'

  _safe_params: ->
    @safe_params = @h.fromPairs @h.reject @h.toPairs(@params), (pair) ->
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
      attributes = @h.reduce @h.concat({}, objects), (map, el) ->
        map[el.type] = el.id
        map
    @to_path view, @h.defaults attributes || {}, @safe_params

  url_changed: ->
    @cache = {}
    @read()
    @render()
