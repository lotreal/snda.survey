<?php
use Lysine\Error;
use Lysine\HttpError;
use Lysine\MVC\Response;

function render_view($view_name, array $vars = null) {
    static $render;
    if (!$render) $render = new Lysine\MVC\View(cfg('app', 'view'));

    return $render->reset()->render($view_name, $vars);
}

function __on_exception($exception) {
    $code = $exception instanceof HttpError
          ? $exception->getCode()
          : 500;
    header(Response::httpStatus($code));

    if (in_array('application/json', req()->acceptTypes())) {
        $response = array(
            'message' => $exception->getMessage(),
            'code' => $exception->getCode(),
        );
        if ($exception instanceof Error) $response = array_merge($response, $exception->getMore());
        echo json_encode($response);
    } else {
        require_once ROOT_DIR .'/public/_error/500.php';
    }

    die($code);
}

function __on_error($errno, $errstr, $errfile, $errline, $errcontext) {
    throw new Error($errstr, $errno, null, array(
        'file' => $errfile,
        'line' => $errline,
    ));
}

function getIp(){
    $private_net_ip_masks = array('10.0.0.', '192.168.', '127.0.0.', '172.16.0.');
    $ipStrings = array();

    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ipStrings = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
    }

    if (!empty($_SERVER['REMOTE_ADDR'])) {
        $ipStrings[] = $_SERVER['REMOTE_ADDR'];
    }

    foreach ($ipStrings as $k1 => $ip) {
        if (empty($ip)) { unset($ipStrings[$k1]); continue; }

//        // 清除内网地址
//        foreach ($private_net_ip_masks as $k2 => $pip) {
//            if(strpos($ip, $pip) === 0){ // local ip
//                unset($ipStrings[$k1]);
//                break;
//            }
//        }
    }

    return empty($ipStrings) ? '0.0.0.0' : array_shift($ipStrings);
}

function uuid() {
    return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff),
        mt_rand(0, 0x0fff) | 0x4000,
        mt_rand(0, 0x3fff) | 0x8000,
        mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
    );
}

function check_chinese( $str ) {
    if ( !preg_match( "/^[\x{4e00}-\x{9fa5}]+$/u", $str ) ) {
        return '请输入中文字符！';
    }
}

function check_email( $str ) {
    if ( !preg_match( "/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(?:[a-zA-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/", $str ) ) {
        return '请输入正确的Email地址！';
    }
}
