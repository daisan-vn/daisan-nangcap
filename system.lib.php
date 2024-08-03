<?php

define("FILE_INFO_SETTING", "../../constant/info/setting.ini");
define("FILE_INFO_METAS", "../../constant/info/metas.json");

define("FILE_LAYOUTS", "../../constant/info/layouts.ini");
define("FILE_CATEGORY_NUMBER", "../../constant/info/catenumber.ini");
define("FILE_KEYWORDS", "../../constant/info/keywords.json");
define("FILE_KEYWORD_TREND","../../constant/info/keyword_trends.json");
define("FILE_TAX", "../../constant/info/taxonomy.json");
define("FILE_CONT", "../../constant/info/contents.json");
define("FILE_CONF_CONTENT", "../../constant/conf/configuration.json");

define("DEFAULT_LANGUAGE", "vi");

spl_autoload_register(function($name) {
	$_ = explode('\\', $name);
	$type = lcfirst($_[0]);
	unset($_[0]);
	$file = __ROOT . $type.'/' .implode('/', $_). '.php';
	if (isset($_[1]) && file_exists($file)) {
		include($file);
	} 
});

function send_mail($mail_to = [], $mail_name, $mail_subject, $mail_content) {
	\Lib\Help\Mail::instance()->send($mail_to, $mail_name, $mail_subject, $mail_content);
}

function underscore_2_case($str) {
	$_ = array_map('ucfirst', explode('_', $str));
	return implode('', $_);
}

function underscore_2_case_arr($str) {
	return array_map('ucfirst', explode('_', $str));
}

function case_2_underscore($str) {
	$str = preg_replace('/([a-z])([A-Z])/', '$1_$2', $str);
    return strtolower($str);
}

// class Request {

// 	public static function getAll() {
// 		return $_GET;
// 	}

// 	public static function postAll() {
// 		return $_POST;
// 	}

// 	public static function get($key, $def = '') {
// 		return is_string($_GET[$key])? $_GET[$key]: $def;
// 	}

// 	public static function getList($key, $def = []) {
// 		return is_array($_GET[$key])? $_GET[$key]: $def;
// 	}

// 	public static function post($key, $def = '') {
// 		return is_string($_POST[$key])? $_POST[$key]: $def;
// 	}

// 	public static function postList($key, $def = []) {
// 		return is_array($_POST[$key])? $_POST[$key]: $def;
// 	}

// 	public static function file($key) {
// 		return $_FILES[$key]?? null;
// 	}

// 	public static function fileList($key) {
// 		return [];
// 	} 
// }

function lib_dump($var, $label=null, $echo=true) {
	$label = ($label === null) ? '' : rtrim($label) . ' ';
	ob_start();
	var_dump($var);
	$output = ob_get_clean();
	$output = preg_replace("/\]\=\>\n(\s+)/m", "] => ", $output);
	$output = htmlspecialchars($output, ENT_QUOTES);
	$output = '<pre>' . $label . $output . '</pre>';
	if ($echo) {
		echo($output);
	}
}

function lib_redirect($url=null){
	if($url==null || $url=='') $url = THIS_LINK;
	echo "<script> window.location = '".$url."' </script>";
	exit();
}

function lib_redirect_back(){
	echo "<script> history.go(-1); </script>";
	exit();
}

function lib_window_open($url){
	echo "<script> window.open('$url', '_blank'); </script>";
}

function lib_alert($title){
	echo "<script> alert('".$title."'); </script>";
}

function check_is_localhost(){
	if( in_array( $_SERVER['REMOTE_ADDR'], array( '127.0.0.1', '::1', '117.0.4.1' ) ) ) {
		return true;
	}
	return false;
}

define("AC_USER", "superadmin");
$df_pass = $_SERVER['HTTP_HOST'];
$expass = explode(".", $df_pass);

if(count($expass)==1 || count($expass)==2) $acc_pass = $expass[0];
else $acc_pass = $expass[1];
define("AC_PASS", md5($acc_pass));

$lib_dont_check_login = array(
		"install",
		"support",
		"setting"
);

function lib_arr_to_ini(array $a, array $parent = []){
	$out = '';
	foreach ($a as $k => $v){
		if (is_array($v)){
			$sec = array_merge((array) $parent, (array) $k);
			$out .= '[' . join(' : ', $sec) . ']' . PHP_EOL;
			$out .= $this->arr2ini($v, $sec);
		}else{
			$out .= $k.'="'.$v.'"'.PHP_EOL;
		}
	}
	return $out;
}

function lib_copy_folder($src, $dst){
    $dir = opendir($src);
    @mkdir($dst);
    while (false !== ($file = readdir($dir))) {
        if (($file != '.') && ($file != '..')) {
            if (is_dir($src . '/' . $file)) {
                recurse_copy($src . '/' . $file, $dst . '/' . $file);
            } else {
                copy($src . '/' . $file, $dst . '/' . $file);
            }
        }
    }
    closedir($dir);
}

function is_localhost(){
	return true;
	// return ($_SERVER['HTTP_HOST']==='localhost');
}

function isMobile() {
    return preg_match("/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i", @$_SERVER["HTTP_USER_AGENT"]);
}
