<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

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

$location = \App::getLocation();

$lang = \App::getAdminLang();
$login = \Auth::getAdminLogin();

$mod = $_GET['mod']?? 'home';
$site = $_GET['site']?? 'index';

\App::setMod($mod);
\App::setSite($site);

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
