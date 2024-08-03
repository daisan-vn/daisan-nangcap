<?php

class Api{

    public $img, $in, $pdo, $str, $tax, $product, $media, $help, $page;
    
    function __construct(){
        //parent::__construct();
        
        $this->pdo = \Lib\DB::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->img = \Lib\Core\Image::instance();
        
        $this->help = \Lib\Dbo\Help::instance();
        $this->product = \Lib\Dbo\Product::instance();
        $this->page = \Lib\Dbo\Page::instance();
        $this->tax = \Lib\Dbo\Taxonomy::instance();
        $this->media = \Lib\Dbo\Media::instance();
        
        $this->in = json_decode(file_get_contents('php://input'), true);

        // $this->hcache = $this->set_login();
        // $this->arg = [
        //     'login' => intval(@$this->hcache['user']['id'])
        // ];

        $this->arg = [
            'login' => 0
        ];
    }

    function cont(){
        $cont = $this->get_afjson_file(FILE_CONT);
        if(!is_array($cont)||count($cont)==0||(time()-@filemtime(FILE_CONT))>300) $cont = $this->set_cont_home();
        echo json_encode($cont);
    }
    
    function _db(){
        $rt = [];
        
        if(isset($this->in['action'])&&$this->in['action']=='product_promo'){
            $sql = "SELECT a.page_id,a.event_id,a.product_id,a.price,a.promo,a.number_click,a.created,
                    e.name AS event,p.name,p.images,pa.name AS page_name
                    FROM eventproducts a LEFT JOIN products p ON p.id=a.product_id 
                        LEFT JOIN events e ON e.id=a.event_id LEFT JOIN pages pa ON pa.id=a.page_id
                    WHERE a.status=1 AND e.status=1";
            $rt = $this->pdo->fetch_all($sql);
            foreach ($rt AS $k=>$item){
                $a_img = $this->product->get_images($item['images'], $item['page_id']);
                $rt[$k]['avatar'] = $a_img[0];
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='product_trend'){
            $sql = "SELECT COUNT(1) AS number,v.product_id,a.page_id,a.name,a.price,a.images,a.minorder,a.taxonomy_id,
                    u.name AS unit,pa.name AS page_name,t.name AS category,
    				IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                    IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
                    FROM productview v LEFT JOIN products a ON a.id=v.product_id LEFT JOIN taxonomy u ON u.id=a.unit_id
                        LEFT JOIN pages pa ON pa.id=a.page_id LEFT JOIN taxonomy t ON t.id=a.taxonomy_id
                    GROUP BY v.product_id ORDER BY number DESC LIMIT 400";
            $rt = $this->pdo->fetch_all($sql);
            foreach ($rt AS $k=>$item){
                $a_img = $this->product->get_images($item['images'], $item['page_id']);
                $rt[$k]['avatar'] = $a_img[0];
                $rt[$k]['minorder'] = $item['minorder']<1?1:$item['minorder'];
                $rt[$k]['price'] = $item['price']==0?'Liên hệ':number_format($item['price']);
                if($item['pricemax']>$item['price']&&$item['price']>0) $rt[$k]['price'] .= '~'.number_format($item['pricemax']);
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='product_cat'){
            $rt = $this->pdo->fetch_all("SELECT a.id,a.name,a.keyword,a.alias,a.parent,a.level,a.lft,a.rgt,
                    m.name AS image,t.alias AS folder
                    FROM taxonomy a LEFT JOIN media m ON m.id=a.image LEFT JOIN taxonomy t ON m.taxonomy_id=t.id
                    WHERE a.type='product' AND a.status=1");
            foreach ($rt AS $k=>$v){
                $rt[$k]['image'] = $this->img->get_image($this->media->get_path($v['folder'], 1), @$v['image']);
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='keyword'){
            $rt = $this->pdo->fetch_all("SELECT id,name,image FROM keywords WHERE status=1");
        }
        
        echo json_encode($rt);
    }
    
    
    function _idb(){
        $rt = null;
        
        if(isset($this->in['action'])&&$this->in['action']=='number_product'){
            $rt = $this->pdo->count_item('products', 'page_id=' . $this->in['page_id']);
        }elseif(isset($this->in['action'])&&$this->in['action']=='save_product'){
            $page_id = $this->in['page_id'];
            $data['page_id'] = $page_id;
            $data['name'] = $this->get_true_value(@$this->in['name']);
            $data['code'] = $this->get_true_value(@$this->in['sku']);
            $data['description'] = $this->get_true_value(@$this->in['description']);
            $data['keyword'] = $this->get_true_value(@$this->in['category']);
            $data['price'] = $this->get_true_value(@$this->in['price']);
            $data['trademark'] = $this->get_true_value(@$this->in['brand']);
            $data['source'] = @$this->in['url'];
            $data['user_id'] = @$this->in['user_id'];
            $data['created'] = time();
            $data['status']=1;
            
            $domain = parse_url($data['source'], PHP_URL_SCHEME)."://".parse_url($data['source'], PHP_URL_HOST);
            $rt['code'] = 0;
            if($data['price']==0){
                $rt['msg'] = "Không có giá bán";
            }elseif(@$this->in['is_product']==0){
                $rt['msg'] = "Nội dung không phù hợp";
            }elseif(@$this->in['image']==null || $data['name']==null || $page_id==0){
                $rt['msg'] = "Nội dung bị thiếu";
            }elseif($db=$this->pdo->fetch_one("SELECT id FROM products WHERE source='".$data['source']."'")){
                $this->pdo->update('products', $data, 'id='.$db['id']);
                $rt['code'] = 1;
                $rt['msg'] = 'Update sản phẩm '.$db['id'];
            }elseif($this->pdo->check_exist("SELECT 1 FROM products WHERE name='".$data['name']."' AND source LIKE '$domain%'")){
                $rt['msg'] = "Sản phẩm đã tồn tại";
            }elseif($product_id = $this->pdo->insert('products', $data)){
                $data['images'] = $this->img->upload_image_auto_resize_fromurl($this->product->get_folder_img($product_id), @$this->in['image'], 400);
                $this->pdo->update('products', $data, "id=$product_id");
                $this->save_keywords($data['keyword'], $product_id);
                
                $data = [];
                $data['product_id'] = $product_id;
                $data['version'] = 'Giá';
                $data['price'] = @$this->in['price'];
                $this->pdo->insert('productprices', $data);
                
                $this->in['a_metas'] = is_array(@$this->in['a_metas'])?$this->in['a_metas']:[];
                foreach ($this->in['a_metas'] AS $k=>$item){
                    if($k!='' && $item!=''){
                        $data = [];
                        $data['meta_key'] = $k;
                        $data['meta_value'] = $item;
                        $data['product_id'] = $product_id;
                        $this->pdo->insert('productmetas', $data);
                    }
                }
                
                $rt['code'] = 1;
                $rt['msg'] = "Thêm mới sản phẩm";
            }else{
                $rt['msg'] = "Không lưu được";
            }
            
        }
        
        echo $rt;
    }
    
    
    function _page(){
        $rt = [];
        
        if(isset($this->in['action'])&&$this->in['action']=='info'){
            $sql = "SELECT a.page_id,a.event_id,a.product_id,a.price,a.promo,a.number_click,a.created,
                    e.name AS event,p.name,p.images,pa.name AS page_name
                    FROM eventproducts a LEFT JOIN products p ON p.id=a.product_id
                        LEFT JOIN events e ON e.id=a.event_id LEFT JOIN pages pa ON pa.id=a.page_id
                    WHERE a.status=1 AND e.status=1";
            $rt = $this->pdo->fetch_all($sql);
            foreach ($rt AS $k=>$item){
                $a_img = $this->product->get_images($item['images'], $item['page_id']);
                $rt[$k]['avatar'] = $a_img[0];
            }
        }elseif(isset($this->in['action'])&&$this->in['action']=='create'){
            $rt['code'] = 0;
            $rt['msg'] = 'Đăng ký thất bại, vui lòng thử lại sau.';
            $data = [];
            $data['name'] = trim($this->in['Name']);
            $data['phone'] = trim($this->in['Phone']);
            $data['website'] = trim($this->in['Website']);
            $data['created'] = time();
            $data['user_id'] = intval($this->in['user_id']);
            $data['status'] = 2;
            if($this->pdo->check_exist("SELECT 1 FROM pages WHERE name='".$data['name']."'")) {
                $rt['msg'] = 'Tên trang đã tồn tại, vui lòng chọn lại';
            }elseif($pageId = $this->pdo->insert('pages', $data)) {
                $rt['code'] = 1;
                $rt['msg'] = 'Đăng ký gian hàng thành công.';
                $data['page_name'] = "pid" . $pageId . time();
                $this->pdo->update('pages', $data, "id=" . $pageId);
                
                $rt['alias'] = $data['page_name'];
                $rt['id'] = $pageId;
                
                $data = [];
                $data['page_id'] = $pageId;
                $data['user_id'] = intval($this->in['user_id']);
                $data['created'] = time();
                $data['status'] = 1;
                $this->pdo->insert('pageusers', $data);
                
                $data =  [];
                $data['page_id'] = $pageId;
                $this->pdo->insert('pageprofiles', $data);
                $rt['code'] = 1;
            }
        }
        
        echo json_encode($rt);
    }
    
    
    function product_search_12_5_2024(){
        
        \Service\Ads::instance()->resetDailyPoint();

        $key = isset($this->in['key']) ? trim($this->in['key']) : '';
        $key = str_replace("+", " ", $key);
        $key = str_replace('"', '', $key);
        
        $filter['cat'] = isset($this->in['cat']) ? intval($this->in['cat']) : 0;
        $filter['assessment_company'] = isset($this->in['assessment_company']) ? intval($this->in['assessment_company']) : 0;
        $filter['is_verified'] = isset($this->in['is_verified']) ? intval($this->in['is_verified']) : 0;
        $filter['is_oem'] = isset($this->in['is_oem']) ? intval($this->in['is_oem']) : 0;
        $filter['is_promo'] = isset($this->in['is_promo']) ? intval($this->in['is_promo']) : 0;
        $filter['is_readytoship'] = isset($this->in['is_readytoship']) ? intval($this->in['is_readytoship']) : 0;
        $filter['minorder'] = isset($this->in['minorder']) ? intval($this->in['minorder']) : '';
        $filter['minprice'] = isset($this->in['minprice']) ? intval($this->in['minprice']) : '';
        $filter['maxprice'] = isset($this->in['maxprice']) ? intval($this->in['maxprice']) : '';
        $filter['location'] = isset($this->in['location'])?$this->in['location']:0;
        
        $where = "1=1";
        if(@$this->in['sort']=='price_up'||@$this->in['sort']=='price_down') $where .= " AND a.price>0";

        // if($filter['key']!='') $where .= " AND MATCH(a.name) AGAINST('".$key."' WITH QUERY EXPANSION)";
//         if($filter['key']!='') $where .= " AND MATCH(a.name) AGAINST('".$key."' IN BOOLEAN MODE)";

        if($filter['assessment_company']!=0) $where .= " AND a.pagefee=1";
        if($filter['is_verified']!=0) $where .= " AND a.pageverify=1";
        if($filter['is_oem']!=0) $where .= " AND a.pageoem=1";
        if($filter['is_promo']!=0) $where .= " AND a.promo>0";
        if($filter['is_readytoship']!=0) $where .= " AND a.number>0";
        if($filter['location']!='') $where .= " AND a.location_id IN (".$filter['location'].")";
        if($filter['minorder']!=0) $where .= " AND a.minorder<=".$filter['minorder'];
        if($filter['minprice']!=0) $where .= " AND a.price>=".$filter['minprice'];
        if($filter['maxprice']!=0) $where .= " AND a.price<=".$filter['maxprice'];

        $offset = 0;
        $limit = 24;

        $_ = explode(',', isset($this->in['limit'])? $this->in['limit'] : '');

        if (!empty($_[0])) $offset = trim($_[0]);
        if (!empty($_[1])) $limit = trim($_[1]);

        # sản phẩm top

        $top = [];
        $top_id = [];

        $like_query = \Lib\DB\Help::get_like_query('a.name', $key);

        if ($offset == 0) {
            $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas ";
        }
        else {
            $sql = "SELECT a.product_id AS id ";
        }

        // $sql .= ", ".$like_query['query']." 
        //         FROM page_push_tops t
        //         INNER JOIN (SELECT product_id FROM productsearch
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
    
        if($filter['location']!=''){
            $filter['a_location'] = explode(',', $filter['location']);
            $sql .= " AND a.location_id IN (".$filter['location'].")";
        }

        if ($offset == 0) {
            $sql .= " ORDER BY ".$like_query['score']." DESC, t.created_at DESC ";
        }
        $sql .= ' LIMIT 9';
        $top = $this->pdo->fetch_all($sql);

        if ($offset == 0) {
            foreach ($top AS $k=>$item){
                $item['metas'] = json_decode($item['metas'], true);
                // kien mod
                $item['metas']['page_url'] = $this->page->get_pageurl($item['page_id'], $item['metas']['page_name']);
                // end mod kien
                $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $item['avatar'] = @$item['a_img'][0];
                $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
                $item['url'] = DOMAIN.$this->str->str_convert($item['name']).'-'.$item['id'].'.html';
                $item['is_top'] = 1;
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
        if ($offset == 0) {
            $limit = $limit - count($top_id);
        }
        else {
            $offset = $offset - count($top_id);
        }

        # end sản phẩm top

        # sản phẩm tìm kiếm

        $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,(a.pagefee+a.pageverify) AS spage,
                CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice";

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
            LEFT JOIN productsearch a ON a.product_id=b.product_id 
            LEFT JOIN pages s ON s.id=a.page_id
            ";
        }

        $sql .= "WHERE ".$not_in_top.$where;

        if ($key=='') {
            $sql .= " ORDER BY a.featured DESC, a.ismain DESC, a.score DESC, a.id DESC";
        }
        else {
            if (isset($this->in['sort']) && $this->in['sort']=='price_up') {
                $sql .= " ORDER BY ".$like_query['score']." DESC, a.price ASC, a.featured DESC, a.ismain DESC, a.score DESC";
            } elseif (isset($this->in['sort']) && $this->in['sort']=='price_down') {
                $sql .= " ORDER BY ".$like_query['score']." DESC, a.price DESC, a.featured DESC, a.ismain DESC, a.score DESC";
            } else {
                $sql .= " ORDER BY ".$like_query['score']." DESC, a.featured DESC, a.ismain DESC, a.score DESC";
            }
        }

        $sql .= ' LIMIT '.$offset.','.$limit;
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        
        while ($item = $stmt->fetch()) {
            $item['metas'] = json_decode($item['metas'], true);
            // $item['metas']['page_url'] = $this->page->get_pageurl($item['page_id'], $item['metas']['page_name']);
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
            $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
            $item['url'] = DOMAIN.$this->str->str_convert($item['name']).'-'.$item['id'].'.html';
            $result [] = $item;
        }

        echo json_encode($offset == 0? array_merge($top, $result): $result);
    }
    
    function product_search() {
        $search_repo = \Repo\ProductSearch::instance();

        $key = isset($this->in['key']) ? trim($this->in['key']) : '';
        $key = str_replace('+', ' ', $key);
        $key = str_replace('"', ' ', $key);

        $option = $search_repo->getOptionByArray($this->in);

        // limit, offset
        $offset = 0;
        $limit = 24;

        $_ = explode(',', isset($this->in['limit'])? $this->in['limit'] : '');

        if (!empty($_[0])) $offset = intval($_[0]);
        if (!empty($_[1])) $limit = intval($_[1]);

        $option['offset'] = $offset;
        $option['limit'] = $limit;

        $option['source'] = ['id', 'name', 'images', 'minorder', 'page_id', 'metas', 'url', 'specs', 'source', 'direct', 'src', 'src_type'];
        $product_list = $search_repo->bestSearch($key, $option);

        foreach ($product_list as &$item) {
            // $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['a_img'] = $item['images'];
            $item['avatar'] = @$item['a_img'][0];
            $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
            // $item['url'] = DOMAIN.$this->str->str_convert($item['name']).'-'.$item['id'].'.html';
        }
        
        echo json_encode($product_list);
    }
    
    function product_ads(){
        $key = isset($this->in['key']) ? trim($this->in['key']): '';
        $key = str_replace("+", " ", $key);
        $today = date("Y-m-d");
        
        // $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,ad.campaign_id,
        //     (a.pagefee+a.pageverify) AS spage,CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice,
        //     (SELECT SUM(c.score) FROM adsclicks c 
        //         WHERE c.campaign_id IN (SELECT id FROM adscampaign WHERE date_finish >='".date("Y-m-d")."' AND page_id=a.page_id)) AS total_score_used
        //     FROM adsproducts ad LEFT JOIN adscampaign c ON ad.campaign_id=c.id LEFT JOIN productsearch a ON a.product_id=ad.product_id
        //     WHERE a.score>1 AND a.package_end >'$today' AND c.date_start<='$today' AND c.date_finish>='$today' 
        //         AND ad.keyword LIKE '%$key%' AND ad.status=1 AND c.status=1";

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

        //if($location!='') $sql .= " AND a.location_id IN (".$location.")";

        $sql .= " GROUP BY a.product_id ORDER BY ad.score DESC,a.score DESC LIMIT 30";
        $ads = $this->pdo->fetch_all($sql);

        foreach ($ads AS $k=>$item){
            $item['metas'] = json_decode($item['metas'], true);
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
            $item['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
            $item['url'] .= '?src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time());
            $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
            $ads[$k] = $item;
        }
        echo json_encode(array_merge($this->get_felico_ads_products(), $ads));
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
                $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
                $item['avatar'] = @$item['a_img'][0];
                $item['url'] = $this->product->get_url($item['id'], $this->str->str_convert($item['name']));
                $item['url'] .= '?src=ads&campaign='.$item['campaign_id'].'&token='.base64_encode($this->arg['login'].$item['id'].time());
                $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
            }
            return $result;
        }
        return [];
    }
    
    function _product_search(){
        $today = date("Y-m-d");
        $key = isset($this->in['k']) ? trim($this->in['k']) : '';
        $key = str_replace("+", " ", $key);
        
        $filter['cat'] = isset($this->in['cat']) ? intval($this->in['cat']) : 0;
        $filter['assessment_company'] = isset($this->in['assessment_company']) ? intval($this->in['assessment_company']) : 0;
        $filter['is_verified'] = isset($this->in['is_verified']) ? intval($this->in['is_verified']) : 0;
        $filter['is_oem'] = isset($this->in['is_oem']) ? intval($this->in['is_oem']) : 0;
        $filter['is_promo'] = isset($this->in['is_promo']) ? intval($this->in['is_promo']) : 0;
        $filter['is_readytoship'] = isset($this->in['is_readytoship']) ? intval($this->in['is_readytoship']) : 0;
        $filter['minorder'] = isset($this->in['minorder']) ? intval($this->in['minorder']) : '';
        $filter['minprice'] = isset($this->in['minprice']) ? intval($this->in['minprice']) : '';
        $filter['maxprice'] = isset($this->in['maxprice']) ? intval($this->in['maxprice']) : '';
        $filter['location'] = isset($this->in['location'])?$this->in['location']:0;
        
        $where = "1=1";
        if(isset($this->in['sort']) && $this->in['sort']=='price') $where .= " AND a.price>0";
        if($filter['assessment_company']!=0) $where .= " AND a.pagefee=1";
        if($filter['is_verified']!=0) $where .= " AND a.pageverify=1";
        if($filter['is_oem']!=0) $where .= " AND a.pageoem=1";
        if($filter['is_promo']!=0) $where .= " AND a.promo>0";
        if($filter['is_readytoship']!=0) $where .= " AND a.number>0";
        if($filter['location']!='') $where .= " AND a.location_id IN (".$filter['location'].")";
        if($filter['minorder']!=0) $where .= " AND a.minorder<=".$filter['minorder'];
        if($filter['minprice']!=0) $where .= " AND a.price>=".$filter['minprice'];
        if($filter['maxprice']!=0) $where .= " AND a.price<=".$filter['maxprice'];
        $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.isimport,a.page_id,a.metas,(a.pagefee+a.pageverify) AS spage,
                CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice";
        if($key!=''){
            $sql .= ",CASE WHEN a.name='$key' THEN 5
                WHEN a.name LIKE '$key %' THEN 3
                WHEN a.name LIKE '$key%' THEN 1
                WHEN a.name LIKE '% $key %' THEN 1
                WHEN a.name LIKE '%$key%' THEN 1
                ELSE 0 END AS S1";
            $a_key = explode(' ', $key);
            $c_key = count($a_key);
            if($c_key>=3 && $c_key<=4){
                $new_a_key = [];
                for($i=0; $i<=($c_key-2); $i++){
                    $new_a_key[] = $a_key[$i].' '.$a_key[$i+1];
                }
                foreach ($new_a_key AS $k=>$v){
                    if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS FG";
                    $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS XG".$k;
                }
            }
            if($c_key>=4 && $c_key<=8){
                $new_a_key_3c = [];
                for($i=0; $i<=($c_key-3); $i++){
                    $new_a_key_3c[] = $a_key[$i].' '.$a_key[$i+1].' '.$a_key[$i+2];
                }
                foreach ($new_a_key_3c AS $k=>$v){
                    if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS F3C";
                    $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X3C".$k;
                }
                
            }
            if($c_key>1 && $c_key<=8){
                foreach ($a_key AS $k=>$v){
                    if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 0.5 ELSE 0 END AS F";
                    $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1 WHEN a.name LIKE '% $v %' THEN 1 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X".$k;
                }
            }
        }
        $sql .= ",CASE WHEN a.package_end >= '$today' THEN 1 ELSE 0 END AS flag_check";
        $sql .= " FROM productsearch a WHERE ".$where;
        if($key==''){
            $sql .= " GROUP BY a.page_id";
            $sql .= " ORDER BY flag_check DESC,a.featured DESC,a.ismain DESC,a.score DESC,a.id DESC,RAND()";
        }else{
            $values = "(S1";
            if($c_key>1 && $c_key<=8){
                $values .= "+F";
                foreach ($a_key AS $k=>$v){
                    $values .= "+X".$k;
                }
            }
            if($c_key>=3 && $c_key<=4){
                $values .= "+FG";
                foreach ($new_a_key AS $k=>$v){
                    $values .= "+XG".$k;
                }
            }
            $values .= ")";
            
            $sql .= " HAVING $values >= 1";
            if(isset($this->in['sort']) && $this->in['sort']=='price'){
                $sql .= " ORDER BY $values DESC,a.price ASC,a.score DESC,a.ismain DESC,a.featured DESC";
            }else $sql .= " ORDER BY S1 DESC,$values DESC,flag_check DESC,a.ismain DESC,a.score DESC,a.id DESC";
        }
        
        $sql .= " LIMIT ".($this->in['limit']!=''?$this->in['limit']:24);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        
        while ($item = $stmt->fetch()) {
            unset($item['S1']);
            $item['metas'] = json_decode($item['metas'], true);
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
            $item['price'] = $this->product->get_price_show(@$item['metas']['pricemin'], @$item['metas']['pricemax']);
            $result [] = $item;
        }
        echo json_encode($result);
    }
    
    function category(){
        $rt = [];
        $id = isset($this->in['id']) ? trim($this->in['id']) : 0;
        $info = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE type='product' AND alias='$id' OR id='$id'");
        $id = @$info['id'];
        
        $rt['id'] = $id;
        $rt['info'] = $info;
        $rt['a_cat'] = $this->tax->get_taxonomy('product', $id);
        $rt['a_cat_parent'] = $this->tax->get_taxonomy('product', intval($info['parent']));
        $rt['a_slider'] = $this->media->get_slides($id, 6);
        $parent_tree = $this->get_cat_tree($info['parent']);
        krsort($parent_tree);
        $rt['parent_tree'] = $parent_tree;
        
        $where = '1';
        if($id>0){
            $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                    AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id)) ORDER BY lft)";
        }
        if(@$this->in['sort']=='price_up'||@$this->in['sort']=='price_down') $where .= " AND a.price>0";
        if(@$this->in['assessment_company']!=0) $where .= " AND a.pagefee=1";
        if(@$this->in['is_verified']!=0) $where .= " AND a.pageverify=1";
        if(@$this->in['is_oem']!=0) $where .= " AND a.pageoem=1";
        if(@$this->in['is_promo']!=0) $where .= " AND a.promo>0";
        if(@$this->in['is_readytoship']!=0) $where .= " AND a.number>0";
        if(@$this->in['location']!=0) $where .= " AND a.location_id IN (".@$this->in['location'].")";
        if(@$this->in['minprice']!=0) $where .= " AND a.price>=".@$this->in['minprice'];
        if(@$this->in['maxprice']!=0) $where .= " AND a.price<=".@$this->in['maxprice'];
        $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.page_id,a.metas,(a.pagefee+a.pageverify) AS spage";
        $sql .= " FROM productsearch a WHERE ".$where;
        if(isset($this->in['sort']) && $this->in['sort']=='price_up'){
            $sql .= " ORDER BY a.price ASC,a.featured DESC,spage DESC,a.ismain DESC";
        }elseif(isset($this->in['sort']) && $this->in['sort']=='price_down'){
            $sql .= " ORDER BY a.price DESC,a.featured DESC,spage DESC,a.ismain DESC";
        }else $sql .= " ORDER BY a.featured DESC,spage DESC,a.ismain DESC,a.score DESC,a.id DESC";
        $sql .= " LIMIT ".($this->in['limit']!=''?$this->in['limit']:24);
        $rt['products'] = $this->pdo->fetch_all($sql);
        foreach ($rt['products'] AS $k=>$item){
            $rt['products'][$k]['metas'] = json_decode($item['metas'], true);
            // kien mod
            $rt['products'][$k]['metas']['page_url'] = $this->page->get_pageurl($item['page_id'], $rt['products'][$k]['metas']['page_name']);
            // end mod kien
            $rt['products'][$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $rt['products'][$k]['avatar'] = @$rt['products'][$k]['a_img'][0];
            $rt['products'][$k]['price'] = $this->product->get_price_show(@$rt['products'][$k]['metas']['pricemin'], @$rt['products'][$k]['metas']['pricemax']);
        }
        
        echo json_encode($rt);;
    }

    
    function get_products($cat=0, $limit='24'){
        $sql = "SELECT a.id,a.name,a.images,a.minorder,a.page_id,a.taxonomy_id,CASE WHEN b.package_id>0 THEN 1 ELSE 0 END AS is_package,
				IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax,
                CASE WHEN price>0 THEN 1 ELSE 0 END AS is_price
				FROM products a LEFT JOIN pages b ON b.id=a.page_id
				WHERE a.status=1 AND b.status=1";
        if($cat!=0){
            $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                    AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cat) AND (SELECT rgt FROM taxonomy WHERE id=$cat)) ORDER BY lft)";
        }
        $sql .= " ORDER BY (is_package+b.is_verification) DESC,(a.ismain+is_price) DESC";
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $a_img = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$a_img[0];
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
            if($item['pricemax']>$item['price']&&$item['price']>0) $result[$k]['price'] .= '~'.number_format($item['pricemax']).'đ';
        }
        return $result;
    }
    
    function get_cat_tree($id, $rt=[]){
        $db = $this->pdo->fetch_one("SELECT id,name,alias,parent FROM taxonomy WHERE id=".$id);
        if($db){
            $rt[] = $db;
            if(@$db['parent']>0) $rt = $this->get_cat_tree($db['parent'], $rt);
        }
        return $rt;
    }
    
    function detail(){
        $rt = [];
        $pid = isset($this->in['id']) ? intval($this->in['id']) : 0;
        $category = is_array(@$this->hcache['category_view'])?$this->hcache['category_view']:[];

        $info = $this->pdo->fetch_one("SELECT a.*,un.name AS unit,c.id AS tax_id,c.name AS category,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax,
                (SELECT GROUP_CONCAT(CONCAT(version,':',price) separator ';') FROM productprices WHERE product_id=a.id) AS prices,
                (SELECT GROUP_CONCAT(CONCAT(meta_key,':',meta_value) separator ';') FROM productmetas WHERE product_id=a.id) AS metas
                FROM products a
                LEFT JOIN taxonomy c ON c.id=a.taxonomy_id
                LEFT JOIN taxonomy un ON un.id=a.unit_id
                WHERE a.id=".$pid);
        if($info){
            $info['a_img'] = $this->product->get_images($info['images'], $info['page_id'], 0);
            $info['avatar'] = @$info['a_img'][0];
            $info['prices'] = $this->help->convert_value_concat($info['prices'], 'version', 'price');
            $this->help->aasort($info['prices'], 'price');
            $info['metas'] = $this->help->convert_value_concat($info['metas'], 'meta_key', 'meta_value');
            $info['price'] = $info['price']>0?$info['price']:$info['pricemax'];
            $info['price_sale'] = $info['price']>0?$info['price']:$info['pricemax'];
            if($info['promo']>0){
                $info['price_sale'] = $info['pricemax']*(100-$info['promo'])/100;
                foreach ($info['prices'] AS $k=>$v){
                    $info['prices'][$k]['promo'] = $v['price']*(100-$info['promo'])/100;
                }
            }else $info['promo'] = 0;
            $info['price_promo'] = $info['price']-$info['price_sale'];
            
            $eventproduct_id = isset($this->in['eventproduct_id']) ? intval($this->in['eventproduct_id']) : 0;
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
    
            $page = $this->pdo->fetch_one("SELECT * FROM pages WHERE id=".$info['page_id']);
            //if($this->arg['isadmin'] == 1 || ($page['isphone'] == 1)) $page['phone'] = @$this->option['contact']['phone'];
            $rt['page'] = $page;
    
            $address = $this->pdo->fetch_all("SELECT id,address FROM pageaddress WHERE page_id=".$info['page_id']." LIMIT 4");
            $rt['address'] = $address;
            
            $info['url_addcart'] = DOMAIN . "?mod=product&site=addcart&pid=".$pid;
            if($eventproduct_id!=0) $info['url_addcart'] .= "&eventproduct_id=".$eventproduct_id;
            //$this->smarty->assign('info', $info);
            $rt['info'] = $info;
            
            $rt['a_for_you'] = $this->get_list(0, 0, "a.id<>".@$info['id']." AND a.taxonomy_id IN (".implode(',', $category).")", 12, "a.featured DESC,a.ismain DESC");
            $rt['a_other'] = $this->get_list(0, @$info['taxonomy_id'], 'a.id<>'.@$info['id'], 18, "a.featured DESC,a.ismain DESC,RAND()");
            $rt['a_same_page'] = $this->get_list(@$info['page_id'], 0, 'a.id<>'.@$info['id'], 18);
            
            $parent_tree = $this->get_cat_tree($info['taxonomy_id']);
            krsort($parent_tree);
            $rt['parent_tree'] = $parent_tree;
        }
        
        echo json_encode($rt);
    }

    
    function get_list($page_id=0, $category_id=0, $where=null, $limit=null, $order = null){
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT a.product_id AS id,a.name,a.images,a.page_id,a.price,a.promo FROM productsearch a
				WHERE 1=1 ".$where;
        if($page_id!=0) $sql .= " AND a.page_id=$page_id";
        if($category_id!=0){
            $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$category_id) AND (SELECT rgt FROM taxonomy WHERE id=$category_id))
                ORDER BY lft)";
        }
        if($order!= null) $sql .= " ORDER BY $order";
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            //$result[$k]['url'] = $this->str->str_convert($item['name'])."-".$item['id'].".html";
            //$result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
        }
        return $result;
    }


    function testAPI_getData_apify(){
        $dt = file_get_contents('php://input');     

        $milliseconds = floor(microtime(true) * 1000);  
        $filename = '__webhook/' .$milliseconds .'-'.mt_rand(). '.txt';
        file_put_contents($filename, $dt);
    }


    protected function getAllDataIndex($key, $index){
        $elastic = \Lib\Elasticsearch::instance();
        $result = [];
        $from = 0;
        $size = 1000;
        $total_value = ($elastic->get_count($index))["count"];
        if($total_value > 10000) $elastic->putSettings(['index.max_result_window' => $total_value + $size]);
        for ($i = 0; $i < ceil($total_value/$size); $i++){
            $rs = $elastic->search($index,
                [
                    '_source' => [$key],
                    'size' => $size,
                    'from' => $from,
                    'query' => [
                        'match' => [
                            'src_type' => 'apify'
                        ] 
                    ]
                ]
            );
            $from += $size;
            $data = $rs['hits']['hits'] ?? [];
            $result = array_merge($result, $data);
        }
        return $result;
    }


    protected function getArrApifyRs($arr_apify){
        $arr_apify_rs = [];
        if (!empty($arr_apify)){
            $arr_apify_rs['keyId'] = $arr_apify["resource"]["defaultDatasetId"];
            $arr_apify_rs['actorId'] = $arr_apify["resource"]["actId"];
            // $arr_apify_rs['site'] = $arr_apify["site"];
            $arr_apify_rs['totalRs'] = $arr_apify["resource"]["usage"]["DATASET_WRITES"];
        }else{
           $arr_apify_rs['keyId'] = isset($_GET["keyId"]) ? $_GET["keyId"] : '';
           $arr_apify_rs['actorId'] = isset($_GET["actorId"]) ? $_GET["actorId"] : '';
        //    $arr_apify_rs['site'] = isset($_GET["site"]) ? $_GET["site"] : '';
           $arr_apify_rs['totalRs'] = isset($_GET["totalRs"]) ? $_GET["totalRs"] : '';
        }
        return $arr_apify_rs;
    }


    protected function convertUSDtoVND($usd){
        $usdToVndRate = 23000;

        $usd = preg_replace('#[^0-9\.\,]#', '', $usd);
        $usd = str_replace(',', '.', $usd);

        $vn_val = ceil(floatval($usd) * $usdToVndRate);
        return $vn_val;
    }


    function getDataApify(){
        ini_set('display_errors', true);
        error_reporting(E_ALL);
        
        $elastic = \Lib\Elasticsearch::instance();
        $curlAPI = \Lib\Core\Api::instance();
        $data = file_get_contents('php://input');

        // $arr_apify = json_decode($data, true);
        $arr_apify = $this->getArrApifyRs(json_decode($data, true));

        $keyId = empty($arr_apify['keyId']) ? exit : $arr_apify['keyId'];
        $actorId = empty($arr_apify['actorId']) ? exit : $arr_apify['actorId'];
        // $site = empty($arr_apify['site']) ? exit : $arr_apify['site'];
        $totalRs = empty($arr_apify['totalRs']) ? exit : $arr_apify['totalRs'];

        $limit = 500;
        $offset = 0;
        $totalRun = ceil($totalRs / $limit);
        $lst_urls = [];

        $size_excute_url = 25;
        for ($i=0; $i < $totalRun; $i++){
            $url = APIFY_DOMAIN . "/v2/datasets/" . $keyId . "/items?token=" . APIFY_TOKEN_USER . "&limit=" . $limit . "&offset=" . $offset;
            $lst_urls[] = $url;
            $offset += $limit;
        }
        $arr_data_apify = [];
        foreach (array_chunk($lst_urls, $size_excute_url) as $item){
            $data = $curlAPI->get_data_actor_apify($item);
            $arr_data_apify = array_merge($arr_data_apify, $data);
        }
        if (APIFY_GOOGLE_SHOPPING_INSIGHTS == $actorId){
            $key = 'url';
            $rs_index = $this->getAllDataIndex($key, ELASTIC_INDEX_SEARCH_PRODUCTS);
            $header = [
                'index' => [
                    '_index' => ELASTIC_INDEX_SEARCH_PRODUCTS
                ]
            ];
            foreach ($arr_data_apify as $item){
                $data_item = json_decode($item, true);
                $bulk_data_str = '';
                foreach ($data_item as $it){
                    $exist_item = false;
                    $value_apify = $it['merchantLink'] ?? '';

                    foreach ($rs_index as $doc){
                        $value_elastic = $doc['_source'][$key] ?? '';
                        if ($value_elastic === $value_apify){
                            $exist_item = true;
                            break;
                        }
                    }
                    if (!$exist_item){
                        $data = [];
                        $data['page_id'] = 0;
                        $data['name'] = $it['productName'];
                        $data['content'] = $it['productDetails'];
                        $arr_images = [];
                        $arr_images [] = $it['productImage'];
                        $data['image'] = $arr_images;
                        $data['url'] = $it['merchantLink'];
                        $data['source'] = $it['merchantLink'];
                        $data['direct'] = 1;
                        $data['taxonomy_id'] = 0;
                        $data['minorder'] = 1;
                        $data['number'] = 0;
                        $data['price'] = preg_replace('#[^0-9]#', '', $it['price']);
                        $data['promo'] = 0;
                        $data['ismain'] = 0;
                        $data['isimport'] = 0;
                        $data['featured'] = 0;
                        $data['location_id'] = 1;
                        $data['pagefee'] = 0;
                        $data['pageoem'] = 0;
                        $data['pageverify'] = 0;
                        $metas = [];
                        $metas['page_id'] = 0;
                        $metas['page'] = $it['merchantName'];
                        $metas['phone'] = '';
                        $metas['page_name'] = $it['merchantName'];
                        $metas['page_url'] = '';
                        $metas['page_start'] = '';
                        $metas['page_logo'] = '';
                        $metas['page_fee'] = 0;
                        $metas['page_oem'] = 0;
                        $metas['page_verify'] = 0;
                        $metas['trademark'] = '';
                        $metas['ordertime'] = '';
                        $metas['unit'] = 'piece';
                        $metas['pricemin'] = preg_replace('#[^0-9]#', '', $it['price']);
                        $metas['pricemax'] = preg_replace('#[^0-9]#', '', $it['price']);

                        $data['metas'] = $metas;
                        $data['specs'] = [];
                        $data['src'] = 'contructions';
                        $data['src_type'] = 'apify';
                        $bulk_data_str .= json_encode($header) . "\n" . json_encode($data) . "\n";
                    }
                }
                $elastic->_bulk($bulk_data_str);
            }
            echo "Success!";
        }

    }


    function add_dataApify_productSearch(){
        ini_set('display_errors', true);
        error_reporting(E_ALL);

        $src = 'book';
        $elastic = \Lib\Elasticsearch::instance();

        // $dt = file_get_contents('php://input');
        $dt = file_get_contents('./__webhook/1719457823779-39585506.txt');
        $arr_data = json_decode($dt, true);

        // $milliseconds = floor(microtime(true) * 1000);
        // $filename = '__webhook/' .$milliseconds .'-'.mt_rand(). '.txt';
        // file_put_contents($filename, $dt);

        $header = [
            'index' => [
                '_index' => 'search-products'
            ]
        ];

        foreach($arr_data as $v){
            $data_item = json_decode($v, true); //limit 500
            $bulk_data_str = '';
            foreach($data_item as $item){
                $data = [];

                $data['page_id'] = 0;
                $data['name'] = $item['productName'];
                $data['content'] = $item['productDetails'];

                $arr_images = [];
                $arr_images[] = $item['productImage'];
                $data['images'] = $arr_images;
                $data['url'] = $item['merchantLink'];
                $data['source'] = $item['merchantLink'];
                $data['direct'] = 1;
                $data['taxonomy_id'] = 0;
                $data['minorder'] = 1;
                $data['number'] = 0;
                $data['price'] = $this->convertUSDtoVND($item['price']);
                $data['promo'] = 0;
                $data['ismain'] = 0;
                $data['isimport'] = 0;
                $data['featured'] = 0;
                $data['location_id'] = 1;
                $data['pagefee'] = 0;
                $data['pageoem'] = 0;
                $data['pageverify'] = 0;

                $metas = [];
                $metas['page_id'] = 0;
                $metas['page'] = $item['merchantName'];
                $metas['phone'] = '';
                $metas['page_name'] = $item['merchantName'];
                $metas['page_url'] = '';
                $metas['page_start'] = '';
                $metas['page_logo'] = '';
                $metas['page_fee'] = 0;
                $metas['page_oem'] = 0;
                $metas['page_verify'] = 0;
                $metas['trademark'] = '';
                $metas['ordertime'] = '';
                $metas['unit'] = 'piece';
                $metas['pricemin'] = $this->convertUSDtoVND($item['price']);
                $metas['pricemax'] = $this->convertUSDtoVND($item['price']);

                $data['metas'] = $metas;
                $data['specs'] = [];
                $data['src'] = $src;
                $data['src_type'] = 'apify';

                $bulk_data_str .= json_encode($header) . "\n" . json_encode($data) . "\n";
                // var_dump($data);
                // exit;
            }
            // echo $bulk_data_str;
            $elastic->_bulk($bulk_data_str);
        }
        echo "Success!";
    }

}
