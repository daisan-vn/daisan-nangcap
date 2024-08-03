<?php

class Event extends Pageadmin{
    
    function __construct() {
        parent::__construct ();
        
    }
    
    
    function index(){
        global $login;
        $page_id = $this->page_id;
        $data = $rt = [];
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_form'){
            $id = intval(@$_POST['id']);
            $rt['code'] = 0;
            $data['name'] = trim(@$_POST['name']);
            $data['date_start'] = date('Y-m-d', strtotime(@$_POST['date_start']));
            $data['date_finish'] = date('Y-m-d', strtotime(@$_POST['date_finish']));
            $data['score_daily'] = trim(@$_POST['score_daily']);
            $data['updated'] = time();
            if($id==0){
                $data['page_id'] = $page_id;
                $data['user_id'] = $login;
                $data['created'] = time();
                $this->pdo->insert('adscampaign', $data);
            }else{
                $this->pdo->update('adscampaign', $data, 'id='.$id);
            }
            $rt['code'] = 1;
            echo json_encode($rt);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_form'){
            $id = intval(@$_POST['id']);
            $result = $this->pdo->fetch_one("SELECT * FROM adscampaign WHERE id=$id");
            if(!$result){
                $result['score_daily'] = 1;
                $result['date_start'] = date("d-m-Y");
                $result['date_finish'] = date("d-m-Y", strtotime('+7day'));
            }else{
                $result['date_start'] = date("d-m-Y", strtotime($result['date_start']));
                $result['date_finish'] = date("d-m-Y", strtotime($result['date_finish']));
            }
            echo json_encode($result); exit();
        }
        $out = [];
        $package = $this->pdo->fetch_one("SELECT numb_event FROM packages WHERE id=".$this->profile['package_id']);
        $out['numb_event'] = ($package&&$package['numb_event']!=0)?$package['numb_event']:0;
        $first_time = strtotime(date('Y-m').'-01');
        $last_time = strtotime(date('Y-m-t').' 23:59:59');
        $out['product_monthly'] = $this->pdo->count_rows("SELECT 1 FROM eventproducts WHERE created>$first_time AND created<$last_time");
        $out['numb_use'] = $out['numb_event']-$out['product_monthly'];
        
        $sql = "SELECT a.*,
                (SELECT COUNT(1) FROM eventproducts c WHERE c.event_id=a.id AND c.page_id=$page_id) AS total_product
                FROM events a WHERE status=1
                HAVING total_product>0 OR date_finish>='".date('Y-m-d')."'
                ORDER BY a.date_finish DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('eventproducts', null), 20);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['avatar'] = $this->img->get_image('images/events/', $item['image']);
        }
        
        $this->smarty->assign("result", $result);
        $this->smarty->assign("out", $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function products(){
        global $login;
        $page_id = $this->page_id;
        $event_id = intval(@$_GET['id']);
        $data = $rt = [];
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_form'){
            $id = intval(@$_POST['id']);
            $rt['code'] = 0;
            $data['price'] = $this->str->convert_money_to_int(@$_POST['price']);
            $data['promo'] = $this->str->convert_money_to_int(@$_POST['promo']);
            $data['number'] = intval(@$_POST['number']);
            if($id==0){
                $data['page_id'] = $page_id;
                $data['event_id'] = trim(@$_POST['event_id']);
                $data['product_id'] = trim(@$_POST['product_id']);
                $data['user_id'] = $login;
                $data['created'] = time();
                $this->pdo->insert('eventproducts', $data);
            }else $this->pdo->update('eventproducts', $data, 'id='.$id);
            $rt['code'] = 1;
            echo json_encode($rt);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_form'){
            $id = intval(@$_POST['id']);
            $event_id = intval(@$_POST['event_id']);
            
            $package = $this->pdo->fetch_one("SELECT numb_event FROM packages WHERE id=".$this->profile['package_id']);
            $first_time = strtotime(date('Y-m').'-01');
            $last_time = strtotime(date('Y-m-t').' 23:59:59');
            $product_monthly = $this->pdo->count_rows("SELECT 1 FROM eventproducts WHERE created>$first_time AND created<$last_time");
            if($product_monthly>=intval($package['numb_event'])){
                $result = [];
                $result['error'] = 1;
                $result['msg'] = 'Số lượng đăng tháng này vượt quá giới hạn của gói. Vui lòng chờ sang chu kỳ mới.';
            }else{
                $result = $this->pdo->fetch_one("SELECT * FROM eventproducts WHERE id=$id");
                $products = $this->pdo->fetch_all("SELECT a.id,a.name FROM products a WHERE a.status=1 AND a.page_id=".$this->page_id."
                            AND a.id NOT IN (SELECT b.product_id FROM eventproducts b WHERE b.product_id<>".intval($result['product_id'])." AND b.event_id=$event_id)");
                
                $a_product = [];
                foreach ($products AS $item){
                    $a_product[$item['id']] = $item['name'];
                }
                $result['number'] = $result?$result['number']:1;
                $result['price'] = number_format(@$result['price']);
                $result['promo'] = number_format(@$result['promo']);
                $result['s_product'] = $this->help->get_select_from_array($a_product, @$result['product_id']);
            }
            echo json_encode($result); exit();
        }
        $out = [];
        
        $event = $this->pdo->fetch_one('SELECT * FROM events WHERE id='.$event_id);
        $event['avatar'] = $this->img->get_image('images/events/', $event['image']);
        $this->smarty->assign('event', $event);
        
        $out['modify'] = 1;
        if(strtotime($event['date_finish'])<time()) $out['modify'] = 0;
        
        $sql = "SELECT a.*,p.name,p.images FROM eventproducts a
                LEFT JOIN products p ON p.id=a.product_id
                WHERE a.page_id=$page_id AND a.event_id=$event_id ORDER BY a.id DESC";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['avatar'] = $this->product->get_avatar($item['product_id'], $item['images']);
            $result[$k]['status'] = $this->help->get_btn_status($item['status'], 'eventproducts', $item['id']);
        }
        
        $out['event_id'] = $event_id;
        $this->smarty->assign('out', $out);
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function clicks(){
        $id = intval(@$_GET['adsproduct_id']);
        $sql = "SELECT a.user_ip,a.created,a.user_location,u.name AS user_name
                FROM adsclicks a
                LEFT JOIN adsproducts p ON p.product_id=a.product_id AND p.campaign_id=a.campaign_id AND p.page_id=a.page_id
                LEFT JOIN users u ON u.id=a.user_id
                WHERE p.id=$id ORDER BY a.id DESC";
        $result = $this->pdo->fetch_all($sql);
        $this->smarty->assign("result", $result);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function ajax_delete_product() {
        $id = intval(@$_POST['id']);
        $rt = [];
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        // if($this->pdo->check_exist("SELECT 1 FROM eventproducts a LEFT JOIN events e ON e.id=a.event_id
        //     WHERE a.id=$id AND e.date_start<='".date('Y-m-d')."'")){
        //     $rt['msg'] = 'Không thể xóa sản phẩm khi chương trình đang diễn ra.';
        // }else
        if($this->pdo->check_exist("SELECT 1 FROM eventproducts WHERE id=$id")){
            $this->pdo->query("DELETE FROM eventproducts WHERE id=$id");
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
        }
        echo json_encode($rt);
    }
}