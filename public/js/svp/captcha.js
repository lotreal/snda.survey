var Svp = window.Svp || {}; (function(win, ns) {

    var Captcha = new Class({

        Implements: Events,

        initialize: function(container) {
            this.container = container;
        },

        show: function() {
            var el = this.el || this.create();
            el.show();
            this.change();
        },

        hide: function() {
            if (this.el) this.el.hide();
        },

        change: function() {
            var img = this.captcha, src = img.get('src'),
                match = src.match(/^([^\?]+)\?t=(\d+)$/),
                new_src = match[1] + '?t=' + $time();
            img.set('src', new_src);
            this.input.removeClass('valid').set('value', '');
            this.notify();
        },

        onCheckError: function() {
            this.change();
            this.input.highlight();
            this.notify('error');
        },

        onCheckPass: function() {
            this.notify('pass');
            this.input.addClass('valid');
            this.fireEvent('pass');
        },

        check: function() {
            var box = this.input, code = box.get('value').trim();
            console.log('check captcha', code);
            if (box.hasClass('valid')) return this.onCheckPass();

            if (!code) return this.onCheckError();

            console.log('check captcha response >>>>>>>', box.hasClass('valid'));
            var request = new Request({
                url: '/survey/checkCaptcha',
                data: {'code': code},
                noCache: true,
                onSuccess: (function(response) {
                    response = JSON.decode(response, true);
                    console.log('check captcha response', response);
                    if (response) {
                        this.onCheckPass();
                    } else {
                        this.onCheckError();
                    }
                }).bind(this)
            });
            return request.send();
        },

        notify: function(type) {
            var msg = T('please enter code');
            if (type == 'pass')  {
                msg = T('captha code ok');
            } else if (type == 'error') {
                msg = T('captch code error');
            }
                
            var html = '<span class="' + type + '">' +
                msg + '</span>';
            this.notify_el.set('html', html);
        },

        // 创建校验码表单
        create: function() {
            var code = [
                '<span class="captcha_notify">',
                T('please enter code'),
                '</span>',
                '<input class="captcha_code" type="text" name="_captcha" size="6" maxlength="4"/>',
                '<img class="captcha_img" src="/survey/captcha?t=', $time(), '"/>',
                T('change captcha')
            ].join('');

            var div = new Element('div', {'id': 'captcha', 'html': code, 'styles': {'display': 'none'}});
            div.inject(this.container, 'bottom');

            this.captcha = div.getElement('img').addEvent('click', this.change.bind(this));
            this.input = div.getElement('input').addEvent('keydown', (function(event) {
                if (event.key == 'enter') this.check();
            }).bind(this));
            this.notify_el = div.getElement('.captcha_notify');
            return this.el = div;
        }
    });

    var pool = {};
    ns.CaptchaFactory = function(key, container) {
        if (!(key in pool))
            pool[key] = new Captcha(container);
        return pool[key];
    };

})(window, Svp);
