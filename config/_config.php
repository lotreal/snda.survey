<?php
return array(
    'app' => array(
        'view' => array(
            'view_dir' => ROOT_DIR .'/app/view',
        ),
        'router' => array(
            'rewrite' => array(
                '#^/public/page(\d+)#' => '\Controller\Pub\Page',
                '#^/user/page(\d+)#' => '\Controller\User\Page',
            ),
        ),
    ),
    'survey_public' => require_once ROOT_DIR .'/config/_survey_public.php',
    'survey_snda' => require_once ROOT_DIR .'/config/_survey_snda.php',
    'storage' => array(
        'pool' => array(
            'survey' => array(
                'class' => 'Lysine\Storage\DB\Adapter\Pgsql',
                'dsn' => 'pgsql: host=192.168.1.200 dbname=snda.diaocha',
                'user' => 'dev',
                'pass' => 'abc',
            ),
        ),
    ),
);
