require './data'
Remote = require('./remote').Remote
Render = require('./render').Render

global.LocalStore = L.combine Data, Render
global.Store = L.combine Remote, LocalStore
