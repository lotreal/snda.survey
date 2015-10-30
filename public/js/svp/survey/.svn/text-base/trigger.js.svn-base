var Svp = window.Svp || {}; (function(win, ns) {

    var Trigger = new Class({
        Implements: Events,
        initialize: function(model) {
            this.model = model;
            this.shown = {};
            this.finished = [];
        },

        getTrigger: function(sn) {
            var assoc = this.model.triggers.assoc;
            trigger = assoc.hasOwnProperty(sn) ? assoc[sn] : [];
            return trigger;
        },

        triggering: function(sn, value) {
            var triggers = this.getTrigger(sn);
            for (var i = 0, n = triggers.length; i < n; i++) {
                var rule = triggers[i],
                    trigger = rule['when'],
                    active = value[trigger],
                    action = rule['do'],
                    target = rule['with'];
                console.log('doTrigger', trigger, active, action, target[0]);
                this[action](trigger, active, target);
            }
        },

        show: function(trigger, active, target) {
            this.shown[target] = this.shown[target] || [];
            var shown = this.shown[target],
                triggered = shown.indexOf(trigger) >= 0,
                len = shown.length;
            if (active) {
                if (!triggered && len == 0) {
                    // console.log('show', target);
                    shown.push(trigger);
                    this.fireEvent('show', target);
                }
            } else {
                if (triggered && --len == 0) {
                    // console.log('hide', target);
                    shown.erase(trigger);
                    this.fireEvent('hide', target);
                }
            }
        },

        finish: function(trigger, active, target) {
            var finished = this.finished,
                triggered = finished.indexOf(trigger) >= 0;
            if (active) {
                if (!triggered) {
                    //console.log('add finish trigger');
                    finished.push(trigger);
                    this.fireEvent('finish', finished.length > 0);
                }
            } else {
                if (triggered) {
                    //console.log('remove finish trigger');
                    finished.erase(trigger);
                    this.fireEvent('finish', finished.length > 0);
                }
            }
        }
    });

    ns.Survey = ns.Survey || {};

    ns.Survey.Trigger = Trigger;

})(window, Svp);
