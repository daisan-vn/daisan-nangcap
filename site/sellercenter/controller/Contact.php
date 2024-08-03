<?php

class Contact extends Pageadmin{
	
	private $status, $type;
	
	function __construct() {
		parent::__construct ();
		
		$this->status = array(
				1 => 'Đã phản hồi',
				0 => 'Chưa phản hồi',
		);
		
		$this->type = array(
				0 => 'Thể loại',
				1 => 'Liên hệ gian hàng',
				2 => 'Liên hệ sản phẩm',
		);
		
		$a_menu = array(
				'index' => "Tất cả tin tuyển dụng",
				'create' => "Đăng tin tuyển dụng",
		);
		$this->get_pagemenu($a_menu);
	}
	
	
	function index(){
		global $login, $lang;
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='send_msg'){
			$data['page_id'] = $this->page_id;
			$data['user_id'] = $login;
			$data['message'] = trim($_POST['message']);
			$data['parent'] = trim($_POST['parent']);
			$data['created'] = time();
			$data['status'] = 1;
			$data['isreply'] = 1;
			$id = $this->pdo->insert('pagemessages', $data);
			unset($data);
			
			$data['status'] = 1;
			$this->pdo->update('pagemessages', $data, 'id='.intval($_POST['parent']));
			
			echo $id; exit();
		}
		
		
		$status = isset($_GET['status']) ? intval($_GET['status']) : -1;
		$type = isset($_GET['type']) ? intval($_GET['type']) : -1;
		$key = isset($_GET['key']) ? trim($_GET['key']) : '';
		$where = "a.parent=0 AND a.page_id=".$this->page_id;
		if($key) $where .= " AND (u.name LIKE '%$key%' OR a.message LIKE '%$key%')";
		if($type!=-1) $where .= " AND ".($type==1?"a.product_id=0":"a.product_id<>0");
		if($status!=-1) $where .= " AND a.status=$status";
		
		
		$sql = "SELECT a.id,a.user_id,u.name,u.avatar,a.message,a.created
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id
				WHERE $where ORDER BY a.id DESC";
		$paging = new \Lib\Core\Pagination($this->pdo->count_item('pagemessages', $where), 10);
		$sql = $paging->get_sql_limit($sql);
		
		$parents = $this->pdo->fetch_all($sql);
		foreach ($parents AS $k=>$item){
			$parents[$k]['url'] = "?mod=contact&site=index&parent=".$item['id'];
			$parents[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['user_id']), $item['avatar']);
		}
		
		$parent_id = isset($_GET['parent']) ? intval($_GET['parent']) : intval(@$parents[0]['id']);
		$info = $this->pdo->fetch_one("SELECT a.id,a.user_id,u.name,u.avatar,a.created,a.product_id,a.number,a.unit_id,p.name AS productname,p.images
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id LEFT JOIN products p ON a.product_id=p.id
				WHERE a.id=$parent_id");
		if($info){
		    $info['unit'] = $this->pdo->fetch_one_fields('taxonomy', 'name', "id=".@$info['unit_id']);
		    $info['unit'] = $info['unit']==''?'Piece':$info['unit'];
    		$info['avatar'] = $this->img->get_image($this->user->get_folder_img($info['user_id']), $info['avatar']);
    		$info['productavatar'] = $this->product->get_avatar($info['product_id'], $info['images']);
    		$info['producturl'] = $this->product->get_url($info['product_id'], $info['productname']);
		}
		$this->smarty->assign('info', $info);
		
		
		
		$contacts = $this->pdo->fetch_all("SELECT a.id,a.user_id,u.name,u.avatar,a.message,a.number,a.unit_id,a.created,a.isreply
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id
				WHERE (a.parent=$parent_id OR a.id=$parent_id)
				ORDER BY a.id ASC");
		foreach ($contacts AS $k=>$item){
			$contacts[$k]['url'] = "?mod=contact&site=index&parent=".$item['id'];
			$contacts[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['user_id']), $item['avatar']);
		}
		
		$this->smarty->assign('parents', $parents);
		$this->smarty->assign('contacts', $contacts);
		$out['parent_id'] = $parent_id;
		$out['select_status'] = $this->help->get_select_from_array($this->status, $status, "Trạng thái");
		$out['select_type'] = $this->help->get_select_from_array($this->type, $type, 0);
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	
}
