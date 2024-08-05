<?php

class App {

    protected static $lang;

    public static function getLang() {
        return isset($_SESSION[SESSION_LANGUAGE_DEFAULT]) ? $_SESSION[SESSION_LANGUAGE_DEFAULT] : DEFAULT_LANGUAGE;
    }
}