<?php

class Service extends Pageadmin{
	
	private $cate_type;
	private $taxonomy, $service;
	
	function __construct() {
		parent::__construct ();
		$this->taxonomy = \Lib\Dbo\Taxonomy::instance();
		$this->service = \Lib\Dbo\Service::instance();
		
		$this->cate_type = "service";
		
		$a_menu = array(
				'index' => "Tất cả dịch vụ",
				'create' => "Thêm dịch vụ",
		);
		$this->get_pagemenu($a_menu);
	}
	
	
	function index(){
		global $login;
		$out = [];
		
		$sql = "SELECT s.id,s.name,s.avatar,a.description FROM pageservices a LEFT JOIN services s ON s.id=a.service_id 
				WHERE a.page_id=".$this->page_id;
		$paging = new \Lib\Core\Pagination($this->pdo->count_item('pageservices', "page_id=".$this->page_id), 20);
		$sql = $paging->get_sql_limit($sql);
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		$result = [];
		while ($item = $stmt->fetch()) {
			$item ['avatar'] = $this->img->get_image($this->service->get_folder_img_upload($item['id']), $item['avatar']);
			$item ['url_edit'] = "?mod=service&site=editdetail&ServiceId=".$item['id'];
			$result [] = $item;
		}
		$this->smarty->assign("result", $result);
		
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function create(){
		global $login;
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='create_service'){
			$service_id = isset($_POST['service_id']) ? intval($_POST['service_id']) : 0;
			if($service_id==0){
				$data['taxonomy_id'] = intval(@$_POST['taxonomy_id']);
				$data['name'] = trim(@$_POST['name']);
				$data['user_id'] = $login;
				$data['created'] = time();
				$service_id = $this->pdo->insert('services', $data);
				unset($data);
				$imgname = $this->img->upload_image_base64($this->service->get_folder_img_upload($service_id), $_POST['avatar'], null, 480, 4/3);
				if($imgname){
					$data['avatar'] = $imgname;
					$this->pdo->update('services', $data, "id=$service_id");
				}
				unset($data);
			}
			$data['page_id'] = $this->page_id;
			$data['service_id'] = $service_id;
			$data['status'] = 1;
			$data['created'] = time();
			$this->pdo->insert('pageservices', $data);
			echo $service_id;
			exit();
		}
		
		$out = [];
		$out['select_category'] = $this->taxonomy->get_select_taxonomy($this->cate_type, 0, 0, null, 'Chọn danh mục dịch vụ');
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function editdetail(){
		global $login;
		$service_id = isset($_GET['ServiceId']) ? intval($_GET['ServiceId']) : 0;
		$service = $this->pdo->fetch_one("SELECT a.*,s.name FROM pageservices a LEFT JOIN services s ON a.service_id=s.id
				WHERE a.service_id=$service_id AND a.page_id=".$this->page_id);
		if(isset($_POST['submit'])){
			$data['description'] = trim(@$_POST['description']);
			$data['timework'] = trim(@$_POST['timework']);
			$data['warranty'] = trim(@$_POST['warranty']);
			$data['places'] = @implode(",", @$_POST['places']);
			$this->pdo->update('pageservices', $data, "id=".$service['id']);
			unset($data);
			
			$service_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
			$this->pdo->query("DELETE FROM pageservicemetas WHERE service_id=$service_id AND page_id=".$this->page_id);
			foreach ($service_detail AS $item){
				if(trim($item['key'])!=null && trim($item['value'])!=null){
					$data['meta_key'] = $item['key'];
					$data['meta_value'] = $item['value'];
					$data['page_id'] = $this->page_id;
					$data['service_id'] = $service_id;
					$this->pdo->insert('pageservicemetas', $data);
					unset($data);
				}
			}
			unset($_SESSION['service_add_detail']);
			
			$service_price = isset($_SESSION['service_add_price'])?$_SESSION['service_add_price']:[];
			$this->pdo->query("DELETE FROM pageserviceprices WHERE service_id=$service_id AND page_id=".$this->page_id);
			foreach ($service_price AS $item){
				if(trim($item['key'])!=null && trim($item['value'])!=null){
					$data['version'] = $item['key'];
					$data['price'] = $this->str->convert_money_to_int($item['value']);
					$data['page_id'] = $this->page_id;
					$data['service_id'] = $service_id;
					$this->pdo->insert('pageserviceprices', $data);
					unset($data);
				}
			}
			unset($_SESSION['service_add_price']);
			
			$service_step = isset($_SESSION['service_add_step'])?$_SESSION['service_add_step']:[];
			$this->pdo->query("DELETE FROM pageservicesteps WHERE service_id=$service_id AND page_id=".$this->page_id);
			foreach ($service_step AS $item){
				if(trim($item['value'])!=null){
					$data['content'] = $item['value'];
					$data['page_id'] = $this->page_id;
					$data['service_id'] = $service_id;
					$this->pdo->insert('pageservicesteps', $data);
					unset($data);
				}
			}
			unset($_SESSION['service_add_step']);
			
			$service_promo = isset($_SESSION['service_add_promo'])?$_SESSION['service_add_promo']:[];
			$this->pdo->query("DELETE FROM pageservicepromos WHERE service_id=$service_id AND page_id=".$this->page_id);
			foreach ($service_promo AS $item){
				if(trim($item['value'])!=null){
					$data['content'] = $item['value'];
					$data['page_id'] = $this->page_id;
					$data['service_id'] = $service_id;
					$this->pdo->insert('pageservicepromos', $data);
					unset($data);
				}
			}
			unset($_SESSION['service_add_promo']);
			
			lib_redirect();
		}
		
		$pageservicemetas = $this->pdo->fetch_all("SELECT meta_key,meta_value FROM pageservicemetas 
				WHERE service_id=$service_id AND page_id=".$this->page_id);
		$_SESSION['service_add_detail'] = [];
		foreach ($pageservicemetas AS $k=>$item){
			$_SESSION['service_add_detail'][$k]['key'] = $item['meta_key'];
			$_SESSION['service_add_detail'][$k]['value'] = $item['meta_value'];
		}
		
		$pageservicesteps = $this->pdo->fetch_all("SELECT content FROM pageservicesteps
				WHERE service_id=$service_id AND page_id=".$this->page_id);
		$_SESSION['service_add_step'] = [];
		foreach ($pageservicesteps AS $k=>$item){
			$_SESSION['service_add_step'][$k]['value'] = $item['content'];
		}
		
		$pageservicepromos = $this->pdo->fetch_all("SELECT content FROM pageservicepromos
				WHERE service_id=$service_id AND page_id=".$this->page_id);
		$_SESSION['service_add_promo'] = [];
		foreach ($pageservicepromos AS $k=>$item){
			$_SESSION['service_add_promo'][$k]['value'] = $item['content'];
		}
		
		$pageserviceprices = $this->pdo->fetch_all("SELECT version,price FROM pageserviceprices
				WHERE service_id=$service_id AND page_id=".$this->page_id);
		$_SESSION['service_add_price'] = [];
		foreach ($pageserviceprices AS $k=>$item){
			$_SESSION['service_add_price'][$k]['key'] = $item['version'];
			$_SESSION['service_add_price'][$k]['value'] = number_format($item['price']);
		}
		
		
		$out['select_province'] = $this->help->get_select_location_multi(@$service['places'], 0, 'Toàn Quốc');
		$this->smarty->assign('out', $out);
		$this->smarty->assign('service', $service);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function load_services(){
		$taxonomy_id = isset($_POST['taxonomy_id']) ? intval($_POST['taxonomy_id']) : 0;
		$name = isset($_POST['name']) ? trim($_POST['name']) : '';
		$sql = "SELECT id,name,avatar FROM services WHERE status=1 
				AND id NOT IN (SELECT service_id FROM pageservices WHERE page_id=".$this->page_id.")";
		if($taxonomy_id!=0) $sql .= " AND taxonomy_id=$taxonomy_id";
		if($name!=null) $sql = " AND name LIKE '%$name%'";
		$sql .= " ORDER BY name ASC LIMIT 6";
		$services = $this->pdo->fetch_all($sql);
		foreach ($services AS $k=>$item){
			$services[$k]['avatar'] = $this->img->get_image($this->page->get_folder_img($this->page_id), $item['avatar']);
		}
		$this->smarty->assign('services', $services);
		$this->smarty->display(LAYOUT_NONE);
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
	
	
	function load_steps(){
		$service_add_step = isset($_SESSION['service_add_step'])?$_SESSION['service_add_step']:[];
		$service_add_step = @array_values($service_add_step);
		$_SESSION['service_add_step'] = $service_add_step;
	
		$out['number'] = count($service_add_step);
		$this->smarty->assign('result', $service_add_step);
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_NONE);
	}
	
	
	function load_promos(){
		$service_add_promo = isset($_SESSION['service_add_promo'])?$_SESSION['service_add_promo']:[];
		$service_add_promo = @array_values($service_add_promo);
		$_SESSION['service_add_promo'] = $service_add_promo;
	
		$out['number'] = count($service_add_promo);
		$this->smarty->assign('result', $service_add_promo);
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
	
	
	function ajax_handle(){
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_detail'){
			$service_add_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
			$number = count($service_add_detail);
			$rt['code'] = 1;
			if($number>9){
				$rt['code'] = 0;
				$rt['msg'] = "Bạn chỉ được phép đưa tối đa 10 nội dung.";
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
		
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_step'){
			$service_add_step = isset($_SESSION['service_add_step'])?$_SESSION['service_add_step']:[];
			$number = count($service_add_step);
			$rt['code'] = 1;
			if($number>9){
				$rt['code'] = 0;
				$rt['msg'] = "Bạn chỉ được phép đưa tối đa 10 nội dung.";
			}else{
				$_SESSION['service_add_step'][$number+1]['value'] = "";
			}
			echo json_encode($rt);
			exit();
		}else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_step'){
			$_SESSION['service_add_step'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
			exit();
		}else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='delete_step'){
			unset($_SESSION['service_add_step'][$_POST['id']]);
			exit();
		}else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='sort_step'){
			$id = isset($_POST['id']) ? intval($_POST['id']) : -1;
			$type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
			$me = $_SESSION['service_add_step'][$id];
			if($type=='up'){
				$up = $_SESSION['service_add_step'][$id-1];
				$_SESSION['service_add_step'][$id-1] = $me;
				$_SESSION['service_add_step'][$id] = $up;
			}else{
				$up = $_SESSION['service_add_step'][$id+1];
				$_SESSION['service_add_step'][$id+1] = $me;
				$_SESSION['service_add_step'][$id] = $up;
			}
		}
		
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_promo'){
			$service_add_promo = isset($_SESSION['service_add_promo'])?$_SESSION['service_add_promo']:[];
			$number = count($service_add_promo);
			$rt['code'] = 1;
			if($number>9){
				$rt['code'] = 0;
				$rt['msg'] = "Bạn chỉ được phép đưa tối đa 10 nội dung.";
			}else{
				$_SESSION['service_add_promo'][$number+1]['value'] = "";
			}
			echo json_encode($rt);
			exit();
		}else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_promo'){
			$_SESSION['service_add_promo'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
			exit();
		}else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='delete_promo'){
			unset($_SESSION['service_add_promo'][$_POST['id']]);
			exit();
		}else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='sort_promo'){
			$id = isset($_POST['id']) ? intval($_POST['id']) : -1;
			$type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
			$me = $_SESSION['service_add_promo'][$id];
			if($type=='up'){
				$up = $_SESSION['service_add_promo'][$id-1];
				$_SESSION['service_add_promo'][$id-1] = $me;
				$_SESSION['service_add_promo'][$id] = $up;
			}else{
				$up = $_SESSION['service_add_promo'][$id+1];
				$_SESSION['service_add_promo'][$id+1] = $me;
				$_SESSION['service_add_promo'][$id] = $up;
			}
		}
		
	}
	
	
	function ajax_delete(){
		if(isset($_POST['action']) && $_POST['action']=='delete_item'){
			$id = intval(@$_POST['id']);
			$check_order = $this->pdo->check_exist("SELECT 1 FROM pageserviceorders WHERE service_id=$id AND page_id=".$this->page_id);
			if(!$this->pdo->check_exist("SELECT 1 FROM pageservices WHERE service_id=$id AND page_id=".$this->page_id)){
				$rt['code'] = 0;
				$rt['msg'] = 'Dịch vụ không đúng';
			}
			if(!$this->pdo->check_exist("SELECT 1 FROM pageservices WHERE service_id=$id AND page_id=".$this->page_id)){
				$rt['code'] = 0;
				$rt['msg'] = "Không xóa được dịch vụ vì đang tồn tại đơn hàng cho dịch vụ này.";
			}else{
				$rt['code'] = 1;
				$this->pdo->query("DELETE FROM pageservices WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageservicemetas WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageserviceprices WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageservicepromos WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageservicesteps WHERE service_id=$id AND page_id=".$this->page_id);
			}
			echo json_encode($rt);
			exit();
		}
	}
	
}
