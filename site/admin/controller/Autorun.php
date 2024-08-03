<?php

class Autorun extends Admin {

    private $dom;
    private $file_waitinglinks, $file_scannedlinks, $file_savedlinks;
    
    function __construct() {
        parent::__construct();

        $this->file_waitinglinks = "./file_autorun/waitinglinks.ini";
        $this->file_scannedlinks = "./file_autorun/scannedlinks.ini";
        $this->file_savedlinks = "./file_autorun/savedlinks.ini";
    }

    function index() {
        
        // $data = [];
        // $data['promo_date'] = date('Y-m-d', strtotime('+1 month'));
        // $this->pdo->update('products', $data, "promo>0");
        
        $ads = $this->pdo->fetch_all("SELECT id,product_id FROM adsproducts");
        foreach ($ads AS $v){
            $product = $this->pdo->fetch_one("SELECT name FROM products WHERE id=".$v['product_id']);
            $data = [];
            $data['keyword'] = $product['name'];
            $this->pdo->update('adsproducts', $data, 'id='.$v['id']);
        }
        
//         $html = \Lib\Help\HtmlDomParser::file_get_html('https://chungsuclamnha.com/San-pham/Gach-lat-nen-Catalan-6131-ad6345.html');
//         $a_metas = [];
//         foreach(@$html->find('.price') AS $element){
//             $a_metas[] = trim($element->plaintext);
//         }  
        
//         lib_dump($a_metas);
        
//         $smarty->display(LAYOUT_DEFAULT);
    }

    function run_price(){
        $sql = "SELECT id,name,prefix_auto FROM pages WHERE status=1 AND prefix_auto LIKE '%price%' LIMIT 100";
        $pages = $this->pdo->fetch_all($sql);
        lib_dump($pages);
    }
    
    function update_promo(){
        $sql = "UPDATE products SET promo_date='".date('Y-m-d',strtotime('+1 month'))."' WHERE promo>0";
        $this->pdo->query($sql);
    }
    
    function update_page(){
        // $sql = "SELECT COUNT(1) FROM pages a WHERE 1=1";
        $where = " AND a.taxonomy_id NOT IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=1564) AND (SELECT rgt FROM taxonomy WHERE id=1564))
                ORDER BY lft)";
        //         $rt = $this->pdo->fetch_one($sql.$where);
        //         var_dump($rt);
        
        $sql = "DELETE FROM products2 WHERE page_id IN (SELECT a.id FROM pages a WHERE 1=1 $where)";
        // $rt = $this->pdo->query($sql);
        var_dump($sql);
        
