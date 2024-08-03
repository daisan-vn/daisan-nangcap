<?php

class Product_statis extends Admin {

    public function index() {
        $cat_ids = [11];
        $seller_ids = [];
        
        if (isset($cat_ids) && is_array($cat_ids)) {
            $cat_where_arr = [];
            $cat_list_sql = "SELECT id, lft, rgt FROM taxonomy WHERE type='product' AND id IN (".implode(',', $cat_ids).")";
            $cat_list = $this->pdo->fetch_all($cat_list_sql);
            foreach ($cat_list as $cat) {
                $cat_where_arr[] = "taxonomy.id={$cat['id']} OR (taxonomy.lft>={$cat['lft']} AND taxonomy.rgt<={$cat['rgt']})";
            }
            if ($cat_where_arr) {
                $cat_where = "INNER JOIN taxonomy ON (products.taxonomy_id=taxonomy.id AND taxonomy.type='product' AND (".implode(' OR ', $cat_where_arr)."))";
            }
        }

        $sql_product_list = "SELECT * FROM products {$cat_where} ORDER BY views DESC LIMIT 0,20";

        // var_dump($sql_product_list);
        //$product_list = $this->pdo->fetch_all($sql_product_list);

        $this->smarty->assign('product_list', $product_list);        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
}