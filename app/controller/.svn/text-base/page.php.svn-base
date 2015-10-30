<?php
namespace Controller;

class Page {

    // 调查种类
    protected $type;

    // 数据库表名
    protected $table_name;

    // 总页数
    protected $total_page;

    // 当前页
    protected $current_page;

    // 当前页的题目配置
    protected $survey_cfg;

    /**
     * 根据调查配置组装调查数据
     *
     * @param array $post POST数据
     */
    protected function _build_survey_data( $post ) {
        $cfg = $this->survey_cfg;
        if ( !$cfg ) return false;

        $survey_data = array();

        $ids = array_keys( $cfg ); // 各题目的编号

        // loop 每个题目配置
        foreach ( $ids as $id ) {
            if ( isset( $post[ $id ] ) && !empty( $post[ $id ] ) ) {
                if ( is_array( $post[ $id ] ) ) {
                    if ( $cfg[ $id ][ 'type' ] == 'select' && !isset( $post[ $id ][ 'choice' ] ) ) { // 如果是一般的选择题
                        $survey_data[ $id ] = null;
                    } else {
                        $survey_data[ $id ] = $post[ $id ];
                    }
                } else {
                    $survey_data[ $id ] = $post[ $id ];
                }
            }
            else {
                $survey_data[ $id ] = null;
            }
        }

        return $survey_data;
    }

    /**
     * 将调查数据组装成数据库数据
     *
     * @param array $survey_data
     */
    protected function _build_db_data( $survey_data ) {
        $cfg = $this->survey_cfg;
        if ( !$cfg ) return false;

        $db_data = array();

        foreach ( $survey_data as $id => $data ) {
            if ( $data == null ) {
                $db_data[ $id ] = null;
                continue;
            }

            // 填空题
            if ( $cfg[ $id ][ 'type' ] == 'text' ) {
                $db_data[ $id ] = $this->_buile_text( $data );
            }
            // 选择题
            elseif ( $cfg[ $id ][ 'type' ] == 'select' ) {
                $db_data[ $id ] = $this->_buile_select( $id, $data );

                // 如果选择题可以填写附加内容
                if ( isset( $cfg[ $id ][ 'allow_specify' ] ) ) {
                    $db_data[ $id . 's' ] = $this->_buile_select_specify( $id, $data ); // 数据库字段名定义为 p_1s格式
                }
            }
            // 组合选择题
            elseif ( $cfg[ $id ][ 'type' ] == 'matrix' ) {
                 $return = $this->_buile_matrix( $id, $data );
                 if ( $return ) {
                    foreach ( $return as $k => $v ) {
                        $db_data[ $k ] = $v;
                    }
                 }
            }
        }

        return $db_data;
    }

    /**
     * 填空题数据库数据构造
     *
     * @param <type> $data
     */
    protected function _buile_text( $data ) {
        return trim( $data );
    }

    /**
     * 选择题数据库数据构造
     *
     * @param <type> $data
     */
    protected function _buile_select( $id, $data ) {
        $cfg = $this->survey_cfg;
        if ( !$cfg ) return null;

        $value = null; // 返回值

        if ( $cfg[ $id ][ 'form_type' ] == 'radio' || $cfg[ $id ][ 'form_type' ] == 'select') { // 单选题 暂定下拉框只能单选
            $value = $data['choice'][ 0 ];
        }
        elseif( $cfg[ $id ][ 'form_type' ] == 'checkbox' ) { // 多选题
            $value = pg_encode_array( $data['choice'] );
        }

        return $value;
    }

    /**
     * 选择题填写附加内容数据库数据构造
     *
     * @param <type> $id
     * @param <type> $data
     */
    protected function _buile_select_specify( $id, $data ) {
        $cfg = $this->survey_cfg;
        if ( !$cfg ) return null;

        $value = null; // 返回值

        if ( $cfg[ $id ][ 'form_type' ] == 'radio' ) { // 单选题
            $k = $data['choice'][ 0 ];
            $value = pg_encode_hstore( array( $k => $data['specify'][ $k ] ) );
        }
        elseif( $cfg[ $id ][ 'form_type' ] == 'checkbox' ) { // 多选题
            $value = pg_encode_hstore( $data['specify'] );
        }

        return $value;
    }

    /**
     * 组合选择题数据库数据构造
     *
     * @param string $id
     * @param array $data
     * @return array  array( 数据库字段名 => 值, 数据库字段名 => 值... )
     */
    protected function _buile_matrix( $id, $data ) {
        $cfg = $this->survey_cfg;
        if ( !$cfg ) return null;

        $value = array(); // 返回值

        if ( $cfg[ $id ][ 'form_type' ] == 'radio' ) { // 单选题
            foreach ( $cfg[ $id ][ 'options' ][ 'row' ] as $k => $v ) {
                if ( isset( $data[ $k ] ) && $data[ $k ] ) {
                    $value[ $id . $k ] = $data[ $k ][0];
                }
            }
        }
        elseif ( $cfg[ $id ][ 'form_type' ] == 'checkbox' ) { // 多选题
            foreach ( $cfg[ $id ][ 'options' ][ 'row' ] as $k => $v ) {
                if ( isset( $data[ $k ] ) && $data[ $k ] ) {
                    $value[ $id . $k ] = pg_encode_array( $data[ $k ] );
                }
            }
        }

        return $value;
    }

    /**
     * 检查用户提交数据有效性
     *
     * @param array $survey_data
     */
    protected function _check_validate( $survey_data ) {
        $error = array();

        foreach ( $this->survey_cfg as $id => $cfg ) {

            // 必填项
            if ( isset( $cfg['require'] ) && $cfg['require'] ) {
                if ( empty( $survey_data[ $id ] ) ) {
                    $error['require'][ $id ] = '请填入' . $cfg['subject'] ;
                }
            }

            // 有效性
            if ( isset( $cfg['validate'] ) && $cfg['validate'] ) {
                switch ( $cfg['validate'] ) {
                    case 'Chinese':
                        $msg = check_chinese( $survey_data[ $id ] );
                        if ( $msg ) {
                            $error['validate'][ $id ] = $msg;
                        }
                        break;
                    case 'Email':
                        $msg = check_email( $survey_data[ $id ] );
                        if ( $msg ) {
                            $error['validate'][ $id ] = $msg;
                        }
                        break;
                        break;
                    // 增加其他判断
                    default:
                        break;
                }
            }
        }

        return $error;
    }

    /**
     * 将数据库数据存入缓存
     *
     * @param array $survey_data
     */
    protected function _save_to_cache( $db_data ) {
        $_SESSION[ $this->type ][ $this->current_page ] = $db_data;
    }

    /**
     * 将数据库数据存入数据库
     *
     * @param array $db_data
     */
    protected function _save_to_db() {
        if ( $_SESSION ) {

            $row['sn'] = uuid();
            $row['cookie'] = $_COOKIE['_uid'];

            if ( !$row['cookie'] ) {
                return false;
            }

            foreach ( $_SESSION as $k => $v ) {
                if ( $k == $this->type ) {
                    foreach ( $v as $page => $post_data ) {
                        foreach ( $post_data as $id => $value) {
                            $row[$id] = $value;
                        }
                    }
                } else {
                    $row[$k] = $v;
                }
            }

            $affected = storage('survey')->insert('survey.' . $this->table_name, $row);
        }
    }

    /**
     * 设置用户cookie
     */
    protected function _set_uid() {
        setcookie('_uid', uuid(), (time() + 3600 * 24 * 365), '/');
    }
}
