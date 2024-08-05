<?php

namespace Repo;

class Taxonomy extends \Repo\Main {

    public function getTaxsForSearch($ids, $type = 'product') {
        $in_clause = implode(',', $ids);
        $sql = "SELECT id, lft, rgt FROM taxonomy WHERE type='{$type}' AND id IN ({$in_clause})";
        return $this->db->fetch_all($sql);
    }
}