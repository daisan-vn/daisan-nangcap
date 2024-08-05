<?php

namespace Lib;

class Arr {

    public static function toArrayIds($ids) {
        return array_filter(is_array($ids)? array_map('intval', $ids): [intval($ids)], function($id) { return $id > 0; });
    }
}