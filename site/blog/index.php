<?php

ini_set('display_errors', true);
error_reporting(E_ALL);

ob_start();
session_start();

require_once '../../index.php';
require_once './controller/Blog.php';

$smarty = new Smarty();
$smarty->template_dir = "./view/layouts/";
$compile_dir = "./cache/";
if(!is_dir($compile_dir)) mkdir($compile_dir, 0777);
$smarty->compile_dir  = $compile_dir;
$smarty->config_dir   = 'configs/';
$smarty->debugging = false;
$smarty->caching = false;
$smarty->cache_lifetime = 120000;

$lang = isset($_SESSION[SESSION_LANGUAGE_DEFAULT]) ? $_SESSION[SESSION_LANGUAGE_DEFAULT] : DEFAULT_LANGUAGE;
$login = isset($_SESSION[SESSION_LOGIN_DEFAULT]) ? $_SESSION[SESSION_LOGIN_DEFAULT] : 0;
//$login = isset($_COOKIE[COOKIE_LOGIN_ID]) ? $_COOKIE[COOKIE_LOGIN_ID] : 0;

if (strpos($_SERVER['HTTP_HOST'], 'blog') === 0) {
	$_get = $_GET;
}
else {
	$_get = router_rewrire_url();
}

$mod = isset($_get['mod']) ? $_get['mod'] : "home";
$site = isset($_get['site']) ? $_get['site'] : "index";

$tpl = "../" . $mod . "/" . $site . ".tpl";
$file = ucfirst($mod) . ".php";
$class = ucfirst($mod);

// var_dump($_get);

if(!is_file('./controller/' . $file))
	lib_redirect(DOMAIN);
require_once './controller/' . $file;

if(!method_exists($class, $site))
	lib_redirect(DOMAIN);
$use = new $class;
$use->$site();
ob_end_flush();