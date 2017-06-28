window.R = {
  init: function(opts) {
    if (opts == null) {
      opts = {};
    }
    this.root || (this.root = opts.root || 'main');
    this.views || (this.views = opts.views || [this.root]);
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
      return (base = this.cache)[key] || (base[key] = this.getters[key](decodeURI(this.params[key] || '')));
    } else {
      return decodeURI(this.params[key] || '');
    }
  },
  write: function() {
    var i, j, k, len, ref, v;
    if (arguments.length) {
      if (arguments.length === 1) {
        ref = arguments[0];
        for (k in ref) {
          v = ref[k];
          this._write(k, v);
        }
      } else {
        for (i = j = 0, len = arguments.length; j < len; i = ++j) {
          k = arguments[i];
          if (!(i % 2)) {
            v = arguments[i + 1];
            this._write(k, v);
          }
        }
      }
    }
    history.replaceState({}, location.pathname, this.to_path(this.view, this.params));
    this.url_changed();
  },
  _write: function(k, v) {
    this.params[k] = this.setters[k] ? this.setters[k](v) : v;
  },
  toggle: function(flag, state) {
    this.write(flag, state != null ? (state ? 1 : void 0) : (!this.params[flag] ? 1 : void 0));
  },
  go: function(path) {
    history.pushState({}, null, path);
    this.url_changed();
  },
  read: function() {
    var ref;
    ref = this.split_path(location.pathname), this.view = ref[0], this.params = ref[1];
    this._safe_params();
  },
  split_path: function(path) {
    var list, params, view;
    list = this.h.compact(path.split("/"));
    view = this._existance(list.length % 2 ? list.shift() : this.root);
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
    array = this.h.flatten(this.h.reject(this.h.toPairs(params), function(p) {
      return !p[1];
    }));
    if (view && view !== this.root) {
      array.unshift(view);
    }
    return '/' + array.join('/');
  },
  url: function(view, objects) {
    var attributes;
    if (objects) {
      attributes = this.h.reduce(this.h.concat({}, objects), function(map, el) {
        map[el.type] = el.id;
        return map;
      });
    }
    return this.to_path(view, this.h.defaults(attributes || {}, this.safe_params));
  },
  url_changed: function() {
    this.cache = {};
    this.read();
    this.render();
  }

};
