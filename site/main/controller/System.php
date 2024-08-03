<?php

class System{
    
    public $pdo, $str, $img;
    public $product;
    
    function __construct() {
        global $smarty, $tpl;
        
        $this->smarty = $smarty;
        $this->pdo = \Lib\DB::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->product = \Lib\Dbo\Product::instance();
        
        $this->smarty->assign('content', $tpl);
    }
    
    function ajax_load_product_recommen(){
        $HodineCache = json_decode(@$_COOKIE['HodineCache'], true);
        $category = is_array(@$HodineCache['category_view'])?$HodineCache['category_view']:[];
        
        $limit = isset($_GET['limit'])?intval($_GET['limit']):60;
        $location = isset($_GET['location']) ? intval($_GET['location']) : 0;
        $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a force index (name,package)
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1 AND a.ismain=1 AND b.package_id !=0";
        if($location!=0) $sql.=" AND a.page_id IN (SELECT p.id FROM pages p WHERE p.status=1 AND p.province_id=$location)";
        if(count($category)>0) $sql .= " AND a.taxonomy_id IN (".implode(',', $category).")";
        $sql.=" ORDER BY RAND() LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            //$result[$k]['avatar'] = $this->product->get_avatar($item['id'], $item['images']);
            $a_images = explode(";", $item['images']);
            $result[$k]['avatar'] = URL_IMAGE_S3 . $this->product->get_folder_img_s3($item['id']) .'270x270/' . @$a_images[0];
            $result[$k]['url'] = $this->product->get_url($item['id'], $item['name']);
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = $item['price']==$item['pricemax']?0:$item['pricemax'];
            $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
        }
        
        $this->smarty->assign('result', $result);
        $this->smarty->display(LAYOUT_NONE);
    }
    function info_listuser(){
        global $login;
        $out = [];
        $out['login'] = $login;
        $user = $this->pdo->fetch_one("SELECT id,name,avatar,isadmin FROM users WHERE id=$login");
        //$user['avatar'] = $this->img->get_image($this->user->get_folder_img($_POST['id']), $user['avatar']);
        $this->smarty->assign('user', $user);
        $this->smarty->assign("out",$out);
        $this->smarty->display(LAYOUT_NONE);
    }
    function ajax_set_location_used(){
        global $domain;
        if(isset($_POST['location1'])){
            $value = $this->pdo->fetch_one("SELECT Name FROM locations WHERE id=".$_POST['location1']);
            $value['url']=$this->str->str_convert($value['Name']);
            if($_POST['location1'] ==0){
                unset($_COOKIE[COOKIE_LOCATION_ID_MAIN]);
                setcookie(COOKIE_LOCATION_ID_MAIN, null, time() - 3600, "/", "." . $domain);
                setcookie(COOKIE_LOCATION_URL_MAIN,'', time()-3600, "/", "." . $domain);
            }else{
                setcookie(COOKIE_LOCATION_ID_MAIN, $_POST["location1"], time() + (86400 * 7), "/", "." . $domain);
                setcookie(COOKIE_LOCATION_URL_MAIN, DOMAIN.$value['url']."/", time() + (86400 * 7), "/", "." . $domain);
            }
            echo json_encode($value);
            exit();
        }
    }
}