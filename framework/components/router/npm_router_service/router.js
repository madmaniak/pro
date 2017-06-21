var R;

module.exports = R = {
init: function(opts) {
  if (opts == null) {
	opts = {};
  }
  this.root || (this.root = opts.root || 'main');
  this.views || (this.views = opts.views || [this.root]);
  this.render || (this.render = opts.render || global.render);
  this.h || (this.h = opts.helpers || global._);
  global.onpopstate = this.url_changed;
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
  if (arguments.length) {
	if (arguments.length === 1) {
	  this.h.each(arguments[0], function(v, k) {
		R.params[k] = R.setters[k] ? R.setters[k](v) : v;
	  });
	} else {
	  this.h.each(arguments, function(k, i) {
		var v;
		if (!(i % 2)) {
		  v = arguments[i + 1];
		  R.params[k] = R.setters[k] ? R.setters[k](v) : v;
		}
	  });
	}
  }
  window.history.replaceState({}, window.location.pathname, this.to_path(this.view, this.params));
  this.url_changed();
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
  ref = this.split_path(document.location.pathname), this.view = ref[0], this.params = ref[1];
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
  if (view == null) {
	view = this.view;
  }
  if (params == null) {
	params = this.safe_params;
  }
  return '/' + L(params).toPairs().reject(function(p) {
	return !p[1];
  }).flatten().tap((function(_this) {
	return function(array) {
	  if (view && view !== _this.root) {
		return array.unshift(view);
	  }
	};
  })(this)).join('/');
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
