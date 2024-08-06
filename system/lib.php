<?php

define('SUPER_ADMIN', 'superadmin');

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

$lib_dont_check_login = array(
	'install',
	'support',
);

function get_ssl_page($url) {
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_REFERER, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	$result = curl_exec($ch);
	curl_close($ch);
	return $result;
}


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
	return in_array($_SERVER['REMOTE_ADDR'], ['127.0.0.1']);
}

function isMobile() {
	static $res;
	if (!$res) {
		$res = preg_match("/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i", $_SERVER["HTTP_USER_AGENT"]); 
	}
	return $res;
}
