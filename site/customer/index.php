<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

ob_start();
session_start();

require_once '../../index.php';
require_once './controller/Customerbase.php';

$smarty = new Smarty();
$smarty->template_dir = "./view/layouts/";
$compile_dir = "./cache/";
if(!is_dir($compile_dir)) mkdir($compile_dir, 0777);
$smarty->compile_dir  = $compile_dir;
$smarty->config_dir   = 'configs/';
$smarty->debugging = false;
$smarty->caching = false;
$smarty->cache_lifetime = 120000;

//$_get = router_rewrire_url();
$mod = isset($_GET['mod']) ? $_GET['mod'] : "home";
$site = isset($_GET['site']) ? $_GET['site'] : "index";
$file = ucfirst($mod) . ".php";
$class = ucfirst($mod);

if(!is_file('./controller/' . $file))
	lib_redirect(DOMAIN);
require_once './controller/' . $file;

if(!method_exists($class, $site))
	lib_redirect(DOMAIN);
$use = new $class;
$use->$site();
ob_end_flush();