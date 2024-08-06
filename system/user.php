<?php

class Auth {

    protected static $is_login;

    public static function isUserLogin() {
        if (!static::$is_login) {
            static::$is_login = static::checkUserLogin();
        }
        return static::$is_login;
    }

    public static function checkUserLogin() {
        return isset($_SESSION[SESSION_LOGIN_DEFAULT]) ? $_SESSION[SESSION_LOGIN_DEFAULT] : 0;
    }
}