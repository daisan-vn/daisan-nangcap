<?php

# ================================ #
# Module for Taxonomy management
# ================================ #
class Taxonomy extends Admin {
	
	public $type;
	public $type_prefix;
    
    function __construct() {
        parent::__construct();
        $this->type = array(
            'category' => 'danh mục',
            'product' => 'danh mục sản phẩm',
            'product_unit' => 'đơn vị sản phẩm',
            'service' => 'danh mục dịch vụ',
            'jobpost' => 'danh mục tuyển dụng',
            'image' => 'danh mục hình ảnh',
            'tag' => 'tag',
            'project' => 'danh mục dịch vụ',
            'event'=>'sự kiện',
            'support'=>'danh mục hỗ trợ'
        );

        $not_show = [];
        $not_show['parent'] = array('product_unit');
        $not_show['position'] = array('product_unit');
        $not_show['keyword'] = array('product_unit');
        $this->smarty->assign('not_show', $not_show);
    }

	function index() {
		global $smarty;
		$type = isset($_GET['type']) ? $_GET['type'] : 'category';
		$key = isset ( $_GET ['key'] ) ? trim ( $_GET ['key'] ) : "";
		if(!$this->type[$type]) lib_redirect_back();
		$out = [];
		$out['type'] = $type;
		$out['key'] = $key;
		$out['type_prefix'] = @$this->type[$type];
		$out['select_type'] = $this->help->get_select_from_array($this->type, $type, 0);
		$out['select_parent'] = $this->taxonomy->get_select_taxonomy_tree($type);
        $out['position'] = $this->help->get_select_from_array($this->taxonomy->position,0,"Chọn vị trí");
      //  if($type=='category') $out['position'] = $this->help->get_select_from_array($this->taxonomy->position_post);
		if ($type == 'category' || $type == 'product') $out['select_media_folder'] = $this->taxonomy->get_select_taxonomy('folder', 0, 0, null, null, 0);
		$out['file_include'] = "../taxonomy/category.tpl";
		$smarty->assign("out", $out);

		$this->fetch_taxonomy($type);
		$smarty->display(LAYOUT_DEFAULT);
	}

