global.Cache =

  get: (request_key) ->
    localStorage.getItem(request_key)

  set: (request_key, data) ->
    localStorage.setItem request_key, data
