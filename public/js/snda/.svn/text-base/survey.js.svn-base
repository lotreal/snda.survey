var Svp = window.Svp || {}; (function(win, ns) {
    ns.Snda = ns.Snda || {};
    var S = ns.Snda;

    var ModelConverter = function(define) {
        console.log('define ori', define);
        for (var sn in define) {
            var q = define[sn];
            q.validator = q.validate;
        }

        var n = {};
        n.parts = define;

        console.log('define new', n);
        return n;
    };

    // ns.Snda.Model = new Class({
    //     Implements: ns.Survey.Model
    // });

    var Main = function(survey_define) {
        function getEl(model, id) {
            return $('Q_' + id);
        }

        var define = ModelConverter(survey_define);

        var createUI = ns.Survey.UI_Factory,
            model = new ns.Survey.Model(define);
console.log(define, model);
        for (var sn in model.parts) {
console.log(sn);
            createUI(getEl, model, sn);
        }
    };

    S.Main = Main;
})(window, Svp);


