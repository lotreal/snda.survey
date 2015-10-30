var Svp = window.Svp || {}; (function(win, ns) {
    var Validator = ns.Survey.Validator;

    // mootools 1.3 remove $empty
    var Part = function() {};

    var Question = new Class({
        Implements: Events,

        initialize: function(el, model, sn) {
            this.el = el;
            this.model = model;
            this.sn = sn;
            this.part = model.getPart(sn);
            this.type = model.getType(sn);

            this.initUI();
        },
        
        getEl: function() {
            return this.el;
        },

        show: function() { 
            this.getEl().setStyle('display', ''); 
            this.model.setVisibility(this.sn, true);
        },

        hide: function() {
            this.model.setVisibility(this.sn, false);
            this.reset();
            this.getEl().hide(); 
        },

        initUI: function() {},

        verifyValue: function() {
            console.log('verify value', this.model, this.part, this.getValue());
            return Validator['verify'+this.type.capitalize()
                     ](this.model, this.part, this.getValue());
        },

        verify: function() {
            var el = this.getEl();

            var r = this.verifyValue(), v = Validator.passed(r);

            if (!this.errMsgEl) this.errMsgEl = el.getElement('.error');
            if (this.errMsgEl) 
                this.errMsgEl.set('text', v ? '' : Validator.message(r));

            return v;
        }
    });

    var Page = new Class({

        Extends: Question,

        reset: function() {}
    });

    var TextQuestion = new Class({

        Extends: Question,

        initUI: function() {
            this.input = this.getEl().getElement(this.model.formType(this.sn));
            this.input.addEvent('change', (function() {
                this.verify();
                this.fireEvent('change', this);
            }).bind(this));

            var it = this.model.validator(this.sn);
            if (it == 'date' && 'DatePicker' in window) {
                new DatePicker(this.input, {
                    'pickerClass': 'datepicker_vista',
                    'format': 'Y-m-d',
                    'inputOutputFormat': 'Y-m-d',
                    'allowEmpty': true
                });
            }
        },

        getValue: function() {
            return this.input.get('value').trim();
        },

        reset: function() {
            this.input.set('value', '');
        }
    });

    var SelectQuestion = new Class({
        Extends: Question,
        selected: 'checked',
        initUI: function() {
            var kids = this.model.getChildren(this.part),
                options = [], sp_inputs = {};

            for (var i = 0, n = kids.length; i < n; i++) {
                var sn = kids[i],
                    opt = $(sn),
                    allow_specify = this.model.allowSpecify(sn);
                options.push(opt);
                if (allow_specify) {
                    var sp = $(sn + '_specify');
                    //console.log(sn, allow_specify, sp);
                    sp.addEvent('change', (function() {
                        this.updateValue();
                        this.verify();
                    }).bind(this));
                    
                    sp_inputs[sn] = sp;
                }
            }

            this.options = new Elements(options);
            this.sp_inputs = sp_inputs;

            this.bindEvents();
        },

        bindEvents: function() {
            this.options.addEvent('click', this.onChange.bind(this));
        },

        onChange: function() {
            this.updateValue();
            this.verify();
            this.fireEvent('change', this);
        },

        updateValue: function() {
            var choice = {}, i = 0, specify = {}, 
                sp_inputs = this.sp_inputs;

            this.options.each((function(el) {
                var sn = el.value, checked = el[this.selected];
                choice[sn] = checked;
                if (checked) {
                    i++;
                    var input = sp_inputs[sn];
                    if (this.model.allowSpecify(sn))
                        specify[sn] = input ? input.get('value').trim() : '';
                }
            }).bind(this));

            this.choice = choice;
            this.choice_length = i;
            this.specify = specify;
        },

        getValue: function() {
            if (this.choice_length === undefined) this.updateValue();
            return {
                choice: this.choice,
                choice_length: this.choice_length,
                specify: this.specify
            };
        },

        reset: function() {
            var changed = false;
            this.options.each((function(el) {
                if (el[this.selected]) {
                    el.set(this.selected, false);
                    changed = true;
                }
            }).bind(this));

            if (changed) {
                this.updateValue();
                this.fireEvent('change', this);
            }
        }
    });

    var DropdownListQuestion = new Class({
        Extends: SelectQuestion,
        selected: 'selected',
        bindEvents: function() {
             $(this.sn).addEvent('change', (function() {
                 this.onChange();
                 this.showSpecify();
             }).bind(this));
        },

        showSpecify: function() {
            var choice = this.getValue().choice;
            for (var sn in choice) {
                var sp = this.sp_inputs[sn];
                if (sp) sp.setStyle('display', choice[sn] ? 'inline' : 'none');
            }
        }
    });

    var MatrixQuestion = new Class({

        Extends: Question,

        initUI: function() {
            var model = this.model,
                kids = model.getChildren(this.part),
                cols = [], rows = [];

            for (var i = 0, n = kids.length; i < n; i++) {
                var sn = kids[i];
                if (model.direction(sn) == 'col') cols.push(sn);
                else rows.push(sn);
            }

            this.rows = rows;
            this.cols = cols;
            this.pre_column_one_response = this.model.preColumnOneResponse(this.sn);
            this.getEl().getElements('input').addEvent('change', this.onChange.bind(this));
        },

        onChange: function(event) {
            if (this.pre_column_one_response) {
                var target = $(event.target),
                    row = target.get('row'),
                    col = target.get('col');
                this.preColumnOneResponse(row, col);
            }
            this.updateValue();
            this.verify();
            this.fireEvent('change', this);
        },

        preColumnOneResponse: function(row, col) {
            var rows = this.rows;
            for (var i = 0, n = rows.length; i < n; i++) {
                if (row == rows[i]) continue;
                $(rows[i] + '_' + col).set('checked', false);
            }
        },

        updateValue: function() {
            var rows = this.rows, cols = this.cols, choice = {},
                row_checked = 0;
            for (var i = 0, n = rows.length; i < n; i++) {
                var row_choice = [], row = rows[i];
                for (var j = 0, k = cols.length; j < k; j++) {
                    var col = cols[j], opt = $(row + '_' + col);
                    if (opt.checked) row_choice.push(col);
                }
                choice[row] = row_choice;
                row_checked += row_choice.length > 0 ? 1 : 0;
            }
            this.choice = choice;
            this.row_checked = row_checked;
        },

        getValue: function() {
            if (this.choice === undefined) this.updateValue();
            return {
                choice: this.choice,
                row_checked: this.row_checked,
                row_length: this.rows.length,
                col_length: this.cols.length
            };
        },

        reset: function() {
            this.getEl().getElements('input:checked').set('checked', false);
        }
    });

    var pool = {
        'page': Page,

        'text_input': TextQuestion,
        'text_textarea': TextQuestion,

        'select_radio': SelectQuestion,
        'select_checkbox': SelectQuestion,
        'select_select': DropdownListQuestion,

        'matrix_radio': MatrixQuestion,
        'matrix_checkbox': MatrixQuestion
    };

    var UI_Factory = function(el_getter, model, sn) {
        var type = model.getType(sn),
            formType = model.formType(sn),
            name = type + (formType ? ( '_' + formType ) : ''),
            part = (name in pool) ? pool[name] : Part,
            el = el_getter(model, sn);
        console.log(model, sn, name, el);
        return new part(el, model, sn);
    };

    ns.Survey = ns.Survey || {};
    ns.Survey.UI_Factory = UI_Factory;
})(window, Svp);
