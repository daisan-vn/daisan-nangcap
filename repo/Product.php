<?php

namespace Repo;

class Product extends \Repo\Main {

    public function getProductsFromIds($ids) {
        $in_clause = implode(',', $ids);
        $sql = "SELECT * FROM products
            WHERE id IN({$in_clause})
            ORDER BY FIELD({$in_clause})
            LIMIT 1
        ";
        $product_list = $this->db->fetch_all($sql);
        foreach ($product_list as &$item) {

        }
        return $product_list;
    }

    public function create($data) {
        $this->event->notify('product_create', $data);
    }

    public function update($data, $where) {
        $id = 0; //
        $this->event->notify('product_update', $data, $id);
    }

    public function remove($where) {
        $id = 0; //
        $this->event->notify('product_remove', $id);
    }
}