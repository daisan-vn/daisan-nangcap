<?php

class Event extends Main {
    public $page_id, $profile, $page_url, $sour, $menu;
    
    function index() {
        $sql = "SELECT a.* FROM events a
                WHERE a.status=1 AND a.date_start<='".date('Y-m-d')."' AND a.date_finish>='".date('Y-m-d')."'
                ORDER BY a.sort ASC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('events', null), 12);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);
        $a_event = [];
        foreach ($result AS $k=>$item){
            $result[$k]['avatar'] = $this->img->get_image('images/events/', $item['image']);
            $result[$k]['url'] =DOMAIN."event/".$this->str->str_convert($item['name'])."-".$item['id'];
            $a_event[] = $item['id'];
        }
        $this->smarty->assign("result", $result);
        
        $sql = "SELECT e.id,e.product_id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,e.promo,e.price
				FROM eventproducts e LEFT JOIN products a ON a.id=e.product_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE e.event_id IN (".implode(',', $a_event).") LIMIT 40";
        $products = $this->pdo->fetch_all($sql);
        foreach ($products AS $k=>$item){
            $products[$k]['avatar'] = $this->product->get_avatar($item['page_id'], $item['images']);
            $products[$k]['url'] = $this->product->get_url($item['product_id'], $item['name'])."?eventproduct_id=".$item['id'];
            $products[$k]['percent'] = ($item['price']>$item['promo']&&$item['promo']>0)?(round((1- $item['promo']/$item['price'])*100) ."%"):"0%";
        }
        $this->smarty->assign("products", $products);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function products(){
        $id = \App::getParam('id', 0);
        $id = explode("-",$id);
        $id = end($id);
        
        $sql_event = "SELECT a.* FROM events a WHERE a.id=$id";
        
        $event = $this->pdo->fetch_one($sql_event);
        $event['date_finish'] = date("Y/m/d",strtotime($event['date_finish'])+7*3600);
        $event['image'] = $this->img->get_image('images/events/', $event['image']);
        $event['banner'] = $this->img->get_image('images/events/', $event['banner']);
        $this->smarty->assign("event",$event);
        
        $sql = "SELECT e.id,e.product_id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,e.promo,e.price
				FROM eventproducts e LEFT JOIN products a ON a.id=e.product_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE e.event_id=".$id." ORDER BY e.id DESC";
        
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('eventproducts', 'event_id='.$id), 30);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
//             $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
//             $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['avatar'] = $this->product->get_avatar($item['page_id'], $item['images']);
            $result[$k]['url'] = $this->product->get_url($item['product_id'], $item['name'])."?eventproduct_id=".$item['id'];
            $result[$k]['percent'] = round((1- $item['promo']/$item['price'])*100) ."%";
        }
        $this->get_seo_metadata(@$event['name'], @$event['description'], @$event['name'], @$event['image']);
        $out = [];
        $out['id']=$id;
        $this->smarty->assign('out', $out);
        $this->smarty->assign("result", $result);
        
        $this->smarty->display('detail.tpl');
    }
    function ajax_load_product_tax() {
        $event_id = isset ( $_POST ['event_id'] ) ? intval ( $_POST ['event_id'] ) : 0;
        $id = isset ( $_POST ['id'] ) ? intval ( $_POST ['id'] ) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 32;
        else $limit = (($page-1)*20+32).',20';
        
        $where = "1=1 AND e.event_id=$event_id";
        if($id!=0) $where .= " AND a.taxonomy_id IN (".implode(",", $this->tax->get_subcategory($id)).")";
        $sql = "SELECT e.id,e.product_id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,e.promo,e.price
				FROM eventproducts e LEFT JOIN products a ON a.id=e.product_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE ".$where." LIMIT ".$limit;
        
        
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['avatar'] = $this->product->get_avatar($item['product_id'], $item['images']);
            $result[$k]['url'] = $this->product->get_url($item['product_id'], $item['name'])."?eventproduct_id=".$item['id'];
            $result[$k]['percent'] = round((1- $item['promo']/$item['price'])*100) ."%";
        }
        $this->smarty->assign('result', $result);
        $this->smarty->display ( 'none.tpl' );
        
    }
    function adsclick(){
        global $login;
        $id = isset($_GET['id'])?intval($_GET['id']):0;
        $product = $this->pdo->fetch_one("SELECT p.id,p.name,p.page_id,a.campaign_id,a.id AS adsproduct_id,a.score
                FROM adsproducts a
                LEFT JOIN adscampaign b ON a.campaign_id=b.id
                LEFT JOIN products p ON a.product_id=p.id
                LEFT JOIN pages pa ON a.page_id=pa.id
                WHERE a.product_id=$id AND b.status=1 AND a.status=1 AND p.status=1 AND pa.status=1 AND pa.score_ads>0");
        if($product){
            $data = [];
            $data['page_id'] = $product['page_id'];
            $data['campaign_id'] = $product['campaign_id'];
            $data['product_id'] = $product['id'];
            $data['score'] = $product['score'];
            $data['user_ip'] = getenv('HTTP_CLIENT_IP')?:
            getenv('HTTP_X_FORWARDED_FOR')?:
            getenv('HTTP_X_FORWARDED')?:
            getenv('HTTP_FORWARDED_FOR')?:
            getenv('HTTP_FORWARDED')?:
            getenv('REMOTE_ADDR');
            $data['user_id'] = $login;
            $ip = $_SERVER['REMOTE_ADDR'];
            $details = json_decode(file_get_contents("http://ipinfo.io/{$ip}/json"));
            $data['user_location'] = $details->city.', '.$details->country;
            $data['date_click'] = date('Y-m-d');
            $data['created'] = time();
            $this->pdo->insert('adsclicks', $data);
            unset($data);
            
            $this->pdo->query('UPDATE adsproducts SET number_click=number_click+1 WHERE id='.$product['adsproduct_id']);
            $this->pdo->query('UPDATE pages SET score_ads=score_ads-'.$product['score'].' WHERE id='.$product['page_id']);
            
            $url = $this->product->get_url($product['id'], $product['name']);
            lib_redirect($url);
        }else{
            lib_redirect_back();
        }
    }
}