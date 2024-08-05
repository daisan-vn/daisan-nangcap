<?php

class Auth {

    protected static $is_login;

    public static function isLogin() {
        if (!static::$is_login) {
            static::$is_login = static::checkLogin();
        }
        return static::$is_login;
    }

    public static function checkLogin() {
        return isset($_SESSION[SESSION_LOGIN_DEFAULT]) ? $_SESSION[SESSION_LOGIN_DEFAULT] : 0;
    }
}