	function ajax_handle(){
		global $lang;
	
		if(isset($_POST['ajax']) && $_POST['ajax']=='save_taxonomy_content'){//Create new menu content
			$msg = [];
			if($_POST['id']==0){
				if($this->pdo->check_exist("SELECT id FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."' AND alias='".$_POST['alias']."'")){
					$msg['exist'] = 1;
					exit(json_encode($msg));
				}
				$last_tax = $this->pdo->fetch_one("SELECT MAX(rgt) AS rgt FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."'");
				$data = [];
				if(@$last_tax['rgt']==NULL){//chua co content
					$data['lft'] = 0;
					$data['rgt'] = 1;
				}else{
					if($_POST['parent']==0){//khong co danh muc cha
						$data['lft'] = $last_tax['rgt']+1;
						$data['rgt'] = $last_tax['rgt']+2;
					}else{
						$last_tax = $this->pdo->fetch_one("SELECT MAX(rgt) AS rgt FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."' AND parent=".$_POST['parent']);
						if(@$last_tax['rgt']==NULL){//danh muc cha chua co con nao
							$last_tax = $this->pdo->fetch_one("SELECT rgt FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."' AND id=".$_POST['parent']);
							$this->pdo->query("UPDATE taxonomy SET lft = lft + 2 WHERE lang='$lang' AND type='".$_POST['type']."' AND lft>=".$last_tax['rgt']);
							$this->pdo->query("UPDATE taxonomy SET rgt = rgt + 2 WHERE lang='$lang' AND type='".$_POST['type']."' AND rgt>=".$last_tax['rgt']);
							$data['lft'] = $last_tax['rgt']+0;
							$data['rgt'] = $last_tax['rgt']+1;
						}else{
							$this->pdo->query("UPDATE taxonomy SET lft = lft + 2 WHERE lang='$lang' AND type='".$_POST['type']."' AND lft>".$last_tax['rgt']);
							$this->pdo->query("UPDATE taxonomy SET rgt = rgt + 2 WHERE lang='$lang' AND type='".$_POST['type']."' AND rgt>".$last_tax['rgt']);
							$data['lft'] = $last_tax['rgt']+1;
							$data['rgt'] = $last_tax['rgt']+2;
						}
					}
				}
	
				$data["name"] = trim($_POST['name']);
				$data["alias"] = trim($_POST['alias']);
				$data["type"] = $_POST['type'];
				$data["position"] = trim(@$_POST['position']);
				$data["description"] = trim(@$_POST['description']);
				$data['title']=trim(@$_POST['title']);
				$data["keyword"] = trim(@$_POST['keyword']);
				$data["parent"] = intval(@$_POST['parent']);
				$data["status"] = 1;
				$data["lang"] = $lang;
				if(isset($_POST['parent']) && @$_POST['parent']!=0){
					$parent = $this->pdo->fetch_one("SELECT level FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."' AND id=".$_POST['parent']);
					$data['level'] = @$parent['level'] + 1;
				}
				if($insert_id = $this->pdo->insert("taxonomy", $data)){
					$msg['insert_id'] = $insert_id;
					$msg['select_parent'] = $this->taxonomy->get_select_taxonomy_tree($_POST['type']);
					exit(json_encode($msg));
				}else exit(json_encode($data));
			}else{
				$id = $_POST['id'];
				$tax = $this->pdo->fetch_one("SELECT lft,rgt,level,parent FROM taxonomy WHERE lang='$lang' AND id=".$_POST['id']);
				$data["name"] = trim($_POST['name']);
				$data["type"] = $_POST['type'];
				if($tax['parent'] != $_POST['parent']){
					$tax_move = $tax['rgt']-$tax['lft']+1;
					$move_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
							WHERE lang='$lang' AND type='".$_POST['type']."' AND lft>=".$tax['lft']." AND rgt<=".$tax['rgt']);
					$move_ids = @$move_ids['id'];
	
					$this->pdo->query("UPDATE taxonomy SET lft = lft - $tax_move WHERE lang='$lang' AND type='".$_POST['type']."' AND lft>".$tax['rgt']);
					$this->pdo->query("UPDATE taxonomy SET rgt = rgt - $tax_move WHERE lang='$lang' AND type='".$_POST['type']."' AND rgt>".$tax['rgt']);
						
					if($_POST['parent']==0){
						$parent = $this->pdo->fetch_one("SELECT lft,rgt,level FROM taxonomy
								WHERE lang='$lang' AND type='".$_POST['type']."' AND parent=0 AND id NOT IN ($move_ids)
								ORDER BY rgt DESC LIMIT 1");
						$move_level = 0-$tax['level'];
						$move_to = $parent['rgt']-$tax['lft']+1;
					}else{
						$parent = $this->pdo->fetch_one("SELECT lft,rgt,level FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."' AND id=".$_POST['parent']);
						$move_level = $parent['level']+1-$tax['level'];
						$move_to = $parent['rgt']-$tax['lft'];
	
						$this->pdo->query("UPDATE taxonomy SET lft = lft + $tax_move WHERE lang='$lang' AND type='".$_POST['type']."' AND id NOT IN ($move_ids) AND lft>=".$parent['rgt']);
						$this->pdo->query("UPDATE taxonomy SET rgt = rgt + $tax_move WHERE lang='$lang' AND type='".$_POST['type']."' AND id NOT IN ($move_ids) AND rgt>=".$parent['rgt']);
					}
					$this->pdo->query("UPDATE taxonomy SET lft=lft+($move_to), rgt=rgt+($move_to) WHERE lang='$lang' AND type='".$_POST['type']."' AND id IN ($move_ids)");
					$this->pdo->query("UPDATE taxonomy SET level=level+($move_level) WHERE lang='$lang' AND type='".$_POST['type']."' AND id IN ($move_ids);");
				}
				$data["parent"] = $_POST['parent'];
				$data["alias"] = $_POST['alias'];
				$data["position"] = $_POST['position'];
				$data["title"] = $_POST['title'];
				$data["description"] = $_POST['description'];
				$data["keyword"] = $_POST['keyword'];
				$this->pdo->update("taxonomy", $data, "id=".$_POST['id']);
				unset($data);
				$msg['select_parent'] = $this->taxonomy->get_select_taxonomy_tree($_POST['type']);
				exit(json_encode($msg));
			}
		}elseif(isset($_POST['ajax']) && $_POST['ajax']=='sort_taxonomy'){
			$id = $_POST['id'];
			$tax = $this->pdo->fetch_one("SELECT lft,rgt FROM taxonomy WHERE lang='$lang' AND id=".$_POST['id']);
			$move_number = $tax['rgt']-$tax['lft']+1;
			$move_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
					WHERE lang='$lang' AND type='".$_POST['type']."' AND lft>=".$tax['lft']." AND rgt<=".$tax['rgt']);
			$move_ids = @$move_ids['id'];
				
			if($_POST['sort_type']=='down'){
				$tax_move = $this->pdo->fetch_one("SELECT lft,rgt FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."' AND lft=".($tax['rgt']+1));
				$move_to_number = $tax_move['rgt']-$tax_move['lft']+1;
				$move_to_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
						WHERE lang='$lang' AND type='".$_POST['type']."' AND lft>=".$tax_move['lft']." AND rgt<=".$tax_move['rgt']);
				$move_to_ids = @$move_to_ids['id'];
	
				$this->pdo->query("
						UPDATE taxonomy SET lft=lft+$move_to_number, rgt=rgt+$move_to_number WHERE lang='$lang' AND type='".$_POST['type']."' AND id IN ($move_ids);
						UPDATE taxonomy SET lft=lft-$move_number, rgt=rgt-$move_number WHERE lang='$lang' AND type='".$_POST['type']."' AND id IN ($move_to_ids);");
	
			}else{
				$tax_move = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE lang='$lang' AND type='".$_POST['type']."' AND rgt=".($tax['lft']-1));
				$move_to_number = $tax_move['rgt']-$tax_move['lft']+1;
				$move_to_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
						WHERE lang='$lang' AND type='".$_POST['type']."' AND lft>=".$tax_move['lft']." AND rgt<=".$tax_move['rgt']);
				$move_to_ids = @$move_to_ids['id'];
				$this->pdo->query("
						UPDATE taxonomy SET lft=lft-$move_to_number, rgt=rgt-$move_to_number WHERE lang='$lang' AND type='".$_POST['type']."' AND id IN ($move_ids);
						UPDATE taxonomy SET lft=lft+$move_number, rgt=rgt+$move_number WHERE lang='$lang' AND type='".$_POST['type']."' AND id IN ($move_to_ids);");
			}
		}elseif(isset($_POST['ajax']) && $_POST['ajax']=='load_taxonomy_content') {
			$id = isset ( $_POST ['id'] ) ? intval ( $_POST ['id'] ) : 0;
			$type = isset($_POST['type']) ? $_POST['type'] : 'category';
			$value = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE lang='$lang' AND id=$id");

			$child = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id SEPARATOR ',') AS child FROM taxonomy
						WHERE lang='$lang' AND type='$type' AND lang='$lang' AND lft >= ".$value['lft']." AND rgt <= ".$value['rgt']);
			$value ['select_parent'] = $this->taxonomy->get_select_taxonomy_tree($type, @$value['parent'], 0, "a.id NOT IN (".@$child['child'].")");
	        // if($type=='category') $value['position'] = $this->help->get_select_from_array($this->taxonomy->position_post, @$value['position']);
            // else 
			$value['position'] = $this->help->get_select_from_array($this->taxonomy->position, @$value['position'],"Chọn vị trí");
	        exit (json_encode ( $value ));
		}elseif(isset($_POST['ajax']) && $_POST['ajax']=='save_taxonomy_icon') {
			$data['icon'] = @$_POST['value'];
			if ($this->pdo->update( 'taxonomy' , $data , "id=".$_POST['id']))
			echo "<i class=\"fa ".$_POST['value'] ." fa-fw\" aria-hidden=\"true\"></i>";
			exit();	
		}elseif(isset($_POST['ajax']) && $_POST['ajax']=='reset_selected') {
			echo  $this->taxonomy->get_select_taxonomy_tree($_POST['type'], $_POST['active']);
			exit();	
		}elseif(isset($_POST['ajax']) && $_POST['ajax']=='ajax_update_avatar'){
			$media_id = isset($_POST['media_id']) ? intval($_POST['media_id']) : 0;
			$media = $this->media->get_media_value($media_id);
			$data['image'] = $media_id;
			$this->pdo->update('taxonomy', $data, "id=".intval($_POST['tax_id']));
			echo @$media['thumb'];
			exit();
		}elseif(isset($_POST['ajax']) && $_POST['ajax']=='update_avatar'){
		    $taxonomy = $this->pdo->fetch_one('SELECT id,name,image FROM taxonomy WHERE id='.intval(@$_POST['taxonomy_id']));
		    $image = null;
		    if($taxonomy){
		        @unlink(DIR_UPLOAD.$this->taxonomy->folder.$taxonomy['image']);
		        $upload = $this->img->upload_image_base64($this->taxonomy->folder, @$_POST['img'], null, 400, 0);
		        $data = [];
		        $data['image'] = $upload;
		        $this->pdo->update('taxonomy', $data, "id=".intval(@$_POST['taxonomy_id']));
		        $image = $this->img->get_image($this->taxonomy->folder, $upload);
		    }
		    echo $image;
		    exit();
		}
		elseif (isset($_POST['ajax']) && $_POST['ajax']=='ajax_update_color') {
			$data['color'] = $_POST['color'];
			$this->pdo->update('taxonomy', $data, "id=".intval($_POST['id']));
			echo 1; exit();
		}
		echo 0; exit();
		
		
	}
	

	function fetch_taxonomy($type) {
		global $smarty, $lang;
        $id = isset($_GET['id']) ? $_GET['id'] : 0;
		$sql = "SELECT a.id,a.icon,a.name,a.parent,a.featured,a.status,m.name AS image,t.alias AS folder,
					a.color,a.level,a.parent,a.lft,a.rgt
		    	FROM taxonomy a
		    	LEFT JOIN media m ON a.image=m.id
		    	LEFT JOIN taxonomy t ON m.taxonomy_id=t.id
				WHERE a.type='$type' AND a.lang='$lang' AND a.parent=$id";
	    
		$key = isset ( $_GET ['key'] ) ? trim ( $_GET ['key'] ) : "";
		if ($key != "") $sql .= " AND (a.name LIKE '%$key%')";
		$sql .= " ORDER BY a.lft";
		$paging = new \Lib\Core\Pagination ($this->pdo->count_rows($sql), 20);
		$sql = $paging->get_sql_limit($sql);
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		$result = [];
		
		while ($item = $stmt->fetch()) {
			if ($item['level'] != 0) {
				$find_parent = $this->pdo->fetch_one("SELECT lft,rgt FROM taxonomy WHERE id=" . $item['parent']);
				if ($find_parent) {
					$item['down_unable'] = ($find_parent['rgt'] - $item['rgt']) == 1 ? true : false;
					$item['up_unable'] = ($item['lft'] - $find_parent['lft']) == 1 ? true : false;
				}
			}else {
				$check_down = $this->pdo->check_exist("SELECT id,lft,rgt FROM taxonomy
						WHERE type='$type' AND lang='$lang' AND level=0 AND rgt>".$item['rgt']." ORDER BY rgt ASC LIMIT 1");
				$item['down_unable'] = $check_down ? false : true;

				$check_up = $this->pdo->check_exist("SELECT id,lft,rgt FROM taxonomy
						WHERE type='$type' AND lang='$lang' AND level=0 AND lft<".$item['lft']." ORDER BY lft DESC LIMIT 1");
				$item['up_unable'] = $check_up ? false : true;
			}

			$help_name = '';
			for ($i = 0; $i < $item['level']; $i++) {
				$help_name .= "&#8212; ";
			}
			$item['name'] = $help_name . $item['name'];
			$item ['btn_status'] = $this->help_get_status($item ['status'], 'taxonomy', $item ['id']);
			$item ["btn_featured"] = $this->help_get_featured($item ['featured'], 'taxonomy', $item ['id']);
			$item['category_avatar'] = $this->img->get_image($this->media->get_path($item['folder'], 1), @$item['image']);
			$result [] = $item;
		}
		$smarty->assign('result', $result);
	}


	function refresh_data() {
		global $smarty;

		if (isset($_POST['refresh'])) {
			$type = $_POST['refresh'];
			$this->fetch_taxonomy($type);
			echo $smarty->display('../taxonomy/category.tpl');
			exit();
		}
	}


	function ajax_bulk_delete() {
		global $lang;
		$id = isset($_POST ['id']) ? $_POST ['id'] : 0;
		if ($id == 0) {
			lib_redirect_back(); exit();
		}
		$input_arr = explode(',', $id);
		$deleted_arr = [];
		$notdeleted_arr = [];
		$deleted_id = [];

		foreach ($input_arr as $v) {
			$check_parent = $this->pdo->check_exist("SELECT id FROM taxonomy WHERE parent=$v");

			$info = $this->pdo->fetch_one("SELECT id,name,type,lft,rgt FROM taxonomy WHERE id=$v");
			if (!$check_parent) {
				array_push($deleted_arr, $info['name']);
				array_push($deleted_id, $info['id']);
				
				$this->pdo->query("UPDATE taxonomy SET lft=lft-2 WHERE lang='$lang' AND type='".$info['type']."' AND lft>".$info['rgt']);
				$this->pdo->query("UPDATE taxonomy SET rgt=rgt-2 WHERE lang='$lang' AND type='".$info['type']."' AND rgt>".$info['rgt']);

				$this->pdo->query("DELETE FROM taxonomymetas WHERE id=$v");
				$this->pdo->query("DELETE FROM taxonomy WHERE id=$v");
			}
			else {
				array_push($notdeleted_arr, $info['name']);
			}
		}
		$data = [];
		$data['deleted'] = implode('<br>', $deleted_arr);
		$data['notdeleted'] = implode('<br>', $notdeleted_arr);
		$data['deleted_id'] = implode('-', $deleted_id);
		echo json_encode($data);
	}

	
	function ajax_delete() {
		global $lang;
		$id = isset ( $_POST ['Id'] ) ? intval ( $_POST ['Id'] ) : 0;
		if($id == 0) exit ();
		
		$check_parent = $this->pdo->check_exist ( "SELECT id FROM taxonomy WHERE parent=$id LIMIT 1" );
		$info = $this->pdo->fetch_one("SELECT id,name,type,rgt,lft FROM taxonomy WHERE id=$id");
		$data = [];
		if ($check_parent) {
			$data ['code'] = 0;
			$data ['msg'] = "Không thể xóa <b>" . $info['name'] . "</b> vì dành mục này còn chứa danh mục con";
		} else {
			$data ['code'] = 1;
			$data ['msg'] = "Xóa danh mục <b>" . $info['name'] . "</b> thành công";

			$this->pdo->query("UPDATE taxonomy SET lft=lft-2 WHERE lang='$lang' AND type='".$info['type']."' AND lft>".$info['rgt']);
			$this->pdo->query("UPDATE taxonomy SET rgt=rgt-2 WHERE lang='$lang' AND type='".$info['type']."' AND rgt>".$info['rgt']);

			$this->pdo->query ( "DELETE FROM taxonomy WHERE id=$id" );
			$this->pdo->query ( "DELETE FROM taxonomymetas WHERE taxonomy_id=$id" );
		}
		echo json_encode ( $data );
	}
	
	
	function get_ajax_icon() {
		$id = $_POST['id'];
		$str_icon = parse_ini_file('../../constant/conf/icon.ini', true);
		$iconlist = explode(",", $str_icon['icon']);
		if (isset($_POST['value'])) {
			$iconlist = preg_grep('~' . $_POST['value'] . '~', $iconlist);
		}
		foreach ($iconlist as $data) {
			$strdata = '"' . $data . '"';
			echo "<button style='margin: 4px;' class='btn btn-sm btn-default'onclick='saveicon($strdata,$id);'><i class=\"fa " . $data . " fa-fw fa-lg\" aria-hidden=\"true\"></i></button>";
		}
	}
	

}

?>