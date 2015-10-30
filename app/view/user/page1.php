<?php $this->extend('_layouts/default'); ?>

<?php $this->block('main'); ?>
<div class="page">
    <h2>盛大用户调查第一页</h2>
    <div class="post_error"><pre><?php if( isset( $error ) ) print_r($error); ?></pre></div>
    <form name="form" method="post">
        <ul>
<?php
    $page = 1;
    $survey_user = cfg('survey_snda');

    foreach ( $survey_user[ $page ] as $id => $cfg ) {
        if ( $cfg[ 'type' ] == 'text' ) { // 填空
            if ( $cfg[ 'form_type' ] == 'input' ) {
                $this->includes( '_element/input', array ( 'cfg' => $cfg ) );
            }
            elseif ( $cfg[ 'form_type' ] == 'textarea' ) {
                $this->includes( '_element/textarea', array ( 'cfg' => $cfg ) );
            }
        }
        elseif ( $cfg[ 'type' ] == 'select' ) { // 选择提
            $this->includes( '_element/select', array ( 'cfg' => $cfg ) );
        }
        elseif ( $cfg[ 'type' ] == 'matrix' ) { // matrix类型
            $this->includes( '_element/matrix', array ( 'cfg' => $cfg ) );
        }
    }
?>

        </ul>
        <div><input type="submit" name="submit" value="提交" /></div>
    </form>
</div>
<?php $this->endblock(); ?>

<?php $this->block('javascript'); ?>
<script type="text/javascript">
var survey_config = <?php echo json_encode($survey_user[ $page ]); ?>
</script>
<?php $this->endblock(); ?>