<?php

class Product extends Pageadmin
{
    private $cate_type;
    
    function __construct()
    {
        parent::__construct();
        $this->cate_type = "service";
        $a_menu = array('index' => "Tất cả sản phẩm", 'mains' => "Sản phẩm showcase", 'imports' => 'Sản phẩm nhập khẩu','wholesaler' => 'Sản phẩm phân phối', 'create' => "Thêm sản phẩm",);
        $this->get_pagemenu($a_menu);
        $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=" . $this->profile['package_id']);
        $this->smarty->assign('package', $package);
    }
    
    function index()
    {
        global $login, $lang;
        
        $out = [];
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'copy_product') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $product = $this->pdo->fetch_one("SELECT * FROM products WHERE id=$id");
            $productprices = $this->pdo->fetch_all("SELECT * FROM productprices WHERE product_id=$id ORDER BY id");
            $productmetas = $this->pdo->fetch_all("SELECT * FROM productmetas WHERE product_id=$id ORDER BY id");
            unset($product['id']);
            $product['name'] = trim(@$_POST['name']);
            $product['images'] = '';
            $product['status'] = 0;
            $product['created'] = time();
            $product['user_id'] = $login;
            $product['views'] = 1;
            $product['score'] = 0;
            $product_id = 0;
            if ($product_id = $this->pdo->insert('products', $product)) {
                foreach ($productprices as $item) {
                    $data['product_id'] = $product_id;
                    $data['version'] = $item['version'];
                    $data['price'] = $item['price'];
                    $this->pdo->insert('productprices', $data);
                    unset($data);
                }
                foreach ($productmetas as $item) {
                    $data['product_id'] = $product_id;
                    $data['meta_key'] = $item['meta_key'];
                    $data['meta_value'] = $item['meta_value'];
                    $this->pdo->insert('productmetas', $data);
                    unset($data);
                }
            }
            echo $product_id;
            exit();
        }
        $key = isset($_GET['key']) ? $_GET['key'] : null;
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $category = isset($_GET['category']) ? $_GET['category'] : 0;
        $where = "a.page_id=" . $this->page_id;
        if ($key != null) $where .= " AND a.name LIKE '%$key%'";
        if ($status != -1) $where .= " AND a.status=$status";
        if ($category != 0) $where .= " AND a.taxonomy_id=$category";
        $sql = "SELECT a.id,a.name,a.images,a.status,a.ismain,a.isimport,a.iswhole,a.views,a.score,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price,
				(SELECT SUM(number) FROM productorderitems i WHERE i.page_id=a.page_id AND i.product_id=a.id) AS orders,
                (SELECT type FROM pages s WHERE s.id=a.page_id) AS pagetype FROM products a WHERE $where ORDER BY a.id DESC";
        
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['url_edit'] = "?mod=product&site=editdetail&id=" . $item['id'];
            $item['url_edit_cate'] = "?mod=product&site=create&id=" . $item['id'];
            $item['status'] = $this->product->status[$item['status']];
            $item['url'] = $this->product->get_url($item['id'], $item['name']);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=" . $this->profile['package_id']);
        $limit_push_top = isset($package['limit_push_top']) ? intval($package['limit_push_top']): 5;;
        $sum_click_top_day = $this->pdo->fetch_all("SELECT SUM(count_click) as sum_click FROM page_push_tops WHERE page_id = " . $this->page_id. "
            AND created_at >= " . "'" . date("Y-m-d 00:00:00", time()) . "'" . ' AND created_at < ' . "'" .date("Y-m-d 23:59:59", time()). "'");
        $sum_click_top_day = !empty($sum_click_top_day[0]) ? $sum_click_top_day[0]['sum_click'] : 0;
        
        $a_pagecategory = $this->taxonomy->get_product_category_ofpage($this->page_id);
        $a_category = [];
        foreach ($a_pagecategory as $k => $item) {
            $a_category[$item['id']] = $item['name'];
        }
        
        $list_product_top_day = $this->pdo->fetch_all("SELECT product_id FROM page_push_tops WHERE page_id = " . $this->page_id. "
            AND created_at >= " . "'" . date("Y-m-d 00:00:00", time()) . "'" . ' AND created_at < ' . "'" .date("Y-m-d 23:59:59", time()). "'");
        $product_id_arr = [];
        foreach ($list_product_top_day AS $k=>$item){
            $product_id_arr[$item['product_id']] = true;
        }
        $out['limit_push_top'] = $limit_push_top;
        $out['count_product_top'] = !empty($sum_click_top_day) ? $sum_click_top_day : 0;
        $out['select_category'] = $this->help->get_select_from_array($a_category, $category, "Chọn danh mục");
        $out['select_status'] = $this->help->get_select_from_array($this->product->status, $status, "Chọn trạng thái");
        $out['key'] = $key;
        //        echo '<pre>';
        //        print_r($product_id_arr);
        //        echo '</pre>';die;
        $this->smarty->assign('product_id_arr', $product_id_arr);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function odooproduct()
    {
        global $login, $lang;
        $out = [];
        
        $key = isset($_GET['key']) ? $_GET['key'] : null;
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $category = isset($_GET['category']) ? $_GET['category'] : 0;
        $where = "a.page_id=" . $this->page_id;
        if ($key != null) $where .= " AND a.name LIKE '%$key%'";
        if ($status != -1) $where .= " AND a.status=$status";
        if ($category != 0) $where .= " AND a.taxonomy_id=$category";
        $sql = "SELECT a.id,a.name,a.description,a.images,a.status,a.ismain,a.isimport,a.iswhole,a.views,a.score,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price,
				(SELECT SUM(number) FROM productorderitems i WHERE i.page_id=a.page_id AND i.product_id=a.id) AS orders,
                (SELECT type FROM pages s WHERE s.id=a.page_id) AS pagetype FROM products a WHERE $where ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 60);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['url_edit'] = "?mod=product&site=editdetail&id=" . $item['id'];
            $item['url_edit_cate'] = "?mod=product&site=create&id=" . $item['id'];
            $item['status'] = $this->product->status[$item['status']];
            $item['url'] = $this->product->get_url($item['id'], $item['name']);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    function mains()
    {
        global $login, $lang;
        
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'push_top_product') {
            $id = intval(@$_POST['id']);
            $data['product_id'] = $_POST['product_id'];
            $rt['code'] = 0;
            
            $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=" . $this->profile['package_id']);

            $sum_click_top_day = $this->pdo->fetch_all("SELECT SUM(count_click) as sum_click FROM page_push_tops WHERE page_id = " . $this->page_id. "
            AND created_at >= " . "'" . date("Y-m-d 00:00:00", time()) . "'" . ' AND created_at < ' . "'" .date("Y-m-d 23:59:59", time()). "'");
            $sum_click_top_day = !empty($sum_click_top_day[0]) ? $sum_click_top_day[0]['sum_click'] : 0;
            
            //            $query = $this->pdo->fetch_all("SELECT id, page_id, created_at FROM page_push_tops WHERE page_id = " . $this->page_id. " ORDER BY id ASC LIMIT 1");
            //            $this->pdo->query("DELETE FROM page_push_tops WHERE page_id=" . $this->page_id. "
            //             AND created_at < " . "'" . date("Y-m-d 00:00:00", time()) . "'");
            
            $limit_push_top = isset($package['limit_push_top']) ? intval($package['limit_push_top']): 5;
            //            $count_product_top_day = $this->pdo->count_item('page_push_tops', 'page_id=' . $this->page_id. "
            //            AND created_at >= " . "'" . date("Y-m-d 00:00:00", time()) . "'" . ' AND created_at < ' . "'" .date("Y-m-d 23:59:59", time()). "'");
            
            $count_product_top_all = $this->pdo->count_item('page_push_tops', 'page_id=' . $this->page_id);
            
            if ($sum_click_top_day >= $limit_push_top) {
                $rt['msg'] = 'Số lượng sản phẩm đẩy top đã đạt tối đa';
            } else {
                // delete page_push_tops
                if ($count_product_top_all > 1000) {
                    $this->pdo->query("DELETE FROM page_push_tops WHERE page_id=" . $this->page_id. " ORDER BY id ASC LIMIT 1");
                }
                // check tồn tại sản phẩm đã push top
                $check_product = $this->pdo->count_rows( "SELECT id FROM page_push_tops WHERE page_id=" . $this->page_id . " and product_id = " . $data['product_id']);
                if ($check_product >= 1) {
                    $product_one = $this->pdo->fetch_one( "SELECT id, page_id, product_id, count_click FROM page_push_tops WHERE page_id=" . $this->page_id . " and product_id = " . $data['product_id']);
                    // update page_push_tops
                    $data = [
                        "count_click" => $product_one['count_click'] + 1,
                        "created" => time(),
                    ];
                    $this->pdo->update('page_push_tops', $data, "id = " . $product_one['id'] . " AND page_id= " . $this->page_id . " AND product_id = " . $product_one['product_id']);
                    $rt['msg'] = 'Đưa sản phẩm lên top thành công.';
                    $rt['code'] = 1;
                } else {
                    // create page_push_tops
                    $data = [
                        "user_id" => $this->profile['user_id'],
                        "page_id" => $this->profile['page_id'],
                        "product_id" => $data['product_id'],
                        "created" => time(),
                        "status" => 1,
                        "count_click" => 1,
                    ];
                    $this->pdo->insert('page_push_tops', $data);
                    $rt['msg'] = 'Đưa sản phẩm lên top thành công.';
                    $rt['code'] = 1;
                }
            }
            //            else {
            //                $rt['msg'] = 'Xảy ra lỗi hệ thống, vui lòng thực hiện lại.';
            //            }
            echo json_encode($rt);
            exit();
        }
        
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_main_product') {
            $id = intval(@$_POST['id']);
            $data['ismain'] = 1;
            $rt['code'] = 0;
            
            $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=" . $this->profile['package_id']);
            if ($this->pdo->count_item('products', 'a.ismain=1 AND a.page_id=' . $this->page_id) >= intval(@$package['numb_showcase'])) {
                $rt['msg'] = 'Số lượng sản phẩm showcase đã đạt tối đa';
            } elseif ($this->pdo->update('products', $data, "id=$id AND page_id=" . $this->page_id)) {
                // update db
                $this->update_page_mainproducts();
                $rt['code'] = 1;
                $rt['msg'] = 'Đưa sản phẩm làm sản phẩm showcase thành công.';
                // reindex api
                $curl_get_product = $this->curl_search_get_product($id);
                $curl_get_product['fields']['ismain'] = $data['ismain'];
                $dataCURL_str = json_encode($curl_get_product['fields']);
                $this->curl_search_update_index($id, $dataCURL_str);
            } else {
                $rt['msg'] = 'Xảy ra lỗi hệ thống, vui lòng thực hiện lại.';
            }
            echo json_encode($rt);
            exit();
        }
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_import_product') {
            $id = intval(@$_POST['id']);
            $data['isimport'] = 1;
            $rt['code'] = 0;
            if ($this->pdo->update('products', $data, "id=$id AND page_id=" . $this->page_id)) {
                $rt['code'] = 1;
                $rt['msg'] = 'Đưa sản phẩm vào khu vực Nhập Khẩu thành công';
            } else {
                $rt['msg'] = 'Xảy ra lỗi hệ thống, vui lòng thực hiện lại.';
            }
            echo json_encode($rt);
            exit();
        }
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_whole_product') {
            $id = intval(@$_POST['id']);
            $data['iswhole'] = 1;
            $rt['code'] = 0;
            if ($this->pdo->update('products', $data, "id=$id AND page_id=" . $this->page_id)) {
                $rt['code'] = 1;
                $rt['msg'] = 'Sản phẩm được đưa vào khu vực bán buôn';
            } else {
                $rt['msg'] = 'Xảy ra lỗi hệ thống, vui lòng thực hiện lại.';
            }
            echo json_encode($rt);
            exit();
        }
       
        $sql = "SELECT a.id,a.name,a.images,a.status,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
				FROM products a WHERE a.ismain=1 AND a.page_id=" . $this->page_id . " ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', "ismain=1 AND page_id=" . $this->page_id), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['url_edit'] = "?mod=product&site=editdetail&id=" . $item['id'];
            $item['url_edit_cate'] = "?mod=product&site=create&id=" . $item['id'];
            $item['status'] = $this->product->status[$item['status']];
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    function imports(){
        global $login, $lang;
        $sql = "SELECT a.id,a.name,a.images,a.status,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
				FROM products a WHERE a.isimport=1 AND a.page_id=" . $this->page_id . " ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', "isimport=1 AND page_id=" . $this->page_id), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['status'] = $this->product->status[$item['status']];
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    function wholesaler(){
        global $login, $lang;
        $sql = "SELECT a.id,a.name,a.images,a.status,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
				FROM products a WHERE a.iswhole=1 AND a.page_id=" . $this->page_id . " ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', "iswhole=1 AND page_id=" . $this->page_id), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['status'] = $this->product->status[$item['status']];
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function ads()
    {
        global $login, $lang;
        $page_id = $this->page_id;
        //var_dump($this->pdo->count_rows("SELECT 1 FROM keyads WHERE page_id=$page_id AND status<>2 AND DATE_FORMAT(started, '%Y-%m')='".date("Y-m")."'"));
        
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'save_form') {
            $id = intval(@$_POST['id']);
            $page_id = $this->page_id;
            $number = $this->pdo->count_rows("SELECT 1 FROM keyads
                    WHERE page_id=$page_id AND status<>2 AND DATE_FORMAT(started, '%Y-%m')='" . date("Y-m", strtotime(trim(@$_POST['started']))) . "'");
            $package = $this->pdo->fetch_one("SELECT a.package_id,a.package_end,p.numb_ads
                    FROM pages a LEFT JOIN packages p ON a.package_id=p.id
                    WHERE a.id=$page_id AND a.package_end>='" . date("Y-m-d") . "'");
            
            $rt['code'] = 0;
            if ($number >= intval(@$package['numb_ads'])) {
                $rt['msg'] = "Số lượng quảng cáo vượt giới hạn của gói.";
            } else {
                $data['keyword'] = trim(@$_POST['keyword']);
                $data['keyword_id'] = $this->product->get_keyword_id(trim(@$_POST['keyword']));
                $data['product_id'] = trim(@$_POST['product_id']);
                $data['position'] = trim(@$_POST['position']);
                $data['started'] = date("Y-m-d", strtotime(trim(@$_POST['started'])));
                if ($id == 0) {
                    $data['page_id'] = $this->page_id;
                    $data['user_id'] = $login;
                    $data['created'] = time();
                    $this->pdo->insert('keyads', $data);
                } else {
                    $this->pdo->update('keyads', $data, "id=$id");
                }
                $rt['code'] = 1;
            }
            echo json_encode($rt);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'load_form') {
            $id = intval(@$_POST['id']);
            $products = $this->pdo->fetch_all("SELECT id,name FROM products WHERE status=1 AND page_id=" . $this->page_id);
            $a_product = [];
            foreach ($products as $k => $item) {
                $a_product[$item['id']] = $item['name'];
            }
            $result = $this->pdo->fetch_one("SELECT * FROM keyads WHERE id=$id");
            if (!$result) {
                $result['started'] = date("d-m-Y");
            } else {
                $result['started'] = date("d-m-Y", strtotime($result['started']));
            }
            $result['s_position'] = $this->help->get_select_from_array($this->product->ad_position, @$result['position']);
            $result['s_product'] = $this->help->get_select_from_array($a_product, @$result['product_id']);
            echo json_encode($result);
            exit();
        }
        
        $sql = "SELECT k.id,a.name,a.images,a.status,k.keyword,k.started,k.created,k.status,k.position
				FROM keyads k LEFT JOIN products a ON a.id=k.product_id
                WHERE k.page_id=" . $this->page_id . " ORDER BY k.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('keyads', "page_id=" . $this->page_id), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['position'] = @$this->product->ad_position[@$item['position']];
            $item['status'] = @$this->product->status[$item['status']];
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $out['s_position'] = $this->help->get_select_from_array($this->product->ad_position);
        $this->smarty->assign('out', $out);
        
        $json_keywords = @file_get_contents(FILE_KEYWORDS);
        $this->smarty->assign('json_keywords', $json_keywords);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function select_prod()
    {
        global $login, $lang;
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function create()
    {
        global $login, $lang;
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'create_product') {
            $taxonomy_id = intval(@$_POST['taxonomy_id']);
            $id = intval(@$_POST['id']);
            if ($this->pdo->check_exist("SELECT 1 FROM taxonomy WHERE parent=$taxonomy_id")) {
                $rt['code'] = 0;
                $rt['msg'] = "Vui lòng chọn danh mục cấp nhỏ nhất.";
            } else {
                $data['taxonomy_id'] = $taxonomy_id;
                // ADD
                if ($id == 0) {
                    $data['user_id'] = $login;
                    $data['page_id'] = $this->page_id;
                    $data['created'] = time();
                    // insert db
                    $rt['code'] = $this->pdo->insert('products', $data);
                    $data['id'] = $rt['code'];
                    
                    // indexes api
                    $e_id = $data['id'];
                    $e_category = $this->pdo->fetch_one("SELECT name FROM taxonomy WHERE id=$taxonomy_id");
                    $e_date = new DateTime();
                    $e_date->setTimestamp($data['created']);
                    
                    $dataIndex = [
                        "category" => $e_category['name'],
                        "page_id" => $data['page_id'],
                        "date_start" => $e_date->format('Y-m-d\TH:i:s\Z'),
                        "taxonomy_id" => $data['taxonomy_id'],
                    ];
                    
                    $dataCURL_str = json_encode($dataIndex);
                    $this->curl_search_update_index($e_id, $dataCURL_str);
                    // echo "<pre>";
                    // print_r($dataCURL_str);
                    // echo "</pre>";
                    // die();
                    // EDIT
                } else {
                    
                    $data['created'] = time();
                    // insert db
                    $this->pdo->update('products', $data, 'id=' . $id);
                    $rt['code'] = $id;
                    // indexes api
                    $e_id = $data['id'];
                    $e_category = $this->pdo->fetch_one("SELECT name FROM taxonomy WHERE id=$taxonomy_id");
                    $e_date = new DateTime();
                    $e_date->setTimestamp($data['created']);
                    
                    $curl_get_product = $this->curl_search_get_product($id);
                    $curl_get_product['fields']['category'] = $e_category['name'];
                    $curl_get_product['fields']['date_start'] = $e_date->format('Y-m-d\TH:i:s\Z');
                    $curl_get_product['fields']['taxonomy_id'] = $data['taxonomy_id'];
                    
                    $dataCURL_str = json_encode($dataIndex);
                    $this->curl_search_update_index($e_id, $dataCURL_str);
                }
            }
            echo json_encode($rt);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'load_category') {
            $rt = $this->taxonomy->get_select_taxonomy('product', 0, @$_POST['id'], null, 'Chọn danh mục sản phẩm');
            echo $rt;
            exit();
        }
        $out = [];
        $package = $this->pdo->fetch_one("SELECT numb_product FROM packages WHERE id=" . $this->profile['package_id']);
        $out['numb_product'] = ($package && $package['numb_product'] != 0) ? $package['numb_product'] : 50;
        $out['numb_create'] = $this->pdo->count_item('products', 'status=1 AND page_id=' . $this->page_id);
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $product = $this->pdo->fetch_one("SELECT taxonomy_id FROM products WHERE id=$id");
        if ($product) {
            $tid_1 = $this->taxonomy->get_biggest_parent('product', @$product['taxonomy_id']);
            $taxonomy = $this->pdo->fetch_one("SELECT id,parent,level FROM taxonomy WHERE type='product' AND id=" . @$product['taxonomy_id']);
            if ($taxonomy && @$taxonomy['parent'] != 0) {
                $tid_2 = $taxonomy['parent'];
                $tid_3 = $taxonomy['id'];
            }
        }
        $out['select_category'] = $this->taxonomy->get_select_taxonomy('product', @$tid_1, 0, null, 'Chọn danh mục sản phẩm');
        $out['select_category_sub1'] = '';
        $out['select_category_sub2'] = '';
        if (isset($tid_2) && $tid_2 != 0)
            $out['select_category_sub1'] = $this->taxonomy->get_select_taxonomy('product', @$tid_2, @$tid_1, null, 'Chọn danh mục sản phẩm');
            if (isset($tid_3) && $tid_3 != 0)
                $out['select_category_sub2'] = $this->taxonomy->get_select_taxonomy('product', @$tid_3, @$tid_2, null, 'Chọn danh mục sản phẩm');
                
                $out['id'] = $id;
                $this->smarty->assign('out', $out);
                $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    /*
     function editdetail(){
     global $login, $lang;
     $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
     $product = $this->pdo->fetch_one("SELECT a.* FROM products a WHERE a.id=$id AND a.page_id=".$this->page_id);
     $product['folder'] = URL_UPLOAD.$this->product->get_folder_img($id);
     $a_image = strlen($product['images'])>30 ? explode(";", $product['images']) : [];
     for ($i=0; $i<6; $i++){
     if(isset($a_image[$i]) && is_file($this->product->get_folder_img_upload($id).$a_image[$i])){
     $a_image_show[$i] = $this->img->get_image($this->product->get_folder_img($id), $a_image[$i]);
     }else{
     $a_image_show[$i] = NO_IMG;
     unset($a_image[$i]);
     }
     }
     $product['images'] = implode(";", $a_image);
     $product['s_unit'] = $this->taxonomy->get_select_taxonomy('product_unit', @$product['unit_id'], 0, null, 'Chọn đơn vị');
     $keywords = $this->pdo->fetch_array_field('keywords', 'name', "id IN (".($product['keyword']==null?0:$product['keyword']).")");
     $this->smarty->assign('keywords', $keywords);
     // 		var_dump($keywords);
     
     if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_images'){
     $upload = $this->img->upload_image_base64($this->product->get_folder_img($id), @$_POST['img'], null, 800, 1);
     $a_image[] = $upload;
     $data['images'] = implode(";", $a_image);
     $this->pdo->update('products', $data, "id=$id");
     echo $upload;
     exit();
     }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_images'){
     @unlink($this->product->get_folder_img_upload($id).@$_POST['imgname']);
     foreach ($a_image AS $k=>$item){
     if(!is_file($this->product->get_folder_img_upload($id).$item)) unset($a_image[$k]);
     }
     $data['images'] = implode(";", $a_image);
     $this->pdo->update('products', $data, "id=$id");
     exit();
     }elseif(isset($_POST['submit'])){
     $data['name'] = trim(@$_POST['name']);
     $data['code'] = trim(@$_POST['code']);
     $data['trademark'] = trim(@$_POST['trademark']);
     //$data['keyword'] = trim(@$_POST['keyword']);
     $data['ability'] = trim(@$_POST['ability']);
     $data['ordertime'] = trim(@$_POST['ordertime']);
     $data['minorder'] = intval(@$_POST['minorder']);
     $data['unit_id'] = intval(@$_POST['unit_id']);
     $data['description'] = trim(@$_POST['description']);
     $data['package'] = trim(@$_POST['package']);
     $data['qa'] = trim(@$_POST['qa']);
     $data['user_id'] = $login;
     $data['status'] = 1;
     $data['created'] = time();
     
     if(isset($_POST['key']) && is_array($_POST['key'])){
     $a_key = [];
     foreach ($_POST['key'] AS $k=>$item){
     if(strlen($item)>2) $a_key[] = $this->product->get_keyword_id($item);
     }
     $data['keyword'] = implode(",", $a_key);
     }
     
     $this->pdo->update('products', $data, "id=".$product['id']);
     unset($data);
     
     ##Gửi email
     $user = $this->pdo->fetch_one("SELECT name FROM users WHERE id =$login");
     $email = 'chungit.dsc@daisan.vn';
     $mail_title = "[".$user['name']."] Edit ".$_POST['name'];
     $mail_content = null;
     $mail_content .= DOMAIN."?mod=product&site=detail&pid=$id";
     $this->send_mail($email, $mail_title, $mail_content);
     
     $service_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
     var_dump($service_detail);
     exit();
     $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
     foreach ($service_detail AS $item){
     if(trim($item['key'])!=null && trim($item['value'])!=null){
     $data['meta_key'] = trim($item['key'],":");
     $data['meta_value'] =  trim($item['value'],":");
     $data['product_id'] = $id;
     $this->pdo->insert('productmetas', $data);
     unset($data);
     }
     }
     unset($_SESSION['service_add_detail']);
     
     $service_price = isset($_SESSION['service_add_price'])?$_SESSION['service_add_price']:[];
     $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
     foreach ($service_price AS $item){
     if(trim($item['key'])!=null && trim($item['value'])!=null){
     $data['version'] = $item['key'];
     $data['price'] = $this->str->convert_money_to_int($item['value']);
     $data['product_id'] = $id;
     $this->pdo->insert('productprices', $data);
     unset($data);
     }
     }
     unset($_SESSION['service_add_price']);
     
     lib_redirect("?mod=product&site=index");
     }
     
     $productmetas = $this->pdo->fetch_all("SELECT meta_key,meta_value FROM productmetas WHERE product_id=$id ORDER BY id");
     $_SESSION['service_add_detail'] = [];
     foreach ($productmetas AS $k=>$item){
     $_SESSION['service_add_detail'][$k]['key'] = $item['meta_key'];
     $_SESSION['service_add_detail'][$k]['value'] = $item['meta_value'];
     }
     
     $productprices = $this->pdo->fetch_all("SELECT version,price FROM productprices WHERE product_id=$id ORDER BY id");
     $_SESSION['service_add_price'] = [];
     foreach ($productprices AS $k=>$item){
     $_SESSION['service_add_price'][$k]['key'] = $item['version'];
     $_SESSION['service_add_price'][$k]['value'] = number_format($item['price']);
     }
     
     
     $json_keywords = @file_get_contents(FILE_KEYWORDS);
     $this->smarty->assign('json_keywords', $json_keywords);
     $this->smarty->assign('a_image_show', $a_image_show);
     $this->smarty->assign('product', $product);
     $this->smarty->display(LAYOUT_DEFAULT);
     }
     */
    function editDetail()
    {
        // ini_set('display_errors', true);
        // error_reporting(E_ALL);

        global $login;
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $product = $this->pdo->fetch_one("SELECT a.* FROM products a WHERE a.id=$id AND a.page_id=" . $this->page_id);
        $product['folder'] = URL_UPLOAD . $this->product->get_folder_img($id);
        $a_image = strlen($product['images']) > 30 ? explode(";", $product['images']) : [];
        
        $a_image_show = [];
        for ($i = 0; $i < 6; $i++) {
            if (isset($a_image[$i]) && is_file($this->product->get_folder_img_upload($id) . $a_image[$i])) {
                $a_image_show[$i] = $this->img->get_image($this->product->get_folder_img($id), $a_image[$i]);
            } else {
                $a_image_show[$i] = NO_IMG;
                unset($a_image[$i]);
            }
        }
        
        $product['images'] = implode(";", $a_image);
        $product['s_unit'] = $this->taxonomy->get_select_taxonomy('product_unit', @$product['unit_id'], 0, null, 'Chọn đơn vị');
        $keywords = $this->pdo->fetch_array_field('keywords', 'name', "id IN (" . ($product['keyword'] == null ? 0 : $product['keyword']) . ")");
        $this->smarty->assign('keywords', $keywords);
        
        $data = [];
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'upload_images') {
            $page_id = $this->product->get_folder_img($id);
            if (empty($_FILES['file'])) {
                echo 'Duong dan anh khong ton tai!';
                exit();
            }

            //duong dan upload
            
            $file_data = $_FILES['file']['tmp_name'];
            $type = $_FILES['file']['type'];
            
            list(, $type) = explode("/", $type);
            $imgname = null;
            $imgname = ($imgname == null || $imgname == '') ? 'hodine_img' : $imgname;
            $filename = time() . "_" . md5($imgname) . "." . $type;
            
            $fields = [
                'uploaded_file' => curl_file_create($file_data, $type, $filename),
                'width' => 270,
                'height' => 270,
                'name_file_upload' => DIR_UPLOAD_S3 . $page_id,
                'type_resize' => 'fit',
                'id' => $id,
            ];
            
            $this->callApiUpload(DOMAIN_API . 'resize-image', $fields, 'POST');
            
            $upload = $this->img->upload_image_base64_v1($this->product->get_folder_img($id), @$_POST['img'], $filename, 800, 1);
            
            $a_image[] = $upload;
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
            
            // reindex api
            $curl_get_product = $this->curl_search_get_product($id);
            $curl_get_product['fields']['images'] = $data['images'];
            $dataCURL_str = json_encode($curl_get_product['fields']);
            $this->curl_search_update_index($id, $dataCURL_str);
            echo $upload;
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'remove_images') {
            $data = [];
            $data['path_image'] = [
                $this->product->get_folder_img_upload_s3($id) . '270x270/' . @$_POST['imgname'],
                $this->product->get_folder_img_upload_s3($id) . '800x800/' . @$_POST['imgname'],
            ];
            
            $this->callAPI(DOMAIN_API . 'delete-image', json_encode($data), 'POST');
            @unlink($this->product->get_folder_img_upload($id) . @$_POST['imgname']);
            foreach ($a_image as $k => $item) {
                if (!is_file($this->product->get_folder_img_upload($id) . $item)) unset($a_image[$k]);
            }
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
            
            // reindex api
            $curl_get_product = $this->curl_search_get_product($id);
            $curl_get_product['fields']['images'] = $data['images'];
            $dataCURL_str = json_encode($curl_get_product['fields']);
            $this->curl_search_update_index($id, $dataCURL_str);
            exit();
        } elseif (isset($_POST['submit'])) {
            // attribute_contents - start
            $lenght_attribute = intval(@$_POST['lenght_attribute']);
            $attribute_detail = [];
            $attribute_id = intval(@$_POST['attribute_id']);
            $attribute_db = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id=$attribute_id");
            $attribute_get_db = json_decode(empty($attribute_db['contents'])? "[]": $attribute_db['contents'], true);
            
            for ($i = 1; $i <= $lenght_attribute; $i++) {
                $key = $_POST["detail_attribute_name_$i"];
                $value = $_POST["detail_attribute_content_$i"];
                $attribute_detail_push = [
                    "name" => $key,
                    "contents" => $value
                ];
                array_push($attribute_detail, $attribute_detail_push);
            }
            
            $attribute_user_custom = $attribute_detail;
            
            $attr_data = [];
            foreach ($attribute_get_db as $ka => $va) {
                foreach ($attribute_user_custom as $kb => $vb) {
                    if (chop($va['name'] == chop($vb['name']))) {
                        $attr_data_push = [
                            'name' => chop($vb['name']),
                            'contents' => []
                        ];
                        foreach ($va['contents'] as $ka2 => $va2) {
                            foreach ($vb['contents'] as $kb2 => $vb2) {
                                if (chop($va2['name']) == chop($vb2)) {
                                    $attr_data_child_push = [
                                        'name' => chop($vb2),
                                        'img_id' => $va2['img_id'],
                                        'img_name' => $va2['img_name'],
                                    ];
                                    array_push($attr_data_push['contents'], $attr_data_child_push);
                                }
                            }
                        }
                        array_push($attr_data, $attr_data_push);
                    }
                }
            }
            
            // echo "<pre>";
            // print_r($attr_data);
            // echo "</pre>";
            
            $attribute_contents = json_encode($attr_data, JSON_UNESCAPED_UNICODE);
            // echo "<pre>";
            // print_r($_POST);
            // echo "<pre>";
            // die();
            // attribute_contents - end
            
            $data['name'] = trim(@$_POST['name']);
            $data['code'] = trim(@$_POST['code']);
            $data['trademark'] = trim(@$_POST['trademark']);
            $data['keyword'] = trim(@$_POST['keyword']);
            $data['ability'] = trim(@$_POST['ability']);
            $data['ordertime'] = trim(@$_POST['ordertime']);
            $data['minorder'] = intval(@$_POST['minorder']);
            $data['inventory'] = intval(@$_POST['inventory']);
            $data['unit_id'] = intval(@$_POST['unit_id']);
            $data['description'] = trim(@$_POST['description']);
            $data['package'] = trim(@$_POST['package']);
            $data['qa'] = trim(@$_POST['qa']);
            $data['user_id'] = $login;
            $data['status'] = 1;
            $data['groupattributes_id'] = intval(@$_POST['attribute_id']);
            $data['attribute_contents'] = $attribute_contents;
            $data['created'] = time();

            $html = \Lib\Help\HtmlDomParser::str_get_html($data['description']);
            $a_img = [];

            if ($html) {
                foreach(@$html->find('img') as $element){
                    if(strpos($element->src,'../site/upload')===false&&
                        strpos($element->src,'https://daisan-image.s3.amazonaws.com/')===false&&
                        strpos($element->src,'https://daisan.vn/site/upload/')===false&&
                        strpos($element->src,'https://imgs.daisan.vn/')===false&&
                        strpos($element->src,'https://static01.daisan.vn/site/upload/')===false
                        ){
                        $a_img[] = trim($element->src);
                        $rt = $this->img->upload_image_fromurl('caches/',$element->src,800,0);
                        if($rt){
                            $rt = 'https://daisan.vn/site/upload/caches/'.$rt;
                            $data['description'] = str_replace($element->src, $rt, $data['description']);
                        }
                    }
                }    
            }
            
            if (isset($_POST['key']) && is_array($_POST['key'])) {
                $a_key = [];
                foreach ($_POST['key'] as $k => $item) {
                    if (strlen($item) > 2) $a_key[] = $this->product->get_keyword_id($item);
                }
                $data['keyword'] = implode(",", $a_key);
            }
            
            $this->pdo->update('products', $data, "id=" . $product['id']);
            
            // UPDATE INDEX - START
            if ($id != 0) {
                $e_unit_name = trim(@$_POST['unit_name']);
                $e_date = new DateTime();
                $e_date->setTimestamp($data['created']);
                
                // {
                //     *"attribute_contents": "",
                //     *"groupattributes_id": 0,
                //     "images": "1530096410_fda1474f95e82b9d2c5caad55dc76e69.png",
                //     "ismain": null,
                //     "isphone": null,
                //     *"keyword": "",
                //     "location": "|1|1|50|",
                //     "max_price": 0,
                //     "min_price": 0,
                //     *"minorder": 10,
                //     *"name": "Keo silicone SR 900 (Silicone foam)",
                //     *"ordertime": "",
                //     "package_end": "2019-07-31T00:00:00Z",
                //     "package_id": 4,
                //     "page_name": "dssilicone",
                //     "pageaddress": "",
                //     "pagename": "Silicone Đại Sàn",
                //     "phone": "0986 25 8282",
                //     "status": 1,
                //     *"unit": "Tuýp"
                // }
                
                // (
                //     [name] => Gạch bông ehost
                //     [code] => EH0-123
                //     [trademark] => ehost
                //     [keyword] => 22511,22514,22517
                //     [ability] => 100
                //     [ordertime] =>
                //     [minorder] => 5
                //     [inventory] => 100
                //     [unit_id] => 850
                //     [description] => Mô tả sản phẩm
                //     [package] => Quy cách đóng gói
                //     [qa] => Câu hỏi thường gặp
                //     [user_id] => 17
                //     [status] => 1
                //     [groupattributes_id] => 17
                //     [attribute_contents] => [{"name":"Kích thước","contents":[{"name":"75x150mm","img_id":"","img_name":""},{"name":"75x300mm","img_id":"","img_name":""}]},{"name":"Màu sắc","contents":[{"name":"Be","img_id":"","img_name":""},{"name":"Cam","img_id":"","img_name":""}]},{"name":"Bề mặt","contents":[{"name":"Bóng phẳng","img_id":"","img_name":""},{"name":"Bóng vát","img_id":"","img_name":""}]},{"name":"Thương hiệu","contents":[{"name":"Nhập khẩu","img_id":"","img_name":""}]},{"name":"Hình dáng","contents":[{"name":"Lông vũ","img_id":"","img_name":""}]}]
                //     [created] => 1592195858
                // )
                
                $curl_get_product = $this->curl_search_get_product($id);
                $fields = $curl_get_product['fields'];
                
                $fields['name'] = $data['name'];
                $fields['keyword'] = $data['keyword'];
                $fields['minorder'] = $data['minorder'];
                $fields['ordertime'] = $data['ordertime'];
                $fields['unit'] = $e_unit_name;
                $fields['groupattributes_id'] = $data['groupattributes_id'];
                $fields['attribute_contents'] = $data['attribute_contents'];
                $fields['created'] = $e_date->format('Y-m-d\TH:i:s\Z');
                
                $dataCURL_str = json_encode($fields);
                $this->curl_search_update_index($id, $dataCURL_str);
            }
            // UPDATE INDEX - END
            
            unset($data);
            
            // SEND EMAIL - START
            ##Gửi email
            // $mail_to = array(
            //     'TO' => array('admin@daisan.vn'),
            //     'CC' => array('cntt.dsc@daisan.vn'),
            //     'BCC' => array('chungit.dsc@daisan.vn')
            // );
            // $user = $this->pdo->fetch_one("SELECT name FROM users WHERE id =$login");
            // $mail_title = "[".$user['name']."] Edit ".$_POST['name'];
            // $mail_content = null;
            // $mail_content .= DOMAIN."?mod=product&site=detail&pid=$id";
            // send_mail($mail_to,"New Product" , $mail_title, $mail_content);
            // SEND EMAIL - END
            $service_detail = isset($_SESSION['service_add_detail']) ? $_SESSION['service_add_detail'] : [];
            $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
            foreach ($service_detail as $item) {
                if (trim($item['key']) != null && trim($item['value']) != null) {
                    $data['meta_key'] = trim($item['key'], ":");
                    $data['meta_value'] = trim($item['value'], ":");
                    $data['product_id'] = $id;
                    $this->pdo->insert('productmetas', $data);
                    unset($data);
                }
            }
            unset($_SESSION['service_add_detail']);
            
            $service_price = isset($_SESSION['service_add_price']) ? $_SESSION['service_add_price'] : [];
            $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
            foreach ($service_price as $item) {
                if (trim($item['key']) != null && trim($item['value']) != null) {
                    $data['version'] = $item['key'];
                    $data['price'] = $this->str->convert_money_to_int($item['value']);
                    $data['product_id'] = $id;
                    $this->pdo->insert('productprices', $data);
                    unset($data);
                }
            }
            unset($_SESSION['service_add_price']);
            
            lib_redirect("?mod=product&site=index");
        }
        
        $productmetas = $this->pdo->fetch_all("SELECT meta_key,meta_value FROM productmetas WHERE product_id=$id ORDER BY id");
        $_SESSION['service_add_detail'] = [];
        foreach ($productmetas as $k => $item) {
            $_SESSION['service_add_detail'][$k]['key'] = $item['meta_key'];
            $_SESSION['service_add_detail'][$k]['value'] = $item['meta_value'];
        }
        
        $productprices = $this->pdo->fetch_all("SELECT version,price FROM productprices WHERE product_id=$id ORDER BY id");
        $_SESSION['service_add_price'] = [];
        foreach ($productprices as $k => $item) {
            $_SESSION['service_add_price'][$k]['key'] = $item['version'];
            $_SESSION['service_add_price'][$k]['value'] = number_format($item['price']);
        }
        
        $groupAttributes = $this->pdo->fetch_all("SELECT id,name FROM groupattributes ORDER BY id");
        $groupAttributes_id = $product['groupattributes_id'];
        $curGroupAttributes = $this->pdo->fetch_one("SELECT id,name,contents FROM groupattributes WHERE id=$groupAttributes_id");
        $dataAttribute = json_decode(empty($curGroupAttributes['contents'])? "[]": $curGroupAttributes['contents'], true);
        $product_contents = json_decode(empty($product['attribute_contents'])? "[]": $product['attribute_contents'], true);
        
        foreach ($dataAttribute as $ka => $va) {
            foreach ($product_contents as $kb => $vb) {
                if (chop($va['name']) == chop($vb['name'])) {
                    if (count($vb['contents']) > 0) {
                        $dataAttribute[$ka]['contents_actived'] = $vb['contents'];
                        foreach ($va['contents'] as $ka2 => $va2) {
                            foreach ($vb['contents'] as $kb2 => $vb2) {
                                if (chop($va2['name']) == chop($vb2['name'])) {
                                    $dataAttribute[$ka]['contents'][$ka2]['actived'] = 'true';
                                }
                            }
                        }
                    }
                }
            }
        }
        $folder = URL_UPLOAD . "attribute/";
        $json_keywords = @file_get_contents(FILE_KEYWORDS);
        
        // echo "<pre>";
        // print_r($product);
        // echo "</pre>";
        $this->smarty->assign('folder', $folder);
        $this->smarty->assign('dataAttribute', $dataAttribute);
        $this->smarty->assign('product_contents', $product_contents);
        $this->smarty->assign('groupAttributes_id', $groupAttributes_id);
        $this->smarty->assign('groupAttributes', $groupAttributes);
        $this->smarty->assign('json_keywords', $json_keywords);
        $this->smarty->assign('a_image_show', $a_image_show);
        $this->smarty->assign('product', $product);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function load_details()
    {
        $service_add_detail = isset($_SESSION['service_add_detail']) ? $_SESSION['service_add_detail'] : [];
        $service_add_detail = @array_values($service_add_detail);
        $_SESSION['service_add_detail'] = $service_add_detail;
        
        $out['number'] = count($service_add_detail);
        $this->smarty->assign('result', $service_add_detail);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function load_prices()
    {
        $service_add_price = isset($_SESSION['service_add_price']) ? $_SESSION['service_add_price'] : [];
        $service_add_price = @array_values($service_add_price);
        $_SESSION['service_add_price'] = $service_add_price;
        $out['number'] = count($service_add_price);
        $this->smarty->assign('result', $service_add_price);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function load_products()
    {
        global $login, $lang;
        $key = isset($_POST['key']) ? trim($_POST['key']) : '';
        $key = $key == null ? "-1" : $key;
        $sql = "SELECT a.id,a.name,a.images,a.status,a.ismain,a.views,a.score,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
				FROM products a WHERE a.status=1";
        if ($key != null) $sql .= " AND a.name LIKE '%$key%'";
        $sql .= " ORDER BY a.name ASC LIMIT 12";
        $products = $this->pdo->fetch_all($sql);
        foreach ($products as $k => $item) {
            $a_images = explode(";", $item['images']);
            $products[$k]['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
        }
        $this->smarty->assign('products', $products);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function ajax_handle()
    {
        
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'add_detail') {
            $service_add_detail = isset($_SESSION['service_add_detail']) ? $_SESSION['service_add_detail'] : [];
            $number = count($service_add_detail);
            $rt['code'] = 1;
            if ($number > 14) {
                $rt['code'] = 0;
                $rt['msg'] = "Đã vượt quá nội dung cho phép.";
            } else {
                $_SESSION['service_add_detail'][$number + 1]['key'] = "";
                $_SESSION['service_add_detail'][$number + 1]['value'] = "";
            }
            echo json_encode($rt);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_detail') {
            $_SESSION['service_add_detail'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'delete_detail') {
            unset($_SESSION['service_add_detail'][$_POST['id']]);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'sort_detail') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : -1;
            $type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
            $me = $_SESSION['service_add_detail'][$id];
            if ($type == 'up') {
                $up = $_SESSION['service_add_detail'][$id - 1];
                $_SESSION['service_add_detail'][$id - 1] = $me;
                $_SESSION['service_add_detail'][$id] = $up;
            } else {
                $up = $_SESSION['service_add_detail'][$id + 1];
                $_SESSION['service_add_detail'][$id + 1] = $me;
                $_SESSION['service_add_detail'][$id] = $up;
            }
        }
        
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'add_price') {
            $service_add_price = isset($_SESSION['service_add_price']) ? $_SESSION['service_add_price'] : [];
            $number = count($service_add_price);
            $rt['code'] = 1;
            if ($number > 5) {
                $rt['code'] = 0;
                $rt['msg'] = "Bạn chỉ được phép đưa tối đa 6 nội dung.";
            } else {
                $_SESSION['service_add_price'][$number + 1]['key'] = "";
                $_SESSION['service_add_price'][$number + 1]['value'] = "";
            }
            echo json_encode($rt);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_price') {
            $_SESSION['service_add_price'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'delete_price') {
            unset($_SESSION['service_add_price'][$_POST['id']]);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'sort_price') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : -1;
            $type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
            $me = $_SESSION['service_add_price'][$id];
            if ($type == 'up') {
                $up = $_SESSION['service_add_price'][$id - 1];
                $_SESSION['service_add_price'][$id - 1] = $me;
                $_SESSION['service_add_price'][$id] = $up;
            } else {
                $up = $_SESSION['service_add_price'][$id + 1];
                $_SESSION['service_add_price'][$id + 1] = $me;
                $_SESSION['service_add_price'][$id] = $up;
            }
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'load_detail_attribute') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $curAttr = $_POST['curAttr'];
            $curProduct = $_POST['curProduct'];
            
            // if ($id == $curAttr) {
            //     $result = $this->pdo->fetch_one("SELECT attribute_contents FROM products WHERE id=$curProduct");
            //     $curGroupAttributes = $this->pdo->fetch_one("SELECT id,name,contents FROM groupattributes WHERE id=$curAttr");
            
            //     $dataAttribute = json_decode($curGroupAttributes['contents'], true);
            //     $product_contents = json_decode($result['attribute_contents'], true);
            
            //     foreach ($dataAttribute as $ka => $va) {
            //         foreach ($product_contents as $kb => $vb) {
            //             if (chop($va['name']) == chop($vb['name'])) {
            //                 if (count($vb['contents']) > 0) {
            //                     $dataAttribute[$ka]['contents_actived'] = $vb['contents'];
            //                         foreach ($va['contents'] as $ka2 => $va2) {
            //                             foreach ($vb['contents'] as $kb2 => $vb2) {
            //                                 if (chop($va2['name']) == chop($vb2['name'])) {
            //                                     $dataAttribute[$ka]['contents'][$ka2]['actived'] = 'true';
            //                                 }
            //                             }
            //                         }
            //                 }
            //             }
            //         }
            //     }
            //     $data_f1 = json_encode($dataAttribute, JSON_UNESCAPED_UNICODE);
            //     echo $data_f1;
            
            // }
            if ($id != 0) {
                $result = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id=$id");
                echo json_encode($result['contents'], JSON_UNESCAPED_UNICODE);
            }
            
            exit();
        }
        
    }
    
    
    function ajax_delete()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if ($this->pdo->check_exist("SELECT 1 FROM products WHERE id=$id AND page_id=" . $this->page_id)) {
            $product = $this->pdo->fetch_one("SELECT id,images FROM products WHERE id=$id");
            
            $a_images = explode(";", @$product['images']);
            $folder = $this->product->get_folder_img_upload(@$product['id']);
            foreach ($a_images as $item) {
                @unlink($folder . $item);
            }
            $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
            $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
            $this->pdo->query("DELETE FROM products WHERE id=$id");
            $this->update_page_mainproducts();
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
        }
        
        echo json_encode($rt);
    }
    
    
    function ajax_delete_product_main()
    {
        if (isset($_POST['action']) && $_POST['action'] == 'delete_item') {
            $id = intval(@$_POST['id']);
            if (!$this->pdo->check_exist("SELECT 1 FROM products WHERE ismain=1 AND id=$id AND page_id=" . $this->page_id)) {
                $rt['code'] = 0;
                $rt['msg'] = 'Sản phẩm không chính xác';
            } else {
                $rt['code'] = 1;
                $data['ismain'] = 0;
                // update db
                $this->pdo->update('products', $data, "id=$id");
                $this->update_page_mainproducts();
                // reindex api
                $curl_get_product = $this->curl_search_get_product($id);
                $curl_get_product['fields']['ismain'] = $data['ismain'];
                $dataCURL_str = json_encode($curl_get_product['fields']);
                $this->curl_search_update_index($id, $dataCURL_str);
            }
            echo json_encode($rt);
            exit();
        }
    }
    function ajax_delete_product_import(){
        if (isset($_POST['action']) && $_POST['action'] == 'delete_item') {
            $id = intval(@$_POST['id']);
            if (!$this->pdo->check_exist("SELECT 1 FROM products WHERE isimport=1 AND id=$id AND page_id=" . $this->page_id)) {
                $rt['code'] = 0;
                $rt['msg'] = 'Sản phẩm không chính xác';
            } else {
                $rt['code'] = 1;
                $data['isimport'] = 0;
                // update db
                $this->pdo->update('products', $data, "id=$id");
            }
            echo json_encode($rt);
            exit();
        }
    }

    function ajax_delete_product_whole(){
        if (isset($_POST['action']) && $_POST['action'] == 'delete_item') {
            $id = intval(@$_POST['id']);
            if (!$this->pdo->check_exist("SELECT 1 FROM products WHERE iswhole=1 AND id=$id AND page_id=" . $this->page_id)) {
                $rt['code'] = 0;
                $rt['msg'] = 'Sản phẩm không chính xác';
            } else {
                $rt['code'] = 1;
                $data['iswhole'] = 0;
                // update db
                $this->pdo->update('products', $data, "id=$id");
            }
            echo json_encode($rt);
            exit();
        }
    }
    
    
    function ajax_delete_ads()
    {
        if (isset($_POST['action']) && $_POST['action'] == 'delete_item') {
            $id = intval(@$_POST['id']);
            if (!$this->pdo->check_exist("SELECT 1 FROM keyads WHERE id=$id AND page_id=" . $this->page_id)) {
                $rt['code'] = 0;
                $rt['msg'] = 'Sản phẩm không chính xác';
            } else {
                $rt['code'] = 1;
                $rt['msg'] = 'Xóa thông tin thành công';
                $this->pdo->query("DELETE FROM keyads WHERE id=$id");
            }
            echo json_encode($rt);
            exit();
        }
    }
    
    function update_page_mainproducts()
    {
        $products = $this->pdo->fetch_one("SELECT GROUP_CONCAT(name) AS namemulti FROM products
                        WHERE status=1 AND ismain=1 AND page_id=" . $this->page_id);
        $data['mainproducts'] = $products['namemulti'];
        $this->pdo->update('pageprofiles', $data, "page_id=" . $this->page_id);
        unset($data);
    }
    
}