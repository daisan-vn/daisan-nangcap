<?php

class Apip extends Main{

    public $in, $page_id, $profile, $status_color;
    
    function __construct(){
        parent::__construct();
        
        $this->in = json_decode(file_get_contents('php://input'), true);
        $this->page_id = isset($this->in['page_id'])?intval($this->in['page_id']):0;
        $this->profile = [];
        if($this->page_id>0){
            $this->profile = $this->pdo->fetch_one("SELECT * FROM pages WHERE id=".$this->page_id);
            $this->profile['package'] = $this->get_package(intval(@$this->profile['package_id']));
        }
        
        $this->status_color = [0=>'secondary',1=>'success',2=>'danger'];
    }

    
    function _db(){
        $rt = [];
        
        if(isset($this->in['action'])&&$this->in['action']=='_info'){
            $rt = $this->pdo->fetch_one("SELECT a.id AS pid,a.*,p.*,
                CASE WHEN a.package_end>'".date('Y-m-d')."' THEN a.package_id ELSE 0 END AS package_id,
                CASE WHEN a.package_end>'".date('Y-m-d')."' THEN a.score_ads ELSE 0 END AS score_ads
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
				WHERE 1=1 AND (a.id=".intval($this->in['id'])." OR a.page_name='".$this->in['id']."')");
            if($rt){
                $page_id = $rt['pid'];
                $rt['metas'] = json_decode($rt['metas'],true);
                $rt['folder'] = $this->page->get_folder_img($page_id);
                $rt['logo_img'] = $this->img->get_image($this->page->get_folder_img($page_id), @$rt['logo']);
                $rt['logo_custom_img'] = $this->img->get_image($this->page->get_folder_img($page_id), @$rt['logo_custom']);
                // $rt['date_start'] = date("d-m-Y", strtotime($rt['date_start']));
                $rt['date_start'] = date("Y-m-d", strtotime($rt['date_start']));
                $rt['province'] = $this->pdo->fetch_one_fields('locations', 'Name', 'id='.$rt['province_id']);
                $rt['district'] = $this->pdo->fetch_one_fields('locations', 'Name', 'id='.$rt['district_id']);
                $rt['wards'] = $this->pdo->fetch_one_fields('locations', 'Name', 'id='.$rt['wards_id']);
                $rt['number_mem_show'] = @$this->number_mem[$rt['number_mem']];
                $rt['nation'] = $this->pdo->fetch_one_fields('nations', 'Name','Id='.$rt['nation_id']);
                $rt['revenue'] = @$this->page->revenue[$rt['revenue']];
                $rt['yearexp'] = $this->page->get_yearexp($rt['date_start']);
                $rt['type_name'] = @$this->page->type[$rt['type']];
                $rt['url'] = './item/'.($rt['page_name']!=''?$rt['page_name']:$rt['pid']).'/';
                $rt['pagelink'] = $this->page->get_all_pagelink($rt['pid'], @$rt['page_name']);
                $rt['page_contact'] = DOMAIN."?mod=page&site=contact&page_id=".$rt['page_id'];
                $rt['a_image'] = $this->page->get_images($rt['images'], $page_id);
                
                $rt['neworders'] = $this->pdo->count_item('productorders', 'status=0 AND page_id='.$rt['id']);
                $rt['newcontact'] = $this->pdo->count_item('pagemessages', 'parent=0 AND status=0 AND page_id='.$rt['id']);
                $rt['package'] = $this->get_package(intval(@$rt['package_id']));
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='profile'){
            $rt = $this->pdo->fetch_one("SELECT * FROM pageprofiles WHERE page_id=".$this->in['page_id']);
            
            $a_image = strlen(@$rt['img_sliders'])>30 ? explode(";", $rt['img_sliders']) : [];
            $a_image_show = [];
            for ($i=0; $i<4; $i++){
                if(isset($a_image[$i]) && is_file($this->page->get_folder_img_upload($this->page_id).$a_image[$i])){
                    $a_image_show[$i] = $this->img->get_image($this->page->get_folder_img($this->page_id), $a_image[$i]);
                }else{
                    $a_image_show[$i] = NO_IMG;
                    unset($a_image[$i]);
                }
            }
            $rt['img_sliders'] = implode(";", $a_image);
            $rt['a_sliders'] = $a_image_show;
        }elseif(isset($this->in['action'])&&$this->in['action']=='_form'){
            $rt = $this->pdo->fetch_one("SELECT * FROM products WHERE id=".$this->in['id']);
            $rt['folder'] = URL_UPLOAD . $this->product->get_folder_img($this->in['id']);
            $rt['metas'] = $this->pdo->fetch_all("SELECT meta_key,meta_value FROM productmetas WHERE product_id=".$rt['id']." ORDER BY id");
            $rt['prices'] = $this->pdo->fetch_all("SELECT version,price FROM productprices WHERE product_id=".$rt['id']." ORDER BY id");
            
        }elseif(isset($this->in['action'])&&$this->in['action']=='shop_admin'){
            $rt = $this->pdo->fetch_all("SELECT b.page_id,b.user_id,b.position,a.name,a.page_name,a.logo,a.package_id,
                (SELECT p.name FROM packages p WHERE p.id=a.package_id) AS package
                FROM pageusers b LEFT JOIN pages a ON b.page_id=a.id 
                WHERE b.status=1 AND b.user_id>0 AND a.name IS NOT NULL");
            foreach ($rt AS $k=>$v){
                $rt[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($v['page_id']), @$v['logo']);
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='_package'){
            if($this->in['id']>0){
                $rt = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=".$this->in['id']);
            }else $rt = $this->pdo->fetch_all("SELECT * FROM packages WHERE status=1 ORDER BY sort");
        }elseif(isset($this->in['action'])&&$this->in['action']=='s_category'){
            $rt = $this->tax->get_select_taxonomy('product', @$this->in['id'], @$this->in['parent'], null, 'Chọn danh mục', 0);
            echo $rt;
            exit();
        }
        
        echo json_encode($rt);
    }
    
    
    function get_package($id){
        if($id>0) $rt = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=".$id);
        else{
            $rt['number_product'] = 30;
            $rt['numb_showcase'] = 4;
            $rt['numb_event'] = 10;
            $rt['limit_push_top'] = 2;
            $rt['numb_ads'] = 0;
        }
        return $rt;
    }
    
    
    function _shop(){
        $rt = [];
        
        if(isset($this->in['action'])&&$this->in['action']=='home'){
            $profile = $this->pdo->fetch_one("SELECT * FROM pageprofiles WHERE page_id=".$this->in['id']);
            $a_sliders = strlen(@$profile['img_sliders'])>30 ? explode(";", @$profile['img_sliders']) : [];
            //$a_sliders = strlen(@$profile['images'])>30 ? explode(";", @$profile['images']) : [];
            $rt['a_sliders'] = [];
            foreach ($a_sliders AS $item){
                if(is_file($this->page->get_folder_img_upload($this->in['id']).$item))
                    $rt['a_sliders'][] = $this->img->get_image($this->page->get_folder_img($this->in['id']), $item);
            }
            
            
            $product_category = $this->tax->get_product_category_ofpage($this->in['id']);
            $a_category = [];
            foreach ($product_category AS $k=>$v){
                if($k<=3){
                    $a_category[$k] = $v;
                    $a_category[$k]['products'] = $this->product->get_list($this->in['id'],$v['id'],null,4);
                }
            }
            $rt['a_category'] = $a_category;
            
            $rt['p_main'] = $this->product->get_list($this->in['id'],0,'a.ismain=1',8);
            $rt['p_new'] = $this->product->get_list($this->in['id'], 0, "a.status=1", 10, null, "a.id DESC");
        }elseif(isset($this->in['action'])&&$this->in['action']=='home_new'){
            $profile = $this->pdo->fetch_one("SELECT * FROM pageprofiles WHERE page_id=".$this->in['id']);
            $rt['p_main'] = $this->product->get_list($this->in['id'],0,'a.ismain=1',18);
            $rt['p_new'] = $this->product->get_list($this->in['id'], 0, "a.status=1", 10, null, "a.id DESC");
            $rt['intro'] = @$profile['description'];
        }elseif(isset($this->in['action'])&&$this->in['action']=='product'){
            $where = "a.status=1 AND a.name<>'' AND a.page_id=".$this->in['id'];
            if($this->in['cat']!='') $where .= " AND a.taxonomy_id=".$this->in['cat'];
            $orderby ="a.ismain DESC,a.score DESC,a.views DESC";
            if($this->in['sort']=='newest') $orderby = "a.id DESC";
            if($this->in['sort']=='discount_desc') $orderby = "a.promo DESC";
            if($this->in['sort']=='price_asc') $orderby = "a.price ASC";
            if($this->in['sort']=='price_desc') $orderby = "a.price DESC";
            
            $sql = "SELECT a.id,a.name,a.images,a.page_id,a.trademark,a.ordertime,a.minorder,u.name AS unit,a.promo,
        			IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
        			IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
    				FROM products a LEFT JOIN taxonomy u ON u.id=a.unit_id
    				WHERE $where ORDER BY $orderby";
            $rt['number'] = $this->pdo->count_custom("SELECT COUNT(1) AS number FROM products a WHERE $where");
            if($this->in['limit']!='') $sql .= " LIMIT ".$this->in['limit'];
            
            $result = $this->pdo->fetch_all($sql);
            foreach ($result AS $k=>$item){
                $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $result[$k]['avatar'] = @$result[$k]['a_img'][0];
                $result[$k]['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $result[$k]['unit'] = $item['unit']==''?'Piece':$item['unit'];
                $result[$k]['pricemax'] = $item['price']==$item['pricemax']?'':number_format($item['pricemax']).'đ';
                $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
                $result[$k]['price_show'] = $result[$k]['price'].($result[$k]['pricemax']==''?'':' - '.$result[$k]['pricemax']);
                $result[$k]['price_promo'] = $this->product->get_price_promo($item['price'], $item['pricemax'], $item['promo']);
            }
            $rt['products'] = $result;
            
            $rt['a_category'] = $this->tax->get_product_category_ofpage($this->in['id']);
        }elseif(isset($this->in['action'])&&$this->in['action']=='search'){
            $where = "a.status=1 AND a.name<>'' AND a.page_id=".$this->in['id'];
            if($this->in['key']!='') $where .= " AND a.name LIKE '%".$this->in['key']."%'";
            $sql = "SELECT a.id,a.name,a.images,a.page_id,a.trademark,a.ordertime,a.minorder,u.name AS unit,a.promo,
				IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a LEFT JOIN taxonomy u ON u.id=a.unit_id
				WHERE $where ORDER BY a.ismain DESC,a.score DESC,a.views DESC";
            $rt['number'] = $this->pdo->count_custom("SELECT COUNT(1) AS number FROM products a WHERE $where");
            if($this->in['limit']!='') $sql .= " LIMIT ".$this->in['limit'];
            $result = $this->pdo->fetch_all($sql);
            foreach ($result AS $k=>$item){
                $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $result[$k]['avatar'] = @$result[$k]['a_img'][0];
                $result[$k]['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $result[$k]['unit'] = $item['unit']==''?'Piece':$item['unit'];
                $result[$k]['pricemax'] = $item['price']==$item['pricemax']?'':number_format($item['pricemax']).'đ';
                $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
                $result[$k]['price_show'] = $result[$k]['price'].($result[$k]['pricemax']==''?'':' - '.$result[$k]['pricemax']);
                $result[$k]['price_promo'] = $this->product->get_price_promo($item['price'], $item['pricemax'], $item['promo']);
            }
            $rt['products'] = $result;
        }elseif(isset($this->in['action'])&&$this->in['action']=='address'){
            $rt = $this->pdo->fetch_all("SELECT id,name,image,address,phone,lat,lng FROM pageaddress WHERE page_id=".$this->in['id']);
            foreach ($rt AS $k=>$item){
                $rt[$k]['image'] = $this->img->get_image($this->page->get_folder_img($this->in['id']), $item['image']);
            }
            
        }
        
        echo json_encode($rt);
    }

    
    function frm(){
        $rt = [];
        if(isset($this->in['action'])&&$this->in['action']=='save'){
            $data = $this->in;
            unset($data['action']);
            $this->pdo->update('pages', $data, 'id='.$this->in['id']);
            $rt['code'] = 1;
        }elseif(isset($this->in['action'])&&$this->in['action']=='save_name'){
            if(@$this->in['name']!=''&&!$this->pdo->check_exist("SELECT 1 FROM pages WHERE page_name='".trim(@$this->in['name'])."' AND id<>".$this->in['id'])){
                $data = [];
                $data['page_name'] = trim(@$this->in['name']);
                $this->pdo->update('pages', $data, 'id='.$this->in['id']);
                $rt['code'] = 1;
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='save_profile'){
            $profile = $this->pdo->fetch_one("SELECT * FROM pageprofiles WHERE page_id=".$this->in['page_id']);
            $data = [];
            $data['description'] = trim(@$this->in['description']);
            $data['time_open'] = trim(@$this->in['time_open']);
            $data['revenue'] = intval(@$this->in['revenue']);
            $data['supply_ability'] = trim(@$this->in['supply_ability']);
            $data['url_facebook'] = trim(@$this->in['url_facebook']);
            $data['url_google'] = trim(@$this->in['url_google']);
            $data['url_youtube'] = trim(@$this->in['url_youtube']);
            $data['fb_id'] = trim(@$this->in['fb_id']);
            if(!$profile){
                $data['page_id'] = $this->in['page_id'];
                $this->pdo->insert('pageprofiles', $data);
            }else{
                $this->pdo->update('pageprofiles', $data, "page_id=".$this->in['page_id']);
            }
            
        }elseif(isset($this->in['action'])&&$this->in['action']=='upload_logo'){
            $upload = $this->img->upload_image_base64($this->page->get_folder_img($this->in['page_id']), @$this->in['img'], null, 200, 1);
            $rt['code'] = 0;
            if($upload){
                @unlink($this->page->get_folder_img_upload($this->in['page_id']).$this->profile['logo']);
                $data = [];
                $data['logo'] = $upload;
                $this->pdo->update('pages', $data, "id=".$this->in['page_id']);
                $rt['img'] = URL_UPLOAD.$this->page->get_folder_img($this->in['page_id']).$upload;
                $rt['code'] = 1;
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='upload_images'){
            $profile = $this->pdo->fetch_one("SELECT * FROM pageprofiles WHERE page_id=".$this->in['page_id']);
            $a_image = strlen(@$profile['img_sliders'])>30 ? explode(";", $profile['img_sliders']) : [];
            for ($i=0; $i<4; $i++){
                if(!isset($a_image[$i]) || !is_file($this->page->get_folder_img_upload($this->page_id).$a_image[$i])){
                    unset($a_image[$i]);
                }
            }
            
            $rt['code'] = 0;
            if($upload = $this->img->upload_image_base64($this->page->get_folder_img($this->in['page_id']), @$this->in['img'], null, 800, 4)){
                $a_image[] = $upload;
                $data['img_sliders'] = implode(";", $a_image);
                $this->pdo->update('pageprofiles', $data, "page_id=".$this->in['page_id']);
                
                $rt['code'] = 1;
                $rt['img'] = $upload;
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='remove_images'){
            $profile = $this->pdo->fetch_one("SELECT * FROM pageprofiles WHERE page_id=".$this->in['page_id']);
            $a_image = strlen(@$profile['img_sliders'])>30 ? explode(";", $profile['img_sliders']) : [];
            //$img = $a_image[$this->in['id']];
            @unlink($this->page->get_folder_img($this->in['page_id']).$a_image[$this->in['id']]);
            unset($a_image[$this->in['id']]);
            
            $data = [];
            $data['img_sliders'] = implode(";", $a_image);
            $this->pdo->update('pageprofiles', $data, "page_id=".$this->in['page_id']);
        }
        
        echo json_encode($rt);
    }
    
    
    function product(){
        $rt = [];
        
        if(isset($this->in['action'])&&$this->in['action']=='_admin'){
            $key = isset($this->in['key']) ? $this->in['key'] : null;
            $status = isset($this->in['status']) ? $this->in['status'] : -1;
            $category = isset($this->in['category']) ? $this->in['category'] : 0;
            $where = "a.page_id=" . $this->in['page_id'];
            
            if ($key != null) $where .= " AND a.name LIKE '%$key%'";
            if ($status != -1) $where .= " AND a.status=$status";
            if ($category != 0) $where .= " AND a.taxonomy_id=$category";
            
            $sql = "SELECT a.id,a.name,a.images,a.status,a.ismain,a.isimport,a.iswhole,a.views,a.score,a.price,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT SUM(number) FROM productorderitems i WHERE i.page_id=a.page_id AND i.product_id=a.id) AS orders,
                (SELECT type FROM pages s WHERE s.id=a.page_id) AS pagetype FROM products a WHERE $where ORDER BY a.id DESC";
            $rt['number'] = $this->pdo->count_rows($sql);
            $sql .= " LIMIT ".$this->in['limit'];
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            
            $rt['products'] = [];
            while ($item = $stmt->fetch()) {
                $a_images = explode(";", $item['images']);
                $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
                $item['url_edit'] = "?mod=product&site=editdetail&id=" . $item['id'];
                $item['url_edit_cate'] = "?mod=product&site=create&id=" . $item['id'];
                $item['status_tx'] = $this->product->status[$item['status']];
                $item['status_color'] = $this->status_color[$item['status']];
                $item['url'] = $this->product->get_url($item['id'], $item['name']);
                $rt['products'][] = $item;
            }
            
            $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=" . $this->profile['package_id']);
            $limit_push_top = isset($package['limit_push_top']) ? intval($package['limit_push_top']): 5;;
            $sum_click_top_day = $this->pdo->fetch_all("SELECT SUM(count_click) as sum_click FROM page_push_tops WHERE page_id=".$this->page_id."
                AND created_at>='".date("Y-m-d 00:00:00", time())."' AND created_at<'".date("Y-m-d 23:59:59", time())."'");
            
            $sum_click_top_day = !empty($sum_click_top_day[0]) ? $sum_click_top_day[0]['sum_click'] : 0;
            $a_pagecategory = $this->tax->get_product_category_ofpage($this->page_id);
            
            $a_category = [];
            foreach ($a_pagecategory as $item) {
                $a_category[$item['id']] = $item['name'];
            }
            
            $list_product_top_day = $this->pdo->fetch_all("SELECT product_id FROM page_push_tops WHERE page_id=".$this->page_id."
                AND created_at>='".date("Y-m-d 00:00:00", time())."' AND created_at<'".date("Y-m-d 23:59:59", time())."'");
            $product_id_arr = [];
            foreach ($list_product_top_day AS $item){
                $product_id_arr[$item['product_id']] = true;
            }
            
            $rt['limit_push_top'] = $limit_push_top;
            $rt['count_product_top'] = !empty($sum_click_top_day) ? $sum_click_top_day : 0;
            $rt['select_category'] = $this->help->get_select_from_array($a_category, $category, "Chọn danh mục");
            $rt['select_status'] = $this->help->get_select_from_array($this->product->status, $status, "Chọn trạng thái");
            $rt['select_status_value'] = $this->help->get_select_array_value($this->product->status);
            $rt['key'] = $key;
            $rt['product_id_arr'] = $product_id_arr;
        }elseif(isset($this->in['action'])&&$this->in['action']=='_all'){
            $sql = "SELECT a.id,a.name,a.images,a.code,a.trademark,a.description,
    				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
    				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
    				FROM products a WHERE a.status=1 AND a.page_id=".$this->page_id." ORDER BY a.id ASC";
            $sql .= " LIMIT ".$this->in['limit'];
            //var_dump($sql);
            $rt = $this->pdo->fetch_all($sql);
            foreach ($rt AS $k=>$v){
                $a_images = explode(";", $v['images']);
                $rt[$k]['image'] = $this->img->get_image($this->product->get_folder_img($v['id']), @$a_images[0]);
                $rt[$k]['metas'] = $this->pdo->fetch_all("SELECT meta_key,meta_value FROM product_id=".$v['id']);
            }
            
        }elseif(isset($this->in['action'])&&$this->in['action']=='_list'){
            $sql = "SELECT a.id,a.name,a.images,a.status,
    				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
    				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
    				FROM products a WHERE a.page_id=".$this->page_id;
            
            if(isset($this->in['ismain'])&&$this->in['ismain']==1) $sql .= " AND a.ismain=1";
            elseif(isset($this->in['isimport'])&&$this->in['isimport']==1) $sql .= " AND a.isimport=1";
            elseif(isset($this->in['iswhole'])&&$this->in['iswhole']==1) $sql .= " AND a.iswhole=1";
            $sql .= " ORDER BY a.id DESC";
            
            $rt['number'] = $this->pdo->count_rows($sql);
            $sql .= " LIMIT ".$this->in['limit'];
            //lib_dump($this->profile);
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            $rt['db'] = [];
            while ($item = $stmt->fetch()) {
                $a_images = explode(";", $item['images']);
                $item['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
                $item['url_edit'] = "?mod=product&site=editdetail&id=" . $item['id'];
                $item['url_edit_cate'] = "?mod=product&site=create&id=" . $item['id'];
                $item['status'] = $this->product->status[$item['status']];
                $rt['db'][] = $item;
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='_form'){
            $rt = $this->pdo->fetch_one("SELECT * FROM products WHERE id=".$this->in['id']);
            $rt['folder'] = URL_UPLOAD . $this->product->get_folder_img($this->in['id']);
            $rt['metas'] = $this->pdo->fetch_all("SELECT meta_key,meta_value FROM productmetas WHERE product_id=".$rt['id']." ORDER BY id");
            $rt['prices'] = $this->pdo->fetch_all("SELECT version,price FROM productprices WHERE product_id=".$rt['id']." ORDER BY id");
            
            $a_image = strlen($rt['images']) > 30 ? explode(";", $rt['images']) : [];
            
            $a_image_show = [];
//             for ($i = 0; $i < 6; $i++) {
//                 if (isset($a_image[$i]) && is_file($this->product->get_folder_img_upload($this->in['id']) . $a_image[$i])) {
//                     $a_image_show[$i] = $this->img->get_image($this->product->get_folder_img($this->in['id']), $a_image[$i]);
//                 } else {
//                     $a_image_show[$i] = NO_IMG;
//                     unset($a_image[$i]);
//                 }
//             }
            
            foreach ($a_image AS $v){
                if (is_file($this->product->get_folder_img_upload($this->in['id']).$v)) {
                    $a_image_show[] = $this->img->get_image($this->product->get_folder_img($this->in['id']), $v);
                }
            }
            
            $rt['a_image'] = $a_image_show;
            $rt['avatar'] = isset($a_image_show[0])?$a_image_show[0]:NO_IMG;
            $rt['images'] = implode(";", $a_image);
            $rt['s_unit'] = $this->tax->get_select_taxonomy('product_unit', @$rt['unit_id'], 0, null, 'Chọn đơn vị');
            
            
        }elseif(isset($this->in['action'])&&$this->in['action']=='_create'){
            $taxonomy_id = intval(@$this->in['taxonomy_id']);
            $id = intval(@$this->in['id']);
            
            if($this->pdo->check_exist("SELECT 1 FROM taxonomy WHERE parent=$taxonomy_id")){
                $rt['code'] = 0;
                $rt['msg'] = "Vui lòng chọn danh mục cấp nhỏ nhất.";
            }else{
                $data['taxonomy_id'] = $taxonomy_id;
                if($id == 0){
                    $data['user_id'] = $this->in['user_id'];
                    $data['page_id'] = $this->page_id;
                    $data['created'] = time();
                    $rt['code'] = $this->pdo->insert('products', $data);
                    $data['id'] = $rt['code'];
                }else{
                    $data['created'] = time();
                    $this->pdo->update('products', $data, 'id=' . $id);
                    
                    $rt['code'] = $id;
                }
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='_edit'){
            $id  = intval(@$this->in['id']);
            $data['name'] = trim(@$this->in['name']);
            $data['code'] = trim(@$this->in['code']);
            $data['price'] = intval(@$this->in['price']);
            $data['promo'] = intval(@$this->in['promo']);
            $data['trademark'] = trim(@$this->in['trademark']);
            $data['keyword'] = trim(@$this->in['keyword']);
            $data['ability'] = trim(@$this->in['ability']);
            $data['ordertime'] = trim(@$this->in['ordertime']);
            $data['minorder'] = intval(@$this->in['minorder']);
            $data['inventory'] = intval(@$this->in['inventory']);
            $data['unit_id'] = intval(@$this->in['unit_id']);
            $data['description'] = trim(@$this->in['description']);
            $data['package'] = trim(@$this->in['package']);
            $data['qa'] = trim(@$this->in['qa']);
            $data['user_id'] = $this->in['user_id'];
            $data['status'] = intval(@$this->in['status']);;
            $data['created'] = time();
//             if (isset($this->in['key']) && is_array($this->in['key'])) {
//                 $a_key = [];
//                 foreach ($this->in['key'] as $k => $item) {
//                     if (strlen($item) > 2) $a_key[] = $this->product->get_keyword_id($item);
//                 }
//                 $data['keyword'] = implode(",", $a_key);
//             }
            $this->pdo->update('products', $data, "id=".$id);
            
//             $service_detail = isset($this->in['service_add_detail']) ? $this->in['service_add_detail'] : [];
//             $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
//             foreach ($service_detail as $item) {
//                 if (trim($item['key']) != null && trim($item['value']) != null) {
//                     $data = [];
//                     $data['meta_key'] = trim($item['key'], ":");
//                     $data['meta_value'] = trim($item['value'], ":");
//                     $data['product_id'] = $id;
//                     $this->pdo->insert('productmetas', $data);
//                 }
//             }
            
//             $service_price = isset($this->in['service_add_price']) ? $this->in['service_add_price'] : [];
//             $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
//             foreach ($service_price as $item) {
//                 if (trim($item['key']) != null && trim($item['value']) != null) {
//                     $data = [];
//                     $data['version'] = $item['key'];
//                     $data['price'] = $this->str->convert_money_to_int($item['value']);
//                     $data['product_id'] = $id;
//                     $this->pdo->insert('productprices', $data);
//                 }
//             }
            
        }elseif(isset($this->in['action'])&&$this->in['action']=='update'){
            $data = $this->in;
            unset($data['id'],$data['action']);
            $this->pdo->update('products', $data, 'id='.$this->in['id']);
        }elseif(isset($this->in['action'])&&$this->in['action']=='copy_product'){
            $id = isset($this->in['id']) ? intval($this->in['id']) : 0;
            $product = $this->pdo->fetch_one("SELECT * FROM products WHERE id=$id");
            $productprices = $this->pdo->fetch_all("SELECT * FROM productprices WHERE product_id=$id ORDER BY id");
            $productmetas = $this->pdo->fetch_all("SELECT * FROM productmetas WHERE product_id=$id ORDER BY id");
            unset($product['id']);
            
            $product['name'] = trim(@$this->in['name']);
            $product['images'] = '';
            $product['status'] = 0;
            $product['created'] = time();
            $product['user_id'] = $this->login;
            $product['views'] = 1;
            $product['score'] = 0;
            $product_id = 0;
            if($product_id = $this->pdo->insert('products', $product)) {
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
            
            $rt['id'] = $product_id;
            
        }elseif(isset($this->in['action'])&&$this->in['action']=='upload_images'){
            $id = isset($this->in['id']) ? intval($this->in['id']) : 0;
            $filename = time() . "_" . md5(@$this->in['name']) . "." . $this->in['type'];
            $rt['code'] = 0;
            if($upload = $this->img->upload_image_base64_v1($this->product->get_folder_img($id), @$this->in['img'], $filename, 800, 1)){
                $db = $this->pdo->fetch_one("SELECT images FROM products WHERE id=".$id);
                $a_image = explode(';', $db['images']);
                $a_image[] = $upload;
                $data['images'] = implode(";", $a_image);
                $this->pdo->update('products', $data, "id=".$id);
                $rt['img'] = $upload;
                $rt['code'] = 1;
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='remove_images'){
            $id = isset($this->in['id']) ? intval($this->in['id']) : 0;
            $db = $this->pdo->fetch_one("SELECT images FROM products WHERE id=".$id);
            $a_image = explode(';', $db['images']);
            foreach ($a_image AS $k=>$v){
                if($v==$this->in['file']){
                    unset($a_image[$k]);
                    @unlink($this->product->get_folder_img_upload($id) . @$this->in['file']);
                }
            }
            
            $data = [];
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
        }
        
        echo json_encode($rt);
    }
    
    
    function ads(){
        $rt = [];
        
        if(isset($this->in['action']) && $this->in['action']=='campaign') {
            $sql = "SELECT a.*,(SELECT COUNT(1) FROM adsclicks c WHERE c.campaign_id=a.id) AS total_click,
                (SELECT SUM(c.score) FROM adsclicks c WHERE c.campaign_id=a.id) AS total_score,
                (SELECT SUM(c.score) FROM adsclicks c WHERE (c.campaign_id IN (SELECT id FROM adscampaign WHERE date_finish >='" . date("Y-m-d") . "' AND page_id=".$this->page_id."))) AS total_point
                FROM adscampaign a
                WHERE a.page_id=".$this->page_id." ORDER BY a.id DESC";
            $rt['number'] = $this->pdo->count_rows($sql);
            $score = $this->pdo->fetch_one("SELECT SUM(score) AS numb FROM adsclicks
                WHERE page_id=".$this->page_id." AND DATE_FORMAT(date_click, '%Y-%m')='".date('Y-m')."'");
            $rt['click_ads'] = intval($score['numb']);
            
            $sql .= " LIMIT ".$this->in['limit'];
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            $rt['db'] = [];
            while ($item = $stmt->fetch()) {
                $item['status'] = $this->help->get_btn_status($item['status'], 'adscampaign', $item['id']);
                $rt['db'] [] = $item;
            }
            
        }elseif(isset($this->in['action']) && $this->in['action']=='campaign_frm') {
            $rt = $this->pdo->fetch_one("SELECT * FROM adscampaign WHERE id=".$this->in['id']);
            
            if(intval(@$this->profile['package']['numb_ads'])<=0){
                $rt['error'] = 1;
                $rt['msg'] = 'Quảng cáo chỉ dành cho gian hàng Gold Supplier. Vui lòng nâng cấp lên gói trả phí để sử dụng.';
            }else if(!$rt){
                $rt['score_daily'] = 1;
                $rt['date_start'] = date("d-m-Y");
                $rt['date_finish'] = date("d-m-Y", strtotime('+7day'));
            }else{
                $rt['date_start'] = date("d-m-Y", strtotime($rt['date_start']));
                $rt['date_finish'] = date("d-m-Y", strtotime($rt['date_finish']));
            }
        }elseif(isset($this->in['action']) && $this->in['action']=='campaign_save') {
            $id = intval(@$this->in['id']);
            $rt['code'] = 0;
            $data['name'] = trim(@$this->in['name']);
            $data['date_start'] = date('Y-m-d', strtotime(@$this->in['date_start']));
            $data['date_finish'] = date('Y-m-d', strtotime(@$this->in['date_finish']));
            $data['score_daily'] = trim(@$this->in['score_daily']);
            $data['updated'] = time();
            
            if($id==0){
                $data['page_id'] = $this->page_id;
                $data['user_id'] = $this->in['user_id'];
                $data['created'] = time();
                $this->pdo->insert('adscampaign', $data);
            }else{
                $this->pdo->update('adscampaign', $data, 'id='.$id);
            }
            
            $rt['code'] = 1;
        }elseif(isset($this->in['action']) && $this->in['action']=='campaign_product') {
            $sql = "SELECT a.*,p.name,p.images FROM adsproducts a LEFT JOIN products p ON p.id=a.product_id
                WHERE a.page_id=".$this->page_id." AND a.campaign_id=".$this->in['campaign_id']." ORDER BY a.id DESC";
            
            $rt = $this->pdo->fetch_all($sql);
            foreach ($rt AS $k=>$item){
                $a_images = explode(";", $item['images']);
                $rt[$k]['avatar'] = $this->img->get_image($this->product->get_folder_img($item['product_id']), @$a_images[0]);
                $rt[$k]['status'] = $this->help->get_btn_status($item['status'], 'adsproducts', $item['id']);
            }
            
        }elseif(isset($this->in['action']) && $this->in['action']=='campaign_delete') {
            $id = intval(@$this->in['id']);
            $rt['code'] = 0;
            $rt['msg'] = "Không xóa được nội dung";
            
            if($this->pdo->check_exist("SELECT 1 FROM adsproducts WHERE campaign_id=$id AND page_id=".$this->page_id)){
                $rt['msg'] = "Không xóa được vì có sản phẩm trong chiến dịch";
            }elseif($this->pdo->check_exist("SELECT 1 FROM adscampaign WHERE id=$id AND page_id=".$this->page_id)){
                $this->pdo->query("DELETE FROM adscampaign WHERE id=$id");
                $rt['code'] = 1;
                $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
            }
        }elseif(isset($this->in['action']) && $this->in['action']=='product_frm') {
            $id = intval(@$this->in['id']);
            $campaign_id = intval(@$this->in['campaign_id']);
            $rt = $this->pdo->fetch_one("SELECT * FROM adsproducts WHERE id=$id");
            $products = $this->pdo->fetch_all("SELECT a.id,a.name FROM products a WHERE a.status=1 AND a.page_id=".$this->page_id."
                AND a.id NOT IN (SELECT b.product_id FROM adsproducts b WHERE b.product_id<>".intval($rt['product_id'])." AND b.campaign_id=$campaign_id)");
            
            $a_product = [];
            foreach ($products AS $k=>$item){
                if(!$rt && $k==0){
                    $rt['keyword'] = $item['name'];
                }
                $a_product[$item['id']] = $item['name'];
            }
            
            $rt['score'] = isset($rt['score'])?$rt['score']:1;
            $rt['s_product'] = $this->help->get_select_from_array($a_product, @$rt['product_id']);
        }elseif(isset($this->in['action']) && $this->in['action']=='product_save') {
            $id = intval(@$this->in['id']);
            $rt['code'] = 0;
            $data['score'] = trim(@$this->in['score']);
            $data['keyword'] = trim(@$this->in['keyword']);
            
            if($id==0){
                $data['page_id'] = $this->page_id;
                $data['campaign_id'] = trim(@$this->in['campaign_id']);
                $data['product_id'] = trim(@$this->in['product_id']);
                $data['user_id'] = $this->in['user_id'];
                $data['created'] = time();
                $this->pdo->insert('adsproducts', $data);
            }else $this->pdo->update('adsproducts', $data, 'id='.$id);
            
            $rt['code'] = 1;
        }elseif(isset($this->in['action']) && $this->in['action']=='product_delete') {
            $id = intval(@$this->in['id']);
            $rt['code'] = 0;
            $rt['msg'] = "Không xóa được nội dung";
            
            if($this->pdo->check_exist("SELECT 1 FROM adsproducts WHERE id=$id AND page_id=".$this->page_id)){
                $this->pdo->query("DELETE FROM adsproducts WHERE id=$id");
                $rt['code'] = 1;
                $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
            }
        }elseif(isset($this->in['action']) && $this->in['action']=='product_click') {
            $id = intval(@$this->in['id']);
            
            $sql = "SELECT a.user_ip,a.created,a.user_location,u.name AS user_name FROM adsclicks a
                LEFT JOIN adsproducts p ON p.product_id=a.product_id AND p.campaign_id=a.campaign_id AND p.page_id=a.page_id
                LEFT JOIN users u ON u.id=a.user_id
                WHERE 1=1";
            if($id>0) $sql .= " AND p.id=".$id;
            $sql .= " ORDER BY a.id DESC ORDER BY a.id DESC";
            $rt['number'] = $this->pdo->count_rows($sql);
            if(isset($this->in['limit'])) $sql .= " LIMIT ".$this->in['limit'];
            
            $rt['db'] = $this->pdo->fetch_all($sql);
        }
        
        echo json_encode($rt);
    }
    
    
    function event(){
        $rt = [];
        
        if(isset($this->in['action']) && $this->in['action']=='_list'){
            $sql = "SELECT a.*,
                (SELECT COUNT(1) FROM eventproducts c WHERE c.event_id=a.id AND c.page_id=".$this->page_id.") AS total_product
                FROM events a WHERE status=1
                HAVING total_product>0 OR date_finish>='".date('Y-m-d')."'
                ORDER BY a.date_finish DESC";
            $rt['number'] = $this->pdo->count_rows($sql);
            if(isset($this->in['limit'])) $sql .= " LIMIT ".$this->in['limit'];
            $rt['db'] = $this->pdo->fetch_all($sql);
            foreach ($rt['db'] AS $k=>$item){
                $rt['db'][$k]['avatar'] = $this->img->get_image('images/events/', $item['image']);
                $rt['db'][$k]['url'] = DOMAIN."event/".$this->str->str_convert($item['name'])."-".$item['id'];
            }
            
        }elseif(isset($this->in['action']) && $this->in['action']=='_detail') {
            $rt = $this->pdo->fetch_one('SELECT * FROM events WHERE id='.$this->in['id']);
            $rt['avatar'] = $this->img->get_image('images/events/', $rt['image']);
        }elseif(isset($this->in['action']) && $this->in['action']=='product_list'){
            $sql = "SELECT a.*,p.name,p.images FROM eventproducts a
                LEFT JOIN products p ON p.id=a.product_id
                WHERE a.page_id=".$this->page_id." AND a.event_id=".$this->in['event_id']." ORDER BY a.id DESC";
            $rt = $this->pdo->fetch_all($sql);
            foreach ($rt AS $k=>$item){
                $rt[$k]['avatar'] = $this->product->get_avatar($this->page_id, $item['images']);
                $rt[$k]['status'] = $this->help->get_btn_status($item['status'], 'eventproducts', $item['id']);
            }
            
        }elseif(isset($this->in['action']) && $this->in['action']=='product_frm'){
            $id = intval(@$this->in['id']);
            $event_id = intval(@$this->in['event_id']);
            
            $package = $this->profile['package'];
            $first_time = strtotime(date('Y-m').'-01');
            $last_time = strtotime(date('Y-m-t').' 23:59:59');
            $product_monthly = $this->pdo->count_rows("SELECT 1 FROM eventproducts WHERE created>$first_time AND created<$last_time");
            if($product_monthly>=intval($package['numb_event'])){
                $rt['error'] = 1;
                $rt['msg'] = 'Số lượng đăng tháng này vượt quá giới hạn của gói. Vui lòng chờ sang chu kỳ mới.';
            }else{
                $rt = $this->pdo->fetch_one("SELECT * FROM eventproducts WHERE id=$id");
                $products = $this->pdo->fetch_all("SELECT a.id,a.name FROM products a WHERE a.status=1 AND a.page_id=".$this->page_id."
                    AND a.id NOT IN (SELECT b.product_id FROM eventproducts b WHERE b.product_id<>".intval($rt['product_id'])." AND b.event_id=$event_id)");
                
                $a_product = [];
                foreach ($products AS $item){
                    $a_product[$item['id']] = $item['name'];
                }
                $rt['number'] = $rt?$rt['number']:1;
                $rt['price'] = number_format(@$rt['price']);
                $rt['promo'] = number_format(@$rt['promo']);
                $rt['s_product'] = $this->help->get_select_from_array($a_product, @$rt['product_id']);
            }
        }elseif(isset($this->in['action']) && $this->in['action']=='product_save'){
            $id = intval(@$this->in['id']);
            $product = $this->pdo->fetch_one("SELECT * FROM products WHERE id=".intval(@$this->in['product_id']));
            $rt['code'] = 0;
            $data['price'] = intval(@$product['price']);
            $data['promo'] = $this->str->convert_money_to_int(@$this->in['promo']);
            $data['number'] = intval(@$this->in['number']);
            if($id==0){
                $data['page_id'] = $this->page_id;
                $data['event_id'] = trim(@$this->in['event_id']);
                $data['product_id'] = intval(@$this->in['product_id']);
                $data['user_id'] = $this->in['user_id'];
                $data['created'] = time();
                $this->pdo->insert('eventproducts', $data);
            }else $this->pdo->update('eventproducts', $data, 'id='.$id);
            $rt['code'] = 1;
        }elseif(isset($this->in['action']) && $this->in['action']=='product_delete'){
            $id = intval(@$this->in['id']);
            $rt['code'] = 0;
            $rt['msg'] = "Không xóa được nội dung";
            if($this->pdo->check_exist("SELECT 1 FROM eventproducts WHERE id=$id")){
                $this->pdo->query("DELETE FROM eventproducts WHERE id=$id");
                $rt['code'] = 1;
                $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
            }
        }
        
        echo json_encode($rt);
    }
    
    
    function order(){
        $rt = [];
        if(isset($this->in['action']) && $this->in['action']=='_list') {
            $key = isset($this->in['key'])?$this->in['key']:null;
            $status = isset($this->in['status'])?$this->in['status']:-1;
            $where = "a.page_id=".$this->page_id;
            if($key!=null) $where .= " AND a.customer LIKE '%$key%'";
            if($status!=-1) $where .= " AND a.status=$status";
            
            $sql = "SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a WHERE $where ORDER BY a.id DESC";
            $rt['number'] = $this->pdo->count_rows($sql);
            if(isset($this->in['limit'])) $sql .= " LIMIT ".$this->in['limit'];
            $rt['db'] = $this->pdo->fetch_all($sql);
            foreach ($rt['db'] AS $k=>$item){
                $rt['db'][$k]['code'] = "#OID".$item['page_id'].$item['id'];
            }
        }elseif(isset($this->in['action']) && $this->in['action']=='create') {
            $data = [];
            $data['page_id'] = intval(@$this->in['page_id']);
            $data['customer'] = trim(@$this->in['customer']);
            $data['phone'] = trim(@$this->in['phone']);
            $data['email'] = trim(@$this->in['email']);
            $data['address'] = trim(@$this->in['address']);
            $data['description'] = trim(@$this->in['description']);
            $data['user_id'] = intval(@$this->in['user_id']);
            $data['created'] = time();
            $data['updated'] = time();
            $rt['code'] = 0;
            if ($order_id = $this->pdo->insert('productorders', $data)) {
                $rt['id'] = $order_id;
                $rt['code'] = 1;
                foreach ($this->in['products'] as $k => $item) {
                    $order = [];
                    $order['order_id'] = $order_id;
                    $order['page_id'] = intval(@$this->in['page_id']);
                    $order['product_id'] = $k;
                    $order['number'] = $item['number'];
                    $order['price'] = $item['price'];
                    $this->pdo->insert('productorderitems', $order);
                }
            }
            
        }elseif(isset($this->in['action']) && $this->in['action']=='change_status') {
            $id = intval(@$this->in['id']);
            $order = $this->pdo->fetch_one("SELECT status FROM productorders WHERE id=$id AND page_id=".$this->page_id);
            $rt['code'] = 0;
            if(!$order){
                $rt['msg'] = 'Xảy ra lỗi, vui lòng thử lại';
            }elseif($order['status']==4){
                $rt['msg'] = 'Đơn hàng đã được xử lý từ phía người dùng';
            }else{
                $data['status'] = $this->in['status'];
                $data['updated'] = time();
                $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
                $rt['msg'] = 'Cập nhật đơn hàng thành công';
                $rt['code'] = 1;
            }
        }elseif(isset($this->in['action']) && $this->in['action']=='_detail') {
            $id = isset($this->in['id']) ? intval($this->in['id']) : 0;
            
            $rt = $this->pdo->fetch_one("SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a WHERE a.id=$id AND a.page_id=".$this->page_id);
            
            $rt['items'] = $this->pdo->fetch_all("SELECT a.price,a.number,b.name AS productname
                FROM productorderitems a LEFT JOIN products b ON b.id=a.product_id
                WHERE a.order_id=$id AND a.page_id=".$this->page_id);
            
        }elseif(isset($this->in['action']) && $this->in['action']=='order_form') {
            $id = intval(@$this->in['id']);
            $rt = $this->pdo->fetch_one("SELECT * FROM productorders WHERE id=$id");
        }elseif(isset($this->in['action']) && $this->in['action']=='order_save') {
            $id = intval(@$this->in['id']);
            $data['customer'] = trim(@$this->in['customer']);
            $data['phone'] = trim(@$this->in['phone']);
            $data['email'] = trim(@$this->in['email']);
            $data['address'] = trim(@$this->in['address']);
            $data['description'] = trim(@$this->in['description']);
            $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
        }elseif(isset($this->in['action']) && $this->in['action']=='stat_6m') {
            $start = date('Ym',strtotime('-6 month'));
            $end = date('Ym',strtotime('-1 month'));
            $sql = "SELECT DATE_FORMAT(FROM_UNIXTIME(a.created), '%m-%Y') AS monthlog,a.status,
                SUM((SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id)) AS money
                FROM productorders a WHERE a.page_id=".$this->page_id." 
                    AND DATE_FORMAT(FROM_UNIXTIME(a.created), '%Y%m')<=".$end." AND DATE_FORMAT(FROM_UNIXTIME(a.created), '%Y%m')>=".$start."
                GROUP BY monthlog ORDER BY monthlog";
            //var_dump($sql);
            $rt['db'] = $this->pdo->fetch_all($sql);
            $rt['total'] = $rt['success'] = $rt['inprogress'] = $rt['failed'] = 0;
            $rt['monthly'] = [];
            for ($i=6; $i>=1; $i--) $rt['monthly'][date('m-Y',strtotime('-'.$i.' month'))] = 0;
            foreach ($rt['db'] AS $k=>$v){
                $rt['total'] += $v['money'];
                if($v['status']<3) $rt['inprogress'] += $v['money'];
                elseif($v['status']==3) $rt['success'] += $v['money'];
                else $rt['failed'] += $v['money'];
                
                $rt['monthly'][$v['monthlog']] += $v['money'];
            }
            $rt['avg'] = intval($rt['total']/6);
            
        }elseif(isset($this->in['action']) && $this->in['action']=='stat_thismonth') {
            $sql = "SELECT DATE_FORMAT(FROM_UNIXTIME(a.created), '%d-%m') AS datelog,a.status,COUNT(1) AS number,
                SUM((SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id)) AS totalmoney
                FROM productorders a WHERE a.page_id=".$this->page_id." AND DATE_FORMAT(FROM_UNIXTIME(a.created), '%m%Y')=".date('mY')."
                GROUP BY datelog,a.status ORDER BY datelog";
            $stat = $this->pdo->fetch_all($sql);
            $rt['db'] = $stat;
            $rt['money'] = $rt['money_success'] = $rt['number'] = $rt['number_success'] = $rt['percent_success'] = 0;
            
            $today = intval(date('d'));
            $rt['daily'] = [];
            for($i=1; $i<=$today; $i++){
                if($i<10) $i = '0'.$i;
                $rt['daily'][$i.'-'.date('m')] = 0;
            }
            
            foreach ($stat AS $k=>$v){
                $rt['money'] += $v['totalmoney'];
                $rt['number'] += $v['number'];
                if($v['status']==3){
                    $rt['number_success'] += $v['number'];
                    $rt['money_success'] += $v['totalmoney'];
                }
                $rt['daily'][$v['datelog']] += $v['totalmoney'];
            }
            if($rt['number']>0) $rt['percent_success'] = intval($rt['number_success']/$rt['number']*100);
        }
        echo json_encode($rt);
    }
    
    
    function handle(){
        $rt = [];
        if (isset($this->in['action']) && $this->in['action'] == 'active_item') {
            $sql = "SHOW COLUMNS FROM ".$this->in['table'];
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            $fieldid = $stmt->fetch(PDO::FETCH_COLUMN);
            
            $fieldstatus = "Status";
            if(!$this->pdo->check_exist("SELECT $fieldstatus FROM ".$this->in['table']." LIMIT 1")){
                $fieldstatus = "status";
            }
            $value = $this->pdo->fetch_one("SELECT $fieldstatus FROM ".$this->in['table']." WHERE $fieldid=".$this->in['id']);
            $status = 0;
            if(@$value[$fieldstatus]==0) $status = 1;
            
            $this->pdo->query("UPDATE ".$this->in['table']." SET $fieldstatus=$status WHERE $fieldid=".$this->in['id']);
            echo $status;
            exit();
        }elseif (isset($this->in['action']) && $this->in['action'] == 'push_top_product') {
            $id = intval(@$this->in['id']);
            $data['product_id'] = $this->in['product_id'];
            $rt['code'] = 0;
            $package = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=" . $this->profile['package_id']);
            $sum_click_top_day = $this->pdo->fetch_all("SELECT SUM(count_click) as sum_click FROM page_push_tops WHERE page_id = " . $this->page_id. "
            AND created_at >= " . "'" . date("Y-m-d 00:00:00", time()) . "'" . ' AND created_at < ' . "'" .date("Y-m-d 23:59:59", time()). "'");
            $sum_click_top_day = !empty($sum_click_top_day[0]) ? $sum_click_top_day[0]['sum_click'] : 0;
            
            $limit_push_top = isset($package['limit_push_top']) ? intval($package['limit_push_top']): 5;
            $count_product_top_all = $this->pdo->count_item('page_push_tops', 'page_id=' . $this->page_id);
            
            if ($sum_click_top_day >= $limit_push_top) {
                $rt['msg'] = 'Số lượng sản phẩm đẩy top đã đạt tối đa';
            } else {
                if ($count_product_top_all > 1000) {
                    $this->pdo->query("DELETE FROM page_push_tops WHERE page_id=" . $this->page_id. " ORDER BY id ASC LIMIT 1");
                }
                $check_product = $this->pdo->count_rows( "SELECT id FROM page_push_tops WHERE page_id=" . $this->page_id . " and product_id = " . $data['product_id']);
                if ($check_product >= 1) {
                    $product_one = $this->pdo->fetch_one( "SELECT id, page_id, product_id, count_click FROM page_push_tops WHERE page_id=" . $this->page_id . " and product_id = " . $data['product_id']);
                    $data = [
                        "count_click" => $product_one['count_click'] + 1,
                        "created" => time(),
                    ];
                    $this->pdo->update('page_push_tops', $data, "id = " . $product_one['id'] . " AND page_id= " . $this->page_id . " AND product_id = " . $product_one['product_id']);
                    $rt['msg'] = 'Đưa sản phẩm lên top thành công.';
                    $rt['code'] = 1;
                } else {
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
            echo json_encode($rt);
            exit();
        }
    }

    
    
    
    function update_page_mainproducts(){
        $products = $this->pdo->fetch_one("SELECT GROUP_CONCAT(name) AS namemulti FROM products
            WHERE status=1 AND ismain=1 AND page_id=" . $this->page_id);
        $data['mainproducts'] = $products['namemulti'];
        $this->pdo->update('pageprofiles', $data, "page_id=" . $this->page_id);
        unset($data);
    }
    
}
