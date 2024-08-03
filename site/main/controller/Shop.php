<?php

class Shop extends Main {
	
	private $profile, $shop_id,$is_phone;
    
	function __construct() {
		parent::__construct ();
		
		$pageId = isset($_GET['pageId']) ? trim($_GET['pageId']) : null;
		$this->profile = $this->page->get_profile($pageId);
		// lib_dump($this->profile);
		$this->shop_id = $this->profile['pid'];
		$this->is_phone = $this->profile['isphone'];
		$this->smarty->assign('profile', $this->profile);
		$this->smarty->assign('page', $this->profile);
	}
	
	function index(){
		$key = isset($_GET['k']) ? trim($_GET['k']) : null;
		$out = [];
		
		$a_sliders = strlen(@$this->profile['img_sliders'])>30 ? explode(";", @$this->profile['img_sliders']) : [];
		$a_sliders_show = [];
		foreach ($a_sliders AS $item){
			if(is_file($this->page->get_folder_img_upload($this->shop_id).$item))
				$a_sliders_show[] = $this->img->get_image($this->page->get_folder_img($this->shop_id), $item);
		}
		$this->smarty->assign('a_home_sliders_show', $a_sliders_show);
		// echo json_encode($a_sliders_show);
                            
		$product_category = $this->tax->get_product_category_ofpage($this->shop_id);
		//lib_dump($product_category);
		$a_category = [];
		foreach ($product_category AS $k=>$v){
		    if($k<=3){
		        $a_category[$k] = $v;
		        $a_category[$k]['products'] = $this->product->get_list($this->shop_id,$v['id'],null,4);
		    }
		}
		$this->smarty->assign ('a_category', $a_category);
		// lib_dump($a_category);
		$a_home_product_main = $this->product->get_list($this->shop_id,0,'a.ismain=1',8);
		$this->smarty->assign ('a_home_product_main', $a_home_product_main);
		
		$result = $this->product->get_list($this->shop_id, 0, "a.status=1", 10, null, "a.id DESC");
		$this->smarty->assign('result', $result);
		
		$out['key'] = $key;
		$this->smarty->assign('out', $out);

		$this->set_useronline($this->shop_id);

		$this->get_seo_metadata($this->profile['name'], $this->profile['meta_keyword'], $this->profile['meta_description'], @$this->profile['logo_img']);
		$this->smarty->display('detail.tpl');
	}
	
	
	function products() {
		$cat = isset($_GET['cat']) ? trim($_GET['cat']) : null;
		$sort = isset($_GET['sort']) ? trim($_GET['sort']) : null;
	    $out = [];
	    
	    $where = "a.status=1 AND a.name<>'' AND a.page_id=".$this->shop_id;
		if($cat!='') $where .= " AND a.taxonomy_id=$cat";
		$orderby ="a.ismain DESC,a.score DESC,a.views DESC";
		if($sort=='newest') $orderby = "a.id DESC";
		if($sort=='discount_desc') $orderby = "a.promo DESC";
		if($sort=='price_asc') $orderby = "a.price ASC";
		if($sort=='price_desc') $orderby = "a.price DESC";

	    $sql = "SELECT a.id,a.name,a.images,a.page_id,a.trademark,a.ordertime,a.minorder,u.name AS unit,a.promo,
			IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
			IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a LEFT JOIN taxonomy u ON u.id=a.unit_id
				WHERE $where ORDER BY $orderby";
	    $out['number'] = $this->pdo->count_custom("SELECT COUNT(1) AS number FROM products a WHERE $where");
	    $paging = new \Lib\Core\Pagination($out['number'], 20, 0);
	    $sql = $paging->get_sql_limit($sql);
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
	    $this->smarty->assign('result', $result);
	    
	    $product_category = $this->tax->get_product_category_ofpage($this->shop_id);
		$this->smarty->assign('product_category', $product_category);
		
		$url = $this->profile['url']."?site=products";
		if($cat!='') $url .= "&cat=$cat";
	    $out['url'] = $url;
		$this->smarty->assign('out', $out);
		
		$this->get_seo_metadata($this->profile['name'], $this->profile['meta_keyword'], $this->profile['meta_description'], @$this->profile['a_image'][0]);
	    $this->smarty->display('detail.tpl');
	}

	
	function search() {
		$key = isset($_GET['k']) ? trim($_GET['k']) : null;
	    $out = [];
	    
	    $where = "a.status=1 AND a.name<>'' AND a.page_id=".$this->shop_id;
	    if($key!='') $where .= " AND a.name LIKE '%$key%'";
	    $sql = "SELECT a.id,a.name,a.images,a.page_id,a.trademark,a.ordertime,a.minorder,u.name AS unit,a.promo,
				IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a LEFT JOIN taxonomy u ON u.id=a.unit_id
				WHERE $where ORDER BY a.ismain DESC,a.score DESC,a.views DESC";
	    $out['number'] = $this->pdo->count_custom("SELECT COUNT(1) AS number FROM products a WHERE $where");
	    $paging = new \Lib\Core\Pagination($out['number'], 20, 0);
	    $sql = $paging->get_sql_limit($sql);
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
		$out['key'] = $key;
	    $this->smarty->assign('out', $out);
	    $this->smarty->assign('result', $result);
		$this->smarty->display('detail.tpl');	
	}
	function profile(){

	    $this->smarty->display('detail.tpl');
	}
	
