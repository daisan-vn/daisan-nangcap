<?php

class Product extends Main
{

    public $page_id, $profile, $page_url, $sour, $menu;

    function get_info_call() {
        $phone = isset($_POST['phone'])? trim($_POST['phone']): '';
        $url = isset($_POST['url'])? trim($_POST['url']): '';
        $email = isset($_POST['email'])? trim($_POST['email']): '';
        if ($phone && $url) {
            $data = [];
            if ($email) {
                $data['email'] = $email;
            }
            $data['phone'] = $phone;
            $data['url'] = $url;
            $data['date_log'] = date('Y-m-d');
            $data['updated'] = time();
            $data['user_ip'] = $this->str->get_client_ip();
            $data['ismobile'] = $this->isMobile();
            $details = json_decode(file_get_contents("http://ipinfo.io/" . $this->str->get_client_ip() . "/json"));
            if ($details) {
                $a_address = [];
                if (isset($details->region))
                    $a_address[] = $details->region;
                if (isset($details->city))
                    $a_address[] = $details->city;
                if (isset($details->country))
                    $a_address[] = $details->country;
                $data['location'] = implode(', ', $a_address);
                unset($a_address);
            }
            $this->pdo->insert('accesslogusers', $data);
            echo 1;
            exit;
        }
        echo 0;
    }

