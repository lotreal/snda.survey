<?php
namespace Controller\User;

class Logout {

    public function beforeRun() {
        session_start();
    }

    public function get() {
        session_destroy();
        header("Location: https://pre.cas.sdo.com/cas/logout?url=" . urlencode( 'http://snda.survey.net/user/vertify' ) );
    }
}