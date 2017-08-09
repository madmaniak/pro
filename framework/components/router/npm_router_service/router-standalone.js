module.exports = window.R = {
  _location: location,
  _replaceState: history.replaceState.bind(history),
  _pushState: history.pushState.bind(history),
  _decodeURIComponent: decodeURIComponent,
  _encodeURIComponent: encodeURIComponent,
  init: function(opts) {
    if (opts == null) {
      opts = {};
    }
    this.root || (this.root = opts.root || 'root');
    this.views || (this.views = opts.views || window.Views || [this.root]);
    this.render || (this.render = opts.render || window.render);
    this.h || (this.h = opts.helpers || window._);
    window.onpopstate = this.url_changed.bind(this)
	this.read();
  },
  cache: {},
  getters: {},
  setters: {},
  param: function(key) {
    var base;
    if (this.getters[key]) {
      return (base = this.cache)[key] || (base[key] = this.getters[key](this._decodeURIComponent(this.params[key] || '')));
    } else {
      return this._decodeURIComponent(this.params[key] || '');
    }
  },
  write: function() {
    var i, j, k, len, v;
	for (i = j = 0, len = arguments.length; j < len; i = ++j) {
	  k = arguments[i];
	  if (!(i % 2)) {
		v = arguments[i + 1];
		this._write(k, v);
	  }
	}
    this._replaceState({}, this._location.pathname, this.to_path(this.view, this.params));
    this.url_changed();
  },
  _write: function(k, v) {
	var value = this.setters[k] ? this.setters[k](v) : v;
	value ? this.params[k] = this._encodeURIComponent(value) : delete this.params[k];
  },
  toggle: function(flag, state) {
    this.write(flag, state != null ? (state ? 1 : void 0) : (!this.params[flag] ? 1 : void 0));
  },
  go: function(path) {
    this._pushState({}, null, path);
    this.url_changed();
  },
  read: function() {
    var ref;
    ref = this.split_path(this._location.hash), this.view = ref[0], this.params = ref[1];
    this._safe_params();
  },
  split_path: function(path) {
	path = path.slice(2);
    if (!path.length) {
      return [this.root, {}];
	}
    var list, params, view;
    list = this.h.compact(path.split("/"));
    view = this._existance(list.shift());
    params = this.h.fromPairs(this.h.chunk(list, 2));
    return [view, params];
  },
  _existance: function(view) {
    if (this.h.includes(this.views, view)) {
      return view;
    } else {
      return 'not_found';
    }
  },
  _safe_params: function() {
    return this.safe_params = this.h.fromPairs(this.h.reject(this.h.toPairs(this.params), function(pair) {
      return /^_/.test(pair[0]);
    }));
  },
  to_path: function(view, params) {
    var array;
    if (view == null) {
      view = this.view;
    }
    if (params == null) {
      params = this.safe_params;
    }
    array = this.h.flatten(this.h.toPairs(params));
    return '#/' + view + '/' + array.join('/');
  },
  url_changed: function() {
    this.cache = {};
    this.read();
    this.render();
  }

};
