<?php

class Profile extends Pageadmin{

	function __construct() {
		parent::__construct ();

		$a_menu = array(
				'index' => "Thông tin cơ bản",
				'intro' => "Giới thiệu",
				'address' => 'Địa chỉ làm việc',
				'supporters' => 'Nhân viên CSKH',
				'partners' => 'Đối tác chính',
		);
		$this->get_pagemenu($a_menu);
	}


	function index(){
		global $login, $lang;
		$out = array ();

		if(isset($_POST['submit'])){
			$data['name'] = trim($_POST['name']);
			$data['code'] = trim($_POST['code']);
			$data['name_short'] = trim($_POST['name_short']);
			$data['name_global'] = trim($_POST['name_global']);
			$data['date_start'] = date("Y-m-d", strtotime(trim($_POST['date_start'])));
			$data['type'] = intval($_POST['type']);
			$data['number_mem'] = intval($_POST['number_mem']);
			$data['province_id'] = intval($_POST['province_id']);
			$data['district_id'] = intval($_POST['district_id']);
			$data['wards_id'] = intval($_POST['wards_id']);
			$data['address'] = trim($_POST['address']);
			$data['website'] = trim($_POST['website']);
			$data['phone'] = trim($_POST['phone']);
			$data['email'] = trim($_POST['email']);
			$this->pdo->update('pages', $data, "id=".$this->page_id);
			$this->page->update_page_score($this->page_id);
			lib_redirect();
		}elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_logo'){
			$upload = $this->img->upload_image_base64($this->page->get_folder_img($this->page_id), @$_POST['img'], null, 200, 1);
			$rt = 0;
			if($upload){
				unset($data);
				@unlink($this->page->get_folder_img_upload($this->page_id).$this->profile['logo']);
				$data['logo'] = $upload;
				$this->pdo->update('pages', $data, "id=".$this->page_id);
				$rt = URL_UPLOAD.$this->page->get_folder_img($this->page_id).$upload;
			}
			echo $rt; exit();
		}elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_logo_custom'){
			$upload = $this->img->upload_image_base64($this->page->get_folder_img($this->page_id), @$_POST['img'], null, 300, 3);
			$rt = 0;
			if($upload){
				unset($data);
				@unlink($this->page->get_folder_img_upload($this->page_id).$this->profile['logo_custom']);
				$data['logo_custom'] = $upload;
				$this->pdo->update('pages', $data, "id=".$this->page_id);
				$rt = URL_UPLOAD.$this->page->get_folder_img($this->page_id).$upload;
			}
			echo $rt; exit();
		}

		$out['type'] = $this->help->get_select_from_array($this->page->type, @$this->profile['type']);
		$out['Province'] = $this->help->get_select_location(@$this->profile['province_id'], 0, 'Tỉnh thành phố');
		$out['District'] = $this->help->get_select_location(@$this->profile['district_id'], @$this->profile['province_id'], 'Quận huyện');
		$out['Wards'] = $this->help->get_select_location(@$this->profile['wards_id'], @$this->profile['district_id'], 'Phường xã');
		$out['number_mem'] = $this->help->get_select_from_array($this->page->number_mem, @$this->profile['number_mem']);
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}


	function intro(){
		global $login, $lang;
		$out = array ();

		$profile = $this->pdo->fetch_one("SELECT * FROM pageprofiles WHERE page_id=".$this->page_id);
		if(!$profile){
		    $data['page_id'] = $this->page_id;
		    $this->pdo->insert('pageprofiles', $data);
		    unset($data);
		}

		$a_image = strlen($profile['images'])>30 ? explode(";", $profile['images']) : [];
		for ($i=0; $i<4; $i++){
			if(isset($a_image[$i]) && is_file($this->page->get_folder_img_upload($this->page_id).$a_image[$i])){
				$a_image_show[$i] = $this->img->get_image($this->page->get_folder_img($this->page_id), $a_image[$i]);
			}else{
				$a_image_show[$i] = NO_IMG;
				unset($a_image[$i]);
			}
		}
		$profile['images'] = implode(";", $a_image);

		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_images'){
			$upload = $this->img->upload_image_base64($this->page->get_folder_img($this->page_id), @$_POST['img'], null, 600, 3/2);
			$a_image[] = $upload;
			$data['images'] = implode(";", $a_image);
			$this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
			echo $upload;
			exit();
		}elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_images'){
			@unlink($this->page->get_folder_img_upload($this->page_id).@$_POST['imgname']);
			foreach ($a_image AS $k=>$item){
				if(!is_file($this->page->get_folder_img_upload($this->page_id).$item))
					unset($a_image[$k]);
			}
			$data['images'] = implode(";", $a_image);
			$this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
			exit();
		}elseif(isset($_POST['submit'])){
			$data['description'] = trim($_POST['description']);
			$data['time_open'] = trim($_POST['time_open']);
			$data['revenue'] = intval($_POST['revenue']);
			$data['supply_ability'] = trim($_POST['supply_ability']);
			$data['url_facebook'] = trim($_POST['url_facebook']);
			$data['url_google'] = trim($_POST['url_google']);
			$data['url_youtube'] = trim($_POST['url_youtube']);
			$data['fb_id'] = trim($_POST['fb_id']);
			if(!$profile){
				$data['page_id'] = $this->page_id;
				$this->pdo->insert('pageprofiles', $data);
			}else{
				$this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
			}
			lib_redirect();
		}

		$this->smarty->assign('profile', $profile);
		$this->smarty->assign('a_image_show', $a_image_show);
		$out['revenue'] = $this->help->get_select_from_array($this->page->revenue, @$profile['revenue']);
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}


	function address(){
		global $login, $lang;
		$out = array ();
		if(isset($_POST['submit'])){
			$address_id = intval($_POST['id']);
			$data['page_id'] = $this->page_id;
			$data['name'] = trim($_POST['name']);
			$data['address'] = trim($_POST['address']);
            $data['lat'] = trim($_POST['center_point_lat']);
            $data['lng'] = trim($_POST['center_point_lng']);
			$data['province_id'] = intval($_POST['province_id']);
			$data['phone'] = trim($_POST['phone']);
			$data['email'] = trim($_POST['email']);
			if($address_id==0){
				$data['status'] = 1;
				$data['created'] = time();
				$inId = $this->pdo->insert('pageaddress', $data);
			}else{
				$this->pdo->update('pageaddress', $data, "id=$address_id");
				$inId = $address_id;
			}
			
			if($inId!=0 && @$_FILES['Image']['name']!=''){
			    unset($data);
			    $imgname = $this->img->upload($this->page->get_folder_img($this->page_id), @$_FILES['Image'], 320, 1.5);
			    $data['image'] = $imgname;
			    $img = $this->pdo->fetch_one("SELECT image FROM pageaddress WHERE id=$inId");
			    if($img) @unlink($this->page->get_folder_img_upload($this->page_id).$img['image']);
			    $this->pdo->update('pageaddress', $data, "id=$inId");
			}
			lib_redirect();
		}
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_frm'){
			$address = $this->pdo->fetch_one("SELECT * FROM pageaddress WHERE id=".intval(@$_POST['id']));
			$address['image'] = $this->img->get_image($this->page->get_folder_img($this->page_id), $address['image']);
			echo json_encode($address);
			exit();
		}

        $address = $this->pdo->fetch_all("SELECT id,name,image,address,lat,lng FROM pageaddress WHERE page_id=".$this->page_id);
        foreach ($address AS $k=>$item){
            $address[$k]['image'] = $this->img->get_image($this->page->get_folder_img($this->page_id), $item['image']);
        }
        $this->smarty->assign('address', $address);

		$out['Province'] = $this->help->get_select_location(@$this->profile['province_id'], 0, 'Tỉnh thành phố');
		
		
		
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}


	function supporters(){
		global $login, $lang;
		$out = array ();

		if(isset($_POST['SaveSupporter'])){
			$Id = intval($_POST['Id']);
			$data['name'] = trim($_POST['Name']);
			$data['phone'] = trim($_POST['Phone']);
			$data['skype'] = trim($_POST['Skype']);
			$data['email'] = trim($_POST['Email']);
			$Id = intval($_POST['Id']);
			if($Id==0){
				$data['page_id'] = $this->page_id;
				$data['created'] = time();
				$data['status'] = 1;
				$inId = $this->pdo->insert('pagesupporters', $data);
			}else{
				$this->pdo->update('pagesupporters', $data, "id=$Id");
				$inId = $Id;
			}
			if($inId!=0 && @$_FILES['Image']['name']!=''){
				unset($data);
				$imgname = $this->img->upload($this->page->get_folder_img($this->page_id), @$_FILES['Image'], 160, 1);
				$data['avatar'] = $imgname;
				$img = $this->pdo->fetch_one("SELECT avatar FROM pagesupporters WHERE id=$inId");
				if($img) @unlink($this->page->get_folder_img_upload($this->page_id).$img['avatar']);
				$this->pdo->update('pagesupporters', $data, "Id=$inId");
			}
			lib_redirect();
		}

		if(isset($_POST['Action']) && $_POST['Action']=='load_frm'){
			$supporter = $this->pdo->fetch_one("SELECT * FROM pagesupporters WHERE id=".intval(@$_POST['Id']));
			$supporter['avatar'] = $this->img->get_image($this->page->get_folder_img($this->page_id), $supporter['avatar']);
			echo json_encode($supporter);
			exit();
		}


		$supporters = $this->pdo->fetch_all("SELECT id,name,phone,email,skype,avatar FROM pagesupporters WHERE page_id=".$this->page_id);
		foreach ($supporters AS $k=>$item){
			$supporters[$k]['avatar'] = $this->img->get_image($this->page->get_folder_img($this->page_id), $item['avatar']);
		}
		$this->smarty->assign('supporters', $supporters);

		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}


	function partners(){
		global $login, $lang;
		if(isset($_POST['submit'])){
			$data['page_id'] = $this->page_id;
			$data['partner_id'] = $_POST['partner_id'];
			$data['year_start'] = $_POST['year_start'];
			$data['year_finish'] = $_POST['year_finish'];
			$data['description'] = trim($_POST['description']);
			$data['created'] = time();
			$data['status'] = 1;
			$this->pdo->insert('pagepartners', $data);
			lib_redirect();
		}

		$partners = $this->pdo->fetch_all("SELECT p.id,a.name,a.logo,p.year_start,p.year_finish,p.description,p.partner_id
                FROM pagepartners p LEFT JOIN pages a ON a.id=p.partner_id
				WHERE p.page_id=".$this->page_id);
		foreach ($partners AS $k=>$item){
			$partners[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['partner_id']), $item['logo']);
			$partners[$k]['year_finish'] = $item['year_finish']==0?'Nay':$item['year_finish'];
		}

		$this->smarty->assign('partners', $partners);
		$this->smarty->display(LAYOUT_DEFAULT);
	}


	function load_partners(){
		$key = isset($_POST['key']) ? trim($_POST['key']) : '';
		$sql = "SELECT p.id,p.name,p.logo FROM pages p WHERE p.status=1 AND p.id<>".$this->page_id."
				AND p.id NOT IN (SELECT p1.partner_id FROM pagepartners p1 WHERE p1.page_id=p.id)";
		if($key!=null) $sql .= " AND (p.name LIKE '%$key%' OR p.code LIKE '%$key%' OR p.name_short LIKE '%$key%' OR p.name_global LIKE '%$key%')";
		$sql .= " ORDER BY p.name ASC LIMIT 6";
		$partners = $this->pdo->fetch_all($sql);
		foreach ($partners AS $k=>$item){
			$partners[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
		}
		$this->smarty->assign('partners', $partners);
		$this->smarty->display(LAYOUT_NONE);
	}


	function ajax_delete_partner(){
	    if(isset($_POST['action']) && $_POST['action']=='delete_item'){
	        $id = intval(@$_POST['id']);
	        $rt['code'] = 1;
	        $this->pdo->query("DELETE FROM pagepartners WHERE id=$id AND page_id=".$this->page_id);
	        echo json_encode($rt);
	        exit();
	    }
	}
	function ajax_delete_pageaddress() {
	    $id = isset($_POST ['id']) ? intval($_POST ['id']) : 0;
	    $data['code'] = 1;
	    $data['msg'] = "Xóa thành công";
	    $this->pdo->query("DELETE FROM pageaddress WHERE id=$id");
	    echo json_encode($data);
	    exit();
	}


}
