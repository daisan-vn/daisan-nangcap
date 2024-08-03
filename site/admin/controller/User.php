<?php
# ================================ #
# Module for user management
# ================================ #

class User extends Admin{
	
	function __construct(){
		parent::__construct();
	}
	
	
	function index(){
		global $login;
		
		$user = [];
		$out['key'] = isset($_GET['key']) ? $_GET['key'] : '';
		$where = "WHERE Id<>0";
		if($out['key']!='' && $out['key']!=null) 
			$where .= " AND (name LIKE '%".$out['key']."%' OR username LIKE '%".$out['key']."%' OR phone LIKE '%".$out['key']."%' OR email LIKE '%".$out['key']."%')";
		$sql = "SELECT id,name,username,email,avatar,phone,created,status,isadmin FROM users $where ORDER BY id DESC";
		$paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
		$sql = $paging->get_sql_limit($sql);
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		while ($item = $stmt->fetch()){
			$item['status'] = $this->help_get_status($item ['status'], 'users', $item['id']);
			$item['isadmin'] = $this->help_get_status($item ['isadmin'], 'users', $item['id'], 'setAdmin');
			$item['avatar'] = $this->img->get_image($this->user->get_folder_img($item['id']), $item['avatar']);
			$user[] = $item;
		}
		$this->smarty->assign("result", $user);
		
		$this->smarty->assign("out", $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	function report(){
	    $user = [];
	    $out['from'] = isset($_GET['from'])?$_GET['from']:'';
	    $out['to'] = isset($_GET['to'])?$_GET['to']:'';
	    
	    $where = 'user_id<>0';
	    if($out['from']!=='') $where .= ' AND created>='.strtotime($out['from']);
	    if($out['to']!=='') $where .= ' AND created<='.strtotime('23:23:59 '.$out['to']);
	    $count_product = $this->pdo->fetch_all("SELECT user_id,COUNT(1) AS number FROM products WHERE $where GROUP BY user_id");
	    $count_page = $this->pdo->fetch_all("SELECT user_id,COUNT(1) AS number FROM pageusers WHERE $where GROUP BY user_id");
        $a_product = [];
    	    foreach ($count_product AS $item){
    	        $a_product[$item['user_id']] = $item['number'];
    	    }
    	$a_page = [];
    	foreach ($count_page AS $item){
    	        $a_page[$item['user_id']] = $item['number'];
    	    }
    	    $sql = "SELECT id,name,username FROM users ORDER BY created DESC";
    	    $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
    	    $sql = $paging->get_sql_limit($sql);
    	    $stmt = $this->pdo->getPDO()->prepare($sql);
    	    $stmt->execute();
    	    while ($item = $stmt->fetch()){
    	        $item['products'] = intval(@$a_product[$item['id']]);
    	        $item['pages'] = intval(@$a_page[$item['id']]);
    	        $item['keywords'] = intval(@$a_keyword[$item['id']]);
    	        $item['posts'] = intval(@$a_post[$item['id']]);
    	        $user[] = $item;
    	    }
    	    $this->smarty->assign("result", $user);
// 	    $where = "WHERE Id<>0" ;
// 	    if($out['key']!='' && $out['key']!=null)
// 	        $where .= " AND (name LIKE '%".$out['key']."%' OR username LIKE '%".$out['key']."%' OR phone LIKE '%".$out['key']."%')";
// 	        $sql = "SELECT id,name,username,avatar,phone,created,status,(SELECT COUNT(1) FROM pageusers WHERE user_id = users.id) AS num_pages,
//             (SELECT COUNT(1) FROM products WHERE user_id=users.id) AS num_prod FROM users $where ORDER BY id DESC";
// 	        $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
// 	        $sql = $paging->get_sql_limit($sql);
// 	        $stmt = $this->pdo->getPDO()->prepare($sql);
// 	        $stmt->execute();
// 	        while ($item = $stmt->fetch()){
// 	            $item['status'] = $this->help_get_status($item ['status'], 'users', $item['id']);
// 	            $item['avatar'] = $this->img->get_image($this->user->get_folder_img($item['id']), $item['avatar']);
// 	            $item['today'] = time();
// 	            $user[] = $item;
// 	        }
// 	        $this->smarty->assign("result", $user);
	        
	        $this->smarty->assign("out", $out);
	        $this->smarty->display(LAYOUT_DEFAULT);
	}
	

	function ajax_delete() {
		global $login;
		$Id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
		$profile = $this->pdo->fetch_one("SELECT Level FROM useradmin WHERE Id=$login");
		$user = $this->pdo->fetch_one("SELECT Level FROM useradmin WHERE Id=$Id");
		
		$data['code'] = 0;
		if ($profile['Level']<=$user['Level']){
			$data['msg'] = "Không thể xóa tài khoản này, vượt quá quyền hạn của bạn.";
		}else {
			$data['code'] = 1;
			$data['msg'] = "Xóa tài khoản thành công.";
			$this->pdo->query("DELETE FROM useradmin WHERE Id=$Id");
		}
		echo json_encode($data);
		exit();
	}

	function ajax_setadmin() {
	    if (isset($_POST['Id'])) {
	        $value = $this->pdo->fetch_one("SELECT isadmin FROM users WHERE id=".$_POST['Id']);
	        $status = 0;
	        if (@$value['isadmin'] == 0 || @$value['isadmin'] == 2) $status = 1;
	        elseif(@$value['isadmin'] == 1) $status = 2;
	        
	        $this->pdo->query("UPDATE users SET isadmin=$status WHERE id=".$_POST['Id']);
	        echo $this->help_get_status($status, 'users', $_POST['Id'], 'setAdmin');
	        exit();
	    }
	    echo 0; exit();
	}
	
	
	function ajax_bulk_delete() {
		global $login;
		$id = isset($_POST ['id']) ? $_POST ['id'] : 0;
		if ($id == 0) {
			lib_redirect_back();
			exit();
		}
		$input_arr = explode(',', $id);
		$deleted_arr = [];
		$notdeleted_arr = [];
		$deleted_id = [];

		$profile = $this->pdo->fetch_one("SELECT level FROM useradmin WHERE Id=$login");
		foreach ($input_arr as $k => $v) {
			$user = $this->pdo->fetch_one("SELECT level FROM useradmin WHERE Id=$v");
			
			$check_author_post = $this->pdo->check_exist("SELECT post_id FROM vsc_posts WHERE Id=$v");
			$check_author_comment = $this->pdo->check_exist("SELECT comment_id FROM vsc_comments WHERE author=$v");
			$value = $this->pdo->fetch_one("SELECT Id,name FROM useradmin WHERE Id=$v");
			if (!$check_author_post && !$check_author_comment &&  $profile['level']>$user['level']) {
				array_push($deleted_arr, $value['name']);
				array_push($deleted_id, $value['Id']);
				$this->pdo->query("DELETE FROM useradmin WHERE Id=$v");
			}else {
				array_push($notdeleted_arr, $value['name']);
			}
		}

		$data['deleted'] = implode('<br>', $deleted_arr);
		$data['notdeleted'] = implode('<br>', $notdeleted_arr);
		$data['deleted_id'] = implode('-', $deleted_id);

		echo json_encode($data);
	}
	
	
}