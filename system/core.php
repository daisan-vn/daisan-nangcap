<?php

spl_autoload_register(function($name) {
	$_ = explode('\\', $name);
	$file = __SHARED .implode('/', $_). '.php';
	if (isset($_[1]) && file_exists($file)) {
		include($file);
	} 
});

class Request {

	public static function getAll() {
		return $_GET;
	}

	public static function postAll() {
		return $_POST;
	}

	public static function get($key, $def = '') {
		return is_string($_GET[$key])? $_GET[$key]: $def;
	}

	public static function getList($key, $def = []) {
		return is_array($_GET[$key])? $_GET[$key]: $def;
	}

	public static function post($key, $def = '') {
		return is_string($_POST[$key])? $_POST[$key]: $def;
	}

	public static function postList($key, $def = []) {
		return is_array($_POST[$key])? $_POST[$key]: $def;
	}

	public static function file($key) {
		return $_FILES[$key]?? null;
	}
}