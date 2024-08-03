<?php

namespace Repo;

class Main {

    use \Lib\Singleton;

    protected $db, $event;

    protected function __construct() {
        $this->db = \Lib\DB::instance();
        $this->event = \Lib\Event::instance();
    }
}