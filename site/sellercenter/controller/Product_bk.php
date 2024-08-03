<?php

class Product extends Pageadmin {
    private $cate_type;
    
    function __construct() {
        parent::__construct ();
        $this->cate_type = "service";
        $a_menu = array(            'index' => "Tất cả sản phẩm",            'mains' => "Sản phẩm showcase",            'create'=> "Thêm sản phẩm",        );
        $this->get_pagemenu($a_menu);
        $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=".$this->profile['package_id']);
        $this->smarty->assign('package', $package);    }
        
    function index(){
        global $login, $lang;
        $out = array ();
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='copy_product'){
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
            if($product_id = $this->pdo->insert('products', $product)){
                foreach ($productprices AS $item){                    $data['product_id'] = $product_id;                    $data['version'] = $item['version'];                    $data['price'] = $item['price'];                    $this->pdo->insert('productprices', $data);                    unset($data);                } 
                foreach ($productmetas AS $item){                    $data['product_id'] = $product_id;                    $data['meta_key'] = $item['meta_key'];                    $data['meta_value'] = $item['meta_value'];                    $this->pdo->insert('productmetas', $data);                    unset($data);                }            }            echo $product_id; exit();        }        $key = isset($_GET['key'])?$_GET['key']:null;        $status = isset($_GET['status'])?$_GET['status']:-1;        $category = isset($_GET['category'])?$_GET['category']:0;        $where = "a.page_id=".$this->page_id;        if($key!=null) $where .= " AND a.name LIKE '%$key%'";        if($status!=-1) $where .= " AND a.status=$status";        if($category!=0) $where .= " AND a.taxonomy_id=$category";        $sql = "SELECT a.id,a.name,a.images,a.status,a.ismain,a.views,a.score,				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price,                (SELECT SUM(number) FROM productorderitems i WHERE i.page_id=a.page_id AND i.product_id=a.id) AS orders				FROM products a WHERE $where ORDER BY a.id DESC";        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['url_edit'] = "?mod=product&site=editdetail&id=".$item['id'];
            $item['url_edit_cate'] = "?mod=product&site=create&id=".$item['id'];
            $item['status'] = $this->product->status[$item['status']];
            $item['url'] = $this->product->get_url($item['id'], $item['name']);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $a_pagecategory = $this->taxonomy->get_product_category_ofpage($this->page_id);
        $a_category = [];
        foreach ($a_pagecategory AS $k=>$item){
            $a_category[$item['id']] = $item['name'];
        }
        
        $out['select_category'] = $this->help->get_select_from_array($a_category, $category, "Chọn danh mục");
        $out['select_status'] = $this->help->get_select_from_array($this->product->status, $status, "Chọn trạng thái");
        $out['key'] = $key;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function mains(){
        global $login, $lang;
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_main_product'){
            $id = intval(@$_POST['id']);
            $data['ismain'] = 1;
            $e_ismain = $data['ismain'];
            $rt['code'] = 0;
            
            $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=".$this->profile['package_id']);
            if($this->pdo->count_item('products', 'a.ismain=1 AND a.page_id='.$this->page_id) >= intval(@$package['numb_showcase'])){
                $rt['msg'] = 'Số lượng sản phẩm showcase đã đạt tối đa';
            }elseif($this->pdo->update('products', $data, "id=$id AND page_id=".$this->page_id)){
                // Update db
                $this->update_page_mainproducts();
                $rt['code'] = 1;
                $rt['msg'] = 'Đưa sản phẩm làm sản phẩm showcase thành công.';
                
                // Reindex API
                $curl_get_product = $this->curl_search_get_product($id);
                $curl_get_product['fields']['ismain'] = $data['ismain'];
                $dataCURL_str = json_encode($curl_get_product['fields']);
                $this->curl_search_update_index($id, $dataCURL_str);

            }else{
                $rt['msg'] = 'Xảy ra lỗi hệ thống, vui lòng thực hiện lại.';
            }
            echo json_encode($rt); exit();
        }
        
