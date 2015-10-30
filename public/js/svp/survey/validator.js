var Svp = window.Svp || {}; (function(win, ns) {
    var Validator_Regexps = {
        number: {
            re: /^-?\d+(\.\d+)?$/,
            message: T('error validator number')
        },
        date: {
            re: /^\d{4}\-\d{1,2}\-\d{1,2}$/,
            message: T('error validator date')
        },
        email: {
            re: /^([a-z0-9_\-\.])+\@([a-z0-9_\-\.])+\.([a-z]{2,4})$/i,
            message: T('error validator email')
        },
        chinese: {
            re: /^[\u4e00-\u9fa5]+$/i,
            message: T('chinese only')
        }
    };

    ns.Survey = ns.Survey || {};

    ns.Survey.Validator = {
        pass: function() {
            return { pass: true };
        },

        error: function(rule, message) {
            return { pass: false, rule: rule, message: message};
        },

        passed: function(result) {
            return result && result.pass;
        },

        message: function(result) {
            if (!result) return '';
            return result.message;
        },

        verifyText: function(model, part, value) {
            if (!model.getVisibility(part)) return this.pass();

            if (!value) return model.isRequire(part) ? this.error('is_require', T('error is require')) : this.pass();

            var validator = model.validator(part).toLowerCase(), r;
            console.log('validator', validator);
            if (validator && (r = Validator_Regexps[validator]) && (!value.test(r.re))) return this.error('validator', r.message);

            var tlr = model.textLengthRange(part), 
                len = value.length,
                least_input = tlr[0], most_input  = tlr[1];

            if (least_input && len < least_input) return this.error('least_input', sprintf(T('error least input'), least_input));
            if (most_input  && len > most_input)  return this.error('most_input',  sprintf(T('error most input'),  most_input));

            return this.pass();
        },

        verifySelect: function(model, part, value) {
            if (!model.getVisibility(part)) return this.pass();

            var choice = value.choice,
                choice_length = value.choice_length || 0,
                specify = value.specify;

            if (!choice_length) return model.isRequire(part) ? this.error('is_require', T('error is require')) : this.pass();

            var clr = model.choiceLengthRange(part), least_choice = clr[0], most_choice = clr[1];
            if (least_choice && choice_length < least_choice) return this.error('least_choice',  sprintf(T('error least choice'), least_choice));
            if (most_choice && choice_length > most_choice) return this.error('most_choice',  sprintf(T('error most choice'), most_choice));

            for (var sn in specify) {
                var verifySpecify = this.verifyText(model, sn, specify[sn]);
                if (!this.passed(verifySpecify)) return verifySpecify;
            }

            return this.pass();
        },

        verifyMatrix: function(model, part, value) {
            if (!model.getVisibility(part)) return this.pass();

            var row_checked = value.row_checked;

            if (model.isRequire(part)) {
                if (model.preColumnOneResponse(part)) {
                    if(row_checked < value.col_length &&
                       row_checked < value.row_length)
                        return this.error('is_require',  T('error is require'));
                } else {
                    if(row_checked < value.row_length)
                        return this.error('is_require',  T('error is require'));
                }
            }
            return this.pass();
        }

    };

})(window, Svp);
