<?php

ini_set('display_errors', true);
error_reporting(E_ALL);

session_start();

require_once '../../index.php';
require_once './controller/Blog.php';

$smarty = new \Smarty();
$smarty->template_dir = "./view/layouts/";
$compile_dir = "./cache/";
if(!is_dir($compile_dir)) mkdir($compile_dir, 0777);
$smarty->compile_dir  = $compile_dir;
$smarty->config_dir   = 'configs/';
$smarty->debugging = false;
$smarty->caching = false;
$smarty->cache_lifetime = 120000;

$lang = \App::getUserLang();
$login = \Auth::getUserLogin();

if (strpos($_SERVER['HTTP_HOST'], 'blog') === 0) {
	$route = $_GET;
}
else {
	$route = router_rewrire_url();
}

$mod = $route['mod'] ?? 'home';
$site = $route['site'] ?? 'index';

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
