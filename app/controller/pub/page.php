<?php
namespace Controller\Pub;

class Page extends \Controller\Page {

    function __construct() {
        $this->type = 'survey_public';
        $this->table_name = 'public_data';
        $this->total_page = 4;
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
        if ($page_number < 1) $page_number = 1;
        if ($page_number > $this->total_page) $page_number = $this->total_page;

        $this->current_page = $page_number;

        // 检查cookie
        if ( $this->current_page == 1 ) { // 首页如果用户没有cookie，设置cookie
            if (!isset($_COOKIE['_uid'])) {
                $this->_set_uid();
            }
        } else {
            if (!isset($_COOKIE['_uid'])) { // 非首页用户没有cookie，返回首页
                return app()->redirect( '/public/page1' );
            }
        }

        $view_file = 'pub/page'. $this->current_page;
        return render_view($view_file);
    }

    /**
     * 处理页面post提交调查数据
     *
     * @param integer $page_number
     */
    public function post($page_number) {
        // 验证页数
        if ( $page_number < 1 || $page_number > $this->total_page ) {
            return app()->redirect( '/public/page1' );
        }
        $this->current_page = $page_number;

        // 当前页的调查题目配置
        $survey_public = cfg( $this->type );
        $this->survey_cfg = $survey_public[ $this->current_page ];

        // 将用户post数据按照配置组装成调查数据
        $survey_data = $this->_build_survey_data( post() );

        // 检查用户数据有效性
        $error = $this->_check_validate( $survey_data );
        if ( $error ) {
            $view_file = 'pub/page'. $this->current_page;
            return render_view( $view_file, array('error'=>$error) );
        }

        // 将调查数据组装成数据库数据
        $db_data = $this->_build_db_data( $survey_data );

        // 将调查数据存入缓存
        $this->_save_to_cache( $db_data );

        // 不同的页数进行不同的处理 注意return
        switch( $page_number ) {
            case '1':
                return $this->_do_with_page1();
                break;
            case '2':
                return $this->_do_with_page2();
                break;
            case '3':
                return $this->_do_with_page3();
                break;
            case '4':
                return $this->_do_with_page4();
                break;
            default:
                return app()->redirect('/index');
                break;
        }
    }

    protected function _do_with_page1() {
        if ( isset($_POST['p_3']) && $_POST['p_3']['choice'][0]  == '1' ) { // 跳转到第2页
            return app()->redirect( '/public/page2' );
        }
        elseif ( isset($_POST['p_3']) && $_POST['p_3']['choice'][0] == '2' ) {  // 跳转到第3页
            return app()->redirect( '/public/page3' );
        } else {
            return app()->redirect( '/public/page2' );
        }
    }

    protected function _do_with_page2() {
        return app()->redirect( '/public/page4' );
    }

    protected function _do_with_page3() {
        return app()->redirect( '/public/page4' );
    }

    protected function _do_with_page4() {
        // 记录完成调查的时间
        $_SESSION['finish_time'] = date('Y-m-d H:i:s');

        // 保存用户调查数据
        $this->_save_to_db();

        // 清空session
        session_destroy();

        if ( isset($_POST['p_8']) && $_POST['p_8']['choice'][0] == '1' ) { // 盛大用户
            // 跳转到盛大登录界面
            if ( !isset( $_SESSION['snda_id'] ) ) {
                header("Location: https://pre.cas.sdo.com/cas/login?service=" . urlencode( 'http://snda.survey.net/user/vertify' ) );
            }
        } elseif ( isset($_POST['p_8']) && $_POST['p_8']['choice'][0] == '2' ) { // 非盛大用户
            // 跳转到首页
            return app()->redirect( '/index' );
        } else {
            // 跳转到盛大登录界面
            if ( !isset( $_SESSION['snda_id'] ) ) {
                header("Location: https://pre.cas.sdo.com/cas/login?service=" . urlencode( 'http://snda.survey.net/user/vertify' ) );
            }
        }
    }
}
