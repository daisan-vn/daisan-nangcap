<?php

class Scanv2 extends Admin {

    function repeat() {

        $this->smarty->assign('categories', $this->taxonomy->get_select_taxonomy('product', 0, 0, null, '-- Chọn danh mục --'));

        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function repeat_start_scan() {
        $cat_id = $_POST['cat_id'] ?? 0;
        $page_id = $_POST['page_id'] ?? 0;
        
        var_dump($tax_id, $page_id);

    }
}