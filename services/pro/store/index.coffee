require './actions'
require './local'

TmpIdsCheck  = require './tmp_ids_check'
Remote       = require './remote'

global.Store = L.compose

  collections: {}

  get: (name, ids) ->
    return [] unless name and ids
    L.compact L.at(@collections[name], ids)

  get_ref: (reference) -> @get.apply(@, reference)[0]

, TmpIdsCheck, Remote, LocalStore
