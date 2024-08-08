<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

session_start();

require_once '../../index.php';
require_once './controller/Pageadmin.php';

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

$lang = \App::getUserLang();
$login = \Auth::getUserLogin();

if (!$login && !\Auth::getAdminLogin()) {
	lib_redirect(DOMAIN);
}

$mod = $_GET['mod']?? 'home';
$site = $_GET['site']?? 'index';

\App::setMod($mod);
\App::setSite($site);

$tpl = "../" . $mod . "/" . $site . ".tpl";
$file = ucfirst($mod) . ".php";
$class = ucfirst($mod);

if(!is_file('./controller/' . $file)) lib_redirect(DOMAIN);
require_once './controller/' . $file;

if(!method_exists($class, $site)) lib_redirect(DOMAIN);

$use = new $class;
$use->$site();
