<?php
namespace Controller\User;

class Page extends \Controller\Page {

    function __construct() {
        $this->type = 'survey_snda';
        $this->table_name = 'user_data';
        $this->total_page = 1;
    }

    public function beforeRun( $args ) {
        session_start();
        if ( !isset($_SESSION['start_time']) ) $_SESSION['start_time'] = date('Y-m-d H:i:s');
        if ( !isset($_SESSION['ip']) ) $_SESSION['ip'] = getIp();
    }

    /**
     * 处理页面get请求
     *
     * @param integer $page_number
     */
    public function get($page_number) {

        if ( !isset( $_SESSION[ 'snda_id' ] ) ) {
            return app()->redirect( '/public/page1' );
        }

        if ($page_number < 1) $page_number = 1;
        if ($page_number > $this->total_page) $page_number = $this->total_page;

        $this->current_page = $page_number;

        // 检查cookie
        if ( $this->current_page == 1 ) {
            if (!isset($_COOKIE['_uid'])) {
                $this->_set_uid();
            }
        } else {
            if (!isset($_COOKIE['_uid'])) return app()->redirect( '/user/page1' );
        }

        $view_file = 'user/page'. $this->current_page;
        return render_view($view_file);
    }

    /**
     * 处理页面post提交调查数据
     *
     * @param integer $page_number
     */
    public function post($page_number) {

        if ( !isset( $_SESSION[ 'snda_id' ] ) ) {
            return app()->redirect( '/public/page1' );
        }

        if ( $page_number < 1 || $page_number > $this->total_page ) {
            return app()->redirect( '/public/page1' );
        }

        $this->current_page = $page_number;

        // 当前页的调查题目配置
        $survey_user = cfg( $this->type );
        $this->survey_cfg = $survey_user[ $this->current_page ];

        // 将用户post数据按照配置组装成调查数据
        $survey_data = $this->_build_survey_data( post() );

        // 检查用户数据有效性
        $error = $this->_check_validate( $survey_data );
        if ( $error ) {
            $view_file = 'user/page'. $this->current_page;
            return render_view( $view_file, array('error'=>$error) );
        }

        // 将调查数据组装成数据库数据
        $db_data = $this->_build_db_data( $survey_data );

        // 将调查数据存入缓存
        $this->_save_to_cache( $db_data );

        switch( $page_number ) {
            case '1':
                return $this->_do_with_page1();
                break;
            default:
                return app()->redirect('/index');
                break;
        }
    }

    protected function _do_with_page1() {
        // 记录完成调查的时间
        $_SESSION['finish_time'] = date('Y-m-d H:i:s');

        // 保存用户调查数据
        $this->_save_to_db();

        // 清空session
        session_destroy();

        return app()->redirect( '/index' );
    }
}