    function index()
    {
        global $location;

        \Service\Ads::instance()->resetDailyPoint();

        $today = date("Y-m-d");
        $out = [];
        $id = isset($this->_get['id']) ? $this->_get['id'] : (isset($_GET['id']) ? intval($_GET['id']) : 0);
        $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
        $taxonomy = $this->pdo->fetch_one("SELECT id,name,level,alias FROM taxonomy WHERE type='product' AND alias='$id' OR id='$id'");
        $id = intval($taxonomy['id']);
        $category = $this->tax->get_value($id);
        $a_category = $this->tax->get_taxonomy('product', intval(@$taxonomy['id']), null, null, 0, 0);

        $this->smarty->assign('taxonomy', $taxonomy);
        $this->smarty->assign('a_category', $a_category);

        $contents = $this->pdo->fetch_one("SELECT contents FROM taxonomy WHERE id =$id");
        $result = json_decode($contents['contents'], true);
        if (is_array($result) || is_object($result)){
            foreach($result as $k => $v){
                $result[$k]['image'] = URL_UPLOAD."keywords/".$v['img_name'];
                $result[$k]['url'] = DOMAIN.'product?k='.urlencode($v['name']);
            }
        }
        $out['a_keyword'] = $result;

        $ads = [];
        $ad_id = [];
        if($page==1){
            $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,ad.campaign_id,
                    (a.pagefee+a.pageverify) AS spage,CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice 
                    FROM adsproducts ad LEFT JOIN adscampaign c ON ad.campaign_id=c.id LEFT JOIN productsearch a ON a.product_id=ad.product_id
                    WHERE a.score>1 AND a.package_end >'$today' AND c.date_start<='$today' AND c.date_finish>='$today' AND ad.status=1 AND c.status=1";
            if($id!=0){
            $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id))
                ORDER BY lft)";
            }
            //$location = isset($_GET['location'])?$_GET['location']:(isset($this->hcache['place']['id'])?$this->hcache['place']['id']:1);
            //if($location!=0) $sql.=" AND a.page_id IN (SELECT p.id FROM pages p WHERE p.status=1 AND p.province_id=$location)";
            $sql .= " GROUP BY a.product_id ORDER BY ad.score DESC,a.score DESC LIMIT 30";
            $ads = $this->pdo->fetch_all($sql);
            foreach ($ads AS $k=>$item){
                $item['metas'] = json_decode($item['metas'], true);
                $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
                $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $item['avatar'] = @$item['a_img'][0];
                $item['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $item['url_ads'] = 'src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time());
                $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
                $item['url_page'] = $this->page->get_pageurl($item['page_id'], @$item['metas']['page_name']);
                $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
                $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
                $ads[$k] = $item;
                $ad_id[] = $item['id'];
            }
        }
        $this->smarty->assign("ads", $ads);
       
        //$location_id = isset($_GET['location_id']) ? trim($_GET['location_id']) : $location;

        $where = "a.status=1 AND a.name<>''";
        if($id!=0){
            $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                    AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id))
                    ORDER BY lft)";
            
        }
        //if($location_id!=0) $where .= " AND a.page_id IN (SELECT p.id FROM pages p WHERE p.status=1 AND p.province_id=$location_id)";
        
        $sql = "SELECT a.id,a.name,a.images,a.page_id,a.trademark,a.ordertime,a.minorder,u.name AS unit,
				IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a LEFT JOIN taxonomy u ON u.id=a.unit_id
				WHERE $where ORDER BY a.featured DESC,a.ismain DESC,a.score DESC,a.views DESC";
        $out['number'] = $this->pdo->count_custom("SELECT COUNT(1) AS number FROM products a LEFT JOIN pages b ON b.id=a.page_id WHERE $where");
        
        $limit = count($a_category)>0?20:30;
        $paging = new \Lib\Core\Pagination($out['number'], $limit);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
            $result[$k]['unit'] = $item['unit']==''?'Piece':$item['unit'];
            $result[$k]['pricemax'] = $item['price']==$item['pricemax']?'':'-'.number_format($item['pricemax']).'đ';
            $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
        }

        # add felico
        $result = array_merge($this->product->get_felico_products($taxonomy['alias'] ?? ''), $result);
        # end add felico

        $this->smarty->assign('result', $result);

        $this->get_breadcrumb($id);
        
        // $out['location'] = $this->help->get_select_location($location_id, 0, 'Tất cả vị trí');
        // $out['url'] = "?mod=product&site=index";
        // if ($id != 0)
        //     $out['url'] .= "&id=$id";
        // if ($location != 0)
        //     $out['url'] .= "&location=$location";
        $this->get_seo_metadata(@$category['title'] ? $category['title'] : $category['name'], @$category['keyword'], @$category['description'], @$category['image']);
        $this->smarty->assign('out', $out);
        $this->smarty->display('category.tpl');
    }

    protected function get_felico_ads_products($cat_slug = '') {
        if (!$cat_slug || preg_match($this->product->felico_category_pattern(), $cat_slug)) {
            $felico_sql = "
                SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,
                    0 AS campaign_id,
                    (a.pagefee+a.pageverify) AS spage,
                    CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice
                FROM (".$this->product->get_felico_query().") t
                INNER JOIN productsearch a ON a.product_id = t.id
                LIMIT 5
            ";

            $result = $this->pdo->fetch_all($felico_sql);
            foreach ($result AS &$item){
                $item['metas'] = json_decode($item['metas'], true);
                $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
                $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $item['avatar'] = @$item['a_img'][0];
                $item['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $item['url_ads'] = 'src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time());
                $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
                $item['url_page'] = $this->page->get_pageurl($item['page_id'], @$item['metas']['page_name']);
                $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
                $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
            }
            return $result;
        }
        return [];
    }

    function search(){
        ini_set('display_errors', 1);
        error_reporting(E_ALL);

        global $login;

        \Service\Ads::instance()->resetDailyPoint();

        $limit = 24;

        $today = date("Y-m-d");
        $out = [];
        $filter = [];
        $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
        $key = isset($_GET['k']) ? trim(urldecode($_GET['k'])) : '';
        $t = isset($_GET['t']) ? intval($_GET['t']) : 0;
        $isads = isset($_GET['ads']) ? intval($_GET['ads']) : 0;
        $key = str_replace("+", " ", $key);
        $key = str_replace('"', '', $key);

        if($t != 0){
            $taxonomy = $this->pdo->fetch_one("SELECT id,name,level FROM taxonomy WHERE type='product' AND id='$t'");
            //$out['key'] = $taxonomy['name'];
        }
        if($key !='' && $t !=0){
            $out['key'] = $taxonomy['name']." - ".$key;
        }elseif($key =='' && $t !=0){
            $out['key'] = $taxonomy['name'];
        }else{
            $out['key'] = $key;
        }
      
        $sql_cat = "SELECT id,name,alias,level FROM taxonomy WHERE status=1 AND level=2 AND name LIKE '%$key%'";
        if($t!=0){
            $sql_cat .= " AND lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$t) AND (SELECT rgt FROM taxonomy WHERE id=$t)";
        }
        $sql_cat .= " LIMIT 18";
        $out['a_category'] = $this->pdo->fetch_all($sql_cat);
        foreach ($out['a_category'] AS $k=>$v){
           // $out['a_category'][$k]['url'] = DOMAIN.'product?k='.$key.'&cat='.$v['id'];
           $out['a_category'][$k]['url'] = $this->tax->get_url('product',$v['id'],$v['alias'],$v['level']);
        }
        $inputok = $this->check_input($key);
        if ($inputok != 1) {
            $this->smarty->display('403.tpl');
            exit();
        }
        
        $filter['cat'] = isset($_GET['cat']) ? intval($_GET['cat']) : 0;
        $filter['assessment_company'] = isset($_GET['assessment_company']) ? intval($_GET['assessment_company']) : 0;
        $filter['is_verified'] = isset($_GET['is_verified']) ? intval($_GET['is_verified']) : 0;
        $filter['is_oem'] = isset($_GET['is_oem']) ? intval($_GET['is_oem']) : 0;
        $filter['is_promo'] = isset($_GET['is_promo']) ? intval($_GET['is_promo']) : 0;
        $filter['is_readytoship'] = isset($_GET['is_readytoship']) ? intval($_GET['is_readytoship']) : 0;
        $filter['minorder'] = isset($_GET['minorder']) ? intval($_GET['minorder']) : '';
        $filter['minprice'] = isset($_GET['minprice']) ? intval($_GET['minprice']) : '';
        $filter['maxprice'] = isset($_GET['maxprice']) ? intval($_GET['maxprice']) : '';
        $filter['location'] = isset($_GET['location'])?$_GET['location']:0;

        $filter['a_location'] = [];

        //Prdoduct Ads
        $ads = [];
        $ad_id = [];
        if($page==1){

            // kien mod

            $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,ad.campaign_id,
                        (a.pagefee+a.pageverify) AS spage,
                        CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice
                    FROM adsproducts ad
                    INNER JOIN adscampaign c ON c.id = ad.campaign_id
                    INNER JOIN productsearch a ON a.product_id = ad.product_id
                    WHERE
                        c.date_start <= CURDATE()
                        AND c.date_finish >= CURDATE()
                        AND c.score_daily_used < c.score_daily
                        AND c.score_used < c.score_total
                        AND ad.status=1
                        AND a.score>1
                        AND c.status=1
                        AND ad.keyword LIKE '%$key%' ";

            // end kien mod
            
            if($t!=0){
                $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                    AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$t) AND (SELECT rgt FROM taxonomy WHERE id=$t))
                    ORDER BY lft)";
            }
            
            if($filter['location']!=''){
                $filter['a_location'] = explode(',', $filter['location']);
                $sql .= " AND a.location_id IN (".$filter['location'].")";
            }
            
            $sql .= " GROUP BY a.product_id ORDER BY ad.score DESC,a.score DESC LIMIT 30";
            
            $ads = $this->pdo->fetch_all($sql);

            foreach ($ads AS $k=>$item){
                $item['metas'] = json_decode($item['metas'], true);
                $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
                $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $item['avatar'] = @$item['a_img'][0];
                $item['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $item['url_ads'] = 'src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time());
                $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
                $item['url_page'] = $this->page->get_pageurl($item['page_id'], @$item['metas']['page_name']);
                $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
                $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
                $ads[$k] = $item;
                $ad_id[] = $item['id'];
            }
        }
        $this->smarty->assign("ads", array_merge($this->get_felico_ads_products(), $ads));

        # sản phẩm top

        $top = [];
        $this->smarty->assign("top", $top);

        # end sản phẩm top
        
        $out['url'] = DOMAIN.'product?k='.$key;

        if ($isads == 1) $out['url'] = $out['url'].'&ads=1';

        if($t != 0 && $key =='') {
            //$out['a_keyword'] = $this->pdo->fetch_all("SELECT id,name,image FROM keywords WHERE status=1 AND taxonomy_id=$t LIMIT 20");
            $contents = $this->pdo->fetch_one("SELECT contents FROM taxonomy WHERE id =$t");
            $result = json_decode($contents['contents'], true);
            foreach($result as $k => $v){
                $result[$k]['image'] = URL_UPLOAD."keywords/".$v['img_name'];
            }
            $out['a_keyword'] = $result;
        }
        else{
            $sql_key = "SELECT a.id,a.name,a.image
            ,CASE
            WHEN a.name LIKE '$key' THEN 12
            WHEN a.name LIKE '$key%' THEN 6
            WHEN a.name LIKE '%$key%' THEN 3 ELSE 0 END AS S1,
            MATCH(a.name) AGAINST('$key') AS S2";
            //if(strlen($key)>3) $where_key .=" AND MATCH(a.name) AGAINST('$key')";
            $sql_key .= " FROM keywords a WHERE a.status=1 ORDER BY S1 DESC,S2 DESC,LENGTH(a.name) ASC";
            $sql_key .= " LIMIT 20";
            $out['a_keyword'] = $this->pdo->fetch_all( $sql_key );
        }

        $paging = new \Lib\Core\Pagination($limit * 20, $limit, 0, 'pagination justify-content-center');
        
        $search_repo = \Repo\ProductSearch::instance();
        $option = $search_repo->getOptionByArray($filter);

        $page = isset($_REQUEST['page'])? intval($_REQUEST['page']): 1;
        $page = $page < 1? 1: $page;

        $option['limit'] = $limit;
        $option['offset'] = ($page - 1) * $option['limit'];

        $option['tax_ids'] = [$t];

        $option['source'] = ['id', 'name', 'images', 'minorder', 'page_id', 'isimport', 'metas', 'url', 'specs', 'source', 'direct', 'src', 'src_type', 'internal_sale'];
        $result = $search_repo->bestSearch($key, $option);

        // foreach ($result as &$item) {
        //     $item['metas'] = json_decode($item['metas'], true);
        //     $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
        //     $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
        //     $item['avatar'] = @$item['a_img'][0];
        //     $item['url']= isset($_GET['ads']) ? $this->product->get_url($item['id'], $this->str->str_convert($item['name'])).'?src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time()) : $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
        //     $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
        //     $item['url_page'] = $this->page->get_pageurl($item['page_id'], @$item['metas']['page_name']);
        //     $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
        //     $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
        //     $item['thongso'] = $this->convert_value_concat($item['thongso'], 'meta_key', 'meta_value');
        //     $item['page_metas'] = json_decode($this->pdo->fetch_one_fields('pageprofiles','metas','page_id='.$item['page_id']), true);
        // }

        foreach ($result as &$item) {
            $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
            $item['a_img'] = $item['images'];
            $item['avatar'] = @$item['a_img'][0];
            if (isset($_GET['ads'])) {
                $item['url']= $this->product->get_url($item['id'], $this->str->str_convert($item['name'])).'?src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time());
            }
            $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
            $item['url_page'] = $item['metas']['page_url'];
            $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
            $item['specs'] = $item['specs'] ?? [];
            $item['page_metas'] = json_decode($this->pdo->fetch_one_fields('pageprofiles','metas','page_id='.$item['page_id']), true);
        }

        $this->smarty->assign("result", $result);
    
        $out['number'] = count($result);
        $out['a_supplier_type'] = [
            'assessment_company'=>['title'=>'Giao dịch đảm bảo'],
            'is_verified'=>['title'=>'Đã xác minh'],
            'is_oem'=>['title'=>'Nhận gia công']
        ];

        foreach ($out['a_supplier_type'] AS $k=>$v) {
            $out['a_supplier_type'][$k]['url'] = $out['url'].'&'.$k.'=1';
            $out['a_supplier_type'][$k]['active'] = 0;

            if ($filter[$k]!=0) {
                $out['a_supplier_type'][$k]['url'] = $this->unset_filter($out['url'], $k);
                $out['a_supplier_type'][$k]['active'] = 1;
            }
        }

        $out['a_product_type'] = [
            'is_promo'=>['title'=>'Đang khuyến mại'],
            'is_readytoship'=>['title'=>'Giao hàng ngay']
        ];

        foreach ($out['a_product_type'] AS $k=>$v) {
            $out['a_product_type'][$k]['url'] = $out['url'].'&'.$k.'=1';
            $out['a_product_type'][$k]['active'] = 0;
            if ($filter[$k] != 0) {
                $out['a_product_type'][$k]['url'] = $this->unset_filter($out['url'], $k);
                $out['a_product_type'][$k]['active'] = 1;
            }
        }
    
       
        foreach ($out['a_keyword'] AS $k=>$v){
            $out['a_keyword'][$k]['url'] = DOMAIN.'product?k='.urlencode($v['name']);
        }
        
        $out['a_location'] = isset($this->cache_tax['province'])?$this->cache_tax['province']:[];
        foreach ($out['a_location'] AS $k=>$v){
            if($filter['location']=='') $out['a_location'][$k]['url'] = $out['url'].'&location='.$v['Id'];
            else {
                $a_url = explode('&', $out['url']);
                foreach ($a_url AS $k1=>$v1){
                    $a_v1 = explode('=', $v1);
                    if($a_v1[0]=='location'){
                        if(in_array($v['Id'], $filter['a_location'])){
                            $a_location = array_diff($filter['a_location'], [$v['Id']]);
                            if(count($a_location)>0) $a_url[$k1] = 'location='.implode(',', $a_location);
                            else unset($a_url[$k1]);
                        }else $a_url[$k1] .= ','.$v['Id'];
                    }
                }
                $out['a_location'][$k]['url'] = implode('&', $a_url);
            }
        }
        
        $out['link_ads'] = $out['url']."&ads=1";
        $out['isads'] = $isads;

        if(@$_GET['type'] == 'list'){
            $out['url'] .="&type=list";
            $this->smarty->assign('content', PRODUCT_LIST);
        }
        elseif(@$_GET['type']=='grid'){
            $out['url'] .="&type=grid";
            $this->smarty->assign('content', PRODUCT_GRID);
        }else $this->smarty->assign('content', PRODUCT_LIST);
        
        $this->smarty->assign('filter', $filter);
        $this->smarty->assign('out', $out);

        $seo_search = [];
        $seo_search['name'] = "Nơi bán ".$key." Giá rẻ, Uy tín, Chất lượng tại Daisan.vn";
        $seo_search['key'] = $key;
        $seo_search['description'] = "Xem ngay Top các đơn vị cung cấp ".$key." hàng đầu tại Việt Nam, Gọi ngay để được tư vấn và xem mẫu. Chiết Khấu Cao. Hàng Có Sẵn. Giao hàng Toàn Quốc.";
        $seo_search['image']=$out['a_keyword'][0]['image'];
       
        $this->get_seo_metadata(@$seo_search['name'], @$seo_search['key'], @$seo_search['description'], @$seo_search['image']);
        
        $this->smarty->display('search.tpl');
    }

    function search_13_6_2024(){
        global $login;

        \Service\Ads::instance()->resetDailyPoint();

        $limit = 24;

        $today = date("Y-m-d");
        $out = [];
        $filter = [];
        $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
        $key = isset($_GET['k']) ? trim($_GET['k']) : '';
        $t = isset($_GET['t']) ? intval($_GET['t']) : 0;
        $isads = isset($_GET['ads']) ? intval($_GET['ads']) : 0;
        $key = str_replace("+", " ", $key);
        $key = str_replace('"', '', $key);

        if($t != 0){
            $taxonomy = $this->pdo->fetch_one("SELECT id,name,level FROM taxonomy WHERE type='product' AND id='$t'");
            //$out['key'] = $taxonomy['name'];
        }
        if($key !='' && $t !=0){
            $out['key'] = $taxonomy['name']." - ".$key;
        }elseif($key =='' && $t !=0){
            $out['key'] = $taxonomy['name'];
        }else{
            $out['key'] = $key;
        }
      
        // cache key search
        // kien off
        // $this->help->set_keyword($key, $login, $this->help->get_ip());
        // if($key!=null){
        //     $HodineCache = (isset($_COOKIE['HodineCache']))?json_decode($_COOKIE['HodineCache'], true):[];
        //     if(!isset($HodineCache['key']) || !is_array($HodineCache['key'])) $HodineCache['key'] = [];
        //     array_unshift($HodineCache['key'], $key);
        //     $HodineCache['key'] = array_unique($HodineCache['key']);
        //     $HodineCache['key'] = array_slice($HodineCache['key'], 0, 10);
        //     setcookie('HodineCache', json_encode($HodineCache), time() + (86400 * 30 * 30), "/");
        // }
        // $kid = -1;
        // $keyword = $this->pdo->fetch_one("SELECT id FROM keywords WHERE name='$key'");
        // if($keyword && $key!=''){
        //     $kid = $keyword['id'];
        //     $this->pdo->query( "UPDATE keywords SET score=score+1 WHERE id=$kid" );
        // }
        // end kien off

        $sql_cat = "SELECT id,name,alias,level FROM taxonomy WHERE status=1 AND level=2 AND name LIKE '%$key%'";
        if($t!=0){
            $sql_cat .= " AND lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$t) AND (SELECT rgt FROM taxonomy WHERE id=$t)";
        }
        $sql_cat .= " LIMIT 18";
        $out['a_category'] = $this->pdo->fetch_all($sql_cat);
        foreach ($out['a_category'] AS $k=>$v){
           // $out['a_category'][$k]['url'] = DOMAIN.'product?k='.$key.'&cat='.$v['id'];
           $out['a_category'][$k]['url'] = $this->tax->get_url('product',$v['id'],$v['alias'],$v['level']);
        }
        $inputok = $this->check_input($key);
        if ($inputok != 1) {
            $this->smarty->display('403.tpl');
            exit();
        }
        
        $filter['cat'] = isset($_GET['cat']) ? intval($_GET['cat']) : 0;
        $filter['assessment_company'] = isset($_GET['assessment_company']) ? intval($_GET['assessment_company']) : 0;
        $filter['is_verified'] = isset($_GET['is_verified']) ? intval($_GET['is_verified']) : 0;
        $filter['is_oem'] = isset($_GET['is_oem']) ? intval($_GET['is_oem']) : 0;
        $filter['is_promo'] = isset($_GET['is_promo']) ? intval($_GET['is_promo']) : 0;
        $filter['is_readytoship'] = isset($_GET['is_readytoship']) ? intval($_GET['is_readytoship']) : 0;
        $filter['minorder'] = isset($_GET['minorder']) ? intval($_GET['minorder']) : '';
        $filter['minprice'] = isset($_GET['minprice']) ? intval($_GET['minprice']) : '';
        $filter['maxprice'] = isset($_GET['maxprice']) ? intval($_GET['maxprice']) : '';
        $filter['location'] = isset($_GET['location'])?$_GET['location']:0;
       // $filter['location'] = isset($_GET['location'])?$_GET['location']:(isset($this->hcache['place']['id'])?$this->hcache['place']['id']:1);
        $filter['a_location'] = [];
        //Prdoduct Ads
        $ads = [];
        $ad_id = [];
        if($page==1){
            // $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,ad.campaign_id,
            //         (a.pagefee+a.pageverify) AS spage,CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice,
            //         (SELECT SUM(c.score) FROM adsclicks c WHERE c.campaign_id IN (SELECT id FROM adscampaign 
            //         WHERE date_finish >='" . date("Y-m-d") . "' AND page_id=a.page_id)
            //         ) AS total_score_used
            //         FROM adsproducts ad LEFT JOIN adscampaign c ON ad.campaign_id=c.id 
            //         LEFT JOIN productsearch a ON a.product_id=ad.product_id
            //         WHERE a.score>1 AND a.package_end >'$today' AND c.date_start<='$today' 
            //         AND c.date_finish>='$today' AND ad.keyword LIKE '%$key%' AND ad.status=1 AND c.status=1";

            // kien mod

            $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,ad.campaign_id,
                        (a.pagefee+a.pageverify) AS spage,
                        CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice
                    FROM adsproducts ad
                    INNER JOIN adscampaign c ON c.id = ad.campaign_id
                    INNER JOIN productsearch a ON a.product_id = ad.product_id
                    WHERE
                        c.date_start <= CURDATE()
                        AND c.date_finish >= CURDATE()
                        AND c.score_daily_used < c.score_daily
                        AND c.score_used < c.score_total
                        AND ad.status=1
                        AND a.score>1
                        AND c.status=1
                        AND ad.keyword LIKE '%$key%' ";

            // end kien mod
            
            if($t!=0){
                $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                    AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$t) AND (SELECT rgt FROM taxonomy WHERE id=$t))
                    ORDER BY lft)";
            }
            
            if($filter['location']!=''){
                $filter['a_location'] = explode(',', $filter['location']);
                $sql .= " AND a.location_id IN (".$filter['location'].")";
            }
            
            $sql .= " GROUP BY a.product_id ORDER BY ad.score DESC,a.score DESC LIMIT 30";
            
            $ads = $this->pdo->fetch_all($sql);

            foreach ($ads AS $k=>$item){
                $item['metas'] = json_decode($item['metas'], true);
                $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
                $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $item['avatar'] = @$item['a_img'][0];
                $item['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $item['url_ads'] = 'src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time());
                $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
                $item['url_page'] = $this->page->get_pageurl($item['page_id'], @$item['metas']['page_name']);
                $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
                $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
                // $item['show_ads'] = $this->page->get_scoreads($item['page_id']) - $item['total_score_used'];
                $ads[$k] = $item;
                $ad_id[] = $item['id'];
            }
        }
        $this->smarty->assign("ads", array_merge($this->get_felico_ads_products(), $ads));

        # sản phẩm top

        $top = [];
        $top_id = [];

        $like_query = \Lib\DB\Help::get_like_query('a.name', $key);

        if ($page == 1) {
            $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,a.promo,
                (SELECT GROUP_CONCAT(CONCAT(meta_key,': ',meta_value) separator ';') FROM productmetas WHERE product_id=a.product_id) AS thongso";
        }
        else {
            $sql = "SELECT a.product_id AS id";
        }
        
        // $sql .= ", ".$like_query['query']." 
        //         FROM page_push_tops t
        //         INNER JOIN JOIN (SELECT product_id FROM productsearch
        //             WHERE MATCH (name) AGAINST('".$key."' IN BOOLEAN MODE)
        //             LIMIT 1000
        //         ) b ON b.product_id=t.product_id
        //         INNER JOIN productsearch a ON a.product_id=t.product_id
        //         WHERE t.created_at >= '" . date("Y-m-d 00:00:00", time()) . "' AND t.created_at < '" .date("Y-m-d 23:59:59", time())."'
        //     ";

        $sql .= ", ".$like_query['query']." 
                FROM page_push_tops t
                INNER JOIN productsearch a ON a.product_id=t.product_id
                WHERE t.created_at >= '" . date("Y-m-d 00:00:00", time()) . "' AND t.created_at < '" .date("Y-m-d 23:59:59", time())."'
                HAVING ".$like_query['score'].">0 
            ";

        if($t!=0){
            $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$t) AND (SELECT rgt FROM taxonomy WHERE id=$t))
                ORDER BY lft)";
        }
    
        if($filter['location']!=''){
            $filter['a_location'] = explode(',', $filter['location']);
            $sql .= " AND a.location_id IN (".$filter['location'].")";
        }

        if ($page == 1) {
            $sql .= " ORDER BY ".$like_query['score']." DESC, t.created_at DESC ";
        }
        $sql .= ' LIMIT 9';
        $top = $this->pdo->fetch_all($sql);

        if ($page == 1) {
            foreach ($top AS $k=>$item){
                $item['metas'] = json_decode($item['metas'], true);
                $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
                $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $item['avatar'] = @$item['a_img'][0];
                $item['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
                $item['price_promo'] = $this->product->get_price_promo($item['metas']['pricemin'], $item['metas']['pricemax'], $item['promo']);
                $item['url_page'] = $this->page->get_pageurl($item['page_id'], @$item['metas']['page_name']);
                $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
                $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
                $item['thongso'] = $this->convert_value_concat($item['thongso'], 'meta_key', 'meta_value');
                $top[$k] = $item;
                $top_id[] = $item['id'];
            }
        }
        else {
            foreach ($top AS $item){
                $top_id[] = $item['id'];
            }
            $top = [];
        }
        
        $not_in_top = $top_id? ' a.product_id NOT IN ('.implode(',', $top_id).') AND ': ' ';

        # end sản phẩm top
        
        $this->smarty->assign("top", $top);
        
        $out['url'] = DOMAIN.'product?k='.$key;
        if($isads ==1 )
        $out['url'] = $out['url'].'&ads=1';
        $where = "1=1";
        //if(count($ad_id)>0) $where .= " AND a.product_id NOT IN (".implode(',', $ad_id).")";
        if(isset($_GET['sort']) && $_GET['sort']=='price') $where .= " AND a.price>0";
        if($filter['cat']!=0){
            $out['url'] .= '&cat='.$filter['cat'];
            $where .= " AND a.taxonomy_id=".$filter['cat'];
        }elseif($filter['cat']==0 && $t!=0){
            $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                    AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$t) AND (SELECT rgt FROM taxonomy WHERE id=$t))
                    ORDER BY lft)";
        }
        
        if($filter['assessment_company']!=0){
            $out['url'] .= '&assessment_company='.$filter['assessment_company'];
            $where .= " AND a.pagefee=1";
        }
        if($filter['is_verified']!=0){
            $out['url'] .= '&is_verified='.$filter['is_verified'];
            $where .= " AND a.pageverify=1";
        }
        if($filter['is_oem']!=0){
            $out['url'] .= '&is_oem='.$filter['is_oem'];
            $where .= " AND a.pageoem=1";
        }
        if($filter['is_promo']!=0){
            $out['url'] .= '&is_promo='.$filter['is_promo'];
            $where .= " AND a.promo>0";
        }
        if($filter['is_readytoship']!=0){
            $out['url'] .= '&is_readytoship='.$filter['is_readytoship'];
            $where .= " AND a.number>0";
        }
        if($filter['location']!=''){
            $out['url'] .= '&location='.$filter['location'];
            $filter['a_location'] = explode(',', $filter['location']);
            $where .= " AND a.location_id IN (".$filter['location'].")";
        }
        $out['filter_url'] = $out['url'];
        if($filter['minorder']!=0){
            $out['url'] .= '&minorder='.$filter['minorder'];
            $where .= " AND a.minorder<=".$filter['minorder'];
        }
        if($filter['minprice']!=0){
            $out['url'] .= '&minprice='.$filter['minprice'];
            $where .= " AND a.price>=".$filter['minprice'];
        }
        if($filter['maxprice']!=0){
            $out['url'] .= '&maxprice='.$filter['maxprice'];
            $where .= " AND a.price<=".$filter['maxprice'];
        }

        if($t != 0 && $key =='') {
            //$out['a_keyword'] = $this->pdo->fetch_all("SELECT id,name,image FROM keywords WHERE status=1 AND taxonomy_id=$t LIMIT 20");
            $contents = $this->pdo->fetch_one("SELECT contents FROM taxonomy WHERE id =$t");
            $result = json_decode($contents['contents'], true);
            foreach($result as $k => $v){
                $result[$k]['image'] = URL_UPLOAD."keywords/".$v['img_name'];
            }
            $out['a_keyword'] = $result;
        }
        else{
            // $sql_key = "SELECT a.id,a.name,a.image,
            //     CASE WHEN a.name='$key' THEN 5 
            //     WHEN a.name LIKE '$key%' THEN 3
            //     WHEN a.name LIKE '%$key%' THEN 1
            //     ELSE 0 END AS S1
            //     ";
            $sql_key = "SELECT a.id,a.name,a.image
            ,CASE
            WHEN a.name LIKE '$key' THEN 12
            WHEN a.name LIKE '$key%' THEN 6
            WHEN a.name LIKE '%$key%' THEN 3 ELSE 0 END AS S1,
            MATCH(a.name) AGAINST('$key') AS S2";
            //if(strlen($key)>3) $where_key .=" AND MATCH(a.name) AGAINST('$key')";
            $sql_key .= " FROM keywords a WHERE a.status=1 ORDER BY S1 DESC,S2 DESC,LENGTH(a.name) ASC";
            $sql_key .= " LIMIT 20";
            $out['a_keyword'] = $this->pdo->fetch_all( $sql_key );
        }
       
        if($isads === 0){
            $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.isimport,a.page_id,a.metas,(a.pagefee+a.pageverify) AS spage,
                    CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice,
                    (SELECT GROUP_CONCAT(CONCAT(meta_key,':',meta_value) separator ';') FROM productmetas WHERE product_id=a.product_id) AS thongso,
                    CASE WHEN a.package_end >= '$today' THEN 1 ELSE 0 END AS flag_check ";

            if ($key=='') {
                $sql .= " FROM productsearch a ";
            }
            else {
                $sql .= ", ".$like_query['query']."
                FROM (
                    SELECT product_id FROM productsearch
                    WHERE MATCH (name) AGAINST('".$key."' IN BOOLEAN MODE)
                    LIMIT 1000
                ) b
                INNER JOIN productsearch a ON a.product_id=b.product_id ";
            }

            $sql .= "WHERE ".$not_in_top.$where;

            if ($key=='') {
                $sql .= " GROUP BY a.page_id";
                $sql .= " ORDER BY flag_check DESC, a.featured DESC, a.ismain DESC, a.score DESC";
            } else {
                if (isset($_GET['sort']) && $_GET['sort']=='price') {
                    $sql .= " ORDER BY ".$like_query['score']." DESC, a.featured DESC, a.price ASC, a.score DESC, a.ismain DESC";
                } else {
                    $sql .= " ORDER BY ".$like_query['score']." DESC, a.featured DESC, a.ismain DESC, a.score DESC, flag_check DESC";
                }
            }
        } else {
            $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.isimport,a.page_id,a.metas,ad.campaign_id,
                    (a.pagefee+a.pageverify) AS spage,CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice,
                    (SELECT SUM(c.score) FROM adsclicks c WHERE c.campaign_id IN (SELECT id FROM adscampaign WHERE date_finish >='" . date("Y-m-d") . "' AND page_id=a.page_id)) AS total_score_used
                    FROM adsproducts ad LEFT JOIN adscampaign c ON ad.campaign_id=c.id LEFT JOIN productsearch a ON a.product_id=ad.product_id
                    WHERE ".$where." AND a.score>1 AND a.package_end >'$today' AND c.date_start<='$today' AND c.date_finish>='$today' AND ad.keyword LIKE '%$key%' AND ad.status=1 AND c.status=1";
           
            $sql .= " GROUP BY a.product_id ORDER BY ad.score DESC,a.score DESC";
        }
        $paging = new \Lib\Core\Pagination(480, $limit, 0, 'pagination justify-content-center');
        $sql = $paging->get_sql_limit($sql, count($top_id));
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];

        while ($item = $stmt->fetch()) {
            $item['metas'] = json_decode($item['metas'], true);
            $item['metas']['page_year'] = $this->page->get_yearexp($item['metas']['page_start']);
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
            $item['url']= isset($_GET['ads']) ? $this->product->get_url($item['id'], $this->str->str_convert($item['name'])).'?src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time()) : $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
            $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
            $item['url_page'] = $this->page->get_pageurl($item['page_id'], @$item['metas']['page_name']);
            $item['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $item['url_rfq'] = "?mod=page&site=contact&page_id=".$item['page_id'].'&product_id='.$item['id'];
            $item['thongso'] = $this->convert_value_concat($item['thongso'], 'meta_key', 'meta_value');
            $item['page_metas'] = json_decode($this->pdo->fetch_one_fields('pageprofiles','metas','page_id='.$item['page_id']), true);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
//         lib_dump($result);
        
        $out['number'] = count($result);
        $out['a_supplier_type'] = [
            'assessment_company'=>['title'=>'Giao dịch đảm bảo'],
            'is_verified'=>['title'=>'Đã xác minh'],
            'is_oem'=>['title'=>'Nhận gia công']];
        foreach ($out['a_supplier_type'] AS $k=>$v){
            $out['a_supplier_type'][$k]['url'] = $out['url'].'&'.$k.'=1';
            $out['a_supplier_type'][$k]['active'] = 0;
            if($filter[$k]!=0){
                $out['a_supplier_type'][$k]['url'] = $this->unset_filter($out['url'], $k);
                $out['a_supplier_type'][$k]['active'] = 1;
            }
        }
//         var_dump($out['a_supplier_type']);
        $out['a_product_type'] = [
            'is_promo'=>['title'=>'Đang khuyến mại'],
            'is_readytoship'=>['title'=>'Giao hàng ngay']];
        foreach ($out['a_product_type'] AS $k=>$v){
            $out['a_product_type'][$k]['url'] = $out['url'].'&'.$k.'=1';
            $out['a_product_type'][$k]['active'] = 0;
            if($filter[$k]!=0){
                $out['a_product_type'][$k]['url'] = $this->unset_filter($out['url'], $k);
                $out['a_product_type'][$k]['active'] = 1;
            }
        }
       
        // if($key != ''){
        //     $sql_key .=" FROM keywords a WHERE status=1 ORDER BY S1 DESC,$values DESC LIMIT 20";
        //     $out['a_keyword'] = $this->pdo->fetch_all($sql_key);
        // }
       
        foreach ($out['a_keyword'] AS $k=>$v){
            $out['a_keyword'][$k]['url'] = DOMAIN.'product?k='.urlencode($v['name']);
        }
        
        $out['a_location'] = isset($this->cache_tax['province'])?$this->cache_tax['province']:[];
        foreach ($out['a_location'] AS $k=>$v){
            if($filter['location']=='') $out['a_location'][$k]['url'] = $out['url'].'&location='.$v['Id'];
            else {
                $a_url = explode('&', $out['url']);
                foreach ($a_url AS $k1=>$v1){
                    $a_v1 = explode('=', $v1);
                    if($a_v1[0]=='location'){
                        if(in_array($v['Id'], $filter['a_location'])){
                            $a_location = array_diff($filter['a_location'], [$v['Id']]);
                            if(count($a_location)>0) $a_url[$k1] = 'location='.implode(',', $a_location);
                            else unset($a_url[$k1]);
                        }else $a_url[$k1] .= ','.$v['Id'];
                    }
                }
                $out['a_location'][$k]['url'] = implode('&', $a_url);
            }
        }
        
        $out['link_ads'] = $out['url']."&ads=1";
        $out['isads'] = $isads;

        if(@$_GET['type'] == 'list'){
            $out['url'] .="&type=list";
            $this->smarty->assign('content', PRODUCT_LIST);
        }
        elseif(@$_GET['type']=='grid'){
            $out['url'] .="&type=grid";
            $this->smarty->assign('content', PRODUCT_GRID);
        }else $this->smarty->assign('content', PRODUCT_LIST);
        
        $this->smarty->assign('filter', $filter);
        $this->smarty->assign('out', $out);

        $seo_search = [];
        $seo_search['name'] = "Nơi bán ".$key." Giá rẻ, Uy tín, Chất lượng tại Daisan.vn";
        $seo_search['key'] = $key;
        $seo_search['description'] = "Xem ngay Top các đơn vị cung cấp ".$key." hàng đầu tại Việt Nam, Gọi ngay để được tư vấn và xem mẫu. Chiết Khấu Cao. Hàng Có Sẵn. Giao hàng Toàn Quốc.";
        $seo_search['image']=$out['a_keyword'][0]['image'];
       
        $this->get_seo_metadata(@$seo_search['name'], @$seo_search['key'], @$seo_search['description'], @$seo_search['image']);
        
        $this->smarty->display('search.tpl');
    }

    
    function unset_filter($url, $value){
        $a_url = explode('&', $url);
        foreach ($a_url AS $k=>$v){
            $a_v = explode('=', $v);
            if($a_v[0]==$value) unset($a_url[$k]);
        }
        return implode('&', $a_url);
    }

    function new()
    {
        $id = isset($_GET['categoryId']) ? intval($_GET['categoryId']) : 0;
        $a_category = $this->tax->get_taxonomy('product', intval($id), null, null, 0, 0);
        $a_product = $this->product->get_list(0, $id, "a.status=1", 32, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $this->smarty->assign('a_category', $a_category);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function load_more_new()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 32;
        else $limit = (($page-1)*20+32).',20';
        
        $a_product = $this->product->get_list(0, $id, "a.status=1", $limit, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function readytoship()
    {
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $a_product = $this->product->get_list(0, 0, "a.number>0", 120, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function load_more_readytoship()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 32;
        else $limit = (($page-1)*20+32).',20';
        
        $a_product = $this->product->get_list(0, $id, "a.number>0", $limit, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function toprank()
    {
        $id = isset($_GET['categoryId']) ? intval($_GET['categoryId']) : 0;
        $a_category = $this->tax->get_taxonomy('product', intval($id), null, null, 0, 0);
        //$a_product = $this->product->get_list(0, $id, "a.featured=1", 40, null, "a.views DESC, a.id DESC");
        $a_product = $this->product->get_list(0, $id, null, 40, null, "a.featured=1 DESC,a.score ASC,a.ismain DESC,a.views ASC");
        $this->smarty->assign('result', $a_product);
        $this->smarty->assign('a_category', $a_category);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function load_more_toprank()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 32;
        else $limit = (($page-1)*20+32).',20';
        
        //$a_product = $this->product->get_list(0, $id, "a.featured=1", $limit, null, "a.views DESC, a.id DESC");
        $a_product = $this->product->get_list(0, $id, null, $limit, null, "a.featured=1 DESC,a.score ASC,a.ismain DESC,a.views ASC");
        $this->smarty->assign('result', $a_product);
        $out = [];
        $out['id'] = $id;
        $out['page'] = $page;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function newtrend(){
        $id = isset($_GET['categoryId']) ? intval($_GET['categoryId']) : 0;
        $a_category = $this->tax->get_taxonomy('product', intval($id), null, null, 0, 0);
        $sql = "SELECT a.id,a.name,a.images,a.page_id,u.name AS unit,a.minorder,a.promo,COUNT(1) AS numberview,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM productview pv LEFT JOIN products a ON a.id=pv.product_id
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1";
        if($id!=0){
            $sql .= " AND pv.category_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id))
                ORDER BY lft)";
        }
        $sql .= " GROUP BY pv.product_id ORDER BY numberview DESC LIMIT 40";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->str->str_convert($item['name'])."-".$item['id'].".html";
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = @$item['price']==@$item['pricemax']?'':number_format(@$item['pricemax']).'đ';
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
            $result[$k]['price_show'] = $result[$k]['price'].($result[$k]['pricemax']==''?'':'-'.$result[$k]['pricemax']);
            $result[$k]['price_promo'] = $this->product->get_price_promo($item['price'], $item['pricemax'], $item['promo']);
        }
        $this->smarty->assign('result', $result);
        //lib_dump($result); exit();
        $this->smarty->assign('a_category', $a_category);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function load_more_newtrend(){
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 40;
        else $limit = (($page-1)*20+40).',20';
        
        $sql = "SELECT a.id,a.name,a.images,a.page_id,u.name AS unit,a.minorder,a.promo,COUNT(1) AS numberview,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM productview pv LEFT JOIN products a ON a.id=pv.product_id
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1";
        if($id!=0){
            $sql .= " AND pv.category_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id))
                ORDER BY lft)";
        }
        $sql .= " GROUP BY pv.product_id ORDER BY numberview DESC LIMIT ".$limit;
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->str->str_convert($item['name'])."-".$item['id'].".html";
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = @$item['price']==@$item['pricemax']?'':number_format(@$item['pricemax']).'đ';
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
            $result[$k]['price_show'] = $result[$k]['price'].($result[$k]['pricemax']==''?'':'-'.$result[$k]['pricemax']);
            $result[$k]['price_promo'] = $this->product->get_price_promo($item['price'], $item['pricemax'], $item['promo']);
        }
        
        $this->smarty->assign('result', $result);
        $out = [];
        $out['id'] = $id;
        $out['page'] = $page;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function promotions()
    {
        $id = isset($_GET['categoryId']) ? intval($_GET['categoryId']) : 0;
        $a_category = $this->tax->get_taxonomy('product', intval($id), null, null, 0, 0);
        //$a_product = $this->product->get_list(0, $id, "a.promo>0 AND a.promo_date>='".date('Y-m-d')."'", 40, null, "a.featured DESC,a.id DESC");
        $a_product = $this->product->get_list(0, $id, "a.promo>0", 40, null, "a.featured DESC,a.id DESC");
        $this->smarty->assign('result', $a_product);
        $this->smarty->assign('a_category', $a_category);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function load_more_promotions()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 32;
        else $limit = (($page-1)*20+32).',20';
        
        //$a_product = $this->product->get_list(0, $id, "a.promo>0 AND a.promo_date>='".date('Y-m-d')."'", $limit, null, "a.featured DESC,a.id DESC");
        $a_product = $this->product->get_list(0, $id, "a.promo>0", $limit, null, "a.featured DESC,a.id DESC");
        $this->smarty->assign('result', $a_product);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    function imports()
    {
        $id = isset($_GET['categoryId']) ? intval($_GET['categoryId']) : 0;
        $a_category = $this->tax->get_taxonomy('product', intval($id), null, null, 0, 0);
        $a_product = $this->product->get_list(0, $id, "a.isimport=1", 32, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $this->smarty->assign('a_category', $a_category);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function load_more_imports()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 32;
        else $limit = (($page-1)*20+32).',20';
        
        $a_product = $this->product->get_list(0, $id, "a.isimport=1", $limit, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    function wholesaler()
    {
        $id = isset($_GET['categoryId']) ? intval($_GET['categoryId']) : 0;
        $a_category = $this->tax->get_taxonomy('product', intval($id), null, null, 0, 0);
        $a_product = $this->product->get_list(0, $id, "a.iswhole=1", 32, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $this->smarty->assign('a_category', $a_category);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    function load_more_wholesaler()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        if($page==1) $limit = 32;
        else $limit = (($page-1)*20+32).',20';
        
        $a_product = $this->product->get_list(0, $id, "a.iswhole=1", $limit, null, "a.id DESC");
        $this->smarty->assign('result', $a_product);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function justforyou(){
        $HodineCache = json_decode(@$_COOKIE['HodineCache'], true);
        $category = is_array(@$HodineCache['category_view'])?$HodineCache['category_view']:[];
        
        $location = isset($_GET['location']) ? intval($_GET['location']) : 0;
        $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1";
        if($location!=0) $sql.=" AND a.page_id IN (SELECT p.id FROM pages p WHERE p.status=1 AND p.province_id=$location)";
        if(count($category)>0) $sql .= " AND a.taxonomy_id IN (".implode(',', $category).")";
        $sql.=" HAVING pricemin>0 ORDER BY a.ismain=1 DESC";
        $paging = new \Lib\Core\Pagination(400, 40, 0);
        $sql = $paging->get_sql_limit($sql);
        
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->product->get_url($item['id'], $item['name']);
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = $item['pricemin']==$item['pricemax']?0:$item['pricemax'];
            $result[$k]['price'] = $item['pricemin'] == 0 ? "Liên hệ" : number_format($item['pricemin']);
        }
        if(isset($_GET['action'])&&$_GET['action']=='for_page'){
            $this->smarty->assign('content', "../product/load_just_for_you_inpage.tpl");
        }
        $this->smarty->assign('result', $result);
        $this->smarty->display('detail.tpl');
    }
    
    
    function check_input($key)
    {
        $inputok = 1;
        $blacklistChars = '"\';<>^`{|}~\\#=';
        if (preg_match("/[^a-z0-9A-Z_ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]/u", $key)) {
            $inputok = 1;
        }

        if (preg_match_all("/select|insert|update|delete|location|script|passwd|shadow|<|>/", $key)) {
            $inputok = 0;
        }
        $pattern = preg_quote($blacklistChars, '/');
        if (preg_match('/[' . $pattern . ']/', $key)) {
            $inputok = 0;
        }
        return $inputok;
    }
    function load_child_cate(){
        $id = $_POST['id'];
        $child_all = $this->tax->get_taxonomy('product', $id, null, null, 1, 1);
        $this->smarty->assign('child_all', $child_all);
        $this->smarty->display(LAYOUT_NONE);
    }
    function load_more_product_foryou_bycate(){
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $limit = 30;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        $start = ($page-1)*$limit;
        $limit = $start.',30';
        $result = $this->product->get_list_bycate($id, Null, $limit, 'a.ismain DESC,a.id DESC');
        $this->smarty->assign('result',$result);
        $this->smarty->display(LAYOUT_NONE);
    }
    function category()
    {
        // $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $id = isset($this->_get['id']) ? $this->_get['id'] : (isset($_GET['id']) ? intval($_GET['id']) : 0);
        $taxonomy = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE type='product' AND alias='$id' OR id='$id'");
        $id = @$taxonomy['id'];
        $category = $this->tax->get_value($id);
        $a_category_all = $this->tax->get_taxonomy('product', $id, null, null, 1, 1);
        $this->smarty->assign('a_category_all', $a_category_all);
       
        $a_category_hot = $this->tax->get_taxonomy('product', $id, null, 11);
        $this->smarty->assign('a_category_hot', $a_category_hot);
// quang
        $a_slider = $this->media->get_slides($id, 6);  
        $this->smarty->assign('a_slider', $a_slider);
        
        $a_banner = $this->media->get_images($id,2,8,0,'banner');
        $this->smarty->assign('a_banner', $a_banner);

        $file = "../../constant/info/c_".$id.".json";
        $db = json_decode(@file_get_contents($file), true);
        if(!is_array($db)) $db = [];
        if(count($db)<2||(time()-@filemtime($file))>86400){
            $db = [];
            $db['product_hot'] = $this->product->get_list_group_bypage($id, 'a.ismain=1', 6);
            $db['product_promo'] = $this->product->get_list_bycate($id, "a.promo>0 AND a.promo_date>='".date('Y-m-d')."'", 4);
            $db['product_new'] = $this->product->get_list_bycate($id, null, 4, 'a.id DESC');
            $db['product_foryou'] = $this->product->get_list_bycate($id, null, 30, 'a.ismain DESC,a.id DESC');
            $db['page_top'] = $this->page->get_pages_bycate($id, 'a.featured=1', 4);
            foreach ($db['page_top'] AS $k=>$v){
                $db['page_top'][$k]['products'] = $this->product->get_list_bypage($v['id'], null, 2);
                $page_info = $this->page->get_profile($v['id']);
                $db['page_top'][$k]['metas'] = json_decode($page_info['metas'],true);
            }
            $db['page_oem'] = $this->page->get_pages_bycate($id, 'a.is_oem=1', 3);
            foreach ($db['page_oem'] AS $k=>$v){
                $db['page_oem'][$k]['products'] = $this->product->get_list_bypage($v['id'], null, 3);
                $page_info = $this->page->get_profile($v['id']);
                $db['page_oem'][$k]['metas'] = json_decode($page_info['metas'],true);
            }
            file_put_contents($file, json_encode($db));
        }
        
        # add felico
        $db['product_foryou'] = array_merge($this->product->get_felico_products($taxonomy['alias'] ?? ''), $db['product_foryou']);
        # end add felico
        
//         echo date('H:i:s d-m-Y', filemtime(FILE_TAX));
        $this->smarty->assign('db', $db);

        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        
        $this->get_seo_metadata(@$category['name'], @$category['keyword'], @$category['description'], @$category['image']);
        $this->smarty->assign('category', $category);
        $this->smarty->display(LAYOUT_HOME);
    }

    function mainproduct()
    {
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $category = $this->tax->get_value($id);
        $a_category_all = $this->tax->get_taxonomy('product', $id, null, null, 1, 1);
        $a_product = $this->product->get_list(0, $id, "a.ismain=1", 120, null, "a.views ASC");
        $where = "a.status=1 AND a.ismain=1 AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product' AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id)) ORDER BY lft)";
        $all_product = $this->pdo->count_item('products', $where);
        $this->smarty->assign('a_product', $a_product);
        $this->smarty->assign('a_category_all', $a_category_all);
        $this->smarty->assign('category', $category);
        $this->smarty->assign('all_product', $all_product);
        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function allcategory()
    {
        $a_cate_number = @parse_ini_file(FILE_CATEGORY_NUMBER);
        $this->smarty->assign('a_cate_number', $a_cate_number);

        $a_category_all = $this->tax->get_taxonomy('product', 0, null, null, 1, 1);
        $this->smarty->assign('a_category_all', $a_category_all);

        $a_category_hot = $this->tax->get_taxonomy('product', 0, null, 11);
        $this->smarty->assign('a_category_hot', $a_category_hot);

        if (isset($_GET['build_cate_number'])) {
            $this->build_cate_number();
        }

        $this->smarty->display("home.tpl");
    }

    function build_cate_number($parent = 0)
    {
        $a_sub = $this->pdo->fetch_all("SELECT a.taxonomy_id AS id,COUNT(1) AS number FROM products a
                WHERE a.status=1 AND a.taxonomy_id<>0
                GROUP BY a.taxonomy_id");

        $a_sub_0 = [];
        $a_sub_1 = [];
        $a_sub_2 = [];
        foreach ($a_sub as $item) {
            $a_sub_2[$item['id']] = $item['number'];
        }

        $a_category_all = $this->tax->get_taxonomy('product', 0, null, null, 1, 0);
        foreach ($a_category_all as $item) {
            $a_sub_0[$item['id']] = 0;
            foreach ($item['sub'] as $item1) {
                $a_sub_1[$item1['id']] = 0;
                foreach ($item1['sub'] as $item2) {
                    $a_sub_0[$item['id']] += intval(@$a_sub_2[$item2['id']]);
                    $a_sub_1[$item1['id']] += intval(@$a_sub_2[$item2['id']]);
                }
            }
        }

        $a_cate_number = $a_sub_0 + $a_sub_1 + $a_sub_2;

        file_put_contents(FILE_CATEGORY_NUMBER, lib_arr_to_ini($a_cate_number));

        lib_dump($a_cate_number);
        exit();
    }

    function detail()
    {
        $pid = isset($this->_get['id']) ? $this->_get['id'] : (isset($_GET['pid']) ? intval($_GET['pid']) : 0);
        if (isset($this->_get['id'])) {
            $pid = explode("-", $pid);
            $pid = end($pid);
        }
        $category = is_array(@$this->hcache['category_view'])?$this->hcache['category_view']:[];

        $info = $this->pdo->fetch_one("SELECT a.*,un.name AS unit,c.id AS tax_id,c.name AS category,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax,
                (SELECT GROUP_CONCAT(CONCAT(version,':',price) separator ';') FROM productprices WHERE product_id=a.id) AS prices,
                (SELECT GROUP_CONCAT(CONCAT(meta_key,':',meta_value) separator ';') FROM productmetas WHERE product_id=a.id) AS metas
                FROM products a
                LEFT JOIN taxonomy c ON c.id=a.taxonomy_id
                LEFT JOIN taxonomy un ON un.id=a.unit_id
                WHERE a.id=$pid");
        if(!$info){
            $this->smarty->display('403.tpl');
            exit();
        }
     
        $info['a_img'] = $this->product->get_images($info['images'], $info['page_id'], 0);
        $info['avatar'] = @$info['a_img'][0];
        $info['prices'] = $this->convert_value_concat($info['prices'], 'version', 'price');
        $info['description'] = str_replace('../site/', 'https://daisan.vn/site/', $info['description']);
        $info['description'] = str_replace('https://imgs.daisan.vn/', 'https://daisan.vn/site/upload/', $info['description']);
        $info['description'] = str_replace('http://imgs.beta.daisan.vn/', 'https://daisan.vn/site/upload/', $info['description']);
        $info['description'] = str_replace('https://static01.daisan.vn/site/upload/', 'https://daisan.vn/site/upload/', $info['description']);
        
        $this->aasort($info['prices'], 'price');
        $info['metas'] = $this->convert_value_concat($info['metas'], 'meta_key', 'meta_value');
        $info['price_promo'] = 0;
        if($info['promo']>0){
            $info['price_promo'] = $info['pricemax']*$info['promo']/100;
            foreach ($info['prices'] AS $k=>$v){
                $info['prices'][$k]['promo'] = $v['price']*(100-$info['promo'])/100;
            }
            $info['pricemin'] = $info['pricemax'] - $info['price_promo'];
        }else $info['promo'] = 0;
        $info['created'] = gmdate("Y-m-d", $info['created']);
        
        $eventproduct_id = isset($_GET['eventproduct_id']) ? intval($_GET['eventproduct_id']) : 0;
        if ($eventproduct_id != 0) {
            $epro = $this->pdo->fetch_one('SELECT price,promo FROM eventproducts WHERE id=' . $eventproduct_id);
            $info['prices'] = [];
            $info['prices'][0]['version'] = 'Giá khuyến mãi';
            $info['prices'][0]['price'] = $epro['promo'];
            $info['prices'][1]['version'] = 'Giá gốc';
            $info['prices'][1]['price'] = $epro['price'];
            $this->pdo->query('UPDATE eventproducts SET number_click=number_click+1 WHERE id=' . $eventproduct_id);
        }
        $this->product->ads_click($pid, $this->arg['login']);

        $info['order'] = count($info['prices']) == 0 ? 0 : 1;

        $page = $this->page->get_profile(@$info['page_id']);
        if ($page['isphone'] == 1) {
            $page['phone'] = @$this->option['contact']['phone'];
        }

        $page['phone_hide'] = !empty($page['phone'])? substr($page['phone'], 0, 4). '.xxxxxx': 'Đang cập nhật';

        $this->smarty->assign('page', $page);

        $address = $this->pdo->fetch_all("SELECT id,address FROM pageaddress WHERE page_id=".$info['page_id']." LIMIT 4");
        $this->smarty->assign('address', $address);
        
        $info['url_addcart'] = DOMAIN . "?mod=product&site=addcart&pid=".$pid;
        if ($eventproduct_id != 0) $info['url_addcart'] .= "&eventproduct_id=".$eventproduct_id;

        $info['internal_sale'] = $info['internal_sale'] && $page['internal_sale'];

        $this->smarty->assign('info', $info);

        if (isset($_COOKIE['HodineCache'])) $HodineCache = json_decode($_COOKIE['HodineCache'], true);
        else $HodineCache = [];
        if (!isset($HodineCache['product_view']) || !is_array($HodineCache['product_view'])) $HodineCache['product_view'] = [];
        if (!isset($HodineCache['category_view']) || !is_array($HodineCache['category_view'])) $HodineCache['category_view'] = [];
        array_unshift($HodineCache['product_view'], $pid);
        $HodineCache['product_view'] = array_unique($HodineCache['product_view']);
        $HodineCache['product_view'] = array_slice($HodineCache['product_view'], 0, 3);
        if(intval(@$info['taxonomy_id'])!=0){
            array_unshift($HodineCache['category_view'], intval(@$info['taxonomy_id']));
            $HodineCache['category_view'] = array_unique($HodineCache['category_view']);
            $HodineCache['category_view'] = array_slice($HodineCache['category_view'], 0, 10);
        }
        setcookie('HodineCache', json_encode($HodineCache), time() + (86400 * 30 * 30), "/");

        $out = [];
        $out['a_for_you'] = $this->product->get_list(0,0, "a.id<>".@$info['id']." AND a.taxonomy_id IN (".implode(',', $category).")", 15, null, "a.featured DESC,a.ismain DESC");
         $out['a_other'] = $this->product->get_list(@$info['page_id'],@$info['taxonomy_id'], 'a.id<>'.@$info['id'], 15, null, "a.featured DESC,a.ismain DESC,RAND()");
        $out['a_same_page'] = $this->product->get_list(@$info['page_id'], 0, 'a.id<>'.@$info['id'], 15);
        $this->smarty->assign('out', $out);
        
        $this->set_useronline($info['page_id']);
        
        $this->get_seo_metadata(@$info['name'], @$out['meta_key'], @$info['name'], @$info['avatar']);
        $this->get_breadcrumb(@$info['taxonomy_id']);
        $a_cate_number = @parse_ini_file(FILE_CATEGORY_NUMBER);
        $this->smarty->assign('a_cate_number', $a_cate_number);
        $this->pdo->query("UPDATE products SET views=views+1 WHERE id=$pid");
        $this->save_view(@$info['id'],@$info['page_id'],@$info['taxonomy_id']);
        $this->smarty->display('detail.tpl');
    }

    function save_view($product_id, $page_id, $category_id){
        global $login;
        $data = [];
        $data['product_id'] = $product_id;
        $data['page_id'] = $page_id;
        $data['category_id'] = $category_id;
        $data['user_id'] = $login;
        $data['userip'] = $this->get_client_ip();
        $data['created'] = time();
        $id = $this->pdo->insert('productview', $data);
        //$this->pdo->query("DELETE FROM productview WHERE created<=".strtotime('-30day'));
        return $id;
    }
    
    
    function get_client_ip() {
        $ipaddress = '';
        if (isset($_SERVER['HTTP_CLIENT_IP'])) $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
        else if(isset($_SERVER['HTTP_X_FORWARDED_FOR'])) $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
        else if(isset($_SERVER['HTTP_X_FORWARDED'])) $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
        else if(isset($_SERVER['HTTP_FORWARDED_FOR'])) $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
        else if(isset($_SERVER['HTTP_FORWARDED'])) $ipaddress = $_SERVER['HTTP_FORWARDED'];
        else if(isset($_SERVER['REMOTE_ADDR'])) $ipaddress = $_SERVER['REMOTE_ADDR'];
        else $ipaddress = 'UNKNOWN';
        return $ipaddress;
    }
    
    function get_price_from_number(array $a_price, $number){
        $price = 0;
        if(count($a_price)==1){
            $price = $a_price[0]['price'];
            if($a_price[0]['promo']>0) $price = $a_price[0]['promo'];
        }elseif (count($a_price)>1){
            
        }
        
        return $price;
    }
    
    function aasort(&$array, $key)
    {
        $sorter = [];
        $ret = [];
        reset($array);
        foreach ($array as $ii => $va) {
            $sorter[$ii] = $va[$key];
        }
        asort($sorter);
        foreach ($sorter as $ii => $va) {
            $ret[$ii] = $array[$ii];
        }
        $array = $ret;
    }

    function convert_value_concat($str, $field1 = 'key', $field2 = 'value')
    {
        $ex_str = explode(';', $str);
        $a_str = [];
        foreach ($ex_str as $k => $item) {
            $a_item = explode(':', $item, 2);
            if (count($a_item) == 2) {
                $a_str[$k][$field1] = trim($a_item[0]);
                $a_str[$k][$field2] = trim($a_item[1]);
            }
        }
        return $a_str;
    }

    function load_prices()
    {
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        if ($id != 0) {
            $prices = $this->pdo->fetch_all('SELECT version,price FROM productprices WHERE product_id=' . $id);

            $_SESSION['Product_prices'] = [];
            foreach ($prices as $k => $item) {
                $_SESSION['Product_prices'][$k]['key'] = $item['version'];
                $_SESSION['Product_prices'][$k]['value'] = number_format($item['price']);
            }
        } else {
            $_SESSION['Product_prices'] = isset($_SESSION['Product_prices']) ? $_SESSION['Product_prices'] : [];
        }

        $out = [];
        $out['number'] = count($_SESSION['Product_prices']);
        $this->smarty->assign('result', $_SESSION['Product_prices']);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }

//     function set_useronline($page_id)
//     {
//         global $login;
//         $step_time = time() - 30 * 60;
//         $ip = $_SERVER['REMOTE_ADDR'];
//         $date = date("Y-m-d");
//         $online = $this->pdo->check_exist("SELECT updated,number FROM useronlines
//     			WHERE user_id=$login AND date_log='$date' AND user_ip='$ip' AND page_id=$page_id");
//         $data = [];
//         $data['updated'] = time();
//         if (! $online) {
//             $data['page_id'] = $page_id;
//             $data['user_id'] = $login;
//             $data['user_ip'] = $ip;
//             $data['date_log'] = $date;
//             $data['number'] = 1;
//             $this->pdo->insert('useronlines', $data);
//         } elseif ($online && $online['updated'] < $step_time) {
//             $data['number'] = $online['number'] + 1;
//             $this->pdo->update('useronlines', $data, "user_id=$login AND date_log='$date' AND user_ip='$ip' AND page_id=$page_id");
//         } else {
//             $this->pdo->update('useronlines', $data, "user_id=$login AND date_log='$date' AND user_ip='$ip' AND page_id=$page_id");
//         }
//     }

    function ajax_handle_price()
    {
        $rt = [];
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'add_price') {
            $Product_prices = isset($_SESSION['Product_prices']) ? $_SESSION['Product_prices'] : [];
            $number = count($Product_prices);
            $rt['code'] = 1;
            if ($number > 5) {
                $rt['code'] = 0;
                $rt['msg'] = "Báº¡n chá»‰ Ä‘Æ°á»£c phÃ©p Ä‘Æ°a tá»‘i Ä‘a 6 ná»™i dung.";
            } else {
                $_SESSION['Product_prices'][$number + 1]['key'] = "";
                $_SESSION['Product_prices'][$number + 1]['value'] = "";
            }
            echo json_encode($rt);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_price') {
            $_SESSION['Product_prices'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'delete_price') {
            unset($_SESSION['Product_prices'][$_POST['id']]);
            exit();
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'sort_price') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : - 1;
            $type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
            $me = $_SESSION['Product_prices'][$id];
            if ($type == 'up') {
                $up = $_SESSION['Product_prices'][$id - 1];
                $_SESSION['Product_prices'][$id - 1] = $me;
                $_SESSION['Product_prices'][$id] = $up;
            } else {
                $up = $_SESSION['Product_prices'][$id + 1];
                $_SESSION['Product_prices'][$id + 1] = $me;
                $_SESSION['Product_prices'][$id] = $up;
            }
        } else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'save_price') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $Product_prices = isset($_SESSION['Product_prices']) ? $_SESSION['Product_prices'] : [];
            $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
            foreach ($Product_prices as $item) {
                if (trim($item['key']) != null && trim($item['value']) != null) {
                    $data = [];
                    $data['version'] = $item['key'];
                    $data['price'] = $this->str->convert_money_to_int($item['value']);
                    $data['product_id'] = $id;
                    $this->pdo->insert('productprices', $data);
                    unset($data);
                }
            }
            unset($_SESSION['Product_prices']);
        }
    }

    function adsclick()
    {
        global $login;
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $product = $this->pdo->fetch_one("SELECT p.id,p.name,p.page_id,a.campaign_id,a.id AS adsproduct_id,a.score
                FROM adsproducts a
                LEFT JOIN adscampaign b ON a.campaign_id=b.id
                LEFT JOIN products p ON a.product_id=p.id
                WHERE a.product_id=$id AND b.status=1 AND a.status=1");

        if ($product) {
            $data = [];
            $data['page_id'] = $product['page_id'];
            $data['campaign_id'] = $product['campaign_id'];
            $data['product_id'] = $product['id'];
            $data['score'] = $product['score'];
            $data['user_ip'] = getenv('HTTP_CLIENT_IP') ?: getenv('HTTP_X_FORWARDED_FOR') ?: getenv('HTTP_X_FORWARDED') ?: getenv('HTTP_FORWARDED_FOR') ?: getenv('HTTP_FORWARDED') ?: getenv('REMOTE_ADDR');
            $data['user_id'] = $login;
            $data['date_click'] = date('Y-m-d');
            $data['created'] = time();
            $this->pdo->insert('adsclicks', $data);
            unset($data);
            $this->pdo->query('UPDATE adsproducts SET number_click=number_click+1 WHERE id=' . $product['adsproduct_id']);
            $url = $this->product->get_url($product['id'], $product['name']);
            lib_redirect($url);
        } else {}
    }

    function addcart()
    {
        $pid = isset($_GET['pid']) ? intval($_GET['pid']) : 0;
        $eventproduct_id = isset($_GET['eventproduct_id']) ? intval($_GET['eventproduct_id']) : 0;
        $info = $this->pdo->fetch_one("SELECT a.id,a.name,a.minorder,a.images,a.page_id,b.name AS page_name,
    			(SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1) AS price
    			FROM products a LEFT JOIN pages b ON b.id=a.page_id
    			WHERE a.id=$pid");
        if (! $info) lib_redirect(DOMAIN);
        $info['avatar'] = $this->product->get_avatar($info['page_id'], $info['images']);
        $info['url'] = $this->product->get_url($pid, $info['name']);
        $page_id = $info['page_id'];
        // var_dump($info);
        $_SESSION[SESSION_PRODUCTCART] = isset($_SESSION[SESSION_PRODUCTCART]) ? $_SESSION[SESSION_PRODUCTCART] : [];
        if (!isset($_SESSION[SESSION_PRODUCTCART][$page_id])) {
            $_SESSION[SESSION_PRODUCTCART][$page_id] = [];
            $_SESSION[SESSION_PRODUCTCART][$page_id]['pagename'] = $info['page_name'];
            $_SESSION[SESSION_PRODUCTCART][$page_id]['products'] = [];
        }

        $number = isset($_GET['number'])?intval($_GET['number']):($info['minorder']==0?1:$info['minorder']);
        $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$pid]['id'] = $info['id'];
        $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$pid]['name'] = $info['name'];
        $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$pid]['avatar'] = $info['avatar'];
        $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$pid]['url'] = $info['url'];
        $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$pid]['price'] = $info['price'];
        $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$pid]['number'] = $number;
        if ($eventproduct_id != 0) {
            $epro = $this->pdo->fetch_one('SELECT price,promo FROM eventproducts WHERE id=' . $eventproduct_id);
            $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$pid]['price'] = $epro['promo'];
        }
        lib_redirect("?mod=product&site=cart");
    }

    function cart()
    {
        $cart = isset($_SESSION[SESSION_PRODUCTCART]) ? $_SESSION[SESSION_PRODUCTCART] : [];
        $out = [];
        $out['number'] = 0;
        $out['total'] = 0;
        // lib_dump($_SESSION[SESSION_PRODUCTCART]);
        
        foreach ($cart as $k => $page) {
            $total = 0;
            foreach ($page['products'] as $item) {
                $total += $item['price'] * $item['number'];
                $out['total'] += $item['price'] * $item['number'];
                $out['number'] += 1;
            }
            $cart[$k]['total'] = $total;
        }

        if(isset($_POST['action']) && $_POST['action']=='get_number'){
            echo $out['number'];
            exit();
        }
        
        $this->smarty->assign('cart', $cart);
        $this->smarty->assign("out", $out);
        $this->smarty->display(LAYOUT_HOME);
    }

    // function chung_test(){
    //     $page_id=1;
    //     $order_id=2;
    //     echo get_ssl_page(DOMAIN . '?mod=product&site=set_mail_content_cart&id=' . $page_id . '&order_id=' . $order_id);
    // }

    function payment()
    {
        global $login;
        $cart = isset($_SESSION[SESSION_PRODUCTCART]) ? $_SESSION[SESSION_PRODUCTCART] : [];
        $out = [];
        $out['number'] = 0;
        $out['total'] = 0;
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'payment') {
            $data = [];
            $data['customer'] = trim(@$_POST['name']);
            $data['phone'] = trim(@$_POST['phone']);
            $data['email'] = trim(@$_POST['email']);
            $data['address'] = trim(@$_POST['address']);
            $data['description'] = trim(@$_POST['description']);
            $data['user_id'] = $login;
            $data['created'] = time();
            $data['updated'] = time();
            $rt = [];
            foreach ($cart as $page_id => $page) {
                $data['page_id'] = $page_id;
                if ($order_id = $this->pdo->insert('productorders', $data)) {
                    $rt[] = $order_id;
                    foreach ($page['products'] as $k => $item) {
                        $order = [];
                        $order['order_id'] = $order_id;
                        $order['page_id'] = $page_id;
                        $order['product_id'] = $k;
                        $order['number'] = $item['number'];
                        $order['price'] = $item['price'];
                        $this->pdo->insert('productorderitems', $order);
                        unset($order);
//                         $product = [];
//                         $product['inventory'] = ($item['inventory'] - $item['number']);
//                         $this->pdo->update('products', $product, "id=$k AND page_id=$page_id");
//                         unset($product);
                    }

                    $page = $this->pdo->fetch_one("SELECT id,name,email FROM pages WHERE id=$page_id");

                    if(is_localhost()){
                        $a_mail_to = ['admin@daisan.vn'];
                        $a_mail_cc = [];
                        $a_mail_bcc = [];
                    }else{
                        $a_mail_to = ['admin@daisan.vn'];
                        $a_mail_cc = [
                            'sales@daisan.vn',
                            'nhamphongdaijsc@gmail.com',
                            'chung.nguyenduc@daisan.vn',
                            'minhhieu258ht@gmail.com',
                        ];
                        $a_mail_bcc = [];
                    }

                    $a_mail_bcc[] = $page['email'];

                    $ordercode = "#OID" . $page['id'] . $order_id;
                    $mail_title = "Đơn hàng mới $ordercode";
                    $mail_to = ['TO' => $a_mail_to, 'CC' => $a_mail_cc, 'BCC' => $a_mail_bcc];

                    $mail_content = get_ssl_page(DOMAIN . '?mod=product&site=set_mail_content_cart&id=' . $page_id . '&order_id=' . $order_id);
                    
                    send_mail($mail_to, "DAISAN", $mail_title, $mail_content);
                    
                }
            }

            if(isset($_POST['update_user'])&&$_POST['update_user']==1){
                $data = [];
                $data['phone'] = trim(@$_POST['phone']);
                $data['name'] = trim(@$_POST['name']);
                $data['address'] = trim(@$_POST['address']);
                $this->pdo->update('users', $data, 'id='.$this->arg['login']);
            }
            
            $_SESSION[SESSION_PRODUCTCART] = [];
            echo json_encode($rt);
            exit();
        }
        foreach ($cart as $k => $page) {
            $total = 0;
            foreach ($page['products'] as $item) {
                $total += $item['price'] * $item['number'];
                $out['total'] += $item['price'] * $item['number'];
                $out['number'] += 1;
            }
            $cart[$k]['total'] = $total;
        }

        $out['user'] = $this->pdo->fetch_one('SELECT * FROM users WHERE id='.$this->arg['login']);
        
        $this->smarty->assign('cart', $cart);
        $this->smarty->assign("out", $out);
        $this->smarty->display(LAYOUT_HOME);
    }

    function order_confirm(){
        $oId = $_GET['oId'];
        $id = json_decode($oId, true);
        $this->smarty->assign("out", $id);
        $this->smarty->display(LAYOUT_HOME);
    }

    function set_mail_content_cart()
    {
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $order_id = isset($_GET['order_id']) ? intval($_GET['order_id']) : 0;
        $page = $this->pdo->fetch_one("SELECT a.id,a.name,a.phone,a.email FROM pages a
                WHERE a.id=$id");
        $page['token'] = md5($page['email'] . time());
        $page['url'] = URL_PAGEADMIN . '?mod=order&site=index&token=' . $page['token'];
        $page['codeorder'] = "#OID" . $page['id'] . $order_id;
        $this->smarty->assign('data', $page);
        $where = "a.order_id=$order_id AND a.page_id=$id";
        $detail = $this->pdo->fetch_all("SELECT a.price,a.number,b.name AS productname
                FROM productorderitems a LEFT JOIN products b ON b.id=a.product_id
                WHERE $where");
        $this->smarty->assign('detail', $detail);
        $this->smarty->display(LAYOUT_NONE);
    }

    function ajax_loadmore_product()
    {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $limit = 40;
        $page = isset($_POST['page']) ? trim($_POST['page']) : 1;
        $start = ($page - 1) * $limit;
        $a_product = $this->product->get_list(0, $id, "a.ismain=1", "$start,$limit");
        $this->smarty->assign('a_product', $a_product);
        $this->smarty->display(LAYOUT_NONE);
    }

    
    function load_just_for_you(){
        $HodineCache = json_decode(@$_COOKIE['HodineCache'], true);
        $category = is_array(@$HodineCache['category_view'])?$HodineCache['category_view']:[];
        
        $limit = isset($_GET['limit'])?intval($_GET['limit']):30;
        $location = isset($_GET['location']) ? intval($_GET['location']) : 0;
        $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,a.views,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1";
        if($location!=0) $sql.=" AND a.page_id IN (SELECT p.id FROM pages p WHERE p.status=1 AND p.province_id=$location)";
        if(count($category)>0) $sql .= " AND a.taxonomy_id IN (".implode(',', $category).")";
        $sql.=" HAVING pricemin>0 ORDER BY a.ismain=1 DESC,RAND() LIMIT $limit";
      
       // $sql.=" ORDER BY a.ismain=1 DESC,RAND() LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->product->get_url($item['id'], $item['name']);
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = $item['pricemin']==$item['pricemax']?0:$item['pricemax'];
            $result[$k]['price'] = $item['pricemin'] == 0 ? "Liên hệ" : number_format($item['pricemin']);
        }
        if(isset($_GET['action'])&&$_GET['action']=='for_page'){
            $this->smarty->assign('content', "../product/load_just_for_you_inpage.tpl");
        }
        $this->smarty->assign('result', $result);
        $this->smarty->display(LAYOUT_NONE);
    }

    function load_more_just_for_you(){
        $HodineCache = json_decode(@$_COOKIE['HodineCache'], true);
        $category = is_array(@$HodineCache['category_view'])?$HodineCache['category_view']:[];
        
        $limit = 30;
        $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
        $start = ($page-1)*$limit;
        $limit = $start.',30';

        //$limit = isset($_GET['limit'])?intval($_GET['limit']):12;
        $location = isset($_GET['location']) ? intval($_GET['location']) : 0;
        $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1";
        if($location!=0) $sql.=" AND a.page_id IN (SELECT p.id FROM pages p WHERE p.status=1 AND p.province_id=$location)";
        if(count($category)>0) $sql .= " AND a.taxonomy_id IN (".implode(',', $category).")";
       // $sql.=" HAVING pricemin>0 ORDER BY a.ismain=1 DESC,RAND() LIMIT $limit";
        $sql.=" ORDER BY a.ismain DESC,RAND() LIMIT $limit";
       
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->product->get_url($item['id'], $item['name']);
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = $item['pricemin']==$item['pricemax']?0:$item['pricemax'];
            $result[$k]['price'] = $item['pricemin'] == 0 ? "Liên hệ" : number_format($item['pricemin']);
        }
        if(isset($_GET['action'])&&$_GET['action']=='for_page'){
            $this->smarty->assign('content', "../product/load_just_for_you_inpage.tpl");
        }
       
        $this->smarty->assign('result', $result);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function ajax_handle()
    {
        global $login;
        $data = [];
        $rt = [];
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'cart_add_product') {
            $_SESSION['vsc_session_shop_cart']['product_id'] = intval(@$_POST['id']);
            $_SESSION['vsc_session_shop_cart']['number'] = intval(@$_POST['number']);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'delete_cart') {
            $_SESSION[SESSION_PRODUCTCART] = [];
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'delete_product') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $page_id = isset($_POST['page_id']) ? intval($_POST['page_id']) : 0;

            unset($_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$id]);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'change_number_product') {
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $page_id = isset($_POST['page_id']) ? intval($_POST['page_id']) : 0;
            $number = isset($_POST['number']) ? intval($_POST['number']) : 0;

            $_SESSION[SESSION_PRODUCTCART][$page_id]['products'][$id]['number'] = $number;
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_product_favorite') {
            $id = intval(@$_POST['id']);
            if ($this->pdo->check_exist("SELECT 1 FROM productfavorites WHERE user_id=$login AND product_id=$id")) {
                $rt['code'] = 0;
                $rt['msg'] = 'Bạn đã thêm vào danh sách theo dõi.';
            } else {
                $data['user_id'] = $login;
                $data['product_id'] = $id;
                $data['created'] = time();
                $data['status'] = 1;
                $this->pdo->insert('productfavorites', $data);
                $rt['code'] = 1;
                $rt['msg'] = 'Lưu vào danh sách theo dõi thành công.';
            }
            echo json_encode($rt);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'remove_product_favorite') {
            $id = intval(@$_POST['id']);
            $data['created'] = time();
            $data['status'] = 0;
            $this->pdo->update('productfavorites', $data, "product_id=$id AND user_id=$login");
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'set_view_keyword'){
            $id = intval(@$_POST['id']);
            $this->pdo->query("UPDATE keywords SET score=score+1 WHERE id=$id");
        }
    }

    function stripVN($str)
    {
        $str = preg_replace("/(à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ)/", 'a', $str);
        $str = preg_replace("/(è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ)/", 'e', $str);
        $str = preg_replace("/(ì|í|ị|ỉ|ĩ)/", 'i', $str);
        $str = preg_replace("/(ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ)/", 'o', $str);
        $str = preg_replace("/(ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ)/", 'u', $str);
        $str = preg_replace("/(ỳ|ý|ỵ|ỷ|ỹ)/", 'y', $str);
        $str = preg_replace("/(đ)/", 'd', $str);

        $str = preg_replace("/(À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ)/", 'A', $str);
        $str = preg_replace("/(È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ)/", 'E', $str);
        $str = preg_replace("/(Ì|Í|Ị|Ỉ|Ĩ)/", 'I', $str);
        $str = preg_replace("/(Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ)/", 'O', $str);
        $str = preg_replace("/(Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ)/", 'U', $str);
        $str = preg_replace("/(Ỳ|Ý|Ỵ|Ỷ|Ỹ)/", 'Y', $str);
        $str = preg_replace("/(Đ)/", 'D', $str);
        $str = preg_replace("/[-]+/i", "-", $str);
        $str = preg_replace("/[ ]+/i", '-', $str);
        return $str;
    }
}
