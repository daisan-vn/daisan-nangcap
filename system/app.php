<?php

class App {

    protected static $lang, $mod, $site, $param = [];

    public static function getUserLang() {
        return isset($_SESSION[SESSION_LANGUAGE_DEFAULT]) ? $_SESSION[SESSION_LANGUAGE_DEFAULT] : DEFAULT_LANGUAGE;
    }

    public static function getAdminLang() {
        return isset($_SESSION[SESSION_LANGUAGE_ADMIN]) ? $_SESSION[SESSION_LANGUAGE_ADMIN] : DEFAULT_LANGUAGE;
    }

    public static function getLocation() {
        return isset($_SESSION[SESSION_LOCATION_ID]) ? intval($_SESSION[SESSION_LOCATION_ID]) : 0;
    }

    public static function getMod() {
        return static::$mod;
    }

    public static function setMod($mod) {
        static::$mod = $mod;
    }

    public static function getSite() {
        return static::$site;
    }

    public static function setSite($site) {
        static::$site = $site;
    }

    public static function getParam($key, $default = '') {
        return static::$param[$key] ?? $_REQUEST[$key] ?? $default;
    }

    public static function setParam($key, $value) {
        static::$param[$key] = $value;
    }
}