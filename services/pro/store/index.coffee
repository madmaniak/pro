require './actions'

CurrentState = require './current_state'
TmpIdsCheck  = require './tmp_ids_check'
Remote       = require './remote'
Local        = require './local'
Render       = require './render'

global.Store = L.combine

  collections: {}

  get: (name, ids) ->
    return [] unless name and ids
    L.at @collections[name], ids

  get_current: (object) -> @get(object.type, object.id)[0]

  get_ref: (reference) -> @get.apply(@, reference)[0]

, CurrentState, TmpIdsCheck, Remote, Local, Render
