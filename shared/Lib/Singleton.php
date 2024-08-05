<?php

namespace Lib;

trait Singleton {

    private static $_map = [];

    protected function __construct() {}

    public static function instance() {
        $name = get_called_class();
        if (empty(self::$_map[$name])) {
            self::$_map[$name] = new static();
        }
        return self::$_map[$name];
    }

}
