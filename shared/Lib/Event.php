<?php

namespace Lib;

class Event {

    use \Lib\Singleton;

    protected $map = [];

    public function add($event, $name, $action) {
        $this->map[$event][$name] = $action;
    }

    public function remove($event, $name) {
        if (isset($this->map[$event][$name])) {
            unset($this->map[$event][$name]);
        }
    }

    public function notify($event, $data, ...$param) {
        $events = $this->map[$event]?? [];
        foreach ($events as $event) {
            $obj = new $event();
            $obj->handle($data, ...$param);
        }
    }
}