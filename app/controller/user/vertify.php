<?php
namespace Controller\User;

class Vertify {

    public function beforeRun() {
        session_start();
    }

    public function get() {
        
        $token = get( 'ticket' );
        if ( !$token ) {
            if ( !isset($_SESSION['snda_id']) ) {
                return app()->redirect( '/public/page1' );
            } else {
                return app()->redirect( '/user/page1' );
            }
        } else {
            // 请求cas验证接口
            $check = file('https://pre.cas.sdo.com/cas/Validate.Ex?service=' . urlencode( 'http://snda.survey.net/user/vertify' ) . '&ticket=' . $token );

            if ( 'yes' == trim($check[0]) ) {
                $_SESSION['snda_id'] = trim($check[1]);
                return app()->redirect( '/user/page1' );
            } else {
                return app()->redirect( '/public/page1' );
            }
        }
    }
}
