<?php

class Menu extends Admin {
    
    private $menu;
    
    function __construct() {
        $this->dir = "thumb/";
        parent::__construct();
        $this->menu = \Lib\Dbo\Menu::instance();
    }
    
    
    function index() {
        global $smarty, $lang;
        $position = isset($_GET['menuObj']) ? intval($_GET['menuObj']) : 0;
        if($position==0){
            $taxonomy = $this->pdo->fetch_one("SELECT id FROM taxonomy WHERE type='menugroup' ORDER BY id LIMIT 1");
            if(!$taxonomy){
                $data = [];
                $data["name"] = "Main Menu";
                $data["type"] = "menugroup";
                $data["status"] = 1;
                $data["lang"] = $lang;
                $position = $this->pdo->insert("taxonomy", $data);
            } else $position = @$taxonomy['id'];
        }
        
        $out = [];
        $out['position'] = $position;
        $out['menu'] = $this->taxonomy->get_select_taxonomy("menugroup", $position, 0, null, "Select menu", 0);
        $out['types'] = $this->help->get_select_from_array($this->menu->type, "module", 0);
        $out['parent'] = $this->menu->get_select_menu_parent($position);
        $smarty->assign("out", $out);
        
        $this->smarty->assign('result', []);
        $smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function position() {
        $setting = is_file(FILE_INFO_SETTING) ? parse_ini_file(FILE_INFO_SETTING, true) : [];
        $position = isset($setting['menu_position']) ? $setting['menu_position'] : [];
        
        $result = [];
        foreach ($this->menu->position AS $k=>$item){
            $result[$k]['name'] = $item;
            $result[$k]['position'] = $this->taxonomy->get_select_taxonomy('menugroup', @$position[$k], 0, null, "Select menu", 0);
        }
        $this->smarty->assign('result', $result);
        
        if(isset($_POST['submit'])){
            foreach ($this->menu->position AS $k=>$item){
                $setting['menu_position'][$k] = $_POST[$k];
            }
            file_put_contents(FILE_INFO_SETTING, $this->string->arr_to_ini($setting));
            lib_alert("Update successful.");
            lib_redirect();
            exit();
        }
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function ajax_handle(){
        global $login, $lang;
        
        if(isset($_POST['ajax']) && $_POST['ajax']=='load_menu_object'){
            echo $this->get_select_menu_object($_POST['type'], 0);
            exit();
        }elseif(isset($_POST['ajax']) && $_POST['ajax']=='reset_menu_content'){
            $data['types'] = $this->help->get_select_from_array($this->menu->type, "page", 0);
            $data['parent'] = $this->menu->get_select_menu_parent($_POST['position']);
            echo json_encode($data);
            exit();
        }elseif(isset($_POST['ajax']) && $_POST['ajax']=='load_menu_edit'){
            $data = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE id=".$_POST['id']);
            $desc = isset($data['description'])?$data['description']:current(array_keys($this->menu->type));
            $data['_types'] = $this->help->get_select_from_array($this->menu->type, $desc, 0);
            $data['_parent'] = $this->menu->get_select_menu_parent(@$_POST['position'], @$data['parent'], 0, $_POST['id']);
            $data['_object'] = $this->get_select_menu_object($desc, @$data['keyword']);
            echo json_encode($data);
            exit();
        }elseif(isset($_POST['ajax']) && $_POST['ajax']=='save_menu_content'){//Create new menu content
            if($_POST['id']==0){
                $last_menu = $this->pdo->fetch_one("SELECT MAX(rgt) AS rgt FROM taxonomy WHERE lang='$lang' AND position=".$_POST['position']);
                if(@$last_menu['rgt']==NULL){//chua co content
                    $data['lft'] = 0;
                    $data['rgt'] = 1;
                }else{
                    if($_POST['parent']==0){//khong co danh muc cha
                        $data['lft'] = $last_menu['rgt']+1;
                        $data['rgt'] = $last_menu['rgt']+2;
                    }else{
                        $last_menu = $this->pdo->fetch_one("SELECT MAX(rgt) AS rgt FROM taxonomy
								WHERE lang='$lang' AND position=".$_POST['position']." AND parent=".$_POST['parent']);
                        if(@$last_menu['rgt']==NULL){//danh muc cha chua co con nao
                            $last_menu = $this->pdo->fetch_one("SELECT rgt FROM taxonomy
									WHERE lang='$lang' AND position=".$_POST['position']." AND id=".$_POST['parent']);
                            $this->pdo->query("UPDATE taxonomy SET lft = lft + 2 WHERE lang='$lang' AND position=".$_POST['position']." AND lft>=".$last_menu['rgt']);
                            $this->pdo->query("UPDATE taxonomy SET rgt = rgt + 2 WHERE lang='$lang' AND position=".$_POST['position']." AND rgt>=".$last_menu['rgt']);
                            $data['lft'] = $last_menu['rgt']+0;
                            $data['rgt'] = $last_menu['rgt']+1;
                        }else{
                            $this->pdo->query("UPDATE taxonomy SET lft = lft + 2 WHERE lang='$lang' AND position=".$_POST['position']." AND lft>".$last_menu['rgt']);
                            $this->pdo->query("UPDATE taxonomy SET rgt = rgt + 2 WHERE lang='$lang' AND position=".$_POST['position']." AND rgt>".$last_menu['rgt']);
                            $data['lft'] = $last_menu['rgt']+1;
                            $data['rgt'] = $last_menu['rgt']+2;
                        }
                    }
                }
                
                $data["position"] = $_POST['position'];
                $data["name"] = trim($_POST['name']);
                $data["title"] = trim(@$_POST['title']);
                $data["type"] = "menu";
                $data["description"] = $_POST['type'];
                $data["keyword"] = $_POST['menu_object'];
                $data["alias"] = $_POST['menu_object'];
                $data["parent"] = $_POST['parent'];
                $data["status"] = 1;
                $data["lang"] = $lang;
                if($_POST['parent']!=0){
                    $parent = $this->pdo->fetch_one("SELECT level FROM taxonomy WHERE id=".$_POST['parent']);
                    $data['level'] = @$parent['level'] + 1;
                }
                $id = $this->pdo->insert("taxonomy", $data);
                echo $this->menu->get_select_menu_parent($_POST['position']);
                unset($data);
                exit();
            }else{
                $position = $_POST['position'];
                $menu = $this->pdo->fetch_one("SELECT lft,rgt,level,parent FROM taxonomy WHERE lang='$lang' AND id=".$_POST['id']);
                $data["name"] = trim($_POST['name']);
                $data["title"] = trim(@$_POST['title']);
                $data["description"] = $_POST['type'];
                $data["keyword"] = $_POST['menu_object'];
                $data["alias"] = $_POST['menu_object'];
                if($menu['parent'] != $_POST['parent']){
                    $menu_move = $menu['rgt']-$menu['lft']+1;
                    $move_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
							WHERE lang='$lang' AND position=$position AND lft>=".$menu['lft']." AND rgt<=".$menu['rgt']);
                    $move_ids = @$move_ids['id'];
                    
                    $this->pdo->query("UPDATE taxonomy SET lft = lft - $menu_move WHERE lang='$lang' AND position=".$_POST['position']." AND lft>".$menu['rgt']);
                    $this->pdo->query("UPDATE taxonomy SET rgt = rgt - $menu_move WHERE lang='$lang' AND position=".$_POST['position']." AND rgt>".$menu['rgt']);
                    
                    if($_POST['parent']==0){
                        $parent = $this->pdo->fetch_one("SELECT lft,rgt,level FROM taxonomy
								WHERE lang='$lang' AND position=$position AND parent=0 AND id NOT IN ($move_ids)
								ORDER BY rgt DESC LIMIT 1");
                        $move_level = 0-$menu['level'];
                        $move_to = $parent['rgt']-$menu['lft']+1;
                    }else{
                        $parent = $this->pdo->fetch_one("SELECT lft,rgt,level FROM taxonomy WHERE lang='$lang' AND id=".$_POST['parent']);
                        $move_level = $parent['level']+1-$menu['level'];
                        $move_to = $parent['rgt']-$menu['lft'];
                        
                        $this->pdo->query("UPDATE taxonomy SET lft = lft + $menu_move WHERE lang='$lang' AND position=".$_POST['position']." AND id NOT IN ($move_ids) AND lft>=".$parent['rgt']);
                        $this->pdo->query("UPDATE taxonomy SET rgt = rgt + $menu_move WHERE lang='$lang' AND position=".$_POST['position']." AND id NOT IN ($move_ids) AND rgt>=".$parent['rgt']);
                    }
                    
                    
                    $this->pdo->query("UPDATE taxonomy SET lft=lft+($move_to), rgt=rgt+($move_to) WHERE lang='$lang' AND position=".$_POST['position']." AND id IN ($move_ids)");
                    $this->pdo->query("UPDATE taxonomy SET level=level+($move_level) WHERE lang='$lang' AND position=".$_POST['position']." AND id IN ($move_ids);");
                    
                }
                $data["parent"] = $_POST['parent'];
                $this->pdo->update("taxonomy", $data, "id=".$_POST['id']);
                unset($data);
                echo $this->menu->get_select_menu_parent($_POST['position']);
                exit();
            }
        }elseif(isset($_POST['ajax']) && $_POST['ajax']=='sort_menu_content'){
            $position = $_POST['position'];
            $menu = $this->pdo->fetch_one("SELECT lft,rgt FROM taxonomy WHERE lang='$lang' AND id=".$_POST['id']);
            $move_number = $menu['rgt']-$menu['lft']+1;
            $move_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
					WHERE type='menu' AND lang='$lang' AND position=$position AND lft>=".$menu['lft']." AND rgt<=".$menu['rgt']);
            $move_ids = @$move_ids['id'];
            
            if($_POST['type']=='down'){
                $menu_move = $this->pdo->fetch_one("SELECT lft,rgt FROM taxonomy WHERE type='menu' AND lang='$lang' AND position=$position AND lft=".($menu['rgt']+1));
                $move_to_number = $menu_move['rgt']-$menu_move['lft']+1;
                $move_to_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
						WHERE type='menu' AND lang='$lang' AND position=$position AND lft>=".$menu_move['lft']." AND rgt<=".$menu_move['rgt']);
                $move_to_ids = @$move_to_ids['id'];
                
                $this->pdo->query("
						UPDATE taxonomy SET lft=lft+$move_to_number, rgt=rgt+$move_to_number WHERE type='menu' AND lang='$lang' AND position=".$_POST['position']." AND id IN ($move_ids);
						UPDATE taxonomy SET lft=lft-$move_number, rgt=rgt-$move_number WHERE type='menu' AND lang='$lang' AND position=".$_POST['position']." AND id IN ($move_to_ids);");
                
            }else{
                $menu_move = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE type='menu' AND lang='$lang' AND position=$position AND rgt=".($menu['lft']-1));
                $move_to_number = $menu_move['rgt']-$menu_move['lft']+1;
                $move_to_ids = $this->pdo->fetch_one("SELECT GROUP_CONCAT(id) AS id FROM taxonomy
						WHERE type='menu' AND lang='$lang' AND position=$position AND lft>=".$menu_move['lft']." AND rgt<=".$menu_move['rgt']);
                $move_to_ids = @$move_to_ids['id'];
                $this->pdo->query("
						UPDATE taxonomy SET lft=lft-$move_to_number, rgt=rgt-$move_to_number WHERE type='menu' AND lang='$lang' AND position=".$_POST['position']." AND id IN ($move_ids);
						UPDATE taxonomy SET lft=lft+$move_number, rgt=rgt+$move_number WHERE type='menu' AND lang='$lang' AND position=".$_POST['position']." AND id IN ($move_to_ids);");
            }
        }elseif(isset($_POST['ajax']) && $_POST['ajax']=='save_taxonomy_menu'){
            $id = $_POST['taxonomy_id'];
            $data['name'] = $_POST['name'];
            if ($id == 0) {
                $data['status'] = 1;
                $data['lang'] = $lang;
                $data['type'] = 'menugroup';
                $id = $this->pdo->insert("taxonomy", $data);
            } else {
                $this->pdo->update("taxonomy", $data, ' id='.$id);
            }
            echo $id; exit();
        }
    }
    
    
    function ajax_load_menu_content() {
        global $login, $lang;
        $position = isset($_GET['menu']) ? intval($_GET['menu']) : 0;
        $sql = "SELECT id,name,image,level,lft,rgt,parent,type,color FROM taxonomy
		    	WHERE status=1 AND lang='$lang' AND position=$position AND type='menu' ORDER BY lft";
        
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
						WHERE lang='$lang' AND position=$position
						AND level=0 AND rgt > ".$item['rgt']." ORDER BY rgt ASC LIMIT 1");
                $item['down_unable'] = $check_down ? false : true;
                
                $check_up = $this->pdo->check_exist("SELECT id,lft,rgt FROM taxonomy
						WHERE lang='$lang' AND position=$position
						AND level=0 AND lft < ".$item['lft']." ORDER BY lft DESC LIMIT 1");
                $item['up_unable'] = $check_up ? false : true;
            }
            
            $help_name = '';
            for ($i = 0; $i < $item['level']; $i++) {
                $help_name .= "&#8212; ";
            }
            
            $item['name'] = $help_name . $item['name'];
            $item['category_avatar'] = $this->img->get_image($this->taxonomy->folder, @$item['image']);
            $result[] = $item;
        }
        $this->smarty->assign('content', "../menu/menu_content.tpl");
        $this->smarty->assign('result', $result);
        $this->smarty->display("none.tpl");
    }

    function ajax_save_color() {
		if (isset ( $_POST ['id'] )) {
			$id = intval ( $_POST ['id'] );
			$check = $this->pdo->check_exist ( "SELECT color FROM taxonomy WHERE id=$id" );
			$data ['color'] = $_POST ['color'];
			if ($check) {
				$this->pdo->update ( "taxonomy", $data, "id=$id" );
			} else {
				$data ['id'] = $id;
				$this->pdo->insert ( "taxonomy", $data );
			}
			echo 1;
			exit ();
		}
		echo 0;
		exit ();
	}
    
    
    function ajax_delete_menu() {
        global $lang;
        if(isset ( $_POST ['Id'] )){
            $data ['code'] = 0;
            $data ['msg'] = "Không thể xóa vì menu này còn chứa nội dung";
            if(!$this->pdo->check_exist("SELECT id FROM taxonomy WHERE position=".$_POST['Id'])){
                $data ['code'] = 1;
                $data ['msg'] = "Xóa thành công.";
                $this->pdo->query("DELETE FROM taxonomy WHERE id=".$_POST['Id']);
            }
            echo json_encode ( $data );
        }
    }
    
    
    function ajax_delete_menu_content() {
        global $lang;
        if(isset ( $_POST ['Id'] )){
            $sub = $this->pdo->check_exist("SELECT id FROM taxonomy WHERE parent=".$_POST['Id']);
            if($sub){
                $data ['code'] = 0;
                $data ['msg'] = "Không thể xóa vì menu này còn chứa menu con";
            }else{
                $data ['code'] = 1;
                $menu = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE id=".$_POST['Id']);
                if($this->pdo->query("DELETE FROM taxonomy WHERE id=".$_POST['Id'])){
                    $this->pdo->query("UPDATE taxonomy SET lft=lft-2 WHERE type='menu' AND lang='$lang' AND lft>".$menu['rgt']." AND position=".$menu['position']);
                    $this->pdo->query("UPDATE taxonomy SET rgt=rgt-2 WHERE type='menu' AND lang='$lang' AND rgt>".$menu['rgt']." AND position=".$menu['position']);
                }
                $data['msg'] = "Xóa menu thành công.";
            }
            echo json_encode ( $data );
        }
    }
    
    
    function get_select_menu_object($type, $active){
        $str = null;
        if(in_array($type, ['category','product','support_cate'])){
            $type = ($type=='support_cate')?'support':$type;
            $str = $this->taxonomy->get_select_taxonomy($type, $active);
        }else if(in_array($type, ['post','support'])){
            $str = $this->posts->get_select_posts($type,$active);
        }
        return $str;
    }
    
}

?>