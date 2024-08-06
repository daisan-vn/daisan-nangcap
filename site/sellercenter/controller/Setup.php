<?php

class Setup extends Pageadmin{
	function __construct() {
		parent::__construct ();
		
		$a_menu = array(
				'index' => "Thông tin cài đặt",
				'name' => "Cài đặt tên page",
				'website' => 'Cài đặt website liên kết',
				'seo' => 'Cài đặt seo web',
				'admin' => 'Quản trị viên',
				'link' => 'Link liên kết'
		);
		$this->get_pagemenu($a_menu);
		
	}
	
	
	function index(){
		global $login, $lang;
		$out = [];
		
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}

	
	function name(){
		global $login, $lang;
		$out = [];
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_name'){
			$check = $this->pdo->check_exist("SELECT 1 FROM pages WHERE page_name='".trim(@$_POST['name'])."'");
			if($check){
				$rt['code'] = 0;
				$rt['msg'] = "Tên trang đã tồn tại trên hệ thống, vui lòng chọn tên khác.";
			}else{
				$rt['code'] = 1;
				$data['page_name'] = trim(@$_POST['name']);
				$this->pdo->update('pages', $data, "id=".$this->page_id);
			}
			echo json_encode($rt); exit();
		}
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function website(){
		global $login, $lang;
		$out = [];
	
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function seo(){
		global $login, $lang;
		$out = [];
	
		if(isset($_POST['submit'])){
			$data['meta_title'] = trim(@$_POST['meta_title']);
			$data['meta_keyword'] = trim(@$_POST['meta_keyword']);
			$data['meta_description'] = trim(@$_POST['meta_description']);
			$this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
			lib_redirect();
		}
		
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function admin(){
		global $login, $lang;
		$out = [];
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_pageuser'){
			$user_id = intval(@$_POST['id']);
			$user = $this->pdo->fetch_one("SELECT u.id,u.name,u.avatar,u.username FROM users u WHERE u.id=$user_id");
			$item = $this->pdo->fetch_one("SELECT id,position FROM pageusers WHERE user_id=$user_id AND page_id=".$this->page_id);
			$user['select_position'] = $this->help->get_select_from_array($this->user->admin_position, @$item['position'], 0);
			$user['avatar'] = $this->img->get_image($this->user->get_folder_img($user['id']), $user['avatar']);
			$user['item_id'] = intval(@$item['id']);
			echo json_encode($user);
			exit();
		}elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_pageuser'){
		    $id = intval(@$_POST['id']);
			$data['position'] = intval(@$_POST['position']);
			$data['created'] = time();
			if($id==0){
			    $data['page_id'] = $this->page_id;
			    $data['user_id'] = intval(@$_POST['user_id']);
			    $data['status'] = 1;
    			$this->pdo->insert('pageusers', $data);
			}else $this->pdo->update('pageusers', $data, "id=$id AND page_id=".$this->page_id);
			exit();
		}
		
		$admin = $this->pdo->fetch_all("SELECT u.id,u.name,u.avatar,a.position,a.created,a.status 
				FROM pageusers a LEFT JOIN users u ON u.id=a.user_id
				WHERE a.page_id=".$this->page_id." ORDER BY a.position");
		foreach ($admin AS $k=>$item){
			$admin[$k]['position'] = $this->user->admin_position[$item['position']];
			$admin[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['id']), $item['avatar']);
			$admin[$k]['delete'] = ($item['id']==$login)?0:($this->profile['position']==0?1:0);
		}
		
		$this->smarty->assign('admin', $admin);
		
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function link(){
	    global $login, $lang;
	    
	    if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_content'){
	        $id = intval(@$_POST['id']);
	        $result = $this->pdo->fetch_one("SELECT * FROM pagelinks WHERE id=$id");
	        echo json_encode($result);
	        exit();
	    }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_content'){
	        $id = intval(@$_POST['id']);
	        $data['title'] = trim($_POST['title']);
	        $data['link'] = trim($_POST['link']);
	        if($id==0){
    	        $data['page_id'] = $this->page_id;
    	        $data['created'] = time();
    	        $data['user_id'] = $login;
    	        $data['status'] = 1;
    	        $this->pdo->insert('pagelinks', $data);
	        }else $this->pdo->update('pagelinks', $data, "id=$id AND page_id=".$this->page_id);
	        exit();
	    }
	    
	    $result = $this->pdo->fetch_all("SELECT id,title,link,created FROM pagelinks WHERE page_id=".$this->page_id);
	    $this->smarty->assign('result', $result);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function ajax_delete_link(){
		if(isset($_POST['action']) && $_POST['action']=='delete_item'){
			$id = intval(@$_POST['id']);
			$rt['code'] = 1;
			$this->pdo->query("DELETE FROM pagelinks WHERE id=$id AND page_id=".$this->page_id);
			echo json_encode($rt);
			exit();
		}
	}

	
	function ajax_delete_admin(){
	    if(isset($_POST['action']) && $_POST['action']=='delete_item'){
	        $id = intval(@$_POST['id']);
	        $rt['code'] = 1;
	        $this->pdo->query("DELETE FROM pageusers WHERE user_id=$id AND page_id=".$this->page_id);
	        echo json_encode($rt);
	        exit();
	    }
	}
	
	
	function load_users(){
		global $login, $lang;
		$key = isset($_POST['key']) ? trim($_POST['key']) : '';
		$key = $key==null?"-1":$key;
		$sql = "SELECT a.id,a.name,a.avatar FROM users a WHERE a.status=1 AND a.id<>$login
				AND a.id NOT IN (SELECT p.user_id FROM pageusers p WHERE p.page_id=".$this->page_id.")";
		if($key!=null) $sql .= " AND (a.name LIKE '%$key%' OR a.phone LIKE '%$key%' OR a.email LIKE '%$key%')";
		$sql .= " ORDER BY a.name ASC LIMIT 12";
		$users = $this->pdo->fetch_all($sql);
		foreach ($users AS $k=>$item){
			$users[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['id']), $item['avatar']);
		}
		
		$this->smarty->assign('users', $users);
		$this->smarty->display(LAYOUT_NONE);
	}
	
	
}
