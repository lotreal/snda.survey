var Svp = window.Svp || {}; (function(win, ns) {
    var Node = new Class({
        initialize: function(key, obj) {
            this.key = key;
            this.obj = obj;

            this._parent = null;
            this._children = [];
        },

        // -----------------------------------------
        getKey: function() { return this.key; },
        getObj: function() { return this.obj; },

        getParent: function() { return this._parent; },
        setParent: function(node) { this._parent = node; },

        getChildren: function() { return this._children; },
        // -----------------------------------------
        add: function(node) {
            node.setParent(this);
            this._children.push(node);
        },

        remove: function(node) {
            node.setParent(null);
            this._children.erase(node);
        },

        appendTo: function(node) {
            node.add(this);
        },


        find: function(key) {
            if (this.key === key) return this;
            var n = this._children.length;
            if (n > 0) {
                for (var i = 0; i < n; i++) {
                    var node = this._children[i];
                    if (node.find(key)) return node;
                }
            }
            return false;
        },

	map: function(fn, bind){
            if (fn.call(bind, this.key, this.obj)) return this;
            var n = this._children.length;
            if (n > 0) {
                for (var i = 0; i < n; i++) {
                    var node = this._children[i];
                    if (node.find(key)) return node;
                }
            }
            return false;
	},

        next: function() {
        },


        // -----------------------------------------
        hasNext: function() {
            var p = this._parent;
            if (p === null) return false;
            var kids = p.getChildren(),
                len = kids.length,
                idx = kids.indexOf(this);
            return (++idx < len);
        },
        getNext: function(fn) {
            var p = this._parent;
            if (p === null) return false;
            var kids = p.getChildren(),
                len = kids.length,
                idx = kids.indexOf(this);
            if ($type(fn) === 'function') {
                for (var i = ++idx; i < len; i++) {
                    var kid = kids[i], obj = kid.getObj();
                    var ret = fn.call(obj, kid.key, obj);
                    if (ret) return kid;
                }
                return false;
            } else {
                return (++idx < len) ? kids[idx] : false;
            }
        }
    });

    var RootNode = new Class({
        Extends: Node
    });

    var NodePool = new Class({
        initialize: function(obj_getter) {
            this.obj_getter = obj_getter;
            this.pool = {};
        },

        get: function(key, obj_getter) {
            obj_getter = obj_getter || this.obj_getter;
            if (!(key in this.pool)) {
                var obj = obj_getter(key);
                if (!obj) return false;
                this.pool[key] = new Node(key, obj);
            }
            return this.pool[key];
        }
    });

    ns.Tree = {
        'Node': Node,
        'RootNode': Node,
        'NodePool': NodePool
    };
})(window, Svp);
