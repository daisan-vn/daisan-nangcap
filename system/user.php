<?php

class Auth {

    protected static $user_data = [], $admin_data = [];

    // chuẩn hóa các biến SESSION, COOKIE vào class Auth

    public static function setUserData($data = []) {
        static::$user_data = $data;
    }

    public static function getUserData() {
        return static::$user_data;
    }

    public static function setAdminData($data = []) {
        static::$admin_data = $data;
    }

    public static function getAdminData() {
        return static::$admin_data;
    }

    public static function getUserLogin() {
        return isset($_SESSION[SESSION_LOGIN_DEFAULT]) ? $_SESSION[SESSION_LOGIN_DEFAULT] : 0;
    }

    public static function setUserLogin($userId, $data = []) {
        $_SESSION[SESSION_LOGIN_DEFAULT] = $userId;
    }

    public static function logoutUser() {
        if (isset($_SESSION[SESSION_LOGIN_DEFAULT])) {
            unset($_SESSION[SESSION_LOGIN_DEFAULT]);
        }
    }

    public static function getAdminLogin() {
        return isset($_SESSION[SESSION_LOGIN_ADMIN]) ? $_SESSION[SESSION_LOGIN_ADMIN] : 0;
    }

    public static function setAdminLogin($adminId, $data = []) {
        $_SESSION[SESSION_LOGIN_ADMIN] = $adminId;
    }

    public static function logoutAdmin() {
        if (isset($_SESSION[SESSION_LOGIN_ADMIN])) {
            unset($_SESSION[SESSION_LOGIN_ADMIN]);
        }
    }

    public static function getPageManager() {
        return empty($_SESSION[SESSION_PAGEID_MANAGER]) ? []: $_SESSION[SESSION_PAGEID_MANAGER];        
    }

    public static function setPageManager($data = []) {
        $_SESSION[SESSION_PAGEID_MANAGER] = $data;
    }

    public static function logoutPageManager() {
        if (isset($_SESSION[SESSION_PAGEID_MANAGER])) {
            unset($_SESSION[SESSION_PAGEID_MANAGER]);
        }
    }
}