<?php

class Ads extends Pageadmin{
    
    function index(){
        global $login;
        $page_id = $this->page_id;
        $data = $rt = [];

        $default_score_total = 5000;
        $default_score_daily = 500;
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_form'){
            $id = intval(@$_POST['id']);
            $data['name'] = trim(@$_POST['name']);
            $data['date_start'] = date('Y-m-d', strtotime(@$_POST['date_start']));
            $data['date_finish'] = date('Y-m-d', strtotime(@$_POST['date_finish']));
            $data['score_total'] = isset($_POST['score_total'])? intval($_POST['score_total']): $default_score_total;
            $data['score_daily'] = isset($_POST['score_daily'])? intval($_POST['score_daily']): $default_score_daily;
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

            // $package = $this->pdo->fetch_one("SELECT score_ads FROM packages WHERE id=".$this->profile['package_id']);
            
            $result = $this->pdo->fetch_one("SELECT * FROM adscampaign WHERE id=$id");

            // $score_used = $this->pdo->fetch_one("SELECT SUM(c.score) as number FROM adsclicks c WHERE c.campaign_id IN (SELECT id FROM adscampaign WHERE date_finish >='" . date("Y-m-d") . "' AND page_id=".$this->page_id.")");
            // $result['score_daily'] = $this->profile['score_ads'] - $score_used['number'];

            if (!$result) {
                $ads_repo = \Repo\Ads::instance();
                $score_used = $ads_repo->getMonthCampaignPointUsed($this->page_id);
                $result = [];
                $result['score_total'] = max(0, $this->profile['score_ads'] - $score_used);
                $result['score_daily'] = $default_score_daily;
            }
            
            $result['score_ads'] = $this->profile['score_ads'];
            $result['max_score'] = $this->profile['score_ads'];

            if($this->profile['score_ads'] <=0) {
                $result['error'] = 1;
                $result['msg'] = 'Quảng cáo chỉ dành cho gian hàng Gold Supplier. Vui lòng nâng cấp lên gói trả phí để sử dụng.';
            }else if($score_daily <= 0) {
                $rt['code'] = 0;
                $rt['msg'] = 'Bạn đã hết điểm quảng cáo!';
            }

            if (empty($result['date_start'])) {
                $result['date_start'] = date("d-m-Y");
            }
            else {
                $result['date_start'] = date("d-m-Y", strtotime($result['date_start']));
            }

            if (empty($result['date_finish'])) {
                $result['date_finish'] = date("d-m-Y", strtotime('+7day'));
            }
            else {
                $result['date_finish'] = date("d-m-Y", strtotime($result['date_finish']));
            }
            
            echo json_encode($result); exit();
        }
        
        // $sql = "SELECT a.*,
        //         (SELECT COUNT(1) FROM adsclicks c WHERE c.campaign_id=a.id) AS total_click,
        //         (SELECT SUM(c.score) FROM adsclicks c WHERE c.campaign_id=a.id) AS total_score,
        //         (SELECT SUM(c.score) FROM adsclicks c WHERE (c.campaign_id IN (SELECT id FROM adscampaign WHERE date_finish >='" . date("Y-m-d") . "' AND page_id=".$this->page_id."))) AS total_point
        //         FROM adscampaign a
        //         WHERE a.page_id=".$this->page_id." ORDER BY a.id DESC";

        $sql = "SELECT a.*,
            (SELECT COUNT(1) FROM adsclicks c WHERE c.campaign_id=a.id) AS total_click,
            (SELECT SUM(c.score) FROM adsclicks c WHERE c.campaign_id=a.id) AS total_score
            FROM adscampaign a
            WHERE a.page_id=".$this->page_id." ORDER BY a.id DESC";

        $paging = new \Lib\Core\Pagination($this->pdo->count_item('adscampaign', "page_id=".$this->page_id), 20);
        $sql = $paging->get_sql_limit($sql);
       
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $item['status'] = $this->help->get_btn_status($item['status'], 'adscampaign', $item['id']);
            $result[] = $item;
        }

        // kien mod

        $point_used = \Repo\Ads::instance()->getMonthPointUsed($this->page_id);
        $point_left = max(0, $this->profile['score_ads'] - $point_used);
        
        $this->smarty->assign("point_used", $point_used);
        $this->smarty->assign("point_left", $point_left);

        // end kien mod

        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function products(){
        global $login;
        $page_id = $this->page_id;
        $campaign_id = intval(@$_GET['campaign_id']);
        $data = $rt = [];
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_form'){
            $id = intval(@$_POST['id']);
            $rt['code'] = 0;
            $data['score'] = trim(@$_POST['score']);
            $data['keyword'] = trim(@$_POST['keyword']);
            if($id==0){
                $data['page_id'] = $page_id;
                $data['campaign_id'] = trim(@$_POST['campaign_id']);
                $data['product_id'] = trim(@$_POST['product_id']);
                $data['user_id'] = $login;
                $data['created'] = time();
                $this->pdo->insert('adsproducts', $data);
            }else $this->pdo->update('adsproducts', $data, 'id='.$id);
            $rt['code'] = 1;
            echo json_encode($rt);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_form'){
            $id = intval(@$_POST['id']);
            $campaign_id = intval(@$_POST['campaign_id']);
            $result = $this->pdo->fetch_one("SELECT * FROM adsproducts WHERE id=$id");
            $products = $this->pdo->fetch_all("SELECT a.id,a.name FROM products a WHERE a.status=1 AND a.page_id=".$this->page_id."
                        AND a.id NOT IN (SELECT b.product_id FROM adsproducts b WHERE b.product_id<>".intval($result['product_id'])." AND b.campaign_id=$campaign_id)");
            
            $a_product = [];
            foreach ($products AS $k=>$item){
                if(!$result && $k==0){
                    $result['keyword'] = $item['name'];
                }
                $a_product[$item['id']] = $item['name'];
            }
            $result['score'] = isset($result['score'])?$result['score']:1;
            $result['s_product'] = $this->help->get_select_from_array($a_product, @$result['product_id']);
            echo json_encode($result); exit();
        }
        
        $sql = "SELECT a.*,p.name,p.images FROM adsproducts a LEFT JOIN products p ON p.id=a.product_id
                WHERE a.page_id=$page_id AND a.campaign_id=$campaign_id ORDER BY a.id DESC";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $a_images = explode(";", $item['images']);
            $result[$k]['avatar'] = $this->img->get_image($this->product->get_folder_img($item['product_id']), @$a_images[0]);
            $result[$k]['status'] = $this->help->get_btn_status($item['status'], 'adsproducts', $item['id']);
        }
        $out = [];
        $out['campaign_id'] = $campaign_id;
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
        if($this->pdo->check_exist("SELECT 1 FROM adsproducts WHERE id=$id")){
            $this->pdo->query("DELETE FROM adsproducts WHERE id=$id");
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
        }
        echo json_encode($rt);
    }
    
    
    function ajax_delete_camplaign(){
        if(isset($_POST['action']) && $_POST['action']=='delete_item'){
            $id = intval(@$_POST['id']);
            $rt = [];
            if(!$this->pdo->check_exist("SELECT 1 FROM adscampaign WHERE id=$id AND page_id=".$this->page_id)){
                $rt['code'] = 0;
                $rt['msg'] = 'Sản phẩm không chính xác';
            }else{
                $rt['code'] = 1;
                $rt['msg'] = 'Xóa thông tin thành công';
                $this->pdo->query("DELETE FROM adscampaign WHERE id=$id");
            }
            echo json_encode($rt);
            exit();
        }
    }
}