        //         $this->pdo->query($sql);
    }
    
    function update_page_metas(){
        if(!$this->pdo->check_exist('SELECT metas FROM pageprofiles LIMIT 1')){
            $this->pdo->query("ALTER TABLE `pageprofiles` ADD `metas` TEXT NULL DEFAULT NULL AFTER `url_youtube`;");
        }
        
        $sql = "SELECT id,name FROM pages WHERE status=1";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('pages', 'status=1'), 1000);
        $sql = $paging->get_sql_limit($sql);
        
        $pages = $this->pdo->fetch_all($sql);     
        foreach ($pages AS $v){
            $products = $this->pdo->fetch_all("SELECT a.id,a.name,a.images,
            IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
            IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
            FROM products a WHERE a.images !='' AND a.page_id=".$v['id']."
                ORDER BY a.ismain DESC,a.featured DESC,a.views DESC LIMIT 4");
            foreach ($products AS $k2=>$v2){
                $a_img = $this->product->get_images($v2['images'], $v['id']);
                $products[$k2]['avatar'] = $a_img[0];
                $products[$k2]['url'] = $this->string->str_convert($v2['name']).'-'.$v2['id'].'.html';
                $products[$k2]['price'] = $this->product->get_price_show(@$v2['pricemin'], @$v2['pricemax']);
                unset($products[$k2]['images']);
            }
            $db['products'] = $products;
            $images_page = $this->pdo->fetch_one("SELECT images FROM pageprofiles WHERE page_id=".$v['id']);
            $a_image_profile = strlen(@$images_page['images'])>30 ? explode(";", @$images_page['images']) : [];
			$image_profile = [];
			foreach ($a_image_profile AS $item){
				if(is_file($this->page->get_folder_img_upload($v['id']).$item))
					$image_profile[] = $this->img->get_image($this->page->get_folder_img($v['id']), $item);
			}
			//$pages['image_profile'] = $image_profile;
            $db['images'] = $image_profile;

            $data = [];
            $data['metas'] = json_encode($db);
            if($this->pdo->check_exist('SELECT 1 FROM pageprofiles WHERE page_id='.$v['id'])){
                $this->pdo->update('pageprofiles', $data, 'page_id='.$v['id']);
            }else{
                $data['page_id'] = $v['id'];
                $this->pdo->insert('pageprofiles', $data);
            }
        }
        
        $page = isset($_GET['page'])?intval($_GET['page']):1;
        if(count($pages)>0){
            lib_redirect('?mod=autorun&site=update_page_metas&page='.($page+1));
        }else echo 'SUCCESS';
    }
    function update_page_metas_old(){
        if(!$this->pdo->check_exist('SELECT metas FROM pageprofiles LIMIT 1')){
            $this->pdo->query("ALTER TABLE `pageprofiles` ADD `metas` TEXT NULL DEFAULT NULL AFTER `url_youtube`;");
        }
        
        $sql = "SELECT id,name FROM pages WHERE status=1";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('pages', 'status=1'), 1000);
        $sql = $paging->get_sql_limit($sql);
        
        $pages = $this->pdo->fetch_all($sql);
        foreach ($pages AS $v){
            $products = $this->pdo->fetch_all("SELECT id,name,images FROM products WHERE images !='' AND page_id=".$v['id']."  
                ORDER BY ismain DESC,featured DESC,views DESC LIMIT 4");
            foreach ($products AS $k2=>$v2){
                $a_img = $this->product->get_images($v2['images'], $v['id']);
                $products[$k2]['avatar'] = $a_img[0];
                        ;
                unset($products[$k2]['images']);
            }
            $data = [];
            $data['metas'] = json_encode($products);
            if($this->pdo->check_exist('SELECT 1 FROM pageprofiles WHERE page_id='.$v['id'])){
                $this->pdo->update('pageprofiles', $data, 'page_id='.$v['id']);
            }else{
                $data['page_id'] = $v['id'];
                $this->pdo->insert('pageprofiles', $data); 
            }
        }
        
        $page = isset($_GET['page'])?intval($_GET['page']):1;
        if(count($pages)>0){
            lib_redirect('?mod=autorun&site=update_page_metas&page='.($page+1));
        }else echo 'SUCCESS';
    }
               
    function build_tbl_productsearch(){
        $this->pdo->query("DROP TABLE productsearch");
        $this->pdo->query("CREATE TABLE `productsearch` (
              `id` int(11) NOT NULL,
              `product_id` int(11) NOT NULL,
              `page_id` int(11) NOT NULL DEFAULT '0',
              `name` varchar(200) DEFAULT NULL,
              `images` varchar(360) DEFAULT NULL,
              `taxonomy_id` int(11) NOT NULL DEFAULT '0',
              `minorder` int(11) NOT NULL DEFAULT '1',
              `number` int(11) NOT NULL DEFAULT '0',
              `price` int(11) NOT NULL DEFAULT '0',
              `promo` tinyint(3) NOT NULL DEFAULT '0',
              `ismain` tinyint(1) NOT NULL DEFAULT '0',
              `isimport` tinyint(1) NOT NULL DEFAULT '0',
              `featured` tinyint(1) NOT NULL DEFAULT '0',
              `score` int(11) NOT NULL DEFAULT '0',
              `metas` text,
              `pagefee` tinyint(1) NOT NULL DEFAULT '0',
              `location_id` smallint(6) NOT NULL DEFAULT '0',
              `pageverify` tinyint(1) NOT NULL DEFAULT '0',
              `pageoem` tinyint(1) NOT NULL DEFAULT '0',
              `package_end` date NOT NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
        
        $this->pdo->query("ALTER TABLE `productsearch`
              ADD PRIMARY KEY (`id`),
              ADD UNIQUE KEY `product_id` (`product_id`),
              ADD KEY `taxonomy_id` (`taxonomy_id`),
              ADD KEY `ismain` (`ismain`),
              ADD KEY `featured` (`featured`),
              ADD KEY `pagefee` (`pagefee`),
              ADD KEY `location_id` (`location_id`),
              ADD KEY `pageverify` (`pageverify`),
              ADD KEY `pageoem` (`pageoem`),
              ADD KEY `page_id` (`page_id`);");
        
        $this->pdo->query("ALTER TABLE `productsearch` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT; COMMIT;");
    }

    function page_2_elastic() {
        $src = SITE_SRC_NAME;

        $elastic = \Lib\Elasticsearch::instance();

        $sql = "SELECT * FROM pages";

        $result = $this->pdo->fetch_all($sql);
        foreach ($result as $item) {
            $id = intval($item['id']);
            $data = [
                'id' => $id,
                'name' => $item['name'],
                'is_oem' => intval($item['is_oem']),
                'is_verify' => intval($item['is_verification']),
                'page_type' => 'basic',
                'src' => $src
            ];
            $elastic->create('search-pages', $data, $src.'_'.$id);
        }
        echo 'SUCCESS';
    }

    function convert_value_concat($str, $field1 = 'key', $field2 = 'value'){
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

    function product_2_elastic() {
        // ini_set('display_errors', 1);
        // error_reporting(E_ALL);

        $src = SITE_SRC_NAME;
        
        $elastic = \Lib\Elasticsearch::instance();

        $page = isset($_GET['page'])? intval($_GET['page']): 1;

        $age_time = isset($_GET['age_time'])? urldecode($_GET['age_time']): '-1 day';
        
        if ($age_time == 'all') {
            $where_date = '';
        }
        else {
            $where_date = ' AND a.created >= '.strtotime($age_time).' ';
        }

        $sql = "SELECT a.id,a.name,a.description,a.images,a.minorder,a.page_id,a.number,a.featured,a.taxonomy_id,a.promo,a.ismain,a.isimport,a.source,
                a.trademark,a.ordertime,a.views,u.name AS unit,
                p.name AS page, p.phone, p.page_name, p.date_start, p.package_end, p.logo, p.package_id, p.is_oem, p.is_verification, p.province_id,
                p.internal_sale AS page_internal_sale
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax,
                (SELECT GROUP_CONCAT(CONCAT(meta_key,':',meta_value) separator ';') FROM productmetas WHERE product_id=a.id) AS specs
				FROM products a
                LEFT JOIN pages p ON p.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND p.status=1 {$where_date} ORDER BY a.id ASC";

        $paging = new \Lib\Core\Pagination(2000000, 1000);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        foreach ($result as $item) {
            $data = [];
            $id = intval($item['id']);
            $data['id'] = $id;
            
            $data['page_id'] = intval($item['page_id']);
            $data['name'] = trim($item['name']);
            $data['content'] = trim($item['description']);

            $data['images'] = empty($item['images'])? []: $this->product->get_images($item['images'], $item['page_id']);
            $data['url'] = DOMAIN.$this->str->str_convert($item['name']).'-'.$item['id'].'.html';
            $data['source'] = trim($item['source']);
            $data['direct'] = 0;
            $data['internal_sale'] = intval($item['internal_sale'] && $item['page_internal_sale']);

            $data['taxonomy_id'] = intval($item['taxonomy_id']);
            $data['minorder'] = intval($item['minorder']);
            $data['number'] = intval($item['number']);
            $data['price'] = intval($item['pricemin']);
            $data['promo'] = intval($item['promo']);
            $data['ismain'] = intval($item['ismain']);
            $data['isimport'] = intval($item['isimport']);
            $data['featured'] = intval($item['featured']);
            $data['location_id'] = intval($item['province_id']);
            $data['pagefee'] = intval($item['package_id']!=0? 1: 0);
            $data['pageoem'] = intval($item['is_oem']);
            $data['pageverify'] = intval($item['is_verification']);

            $metas = [];
            $metas['page_id'] = intval($item['page_id']);
            $metas['page'] = trim($item['page']);
            $metas['phone'] = trim($item['phone']);
            $metas['page_name'] = $item['page_name']? trim($item['page_name']) : $item['page_id'];
            $metas['page_url'] = $this->page->get_pageurl($item['page_id'], $item['page_name']);
            $metas['page_start'] = trim($item['date_start']);

            $metas['page_logo'] = URL_UPLOAD. 'pages/'.$item['page_id'].'/'.trim($item['logo']);

            $metas['page_fee'] = intval($item['package_id']!=0?1:0);
            $metas['page_oem'] = intval($item['is_oem']);
            $metas['page_verify'] = intval($item['is_verification']);
            $metas['trademark'] = trim($item['trademark']);
            $metas['ordertime'] = trim($item['ordertime']);
            $metas['unit'] = trim($item['unit']==''?'piece':$item['unit']);
            $metas['pricemin'] = intval($item['pricemin']);
            $metas['pricemax'] = intval($item['pricemax']);

            $data['metas'] = $metas;
            $data['specs'] = empty($item['specs'])? []: $this->convert_value_concat($item['specs'], 'name', 'value');

            $data['src'] = $src;
            $data['src_type'] = 'internal';

            $elastic->create('search-products', $data, $src.'_'.$id);     
        
            unset($data);
        }
        
        
        if (count($result) > 0) {
            lib_redirect('?mod=autorun&site=product_2_elastic&age_time='.$age_time.'&page='.($page+1));
        }
        else {
            echo 'SUCCESS';
        }
    }

    function __get_product_search_data($item) {
        $data = [];
        $data['product_id'] = $item['id'];
        $data['page_id'] = $item['page_id'];
        $data['name'] = trim($item['name']);
        $data['images'] = trim($item['images']);
        $data['taxonomy_id'] = $item['taxonomy_id'];
        $data['minorder'] = $item['minorder'];
        $data['number'] = $item['number'];
        $data['price'] = $item['pricemin'];
        $data['promo'] = $item['promo'];
        $data['ismain'] = $item['ismain'];
        $data['isimport'] = $item['isimport'];
        $data['featured'] = $item['featured'];
        $data['location_id'] = $item['province_id'];
        $data['pagefee'] = $item['package_id']!=0?1:0;
        $data['pageoem'] = $item['is_oem'];
        $data['pageverify'] = $item['is_verification'];
        $data['package_end'] = $item['package_end'];
        
        $metas = [];
        $metas['page'] = trim($item['page']);
        $metas['phone'] = trim($item['phone']);
        $metas['page_name'] = trim($item['page_name']);
        $metas['page_url'] = $this->page->get_pageurl($item['page_id'], $item['page_name']);
        $metas['page_start'] = trim($item['date_start']);
        $metas['page_logo'] = trim($item['logo']);
        $metas['page_fee'] = $item['package_id']!=0?1:0;
        $metas['page_oem'] = $item['is_oem'];
        $metas['page_verify'] = $item['is_verification'];
        $metas['trademark'] = trim($item['trademark']);
        $metas['ordertime'] = trim($item['ordertime']);
        $metas['unit'] = trim($item['unit']==''?'piece':$item['unit']);
        $metas['pricemin'] = trim($item['pricemin']);
        $metas['pricemax'] = trim($item['pricemax']);

        $data['metas'] = json_encode($metas);
        
        $data['score'] = (($data['price']>0)?200:0) + (($data['promo']>0)?150:0);
        $data['score'] += (count(explode(";", $data['images']))>0)?200:0;
        $data['score'] += (($data['pagefee']>0)?200:0) + (($data['pageverify']>0)?100:0);
        $data['score'] += intval((($item['views']/10)>200)?200:($item['views']/10));
        $data['score'] += (($data['featured']>0)?100:0);

        return $data;
    }
    
    function update_productsearch() {
        $page = isset($_GET['page'])?intval($_GET['page']):1;
        if($page==1){
            $this->pdo->query("TRUNCATE TABLE productsearch");
        }

        $sql = "SELECT a.id,a.name,a.images,a.minorder,a.page_id,a.number,a.featured,a.taxonomy_id,a.promo,a.ismain,a.isimport,
                a.trademark,a.ordertime,a.views,u.name AS unit,
                p.name AS page, p.phone, p.page_name, p.date_start, p.package_end, p.logo, p.package_id, p.is_oem, p.is_verification, p.province_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages p ON p.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND p.status=1 ORDER BY a.id ASC";

        $paging = new \Lib\Core\Pagination(2000000, 10000);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        foreach ($result AS $item){
            $data = $this->__get_product_search_data($item);
            
            $a_img = explode(';', $data['images']);
            if(count($a_img)>0){
                foreach ($a_img AS $k=>$v) if($v=='') unset($a_img[$k]);
            }
            $a_img = array_values($a_img);
            if(count($a_img)>0 && is_file(DIR_UPLOAD.'pages/'.$data['page_id']."/".$a_img[0])){
                $this->pdo->insert('productsearch', $data);
            }
            unset($data);
        }
        
        
        if (count($result) > 0) {
            lib_redirect('?mod=autorun&site=update_productsearch&page='.($page+1));
        }
        else {
            echo 'SUCCESS';
        }
    }

    function update_productsearch_check_exist() {
        // ini_set('display_errors', 1);
        // error_reporting(E_ALL);

        $page = isset($_GET['page'])? intval($_GET['page']): 1;
        
        $age_time = isset($_GET['age_time'])? urldecode($_GET['age_time']): '-1 day';

        if ($age_time == 'all') {
            $where_date = '';
        }
        else {
            // $where_date = ' AND a.created >= DATE_SUB(NOW(), INTERVAL '.strtoupper(urldecode($age_time)).') ';
            $where_date = ' AND a.created >= '.strtotime($age_time).' ';
        }

        $sql = "SELECT a.id,a.name,a.images,a.minorder,a.page_id,a.number,a.featured,a.taxonomy_id,a.promo,a.ismain,a.isimport,
                a.trademark,a.ordertime,a.views,u.name AS unit,
                p.name AS page, p.phone, p.page_name, p.date_start, p.package_end, p.logo, p.package_id, p.is_oem, p.is_verification, p.province_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages p ON p.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
                LEFT JOIN productsearch ps ON ps.product_id = a.id
				WHERE ps.product_id IS NULL AND a.status=1 AND p.status=1 {$where_date}
                ORDER BY a.id ASC";

        $paging = new \Lib\Core\Pagination(2000000, 10000);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        foreach ($result AS $item){
            $data = $this->__get_product_search_data($item);
        
            $a_img = explode(';', $data['images']);
            if(count($a_img)>0){
                foreach ($a_img AS $k=>$v) if($v=='') unset($a_img[$k]);
            }
            $a_img = array_values($a_img);
            if(count($a_img)>0 && is_file(DIR_UPLOAD.'pages/'.$data['page_id']."/".$a_img[0])){
                $this->pdo->insert('productsearch', $data);
            }
            unset($data);
        }
        
        
        if (count($result) > 0) {
            lib_redirect('?mod=autorun&site=update_productsearch_check_exist&age_time='.$age_time.'&page='.($page+1));
        }
        else {
            echo 'SUCCESS';
        }
    }

    function update_productsearch_by_condition() {
        ini_set('display_errors', true);
        error_reporting(E_ALL);

        $where = '';
        $option = $_REQUEST;

        if (isset($option['ids'])) {
            $ids = $option['ids'];
            if (is_array($ids)) {
                $ids = implode(',', array_map('intval', $ids));
            }
            else {
                $ids = intval($ids);
            }
            $where = 'a.id IN ('.$ids.')';
        }
        elseif (isset($option['time_gap'])) {
            $time_gap = strtotime('-'. urldecode($option['time_gap']));
            if ($time_gap) {
                $where = 'created>='.$time_gap;
            }
        }

        if (!$where) {
            echo 'Chưa có điều kiện đầu vào.';
            return;
        }

        $sql = "SELECT a.id,a.name,a.images,a.minorder,a.page_id,a.number,a.featured,a.taxonomy_id,a.promo,a.ismain,a.isimport,
                a.trademark,a.ordertime,a.views,u.name AS unit,
                p.name AS page, p.phone, p.page_name, p.date_start, p.package_end, p.logo, p.package_id, p.is_oem, p.is_verification, p.province_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages p ON p.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND p.status=1 AND {$where} ORDER BY a.id ASC";

        $result = $this->pdo->fetch_all($sql);

        foreach ($result AS $item){
            $data = $this->__get_product_search_data($item);
            
            $a_img = explode(';', $data['images']);
            if(count($a_img)>0){
                foreach ($a_img AS $k=>$v) if($v=='') unset($a_img[$k]);
            }
            $a_img = array_values($a_img);
            if(count($a_img)>0 && is_file(DIR_UPLOAD.'pages/'.$data['page_id']."/".$a_img[0])){
                $product = $this->pdo->fetch_one("SELECT id FROM productsearch WHERE product_id={$item['id']} LIMIT 1");
                if ($product) {
                    $this->pdo->update('productsearch', $data, 'id='.$product['id']);
                }
                else {
                    $this->pdo->insert('productsearch', $data);
                }
            }
            unset($data);
        }

        echo 'Đã cập nhật dữ liệu thành công.';
    }
    
    function upload_img_to_amazon(){
//         $products = $this->pdo->fetch_all("SELECT id,page_id,images FROM products 
//                 WHERE status=0 AND page_id<>0 AND images IS NOT NULL LIMIT 2");
        
        $v = $this->pdo->fetch_one("SELECT id,page_id,images FROM products
                WHERE id=611677");
        
        // foreach ($products AS $v){
            $a_images = explode(";", $v['images']);
            $img = 'http://imgs.daisan.vn/pages/'.$v['page_id'].'/'.@$a_images[0];
            
            $img2 = 'https://imgs.daisan.vn/pages/22975/1540440991_9afdb01339ef137ea2f3fb1aa64a9024.jpeg';
            
            $curl_handle=curl_init();
            curl_setopt($curl_handle, CURLOPT_URL,$img2);
            curl_setopt($curl_handle, CURLOPT_CONNECTTIMEOUT, 2);
            curl_setopt($curl_handle, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($curl_handle, CURLOPT_USERAGENT, 'Your application name');
            $query = curl_exec($curl_handle);
            curl_close($curl_handle);
            
            var_dump($query); exit();
            
            
            
            $fields = [
                'uploaded_file' => file_get_contents($img),
                'width' => 270,
                'height' => 270,
                'name_file_upload' => DIR_UPLOAD_S3 . $v['page_id'],
                'type_resize' => 'fit',
                'id' => $v['id']
            ];
            
            $this->callApiUpload(DOMAIN_API.'resize-image',  $fields, 'POST');
        //     var_dump(file_get_contents($img));
        // }
        
    }
    
    function get_images($str, $page_id){
        $folder = 'pages/'.$page_id.'/270x270/';
        $a_images = explode(";", $str);
        $a_img = [];
        foreach ($a_images AS $v){
            if($v!='') $a_img[] = URL_IMAGE_S3.$folder.$v;
        }
        return $a_img;
    }
    
    
    function autorun_start(){
        $limit = 20;
        $url = isset($_POST['url']) ? trim($_POST['url']) : '';
        $restart = isset($_POST['restart']) ? intval($_POST['restart']) : 0;
        $a_url = [];
        if($restart==0) $a_url[] = $url;
        else{
            $a_url = @parse_ini_file($this->file_waitinglinks);
            if(!is_array($a_url) || count($a_url)==0) $a_url = [];
            elseif (count($a_url)>$limit) $a_url = array_splice($a_url, 0, $limit);
        }
        
        $rt['number'] = 0;
        if(count($a_url)>0){
            $_SESSION['AUTORUN_URL_SCAN_LINKS'] = $a_url;
            reset($a_url);
            $rt['url_id'] = key($a_url);
            $rt['str_links'] = $this->get_str_links($_SESSION['AUTORUN_URL_SCAN_LINKS']);
            $rt['number'] = count($a_url);
        }
        echo json_encode($rt); exit();
    }
    
    
    function autorun_handle(){
        $url_id = isset($_POST['url_id']) ? trim($_POST['url_id']) : 0;
        $url = @$_SESSION['AUTORUN_URL_SCAN_LINKS'][$url_id];
        unset($_SESSION['AUTORUN_URL_SCAN_LINKS'][$url_id]);
        
        $html = false;
        if(filter_var($url, FILTER_VALIDATE_URL)) $html = \Lib\Help\HtmlDomParser::file_get_html($url);
        
        $a_waiting_links = is_file($this->file_waitinglinks)?@parse_ini_file($this->file_waitinglinks):[];
        $a_scanned_links = is_file($this->file_scannedlinks)?@parse_ini_file($this->file_scannedlinks):[];
        
        $a_links = [];
        if($html){
            foreach($html->find('a') as $element){
                $a_links[] = trim($element->href);
            }
            $a_links = $this->get_trueLink($a_links, $url, "q=;sort=;m/p/");
            
            $data['image'] = null;
            foreach ($html->find('.sticky-header__thumbnail img') AS $element){
                $data['image'] = $element->src;
                break;
            }
            if($data['image']!=null && substr_count($data['image'], 'sys_master')<=0){
                $a_img = @explode("/", $data['image']);
                $a_img[3] = "sys_master";
                unset($a_img[4]);
                $data['image'] = implode("/", $a_img);
            }
            $data['name'] = $this->get_html_value($html, "#header-position h1-->0");
            $data['code'] = null;
            $code = $this->get_html_value($html, ".panel-serial-number-->0");
            if($code!=null){
                $a_code = explode(" - ", $code);
                $a_code = explode(":", $a_code[1]);
                $data['code'] = trim($a_code[1]);
                $data['code'] = trim(str_replace(")", "", $data['code']));
                
            }
            $data['brandname'] = $this->get_html_value($html, "#header-position .product-detail__title-brand a-->0");
            $a_cates = $this->get_html_value($html, "#header__breadcrumb li-->array");
            $data['category'] = end($a_cates);
            $data['a_metas'] = $this->get_html_value($html, "#js-product-classifications table td-->array");
            
            $rt = $this->save_product($data);
            if($rt['code']==1){
                $a_savedlinks = is_file($this->file_savedlinks)?@parse_ini_file($this->file_savedlinks):[];
                $a_savedlinks[] = $url;
                file_put_contents($this->file_savedlinks, lib_arr_to_ini($a_savedlinks));
            }
        }
        
        $a_scanned_links[] = $url;
        $a_links = array_diff($a_links, $a_waiting_links);
        $a_links = array_diff($a_links, $a_scanned_links);
        foreach ($a_links AS $item){
            $a_waiting_links[] = $item;
        }
        $a_waiting_links = array_diff($a_waiting_links, $a_scanned_links);
        $a_waiting_links = @array_unique($a_waiting_links);
        $a_waiting_links = @array_values($a_waiting_links);
        @file_put_contents($this->file_waitinglinks, lib_arr_to_ini($a_waiting_links));

        $a_scanned_links = @array_unique($a_scanned_links);
        $a_scanned_links = @array_values($a_scanned_links);
        @file_put_contents($this->file_scannedlinks, lib_arr_to_ini($a_scanned_links));
        
        $a_url = $_SESSION['AUTORUN_URL_SCAN_LINKS'];
        reset($a_url);
        $rt['url_id'] = key($a_url);
        $rt['number'] = count($_SESSION['AUTORUN_URL_SCAN_LINKS']);
        echo json_encode($rt);
        exit();
    }
    
    
    function save_product(array $a_value){
        $brandname = $this->get_true_value(@$a_value['brandname']);
        $page = $this->pdo->fetch_one("SELECT id FROM pages WHERE page_name='".$this->string->str_convert($brandname)."'");
        $page_id = intval(@$page['id']);
        if(!$page && $brandname!='' && $a_value['code']!=null && $a_value['name']!=null){
            $data['name'] = $brandname;
            $data['name_short'] = $brandname;
            $data['page_name'] = $this->string->str_convert($brandname);
            $data['created'] = time();
            $page_id = $this->pdo->insert('pages', $data);
            unset($data);
            
            $data['page_id'] = $page_id;
            $this->pdo->insert('pageprofiles', $data);
            unset($data);
        }
        
        $data['page_id'] = $page_id;
        $data['name'] = $this->get_true_value(@$a_value['name']);
        $data['code'] = $this->get_true_value(@$a_value['code']);
        $data['trademark'] = $brandname;
        $data['created'] = time();
        if($data['code']!=null && $data['name']!=null && $page_id!=0)
            $data['taxonomy_id'] = $this->taxonomy->create('product', $a_value['category'], $this->string->str_convert($a_value['category']));
        
        $rt['code'] = 0;
        if($data['code']==null || $data['name']==null || $page_id==0){
            $rt['msg'] = "Nội dung bị thiếu";
        }elseif($this->pdo->check_exist("SELECT 1 FROM products WHERE code='".$data['code']."'")){
            $rt['msg'] = "Mã sản phẩm đã tồn tại";
        }elseif($this->pdo->check_exist("SELECT 1 FROM products WHERE name='".$data['name']."'")){
            $rt['msg'] = "Tên sản phẩm đã tồn tại";
        }elseif($product_id = $this->pdo->insert('products', $data)){
            $a_metas = [];
            $number = count($a_value['a_metas'])/2;
            for($i=0; $i<$number; $i++){
                $a_metas[$a_value['a_metas'][$i*2]] = $a_value['a_metas'][$i*2+1];
            }
            foreach ($a_metas AS $k=>$item){
                $data['product_id'] = $product_id;
                $data['meta_key'] = $k;
                $data['meta_value'] = $item;
                $this->pdo->insert('productmetas', $data);
                unset($data);
            }
            
            $data['images'] = $this->img->upload_image_fromurl($this->product->get_folder_img($product_id), @$a_value['image'], 600, 1);
            $this->pdo->update('products', $data, "id=$product_id");
            
            
            $rt['code'] = 1;
            $rt['msg'] = "Lưu sản phẩm thành công";
        }else{
            $rt['msg'] = "Không lưu được sản phẩm";
        }
        unset($data);
        return $rt;
    }
    
    
    function get_true_value($str){
        $str = str_replace("&nbsp;", "", $str);
        return $str;
    }
    
    
    function load_pagecontent(){
        $url = isset($_POST['url'])?trim($_POST['url']):null;
        $data = $this->get_page_content($url);
        $this->smarty->assign('data', $data);
        
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function get_page_content($url, $prefix=null){
        $html = false;
        if(filter_var($url, FILTER_VALIDATE_URL)) $html = \Lib\Help\HtmlDomParser::file_get_html($url);
        
        $data = [];
        $data['url'] = $url;
        $data['a_links'] = [];
        if($html){
            $ex_prefix = explode("&&", $prefix);
            foreach ($ex_prefix AS $item){
                $ex_item = explode(":", $item);
                if(count($ex_item)==2) $a_prefix[$ex_item[0]] = $ex_item[1];
            }
            
            foreach($html->find('a') as $element){
                $data['a_links'][] = trim($element->href);
            }
            $data['a_links'] = $this->get_trueLink($data['a_links'], $url);
            
            $data['name'] = $this->get_html_value($html, "title-->0");
            if(isset($a_prefix['name']) && $a_prefix['name']!=null)
                $data['name'] = $this->get_html_value($html, $a_prefix['name']);
                
                
                $data['image'] = null;
                foreach($html->find("meta[property=og:image]") as $element){
                    $data['image'] = trim($element->content);
                }
                if(isset($a_prefix['image']) && $a_prefix['image']!=null){
                    foreach ($html->find($a_prefix['image']) AS $element){
                        $data['image'] = $element->src;
                        break;
                    }
                }
        }
        return $data;
    }
    
    
    /**
     * 
     * @param object $html
     * @param string $prefix
     * @return string
     */
    function get_html_value($html, $prefix=null){
        $str = null;
        if($prefix!=null){
            if(strpos($prefix, '||')!==false){//Lấy giá trị hoặc
                $a_prefix = explode("||", $prefix);
                foreach ($a_prefix AS $item){
                    $str = $this->get_html_value($html, $item);
                    if($str!=null && $str!='') break;
                }
            }else{
                $nth = 0;
                $pre_remove = null;
                if(strpos($prefix, '---')!==false){//Loại bỏ giá trị con
                    $a_prefix = explode("---", $prefix);
                    $prefix = $a_prefix[0];
                    $pre_remove = $a_prefix[1];
                }
                if(strpos($prefix, '-->')!==false){//Lấy theo thứ tự
                    $a_prefix = explode("-->", $prefix);
                    $nth = $a_prefix[1];
                    $prefix = $a_prefix[0];
                }
                if($pre_remove) $html = $this->remove_html_value($html, $prefix." ".$pre_remove);
                if($nth==='n' || $nth=='array'){
                    $a_str = [];
                    foreach($html->find($prefix) AS $element){
                        $a_str[] = trim($element->plaintext);
                    }
                    $str = $a_str;
                    if($nth==='n') $str = trim(implode(" ", @$a_str));
                }else $str = trim(@$html->find(trim($prefix), $nth)->plaintext);
            }
        }
        return $str;
    }
 
    
    function remove_html_value($html, $selector){
        foreach ($html->find($selector) as $node){
            $node->outertext = '';
        }
        return $html->load($html->save());
    }
    
    
    function get_trueLink($a_url, $url=null, $pre_remove=null){
        if(count($a_url)>0){
            $Domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST);
            $a_url = @array_unique($a_url);
            $a_url = is_array($a_url) ? $a_url : [];
            foreach ($a_url AS $k=>$item){
                $a_item = explode(".", $item);
                $typeurl = end($a_item);
                if($item==''||$item=='/'||$item=='./'||@$item[0]=='#'||@$item[0]=="'") unset($a_url[$k]);
                elseif(substr_count($item, '?')>1||substr_count($item, '"')>0||substr_count($item, '|')>0) unset($a_url[$k]);
                elseif(strpos($item, '{')!==false && strpos($item, '}')!==false) unset($a_url[$k]);
                elseif(@$item[0]=='j'&&@$item[1]=='a'&&@$item[2]=='v'&&@$item[3]=='a') unset($a_url[$k]);
                elseif($url && ($Domain==$item||$Domain."/"==$item||$Domain."/."==$item)) unset($a_url[$k]);
                elseif(strpos($item, 'tel:')!==false||strpos($item, 'skype:')!==false||strpos($item, 'mailto:')!==false) unset($a_url[$k]);
                elseif(strpos($item, '../')!==false) unset($a_url[$k]);
                elseif(in_array(strtoupper($typeurl), array('JPG','JPEG','PNG','GIF','PDF','SWF','RAR','ZIP','TXT','DOC','DOCX','MP4','MP3'))) unset($a_url[$k]);
                elseif($url && filter_var($item, FILTER_VALIDATE_URL) === FALSE){
                    if(!parse_url($item, PHP_URL_SCHEME)){
                        if(@$item[0]=='?'){
                            $a_ex_url = explode("?", $url);
                            $a_url[$k] = $a_ex_url[0] . $item;
                        }elseif(@$item[0]==@$item[1] && @$item[1]=="/"){
                            $a_url[$k] = parse_url($Domain, PHP_URL_SCHEME).":".$item;
                        }elseif(@$item[0]=="." && @$item[1]=="/"){
                            $a_url[$k] = $Domain.substr($item, 1);
                        }else{
                            $item = $Domain . (@$item[0]=='/'?$item:'/'.$item);
                            $a_url[$k] = $item;
                        }
                    }else unset($a_url[$k]);
                }
                
                if(isset($a_url[$k])){
                    if(strlen($a_url[$k])>120) unset($a_url[$k]);
                    elseif(filter_var($a_url[$k], FILTER_VALIDATE_URL) === FALSE) unset($a_url[$k]);
                    elseif($url && parse_url($Domain, PHP_URL_HOST)!=parse_url($a_url[$k], PHP_URL_HOST)) unset($a_url[$k]);
                    elseif(strpos(parse_url($Domain, PHP_URL_HOST), 'http://')!==false||strpos(parse_url($Domain, PHP_URL_HOST), 'https://')!==false) unset($a_url[$k]);
                    elseif($pre_remove && $pre_remove!=''){
                        $a_remove = explode(";", $pre_remove);
                        foreach ($a_remove AS $itemremove){
                            if(strpos($a_url[$k], $itemremove)!==false){
                                unset($a_url[$k]);
                                break;
                            }
                        }
                    }
                }
            }
            @asort($a_url);
        }
        return @array_values($a_url);
    }
    
    
    function get_str_links($a_links){
        $str = "<url id=\"scanlinks\">";
        foreach ($a_links AS $k=>$item){
            $str .= "<li id=\"uid$k\">";
            $str .= "<a href='".@$item."' target='_blank'>";
            $str .= "<i class=\"fa fa-fw fa-link\"></i> ".@$item;
            $str .= "</a>";
            $str .= "</li>";
        }
        $str .= "</ul>";
        return $str;
    }

}
