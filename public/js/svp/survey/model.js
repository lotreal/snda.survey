var Svp = window.Svp || {}; (function(win, ns) {

    var Model = new Class({
        initialize: function(define) {
            this.page = define.page;
            this.parts = define.parts;
            this.structure = define.structure;
            this.triggers = define.triggers;
        },

        getSN: function(part) {
            return part['sn'] || part;
        },

        getPart: function(part) {
            return typeof part == 'object' ? part : this.parts[part];
        },
        
        getType: function(part) { return this.getPart(part)['type'] || ''; },

        getChildren: function(part) {
            var sn = this.getSN(part),
                struc = this.structure || {};
            return struc.hasOwnProperty(sn) ? struc[sn] : [];
        },

        getPageTotal: function() {
            var current_page, page_count = 0;
            for (var page_sn in define['page']) {
                if (!current_page) current_page = page_sn;
                page_count++;
            }
        },

        // need json
        getVisibility: function(part) { return Boolean(this.getPart(part)['visibility'] || true); },
        setVisibility: function(part, visibility) {
            this.getPart(part)['visibility'] = Boolean(visibility); 
        },

        // allow_specify 在验证 有指定输入的 select_option 这种题型的
        // specify input 时候有用
        // NEW: 修改 define, 为 allow_specify 的选项 设定 is_require
        isRequire: function(part) { return this.getPart(part)['is_require'] || 0 > 0; },
        allowSpecify: function(part) { return this.getPart(part)['allow_specify'] > 0; },
        isMultipleChoice: function(part) { return this.getPart(part)['multiple_choice'] > 0; },
        direction: function(part) { return this.getPart(part)['direction'] || ''; },
        preColumnOneResponse: function(part) { return this.getPart(part)['pre_column_one_response'] > 0; },

        validator: function(part) { return this.getPart(part)['validator'] || ''; },
        formType: function(part) { return this.getPart(part)['form_type'] || ''; },
        leastInput: function(part) { return parseInt(this.getPart(part)['least_input']) || 0; },
        mostInput: function(part) { return parseInt(this.getPart(part)['most_input']) || 0; },
        textLengthRange: function(part) {
            var l = this.leastInput(part), m = this.mostInput(part);
            return l < m ? [l, m] : [m, l];
        },

        leastChoice: function(part) { return parseInt(this.getPart(part)['least_choice']) || 0; },
        mostChoice: function(part) { return parseInt(this.getPart(part)['most_choice']) || 0; },
        choiceLengthRange: function(part) { 
            var l = this.leastChoice(part), m = this.mostChoice(part);
            return l < m ? [l, m] : [m, l];
        }
    });

    ns.Survey = ns.Survey || {};

    ns.Survey.Model = Model;
})(window, Svp);
