<?php

# ================================ #
# Module for Pages management
# ================================ #

class Keyword extends Admin {
	
	
	function __construct() {
		parent::__construct();
	}


	function index() {
		global $login, $lang;
		$out = [];
		$cate_id = isset($_GET['cat'])?intval($_GET['cat']):-1;
		$status = isset($_GET['status']) ? $_GET['status'] : -1;

		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_keyword'){
		    $id = intval(@$_POST['id']);
		    $result = $this->pdo->fetch_one("SELECT * FROM keywords WHERE id=$id");
		    echo json_encode($result);
		    exit();
		}if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_keyword'){
		    $id = intval(@$_POST['id']);
		    $data = [];
		    $data['name'] = trim(@$_POST['name']);
		    $data['admin_id'] = $login;
		    $data['created'] = time();
		    if($id==0){
		        $data['status'] = 1;
		        $this->pdo->insert('keywords', $data);
		    }else $this->pdo->update('keywords', $data, "id=$id");
		    echo 1; exit();
		}
		$out['filter_category'] = $this->taxonomy->get_select_taxonomy('product', 0, 0, 'a.status=1', 'Không có danh mục');
		
		$out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status, 'Trạng thái');

		$where = "1=1";
		if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND a.name LIKE '%".$_GET['key']."%'";
		if($cate_id != -1){
			$where .=" AND a.taxonomy_id=$cate_id";
		}
		if($status!=-1) $where.=" AND a.status=$status";
		$sql = "SELECT a.*,
		(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category
		FROM keywords a WHERE $where ORDER BY a.status DESC,a.score DESC,a.id DESC";
		
		$paging = new \Lib\Core\Pagination($this->pdo->count_item('keywords',$where), 20);
		$sql = $paging->get_sql_limit($sql);
		$result = $this->pdo->fetch_all($sql);
		foreach ($result AS $k=>$item){
			$result[$k]['url_cat'] = "?mod=keyword&site=index&cat=".$item['taxonomy_id'];
		    $result[$k]['status'] = $this->help_get_status($item['status'], 'keywords', $item['id']);
			$result[$k]['featured'] = $this->help_get_featured($item['featured'], 'keywords', $item['id']);
		}
		$this->smarty->assign("result", $result);
		
		$out['filter_key'] = trim(@$_GET['key']);
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}

	
	function history() {
	    global $login, $lang;
	    $out = [];
	    $data = [];
	    if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_keyword'){
	        $key = trim(@$_POST['key']);
	        if(strlen($key)>2){
    	        $keyword = $this->pdo->fetch_one("SELECT id FROM keywords WHERE name='$key'");
    	        $key_id = intval(@$keyword['id']);
    	        if(!$keyword){
    	            $data['name'] = $key;
    	            $data['admin_id'] = $login;
    	            $data['created'] = time();
    	            $data['status'] = 1;
    	            $key_id = $this->pdo->insert('keywords', $data);
    	            unset($data);
    	        }
    	        $data['keyword_id'] = $key_id;
    	        $this->pdo->update('keyhistory', $data, "keyword_name='$key'");
	        }
	        exit();
	    }
	    
	    $where = "1=1";
	    if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND a.keyword_name LIKE '%".$_GET['key']."%'";
	    $sql = "SELECT a.* FROM keyhistory a WHERE $where ORDER BY a.id DESC";
	    
	    $paging = new \Lib\Core\Pagination($this->pdo->count_item('keyhistory'), 20);
	    $sql = $paging->get_sql_limit($sql);
	    $result = $this->pdo->fetch_all($sql);
	    $this->smarty->assign("result", $result);
	    
	    $out['filter_key'] = trim(@$_GET['key']);
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
    function category(){
		$id = isset($_GET['id']) ? $_GET['id'] : 0;
        $result = $this->pdo->fetch_all("SELECT id,name,contents FROM taxonomy WHERE status=1 AND parent=$id AND type='product' ORDER BY id ASC");
       // new \Lib\Core\Pagination($this->pdo->count_item('groupattributes', null), 50);
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
	function keyword_category(){
        // $groupAttributes = $this->pdo->fetch_one("SELECT id,name FROM groupattributes ORDER BY id");
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        if ($id != 0) {
            $contents = $this->pdo->fetch_one("SELECT contents FROM taxonomy WHERE id =$id");
            $result = json_decode($contents['contents'], true);
            // echo "<pre>";
            // print_r($result);
            // echo "</pre>";
			$result['show_content'] = "";
			foreach ($result as $k => $v) {
                    $v_name = @$v['name'];
                    $result['show_content'] .= "$v_name\n";
            }
            // edit
            if(isset($_POST['submit'])){
                $lenght_attribute = $_POST['lenght_attribute'];
                $attr_contents = [];
                $attr_content =  $_POST["contents_$id"];
                $tmp = explode(PHP_EOL, $attr_content);
                foreach ($tmp as $k => $v) {
					if(strlen($v) > 1) {
						$arr_push = [
							'name'      => chop($v),
							'img_id'    => '',
							'img_name'  => ''
						];
						array_push($attr_contents,$arr_push);
					}
                }
               // array_push($attr_contents, $arr_push);
			   foreach ($result as $va) {
					foreach ($attr_contents as $kb => $vb) {
						if (chop($va['name'] == chop($vb['name']))) {
							$attr_contents[$kb]['img_id']     = $va['img_id'];
							$attr_contents[$kb]['img_name']   = $va['img_name'];
						}
					}
				}
		
                $data_update = [
                    "contents" => json_encode($attr_contents, JSON_UNESCAPED_UNICODE )
                ];
				
                $this->pdo->update('taxonomy', $data_update, "id=".$id);
                lib_redirect("?mod=keyword&site=category");
            }
        }else {
            lib_redirect("?mod=product&site=list_attribute");
        }
        $this->smarty->assign('result', $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

	function keyword_category_img(){
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        if ($id != 0) {
            $contents = $this->pdo->fetch_one("SELECT contents FROM taxonomy WHERE id =$id");
            $result = json_decode($contents['contents'], true);
            $folder = URL_UPLOAD."keywords/";
            if(isset($_POST['submit'])){
                $lenght_attribute = $_POST['lenght_attribute'];
                $attr_contents = [];
                for ($i=0; $i < $lenght_attribute; $i++) {
                    $attr_name = $_POST["name_$i"];
					$str_fileName = "fileName_".$i;
					$str_imgName = "imgName_".$i;
					$attr_imgName = $_POST[$str_imgName];
					 // upload img
					 if ($_FILES[$str_fileName]['error'] == 0) {
						$img_name = $this->img->upload("keywords/", $_FILES[$str_fileName], 75);
						//$img_name = $this->img->upload_image_base64_v1("keywords/", $_FILES[$str_fileName],$str_imgName,75);
						$data_img = [
							'name' => $img_name,
						];
						$lastInsertId = $this->pdo->insert('keywordimages', $data_img);
						$arr_push = [
							'name'      => chop($attr_name),
							'img_id'    => $lastInsertId,
							'img_name'  => $img_name
						];
					}else {
						if ($attr_imgName != '') {
							$arr_push = [
								'name'      => chop($attr_name),
								'img_id'    => '',
								'img_name'  => $attr_imgName
							];
						}else {
							$arr_push = [
								'name'      => chop($attr_name),
								'img_id'    => '',
								'img_name'  => ''
							];
						}
						
					}
					array_push($attr_contents, $arr_push);
                }
                $data_update = [
                    "contents" => json_encode($attr_contents, JSON_UNESCAPED_UNICODE )
                ];
				
                $this->pdo->update('taxonomy', $data_update, "id=".$id);
                lib_redirect("?mod=keyword&site=keyword_category_img&id=$id");
            }
        }else {
            lib_redirect("?mod=keyword&site=keyword_category_img&id=$id");
        }
        
        $this->smarty->assign('result', $result);
        $this->smarty->assign('folder', $folder);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
	/** =========================================================================== */

	function ajax_delete() {
		$id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
		$rt = [];
		$rt['code'] = 0;
		$rt['msg'] = "Không xóa được nội dung";
		if($this->pdo->check_exist("SELECT 1 FROM keywords WHERE id=$id")){
			$this->pdo->query("DELETE FROM keywords WHERE id=$id");
			$rt['code'] = 1;
			$rt['msg'] = "Xóa thành công.";
		}
		
		echo json_encode($rt);
	}

	
	function ajax_delete_history() {
	    $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
	    $rt['code'] = 0;
	    $rt['msg'] = "Không xóa được nội dung";
	    if($this->pdo->check_exist("SELECT 1 FROM keyhistory WHERE id=$id")){
	        $this->pdo->query("DELETE FROM keyhistory WHERE id=$id");
	        $rt['code'] = 1;
	        $rt['msg'] = "Xóa thành công.";
	    }
	    
	    echo json_encode($rt);
	}
	
	
	function ajax_export_keywords(){
	    $keywords = $this->pdo->fetch_array_field('keywords', 'name', "status=1");
	    $categoris = $this->pdo->fetch_array_field('taxonomy', 'name', "status=1 AND type='product'");
	    $keywords += $categoris;
	    $keywords = array_unique($keywords);
	    lib_dump($keywords);
	    
	    $fp = fopen(FILE_KEYWORDS, 'w');
	    fwrite($fp, json_encode($keywords));
	    fclose($fp);

		$sql = "SELECT id,name,score FROM keywords WHERE status=1 AND featured=1 ORDER BY created DESC LIMIT 0,10";
        $db = $this->pdo->fetch_all ($sql);
		foreach ($db as $k => $item) {
            $result = $this->pdo->fetch_one("SELECT a.id,a.name,a.page_id,a.images
    				FROM products a
    				WHERE a.status=1 AND a.images<>'' AND a.name LIKE '%".$item['name']."%' LIMIT 1");
			$result['a_img'] = $this->product->get_images($result['images'], $result['page_id']);
			$db[$k]['avatar'] = $result['a_img'][0];
			$data['avatar'] = $result['a_img'][0];
			$this->pdo->update('keywords', $data, "id=".$item['id']);
		}
		$db = $this->help->array_sort($db,'score',SORT_DESC);
        file_put_contents(FILE_KEYWORD_TREND, json_encode($db));
	}

	function ajax_update_image_keywords(){
		$key =  isset($_POST['key']) ? $_POST['key'] : '';
		$page = isset($_POST['page']) ? $_POST['page'] : 1;
		$where_k = "status=1 AND image ='' AND name LIKE '%".$key."%'";
		$sql_k = "SELECT id,name FROM keywords WHERE $where_k";
		$paging = new \Lib\Core\Pagination($this->pdo->count_item('keywords',$where_k), 20);
		$sql_k = $paging->get_sql_limit($sql_k);
	
        $db = $this->pdo->fetch_all ($sql_k);
		foreach ($db as $k => $item) {
			$where = "1=1";
			$sql = "SELECT a.product_id AS id,a.name,a.page_id,a.images,
					CASE WHEN a.name='".$item['name']."' THEN 5 
                    WHEN a.name LIKE '".$item['name']." %' THEN 3
                    WHEN a.name LIKE '".$item['name']."%' THEN 1
                    WHEN a.name LIKE '% ".$item['name']." %' THEN 1
                    WHEN a.name LIKE '%".$item['name']."%' THEN 1
                    ELSE 0 END AS S1";
                $a_key = explode(' ', $item['name']);
                $c_key = count($a_key);
                if($c_key>=3 && $c_key<=4){
                    $new_a_key = [];
                    for($i=0; $i<=($c_key-2); $i++){
                        $new_a_key[] = $a_key[$i].' '.$a_key[$i+1];
                    }
                    foreach ($new_a_key AS $k=>$v){
                        if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS FG";
                        $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS XG".$k;
                    }
                }
                if($c_key>=4 && $c_key<=8){
                    $new_a_key_3c = [];
                    for($i=0; $i<=($c_key-3); $i++){
                        $new_a_key_3c[] = $a_key[$i].' '.$a_key[$i+1].' '.$a_key[$i+2];
                    }
                    foreach ($new_a_key_3c AS $k=>$v){
                        if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS F3C";
                        $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X3C".$k;
                    }
                    
                }
                if($c_key>1 && $c_key<=8){
                    foreach ($a_key AS $k=>$v){
                        if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 0.5 ELSE 0 END AS F";
                        $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1 WHEN a.name LIKE '% $v %' THEN 1 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X".$k;
                    }
                }
			$sql .= " FROM productsearch a WHERE ".$where;
			$values = "(S1";
			if($c_key>1 && $c_key<=8){
				$values .= "+F";
				foreach ($a_key AS $k=>$v){
					$values .= "+X".$k;
				}
			}
			if($c_key>=3 && $c_key<=4){
				$values .= "+FG";
				foreach ($new_a_key AS $k=>$v){
					$values .= "+XG".$k;
				}
			}
			$values .= ")";
			
			$sql .= " ORDER BY S1 DESC,$values DESC LIMIT 1";

            $result = $this->pdo->fetch_one($sql);
			$result['a_img'] = $this->product->get_images($result['images'], $result['page_id']);
			$data['image'] = $result['a_img'][0];
			$this->pdo->update('keywords', $data, "id=".$item['id']);
		}
	}
	function ajax_handle(){
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_taxonomy_multi_keyword'){
            $ids = isset($_POST['ids'])?$_POST['ids']:[];
            $taxonomy_id = isset($_POST['taxonomy_id'])?$_POST['taxonomy_id']:0;
            $rt = 0;
			//if($taxonomy_id!=0 && count($ids)>0)
            if(count($ids)>0){
                $data = [];
                $data['taxonomy_id'] = $taxonomy_id;
                $this->pdo->update('keywords', $data, "id IN (".implode(',', $ids).")");
                $rt = 1;
            }
            echo $rt; exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_image_attribute'){
            $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
            $imgName    = $_POST['imgName'];
            $imgID      = $_POST['imgID'];
            if($imgName != null || $imgName != ''){
                if(is_file(DIR_UPLOAD ."keywords/". $imgName)){
                    @unlink(DIR_UPLOAD ."keywords/". $imgName);
                }
            }
            $this->pdo->query("DELETE FROM taxonomy WHERE id=$imgID");
            echo true;
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_avatar'){
            $where_k = "1=1 AND id IN (".implode(',', $_POST['ids']).")";
            $sql_k = "SELECT id,name FROM keywords WHERE $where_k";
            
            $db = $this->pdo->fetch_all ($sql_k);
            foreach ($db as $item) {
                $sql = $this->product->get_sql_productsearch($item['name']);
                $sql .= " LIMIT 1";
                if($result = $this->pdo->fetch_one($sql)){
                    $result['a_img'] = $this->product->get_images($result['images'], $result['page_id']);
                    $data = [];
                    $data['image'] = $result['a_img'][0];
                    $this->pdo->update('keywords', $data, "id=".$item['id']);
                }
            }
        }
	}

	function top_product() {

		if (isset($_POST['ajax_action'])) {
			$action = $_POST['ajax_action'];

			if ($action == 'list_product') {
				// $this->smarty->display(SITE_ROOT. '/view/keyword/top_product_list.tpl');

				$sql = "SELECT k_p.id, p.page_id, p.name, p.images
					FROM keyproducts k_p INNER JOIN products p ON p.id = k_p.product_id
					LIMIT 20";

				$products = $this->pdo->fetch_all($sql);

				foreach ($products as $k => $item) {
					$a_img = $this->product->get_images($item['images'], $item['page_id']);
					$products[$k]['avatar'] = @$a_img[0];
				}
				echo json_encode($products);
			}

			elseif ($action == 'load_pages') {
				$sql = "SELECT id, name FROM pages WHERE is_verification=1 ORDER BY id ASC";
				$pages = $this->pdo->fetch_all($sql);
				echo json_encode($pages);
			}

			elseif ($action == 'load_products') {
				$page_id = isset($_POST['page_id'])? intval($_POST['page_id']): 0;
				$sql = "SELECT id, name FROM products WHERE page_id=".$page_id." ORDER BY id DESC";
				$products = $this->pdo->fetch_all($sql);
				echo json_encode($products);
			}

			elseif ($action == 'add_product') {
				$data = [
					// 'name' => '',
					'page_id' => $_POST['page_id'],
					'product_id' => $_POST['product_id'],
				];
	
				$id = $this->pdo->insert('keyproducts', $data);
				echo $id;
			}

			exit();
		}

		$this->smarty->display(LAYOUT_DEFAULT);
	}

}
