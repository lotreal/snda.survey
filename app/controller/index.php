<?php
namespace Controller;

class index {
    public function get() {
        return app()->redirect('/public/page1');
    }
}
