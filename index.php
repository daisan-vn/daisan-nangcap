<?php

date_default_timezone_set('Asia/Ho_Chi_Minh');

define('__ROOT', realpath(__DIR__).'/');
define('__SHARED', __ROOT.'shared/');

require_once 'system/core.php';
require_once 'system/lib.php';

require_once 'configs/conf.php';

require_once 'system/app.php';
require_once 'system/user.php';

require_once(__SHARED. 'Lib/Smarty/Smarty.class.php');