        $sql = "SELECT a.id,a.name,a.images,a.status,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
				FROM products a WHERE a.ismain=1 AND a.page_id=".$this->page_id." ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', "ismain=1 AND page_id=".$this->page_id), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            $item['url_edit'] = "?mod=product&site=editdetail&id=".$item['id'];
            $item['url_edit_cate'] = "?mod=product&site=create&id=".$item['id'];
            $item['status'] = $this->product->status[$item['status']];
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function ads(){
        global $login, $lang;
        $page_id = $this->page_id;
        //var_dump($this->pdo->count_rows("SELECT 1 FROM keyads WHERE page_id=$page_id AND status<>2 AND DATE_FORMAT(started, '%Y-%m')='".date("Y-m")."'"));
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_form'){
            $id = intval(@$_POST['id']);
            $page_id = $this->page_id;
            $number = $this->pdo->count_rows("SELECT 1 FROM keyads
                    WHERE page_id=$page_id AND status<>2 AND DATE_FORMAT(started, '%Y-%m')='".date("Y-m", strtotime(trim(@$_POST['started'])))."'");
            $package = $this->pdo->fetch_one("SELECT a.package_id,a.package_end,p.numb_ads
                    FROM pages a LEFT JOIN packages p ON a.package_id=p.id
                    WHERE a.id=$page_id AND a.package_end>='".date("Y-m-d")."'");
            
            $rt['code'] = 0;
            if($number >= intval(@$package['numb_ads'])){
                $rt['msg'] = "Số lượng quảng cáo vượt giới hạn của gói.";
            }else{
                $data['keyword'] = trim(@$_POST['keyword']);
                $data['keyword_id'] = $this->product->get_keyword_id(trim(@$_POST['keyword']));
                $data['product_id'] = trim(@$_POST['product_id']);
                $data['position'] = trim(@$_POST['position']);
                $data['started'] = date("Y-m-d", strtotime(trim(@$_POST['started'])));
                if($id==0){
                    $data['page_id'] = $this->page_id;
                    $data['user_id'] = $login;
                    $data['created'] = time();
                    $this->pdo->insert('keyads', $data);
                }else{
                    $this->pdo->update('keyads', $data, "id=$id");
                }
                $rt['code'] = 1;
            }
            echo json_encode($rt);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_form'){
            $id = intval(@$_POST['id']);
            $products = $this->pdo->fetch_all("SELECT id,name FROM products WHERE status=1 AND page_id=".$this->page_id);
            $a_product = [];
            foreach ($products AS $k=>$item){
                $a_product[$item['id']] = $item['name'];
            }
            $result = $this->pdo->fetch_one("SELECT * FROM keyads WHERE id=$id");
            if(!$result){
                $result['started'] = date("d-m-Y");
            }else{
                $result['started'] = date("d-m-Y", strtotime($result['started']));
            }
            $result['s_position'] = $this->help->get_select_from_array($this->product->ad_position, @$result['position']);
            $result['s_product'] = $this->help->get_select_from_array($a_product, @$result['product_id']);
            echo json_encode($result); exit();
        }
        
        $sql = "SELECT k.id,a.name,a.images,a.status,k.keyword,k.started,k.created,k.status,k.position
				FROM keyads k LEFT JOIN products a ON a.id=k.product_id
                WHERE k.page_id=".$this->page_id." ORDER BY k.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('keyads', "page_id=".$this->page_id), 20);
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
    
    function select_prod(){
        global $login, $lang;
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function create(){
        global $login, $lang;
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='create_product'){
            $taxonomy_id = intval(@$_POST['taxonomy_id']);
            $id = intval(@$_POST['id']);
            if($this->pdo->check_exist("SELECT 1 FROM taxonomy WHERE parent=$taxonomy_id")){
                $rt['code'] = 0;
                $rt['msg'] = "Vui lòng chọn danh mục cấp nhỏ nhất.";
            }else{
                $data['taxonomy_id'] = $taxonomy_id;
                if($id==0){
                    $data['user_id'] = $login;
                    $data['page_id'] = $this->page_id;
                    $data['created'] = time();
                    $rt['code'] = $this->pdo->insert('products', $data);
                }else {
                    $data['created'] = time();
                    $this->pdo->update('products', $data, 'id='.$id);
                    $rt['code'] = $id;
                }
            }
            echo json_encode($rt);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_category'){
            $rt = $this->taxonomy->get_select_taxonomy('product', 0, @$_POST['id'], null, 'Chọn danh mục sản phẩm');
            echo $rt;
            exit();
        }
        $out = [];
        $package = $this->pdo->fetch_one("SELECT numb_product FROM packages WHERE id=".$this->profile['package_id']);
        $out['numb_product'] = ($package&&$package['numb_product']!=0)?$package['numb_product']:50;
        $out['numb_create'] = $this->pdo->count_item('products', 'status=1 AND page_id='.$this->page_id);
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $product = $this->pdo->fetch_one("SELECT taxonomy_id FROM products WHERE id=$id");
        if($product){
            $tid_1 = $this->taxonomy->get_biggest_parent('product', @$product['taxonomy_id']);
            $taxonomy = $this->pdo->fetch_one("SELECT id,parent,level FROM taxonomy WHERE type='product' AND id=". @$product['taxonomy_id']);
            if($taxonomy && @$taxonomy['parent']!=0){
                $tid_2 = $taxonomy['parent'];
                $tid_3 = $taxonomy['id'];
            }
        }
        $out['select_category'] = $this->taxonomy->get_select_taxonomy('product', @$tid_1, 0, null, 'Chọn danh mục sản phẩm');
        $out['select_category_sub1'] = '';
        $out['select_category_sub2'] = '';
        if(isset($tid_2) && $tid_2!=0)
            $out['select_category_sub1'] = $this->taxonomy->get_select_taxonomy('product', @$tid_2, @$tid_1, null, 'Chọn danh mục sản phẩm');
            if(isset($tid_3) && $tid_3!=0)
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
    function editdetail(){
        global $login;
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $product = $this->pdo->fetch_one("SELECT a.* FROM products a WHERE a.id=$id AND a.page_id=".$this->page_id);
        $product['folder'] = URL_UPLOAD.$this->product->get_folder_img($id);
        $a_image = strlen($product['images'])>30 ? explode(";", $product['images']) : [];
        
        $a_image_show = [];
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
        
        $data = [];
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_images'){
            $upload = $this->img->upload_image_base64($this->product->get_folder_img($id), @$_POST['img'], null, 800, 1);
            $a_image[] = $upload;
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
            // reindex api
            // GET: lấy thông tin sp
            $curl_get_product = $this->curl_search_get_product($id);
            $curl_get_product['fields']['images'] = $data['images'];
            $dataCURL_str = json_encode($curl_get_product['fields']);
            $this->curl_search_update_index($id, $dataCURL_str);
            echo $upload;
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_images'){
            @unlink($this->product->get_folder_img_upload($id).@$_POST['imgname']);
            foreach ($a_image AS $k=>$item){
                if(!is_file($this->product->get_folder_img_upload($id).$item)) unset($a_image[$k]);
            }
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
            // reindex api
            // GET: lấy thông tin sp
            $curl_get_product = $this->curl_search_get_product($id);
            $curl_get_product['fields']['images'] = $data['images'];
            $dataCURL_str = json_encode($curl_get_product['fields']);
            $this->curl_search_update_index($id, $dataCURL_str);
            exit();
        }elseif(isset($_POST['submit'])){
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
            $mail_to = array(
                'TO' => array('admin@daisan.vn'),
                'CC' => array('cntt.dsc@daisan.vn'),
                'BCC' => array('chungit.dsc@daisan.vn')
            );
            $user = $this->pdo->fetch_one("SELECT name FROM users WHERE id =$login");
            $mail_title = "[".$user['name']."] Edit ".$_POST['name'];
            $mail_content = null;
            $mail_content .= DOMAIN."?mod=product&site=detail&pid=$id";
            send_mail($mail_to,"New Product" , $mail_title, $mail_content);      
            
            $service_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
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
    
    
    function load_details(){
        $service_add_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
        $service_add_detail = @array_values($service_add_detail);
        $_SESSION['service_add_detail'] = $service_add_detail;
        
        $out['number'] = count($service_add_detail);
        $this->smarty->assign('result', $service_add_detail);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function load_prices(){
        $service_add_price = isset($_SESSION['service_add_price'])?$_SESSION['service_add_price']:[];
        $service_add_price = @array_values($service_add_price);
        $_SESSION['service_add_price'] = $service_add_price;
        $out['number'] = count($service_add_price);
        $this->smarty->assign('result', $service_add_price);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function load_products(){
        global $login, $lang;
        $key = isset($_POST['key']) ? trim($_POST['key']) : '';
        $key = $key==null?"-1":$key;
        $sql = "SELECT a.id,a.name,a.images,a.status,a.ismain,a.views,a.score,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
				FROM products a WHERE a.status=1";
        if($key!=null) $sql .= " AND a.name LIKE '%$key%'";
        $sql .= " ORDER BY a.name ASC LIMIT 12";
        $products = $this->pdo->fetch_all($sql);
        foreach ($products AS $k=>$item){
            $a_images = explode(";", $item['images']);
            $products[$k]['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
        }
        $this->smarty->assign('products', $products);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function ajax_handle(){
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_detail'){
            $service_add_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
            $number = count($service_add_detail);
            $rt['code'] = 1;
            if($number>14){
                $rt['code'] = 0;
                $rt['msg'] = "Đã vượt quá nội dung cho phép.";
            }else{
                $_SESSION['service_add_detail'][$number+1]['key'] = "";
                $_SESSION['service_add_detail'][$number+1]['value'] = "";
            }
            echo json_encode($rt);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_detail'){
            $_SESSION['service_add_detail'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='delete_detail'){
            unset($_SESSION['service_add_detail'][$_POST['id']]);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='sort_detail'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : -1;
            $type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
            $me = $_SESSION['service_add_detail'][$id];
            if($type=='up'){
                $up = $_SESSION['service_add_detail'][$id-1];
                $_SESSION['service_add_detail'][$id-1] = $me;
                $_SESSION['service_add_detail'][$id] = $up;
            }else{
                $up = $_SESSION['service_add_detail'][$id+1];
                $_SESSION['service_add_detail'][$id+1] = $me;
                $_SESSION['service_add_detail'][$id] = $up;
            }
        }
        
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_price'){
            $service_add_price = isset($_SESSION['service_add_price'])?$_SESSION['service_add_price']:[];
            $number = count($service_add_price);
            $rt['code'] = 1;
            if($number>5){
                $rt['code'] = 0;
                $rt['msg'] = "Bạn chỉ được phép đưa tối đa 6 nội dung.";
            }else{
                $_SESSION['service_add_price'][$number+1]['key'] = "";
                $_SESSION['service_add_price'][$number+1]['value'] = "";
            }
            echo json_encode($rt);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_price'){
            $_SESSION['service_add_price'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='delete_price'){
            unset($_SESSION['service_add_price'][$_POST['id']]);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='sort_price'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : -1;
            $type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
            $me = $_SESSION['service_add_price'][$id];
            if($type=='up'){
                $up = $_SESSION['service_add_price'][$id-1];
                $_SESSION['service_add_price'][$id-1] = $me;
                $_SESSION['service_add_price'][$id] = $up;
            }else{
                $up = $_SESSION['service_add_price'][$id+1];
                $_SESSION['service_add_price'][$id+1] = $me;
                $_SESSION['service_add_price'][$id] = $up;
            }
        }
        
    }
    
    
    function ajax_delete() {
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if($this->pdo->check_exist("SELECT 1 FROM products WHERE id=$id AND page_id=".$this->page_id)){
            $product = $this->pdo->fetch_one("SELECT id,images FROM products WHERE id=$id");
            
            $a_images = explode(";", @$product['images']);
            $folder = $this->product->get_folder_img_upload(@$product['id']);
            foreach ($a_images AS $item){
                @unlink($folder.$item);
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
    
    
    function ajax_delete_product_main(){
        if(isset($_POST['action']) && $_POST['action']=='delete_item'){
            $id = intval(@$_POST['id']);
            if(!$this->pdo->check_exist("SELECT 1 FROM products WHERE ismain=1 AND id=$id AND page_id=".$this->page_id)){
                $rt['code'] = 0;
                $rt['msg'] = 'Sản phẩm không chính xác';
            }else{
                $rt['code'] = 1;
                $data['ismain'] = 0;
                $this->pdo->update('products', $data, "id=$id");
                $this->update_page_mainproducts();

                // Reindex API -
                $curl_get_product = $this->curl_search_get_product($id);
                $curl_get_product['fields']['ismain'] = $data['ismain'];
                $dataCURL_str = json_encode($curl_get_product['fields']);
                $this->curl_search_update_index($id, $dataCURL_str);
            }
            echo json_encode($rt);
            exit();
        }
    }
    
    
    function ajax_delete_ads(){
        if(isset($_POST['action']) && $_POST['action']=='delete_item'){
            $id = intval(@$_POST['id']);
            if(!$this->pdo->check_exist("SELECT 1 FROM keyads WHERE id=$id AND page_id=".$this->page_id)){
                $rt['code'] = 0;
                $rt['msg'] = 'Sản phẩm không chính xác';
            }else{
                $rt['code'] = 1;
                $rt['msg'] = 'Xóa thông tin thành công';
                $this->pdo->query("DELETE FROM keyads WHERE id=$id");
            }
            echo json_encode($rt);
            exit();
        }
    }
    
    
    function update_page_mainproducts(){
        $products = $this->pdo->fetch_one("SELECT GROUP_CONCAT(name) AS namemulti FROM products
                        WHERE status=1 AND ismain=1 AND page_id=".$this->page_id);
        $data['mainproducts'] = $products['namemulti'];
        $this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
        unset($data);
    }
    
    function curl_search_get_product($id){
        $url = "http://103.63.215.40:8080/api/products/$id";
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "GET");
        // curl_setopt($curl, CURLOPT_POSTFIELDS, $dataCURL_str);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
        )
            );
        $resultCURL = curl_exec($curl);
        curl_close($curl);
        $resultCURL_arr = json_decode($resultCURL, true);
        return $resultCURL_arr;
    }
    
    function curl_search_update_index($id, $data){
        $url = "http://103.63.215.40:8080/api/products/$id";
        
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
        )
            );
        $resultCURL = curl_exec($curl);
        curl_close($curl);
    }
}