<?php

# ================================ #
# Module for Service management
# ================================ #

class Theme extends Admin {
	
	private $folder = "themes/";
	
	function __construct() {
		parent::__construct();

	}


	function index() {
		global $login, $lang;
		$out = [];
		$status= isset($_GET['status']) ? $_GET['status'] : "";
		$out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status);
		$out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
		$out['filter_category'] = $this->taxonomy->get_select_taxonomy('category', isset($_GET['cat']) ? $_GET['cat'] : 0);

		$where = "1=1";
		$sql = "SELECT id,name,avatar,status,title,date_update
				FROM themes a WHERE $where ORDER BY id DESC";
		$paging = new \Lib\Core\Pagination($this->pdo->count_item('themes', $where), 20);
		$sql = $paging->get_sql_limit($sql);
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		$result = [];
		while ($item = $stmt->fetch()) {
			$item ['status'] = $this->help_get_status($item['status'], 'themes', $item['id']);
			$item ['avatar'] = $this->img->get_image($this->folder, $item['avatar']);
			$item ['url_edit'] = "?mod=theme&site=create&ThemeId=".$item['id'];
			$result [] = $item;
		}
		$this->smarty->assign("result", $result);

		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}


	function create() {
		global $login, $lang;
		$theme_id = isset($_GET['ThemeId']) ? intval($_GET['ThemeId']) : 0;
		$theme = $this->pdo->fetch_one("SELECT * FROM themes WHERE id=$theme_id");
		$theme['avatar'] = $this->img->get_image($this->folder, $theme['avatar']);
		$theme['date_update'] = @$theme['date_update']!=''?$theme['date_update']:date('d-m-Y');
		$out['select_category'] = $this->taxonomy->get_select_taxonomy('service', @$theme['taxonomy_id'], 0, null, 'Chọn danh mục dịch vụ');
		$this->smarty->assign('theme', $theme);

		if (isset($_POST['submit'])) {
			$data['name'] = trim($_POST['name']);
			$data['title'] = trim($_POST['title']);
			$data['date_update'] = date("Y-m-d", strtotime($_POST['date_update']));
			//$data['taxonomy_id'] = intval(@$_POST['taxonomy_id']);
			$data['description'] = trim($_POST['description']);
			if($theme_id==0){
				$data['created'] = time();
				$data['updated'] = time();
				$data['status'] = 1;
				$newId = $this->pdo->insert("themes", $data);
			}else{
				$this->pdo->update("themes", $data, "id=$theme_id");
				$newId = $theme_id;
			}
			unset($data);
			if(strlen($_POST['avatar'])>100){
				$imgname = $this->img->upload_image_base64($this->folder, $_POST['avatar'], null, 600, 3/4);
				if($imgname){
					$avatar = $this->pdo->fetch_one("SELECT avatar FROM themes WHERE id=$newId");
					@unlink(DIR_UPLOAD.$this->folder.$avatar['avatar']);
					
					$data['avatar'] = $imgname;
					$this->pdo->update('themes', $data, "id=$newId");
				}
				
			}

			lib_redirect("?mod=theme&site=index");
		}
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}


	function detail(){
		global $login, $lang;
		$PostId = isset($_GET['Id']) ? intval($_GET['Id']) : 0;
		$post = $this->pdo->fetch_one("SELECT a.*,
				(SELECT name FROM vsc_users WHERE a.user_id=user_id) AS username,
				(SELECT GROUP_CONCAT(c.name) FROM vsc_taxonomy c WHERE c.type='category'
				AND c.taxonomy_id IN (SELECT r.taxonomy_id FROM vsc_taxonomyrls r WHERE r.post_id=a.post_id)) AS categories
				FROM vsc_posts a WHERE a.post_id=$PostId");
		$post['avatar'] = $this->img->get_image(@$post['image'], 1);
		 
		$this->smarty->assign('post', $post);
		$this->smarty->display("none.tpl");
	}



	/** =========================================================================== */

	function ajax_delete() {
		$id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
		if ($id == 0) {
			lib_redirect_back();
			exit();
		}
		$check_parent = $this->pdo->check_exist("SELECT comment_id FROM vsc_comments WHERE post_id=$id");
		if ($check_parent) {
			$data['ok'] = 0;
			$data['mes'] = "Không thể xóa <b>".$_POST['target']."</b> vì còn chứa comment";
		}
		else {
			$data['ok'] = 1;
			$this->pdo->query("DELETE FROM images WHERE Id=$id");
			$this->pdo->query("DELETE FROM vsc_taxonomyrls WHERE post_id=$id");
			$this->pdo->query("DELETE FROM vsc_postmeta WHERE post_id=$id");
			// xóa menu
			$value=$this->pdo->fetch_one("SELECT a.menu_id FROM vsc_menu a WHERE a.menu_object=$id");
			$id_menu=$value['menu_id'];

			$this->pdo->query("DELETE FROM vsc_taxonomymeta WHERE meta_value=$id_menu AND meta_key='nav_menu'");
			$this->pdo->query("DELETE FROM vsc_menu WHERE menu_id=$id_menu");
			// kết thúc xóa menu
		}
		echo json_encode($data);
	}

	function ajax_bulk_delete() {
		$id = isset($_POST ['id']) ? $_POST ['id'] : 0;
		if ($id == 0) {
			lib_redirect_back();
			exit();
		}

		$input_arr = explode(',', $id);
		$deleted_arr = [];
		$notdeleted_arr = [];
		$deleted_id = [];

		foreach ($input_arr as $k => $v) {
			$check_parent = $this->pdo->check_exist("SELECT comment_id FROM vsc_comments WHERE post_id=$v");
			$value = $this->pdo->fetch_one("SELECT post_id,title FROM vsc_posts WHERE post_id=$v");
			if (!$check_parent) {
				array_push($deleted_arr, $value['title']);
				array_push($deleted_id, $value['post_id']);
				$this->pdo->query("DELETE FROM vsc_posts WHERE post_id=$v");
				$this->pdo->query("DELETE FROM vsc_taxonomyrls WHERE post_id=$v");
				$this->pdo->query("DELETE FROM vsc_postmeta WHERE post_id=$v");
				// xóa menu
				$value=$this->pdo->fetch_one("SELECT a.menu_id FROM vsc_menu a WHERE a.menu_object=$v");
				$id_menu=$value['menu_id'];

				$this->pdo->query("DELETE FROM vsc_taxonomymeta WHERE meta_value=$id_menu AND meta_key='nav_menu'");
				$this->pdo->query("DELETE FROM vsc_menu WHERE menu_id=$id_menu");
				// kết thúc xóa menu
			}
			else {
				array_push($notdeleted_arr, $value['title']);
			}
		}

		$data['deleted'] = implode('<br>', $deleted_arr);
		$data['notdeleted'] = implode('<br>', $notdeleted_arr);
		$data['deleted_id'] = implode('-', $deleted_id);

		echo json_encode($data);
	}

}
