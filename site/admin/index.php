<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

ob_start();
session_start();

require_once '../../index.php';
require_once 'controller/Admin.php';

$smarty = new \Smarty();
$smarty->template_dir = "./view/layouts/";
$compile_dir = "cache/";
if(!is_dir($compile_dir)) mkdir($compile_dir, 0777);
$smarty->compile_dir  = $compile_dir;
$smarty->config_dir   = 'configs/';
$smarty->debugging = false;
$smarty->caching = false;
$smarty->cache_lifetime = 120000;

if(!isset($_SESSION[SESSION_LANGUAGE_ADMIN])){
	$_SESSION[SESSION_LANGUAGE_ADMIN] = DEFAULT_LANGUAGE;
}

$lang = isset($_SESSION[SESSION_LANGUAGE_ADMIN]) ? $_SESSION[SESSION_LANGUAGE_ADMIN] : DEFAULT_LANGUAGE;
$login = isset($_SESSION[SESSION_LOGIN_ADMIN]) ? intval($_SESSION[SESSION_LOGIN_ADMIN]) : 0;

$location = isset($_SESSION[SESSION_LOCATION_ID]) ? intval($_SESSION[SESSION_LOCATION_ID]) : 0;

$mod = isset($_GET['mod']) ? $_GET['mod'] : "home";
$site = isset($_GET['site']) ? $_GET['site'] : "index";
if($login == 0 && !in_array($mod, $lib_dont_check_login)){
	$mod = "account";
	$site = "login";
}

$tpl = "../" . $mod . "/" . $site . ".tpl";
$file = ucfirst($mod) . ".php";
$class = ucfirst($mod);

require_once './controller/' . $file;
$use = new $class;
$use->$site();
ob_end_flush();