	function contact(){
		global $login;	
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='send_contact'){
			$page_id = isset($_POST['page_id']) ? intval($_POST['page_id']) : 0;
			$product_id = isset($_POST['product_id']) ? intval($_POST['product_id']) : 0;
			$number = isset($_POST['number']) ? intval($_POST['number']) : 0;
			$unit_id = isset($_POST['unit_id']) ? intval($_POST['unit_id']) : 0;
			$rt = [];
			$rt['code'] = 0;
			if($login==0) $rt['msg'] = "Vui lòng đăng nhập trước khi thực hiện chức năng.";
			elseif(!$this->pdo->check_exist("SELECT 1 FROM pages WHERE id=$page_id")){
				$rt['msg'] = "Không tồn tại gian hàng này.";
			}elseif($product_id!=0 && !$this->pdo->check_exist("SELECT 1 FROM products WHERE page_id=$page_id AND id=$product_id")){
				$rt['msg'] = "Sản phẩm không thuộc gian hàng.";
			}else{
			    $data = [];
				$data['page_id'] = $page_id;
				$data['product_id'] = $product_id;
				$data['message'] = trim(@$_POST['message']);
				$data['number'] = $number;
				$data['unit_id'] = $unit_id;
				$data['user_id'] = $login;
				$data['created'] = time();
				$this->pdo->insert('pagemessages', $data);
				$rt['code'] = 1;
				$rt['msg'] = "Gửi liên hệ tới gian hàng thành công.";
			}
			echo json_encode($rt);
			exit();
		}
		
		$page_id = isset($_GET['page_id']) ? intval($_GET['page_id']) : 0;
		$product_id = isset($_GET['product_id']) ? intval($_GET['product_id']) : 0;
		
		$product = $this->pdo->fetch_one("SELECT id,name,images,minorder,unit_id,page_id FROM products WHERE id=$product_id");
		$page = $this->page->get_profile($product['page_id']);
		$this->smarty->assign('page', $page);
		
		$product = $this->product->get_detail($product);
		
		$this->smarty->assign('product_unit',$this->tax->get_select_taxonomy('product_unit', @$product['unit_id'], 0, null, 0));
		$this->smarty->assign('product', $product);
		$this->smarty->display (LAYOUT_CUSTOM);
	}
	function showrooms(){
		global $login;
		$page_id = isset($_GET['page_id']) ? intval($_GET['page_id']) : 0;
		$address = $this->pdo->fetch_all("SELECT id,name,image,address,phone,lat,lng FROM pageaddress WHERE page_id=".$this->shop_id);
        foreach ($address AS $k=>$item){
            $address[$k]['image'] = $this->img->get_image($this->page->get_folder_img($this->shop_id), $item['image']);
			if ($this->is_phone == 1)
			$address[$k]['phone'] = @$this->option['contact']['phone'];
        }
        $this->smarty->assign('address', $address);
		$this->smarty->display (LAYOUT_CUSTOM);
	}
	
}
