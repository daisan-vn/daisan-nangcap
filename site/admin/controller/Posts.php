<?php

# ================================ #
# Module for Posts management
# ================================ #

class Posts extends Admin {
	private $image_type;
	function __construct() {
		parent::__construct();
		$this->folder = 'images/nations/';

		$this->image_type = array(
				'image' => "Quảng cáo hình ảnh",
				'adsense' => "Quảng cáo Adsense"
		);
	}
	function index() {
	    global $lang;
	    $out = [];
	    $type= isset($_GET['type']) ? $_GET['type'] : "post";
	    if(!isset($this->posts->type[$type])) lib_redirect_back();
	    $status= isset($_GET['status']) ? $_GET['status'] : "";
	    $position= isset($_GET['position']) ? $_GET['position'] : "";
	    $type_taxonomy = "category";
	    if(in_array($type, ['project','support'])) $type_taxonomy = $type;
	    
	    $out['filter_status']= $this->help->get_select_from_array($this->posts->status,$status);
	    $out['filter_position'] = $this->help->get_select_from_array($this->posts->position, $position, "Chọn vị trí hiển thị");
	    $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
	    $out['filter_category'] = $this->taxonomy->get_select_taxonomy($type_taxonomy, isset($_GET['cat']) ? $_GET['cat'] : 0);
	    $out['Title'] = @$this->posts->type[$type];
	    $out['type'] = $type;
	    $out['url_create'] = "?mod=posts&site=create&type=$type";
	    

	    $where = "a.lang='$lang' AND a.type='$type'";
	    if($position != "") $where.=" AND a.position = '$position'";
	    if($status != "") $where.=" AND a.status = $status";
	    if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND a.title LIKE '%".$_GET['key']."%'";
	    if(isset($_GET['cat']) && intval($_GET['cat']) != 0){
	        $taxArrId = $this->taxonomy->get_array_sub_id("category", $_GET['cat']);
	        $where .= " AND a.post_id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id IN (".implode(",", $taxArrId)."))";
	    }
	    $sql = "SELECT a.id,a.title,a.alias,a.featured,a.created,a.sort,a.status,a.position,a.type,a.media_id,
        		(SELECT GROUP_CONCAT(c.name) FROM taxonomy c WHERE c.type='$type_taxonomy'
        			AND c.id IN (SELECT r.taxonomy_id FROM taxonomyrls r WHERE r.post_id=a.id)) AS categories
				FROM posts a WHERE $where ORDER BY id DESC";
	    $paging = new \Lib\Core\Pagination($this->pdo->count_item('posts', $where), 20);
	    $sql = $paging->get_sql_limit($sql);
	    $stmt = $this->pdo->getPDO()->prepare($sql);
	    $stmt->execute();
	    $result = [];
	    while ($item = $stmt->fetch()) {
	        $item ['status'] = $this->help_get_status($item ['status'], 'posts', $item['id']);
	        $item ["featured"] = $this->help_get_featured($item['featured'], 'posts', $item['id']);
	        $item ['position'] = @$this->posts->post_position[$item['position']];
	        $item ['avatar'] = $this->media->get_image_byid($item['media_id'], 1);
	        $item ['url_edit'] = "?mod=posts&site=create&type=$type&postId=".$item['id'];
			$item['url'] = URL_BLOG . $item['alias'] . ".htm";
	        $result [] = $item;
	    }
	    $this->smarty->assign("result", $result);
	    
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	function create() {
		global $login, $lang;
		$type= isset($_GET['type']) ? $_GET['type'] : "post";
		if(!isset($this->posts->type[$type])) lib_redirect_back();
		$out = [];
		$out['type'] = $type;
		$out['Title'] = 'Thêm mới ' . @$this->posts->type[$type];
		$post_id = isset($_GET['postId']) ? intval($_GET['postId']) : 0;
		$post = $this->pdo->fetch_one("SELECT * FROM posts WHERE id=$post_id");
		$album = [];
		$arr_media_id = [];
		if($post){
		    $rls = $this->pdo->fetch_one("SELECT GROUP_CONCAT(taxonomy_id) AS taxonomy FROM taxonomyrls WHERE type='post' AND post_id=".$post['id']);
		    $tags = $this->pdo->fetch_one("SELECT GROUP_CONCAT(taxonomy_id) AS taxonomy FROM taxonomyrls WHERE type='tag' AND post_id=".$post['id']);
		    $out['Title'] = 'Chỉnh sửa ' . @$this->posts->type[$type];
		    if($type=='album'){
		        $stmt = $this->pdo->getPDO()->prepare("SELECT meta_value FROM postmetas WHERE meta_key='_images' AND post_id=$post_id");
		        $stmt->execute();
		        while ($item = $stmt->fetch()) {
		            $arr = explode(";", $item['meta_value']);
		            $item['media_id'] = @$arr[0];
		            $item['image_name'] = @$arr[1];
		            $item['image'] = $this->img->get_image(@$arr[1]);
		            $album[] = $item;
		            $arr_media_id[] = @$arr[0];
		        }
		    }
			$this->smarty->assign('view_url', URL_BLOG . $post['alias'] . ".htm");
		}
		
		$post['listImage'] = implode("-", $arr_media_id);
		$post['avatar'] = $this->media->get_image_byid(@$post['media_id']);
		
		$out['select_parent'] = $this->taxonomy->get_select_taxonomy('category');
		$out['select_media_folder'] = $this->taxonomy->get_select_taxonomy('folder', 0, 0, null, null, 0);
		$out['select_position'] = $this->help->get_select_from_array($this->posts->position, @$post['position'], "Chọn vị trí hiển thị");
		$type_taxonomy = "category";
		if(in_array($type, ['project','support'])) $type_taxonomy = $type;
		
		$out['checkbox_taxonomy'] = $this->taxonomy->get_checkbox_taxonomy($type_taxonomy, isset($rls)?explode(",", $rls['taxonomy']):[]);
		$out['tags'] = $this->taxonomy->get_select_taxonomy('tag', isset($tags)?$tags['taxonomy']:0, 0, null, 0);
		$this->smarty->assign('post', $post);
		$this->smarty->assign('album', $album);
		if (isset($_POST['submit'])) {
		    $data = [];
		    $data['title'] = $this->string->del_danger(trim($_POST['title']));
		    $data['content'] = trim(@$_POST['content']);
		    $data['description'] = trim($_POST['description']);
		    $data['keyword'] = trim($_POST['keyword']);
		    $data['alias'] = $this->posts->check_alias('post',$_POST['alias'], @$post_id);
			$data['media_id'] = intval($_POST['media_id']);
			
		    $data['avatar_status'] = isset($_POST['avatar_status']) ? 1 : 0;
		    $data['position'] = $_POST['position'];
		   // $data['date_public'] = $_POST['date_public']==''?null:date("Y-m-d", strtotime($_POST['date_public']));
		  //  $data['date_expire'] = $_POST['date_expire']==''?null:date("Y-m-d", strtotime($_POST['date_expire']));
		    $data['updated'] = time();
		    $data['featured'] = isset($_POST['featured']) ? 1 : 0;
		    $data['status'] = isset($_POST['status']) ? 1 : 0;
		    if($type=='video'){
		        $exp_content = explode("?v=", $data['content']);
		        $data['code'] = @$exp_content[1];
		        unset($exp_content);
		    }
		    if($post_id==0){
		        $data['user_id'] = $login;
		        $data['type'] = $type;
		        $data['views'] = 1;
		        $data['lang'] = $lang;
		        $data['created'] = time();
		        $newId = $this->pdo->insert("posts", $data);
		    }else{
		        $this->pdo->update("posts", $data, "id=$post_id");
		        $newId = $post_id;
		    }
		    unset($data);
		    
		    if(intval($newId)!=0 && $type=='album'){
		        $this->pdo->query("DELETE FROM postmeta WHERE post_id=$newId AND meta_key='_images'");
		        $image_list = explode("-", $_POST['image_list']);
		        foreach ($image_list AS $item){
		            $media = $this->pdo->fetch_one("SELECT CONCAT(t.alias, '/', a.media_name) AS image FROM media a
            				LEFT JOIN taxonomy t ON t.taxonomy_id=a.taxonomy_id
            				WHERE a.media_id=$item");
		            if($media){
		                $data['meta_key'] = "_images";
		                $data['post_id'] = $newId;
		                $data['meta_value'] = $item . ";" . $media['image'];
		                $this->pdo->insert('postmetas', $data);
		                unset($data);
		            }
		        }
		    }
		    $this->taxonomy->save_taxonomy_rls('post', @$_POST[$type_taxonomy], $newId);
		    $this->taxonomy->save_taxonomy_rls('tag', @$_POST['tags'], $newId);
		    lib_redirect("?mod=posts&site=create&type={$type}&postId={$post_id}");
		}
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
		/*
		if (isset($_POST['submit'])) {
			$data['title'] = $this->string->del_danger(trim($_POST['title']));
			$data['content'] = trim(@$_POST['content']);
			$data['description'] = trim($_POST['description']);
			$data['keyword'] = trim($_POST['keyword']);
			$data['alias'] = $this->posts->check_alias('post',$_POST['alias'], @$id);
			$data['media_id'] = intval($_POST['media_id']);
			$data['taxonomy_id'] = intval($_POST['taxonomy_id']);
			$data['position'] = $_POST['position'];
			$data['updated'] = time();
			$data['featured'] = isset($_POST['featured']) ? 1 : 0;
			$data['status'] = isset($_POST['status']) ? 1 : 0;
			if($id==0){
				$data['user_id'] = $login;
				$data['type'] = $type;
				$data['views'] = 1;
				$data['lang'] = $lang;
				$data['created'] = time();
				$newId = $this->pdo->insert("posts", $data);
			}else{
				$this->pdo->update("posts", $data, "id=$id");
				$newId = $id;
			}
			unset($data);
			lib_redirect("?mod=posts&site=index&type=$type");
		}
		
		$post = $this->pdo->fetch_one("SELECT * FROM posts WHERE id=$id");
		
		$arr_media_id = [];
		if($post){
			$out['Title'] = 'Chỉnh sửa ' . @$this->posts->type[$type];
		}
		$post['listImage'] = implode("-", $arr_media_id);
		$post['avatar'] = $this->media->get_image_byid(@$post['media_id']);
		
		$out['select_taxonomy'] = $this->taxonomy->get_select_taxonomy_tree('category', @$post['taxonomy_id']);
		$out['select_position'] = $this->help->get_select_from_array($this->posts->position, @$post['position'], "Chọn vị trí hiển thị");
		$this->smarty->assign('post', $post);
		
		$this->smarty->assign('out', $out);*/
		
	}
	function event() {
	    global $lang;
	    $out = [];
	    $type= isset($_GET['type']) ? $_GET['type'] : "post";
	    if(!isset($this->posts->type[$type])) lib_redirect_back();
	    $status= isset($_GET['status']) ? $_GET['status'] : "";
	    $position= isset($_GET['position']) ? $_GET['position'] : "";
	    $out['filter_status']= $this->help->get_select_from_array($this->posts->status,$status);
	    $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
	    $out['Title'] = @$this->posts->type[$type];
	    $out['type'] = $type;
	    $out['url_create'] = "?mod=posts&site=event_create";
	    
	    $where = "a.lang='$lang' AND a.type='event'";
	    if($position != "") $where.=" AND a.position = '$position'";
	    if($status != "") $where.=" AND a.status = $status";
	    if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND a.title LIKE '%".$_GET['key']."%'";
	    if(isset($_GET['cat']) && intval($_GET['cat']) != 0){
	        $taxArrId = $this->taxonomy->get_all_category_id($_GET['cat']);
	        $where .= " AND a.taxonomy_id IN (".implode(",", $taxArrId).")";
	    }
	    
	    $sql = "SELECT a.id,a.title,a.featured,a.created,a.sort,a.status,a.position,a.type,a.avatar,
				(SELECT t.Name FROM locations t WHERE t.id=a.taxonomy_id) AS category
				FROM posts a WHERE $where ORDER BY a.sort ASC, a.id DESC";
	    $paging = new \Lib\Core\Pagination($this->pdo->count_item('posts', $where), 20);
	    $sql = $paging->get_sql_limit($sql);
	    $stmt = $this->pdo->getPDO()->prepare($sql);
	    $stmt->execute();
	    $result = [];
	    while ($item = $stmt->fetch()) {
	        $item ['status'] = $this->help_get_status($item ['status'], 'posts', $item['id']);
	        $item ["featured"] = $this->help_get_featured($item['featured'], 'posts', $item['id']);
	        $item ['position'] = @$this->posts->post_position[$item['position']];
	        $item ['avatar'] = $this->img->get_image('events/', $item['avatar']);
	        $item ['url_edit'] = "?mod=posts&site=event_create&postId=".$item['id'];
	        $result [] = $item;
	    }
	    $this->smarty->assign("result", $result);
	    
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	function event_detail(){
	    global $login;
	    $out = [];
	    $post_id = isset($_GET['post_id'])?intval($_GET['post_id']):0;
	    $key = isset($_GET['key'])?trim($_GET['key']):'';
	    $value = $this->pdo->fetch_one("SELECT * FROM posts WHERE id=$post_id AND type='event'");
	    $value ['avatar'] = $this->img->get_image('events/', $value['avatar']);
	    $this->smarty->assign('value',$value);
	    
	    if(isset($_POST['action']) && $_POST['action']=='load_page'){
	        $post_id = intval(@$_POST['post_id']);
	        $result = $this->pdo->fetch_one("SELECT * FROM eventpages WHERE post_id=$post_id");
	        $pages = $this->pdo->fetch_all("SELECT a.id,a.name FROM pages a WHERE a.status=1 AND a.id NOT IN (SELECT b.page_id FROM eventpages b WHERE b.post_id=$post_id)"); 
	        $a_page = [];
	        foreach ($pages AS $item){
	            $a_page[$item['id']] = $item['name'];
	        }
	        $result['select_page'] = $this->help->get_select_from_array($a_page, @$result['page_id']);
	        echo json_encode($result);
	        exit();
	    }elseif(isset($_POST['action']) && $_POST['action']=='save_page'){
	        $rt = [];
	        $rt['code'] = 0;
	        $data = [];
            $data['page_id'] = $_POST['page_id'];
            $data['post_id'] = trim(@$_POST['post_id']);
            $data['user_id'] = $login;
            $data['created'] = time();
            if($this->pdo->insert('eventpages', $data)){
                $rt['code']=1;
                $rt['msg'] = 'Add pages success';
            };
            echo json_encode($rt);
            exit();
	    }
	    $count_product = $this->pdo->fetch_all("SELECT page_id,COUNT(1) AS number FROM products GROUP BY page_id");
	    $a_count = [];
	    foreach ($count_product AS $item){
	        $a_count[$item['page_id']] = $item['number'];
	    }
	    
	    $count_product_active = $this->pdo->fetch_all("SELECT page_id,COUNT(1) AS number FROM products WHERE status=1 GROUP BY page_id");
	    $a_count_active = [];
	    foreach ($count_product_active AS $item){
	        $a_count_active[$item['page_id']] = $item['number'];
	    }
	    
	    $where = "1=1 AND a.post_id=$post_id ";
	    if($key!=null) $where .= " AND (b.name LIKE '%".$_GET['key']."%' OR b.id LIKE '%".$_GET['key']."%')";
	    $sql = "SELECT a.*,b.id AS page_id,b.name,b.address,b.website,b.logo,b.page_name,b.created,b.featured,b.status,b.package_end,b.score_ads,b.nation_id,
                (SELECT n.Image FROM nations n WHERE n.Id=b.nation_id) AS nation_img
                FROM eventpages a LEFT JOIN pages b ON a.page_id=b.id
                WHERE $where ORDER BY a.created DESC";
	    $paging = new \Lib\Core\Pagination($this->pdo->count_item('eventpages', $where), 20);
	    $sql = $paging->get_sql_limit($sql);
	    $stmt = $this->pdo->getPDO()->prepare($sql);
	    $stmt->execute();
	    $result = [];
	    while ($item = $stmt->fetch()) {
	        $item ['logo'] = $this->img->get_image($this->page->get_folder_img($item['page_id']), $item['logo']);
	        $item ['nation_logo'] = (@$item['nation_id']==0)?($this->img->get_image($this->folder, '1538472307_9afdb01339ef137ea2f3fb1aa64a9024.png')):($this->img->get_image($this->folder, @$item['nation_img']));
	        $item ['url'] = $this->page->get_pageurl($item['page_id'], $item['page_name']);
	        $item ['status'] = $this->help_get_status($item ['status'], 'pages', $item['id']);
	        $item ['products'] = intval(@$a_count[$item['page_id']]);
	        $item ['products_active'] = intval(@$a_count_active[$item['page_id']]);
	        $result [] = $item;
	    }
	    $this->smarty->assign("result", $result);
	    $this->smarty->assign("number",$this->pdo->count_item('eventpages', $where));
	    
	    $out['key'] = $key;
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	function event_create() {
	    global $login, $lang;
	    $out = [];
	    $id = isset($_GET['postId']) ? intval($_GET['postId']) : 0;
	    if (isset($_POST['submit'])) {
	        $data = [];
	        $data['title'] = trim($_POST['title']);
	        $data['content'] = trim(@$_POST['content']);
	        $data['description'] = trim($_POST['description']);
	        $data['keyword'] = trim($_POST['keyword']);
	        $data['taxonomy_id'] = intval($_POST['taxonomy_id']);
	        $data['updated'] = time();
	        $data['featured'] = isset($_POST['featured']) ? 1 : 0;
	        $data['status'] = isset($_POST['status']) ? 1 : 0;
	        $data['time_start'] = date('Y-m-d H:i:s', strtotime($_POST['start_time'].' '.$_POST['start_date']));
	        $data['time_finish'] = date('Y-m-d H:i:s', strtotime($_POST['finish_time'].' '.$_POST['finish_date']));
	        if($id==0){
	            $data['user_id'] = $login;
	            $data['type'] = 'event';
	            $data['views'] = 1;
	            $data['lang'] = $lang;
	            $data['created'] = time();
	            $id = $this->pdo->insert("posts", $data);
	        }else{
	            $this->pdo->update("posts", $data, "id=$id");
	        }
	        unset($data);
	        
	        if(@$_POST['avatar']!='' || @$_POST['banner']!=''){
	            $post = $this->pdo->fetch_one("SELECT metas,avatar FROM posts WHERE id=$id");
	            $data = [];
	            if(@$_POST['avatar']!=''){
	                $data['avatar'] = $this->img->upload_image_base64('events/', @$_POST['avatar'], null, 600, 2);
	                @unlink(DIR_UPLOAD.'events/'.$post['avatar']);
	            }
	            if(@$_POST['banner']!=''){
	                $metas = json_decode(@$post['metas'], true);
	                @unlink(DIR_UPLOAD.'events/'.@$metas['banner']);
	                $metas['banner'] = $this->img->upload_image_base64('events/', @$_POST['banner'], null, 1500, 5);
	                $data['metas'] = json_encode($metas);
	            }
	            $this->pdo->update('posts', $data, 'id='.$id);
	        }
	        
	        lib_redirect("?mod=posts&site=event");
	    }
	    
	    $post = $this->pdo->fetch_one("SELECT * FROM posts WHERE id=$id");
	    $metas = json_decode($post['metas'], true);
	    $post['avatar'] = $this->img->get_image('events/', $post['avatar']);
	    $post['banner'] = $this->img->get_image('events/', @$metas['banner']);
	    
	    $out['select_taxonomy'] = $this->help->get_select_location(@$post['taxonomy_id'],0,'Chọn tỉnh thành');
	    $out['select_position'] = $this->help->get_select_from_array($this->posts->position, @$post['position'], "Chọn vị trí hiển thị");
	    $this->smarty->assign('post', $post);
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	
	function images() {
	    global $lang, $location;
	    $out = [];
	    $a_category = $this->media->a_category;
	    $a_position = array( 0=>"Chọn vị trí", 1 => "Position 1", 2 => "Position 2", 3=>"Position 3" );
	    $a_display = array( 0=>"Chọn trang hiển thị", 1 => "Home", 2 => "DaisanMall", 3=>"Evietbuild", 4=>"Blog" );
	    
	    if(isset($_POST['ajax']) && $_POST['ajax']=='save_image'){
	        $rt = [];
	        $rt['msg'] = 0;
	        $data = [];
	        $data['taxonomy_id'] = $_POST['taxonomy_id'];
	        $data['media_id'] = $_POST['media_id'];
	        $data['type'] = 'image';
	        $data['province_id']=$location;
	        $data['created'] = time();
	        $data['updated'] = time();
	        $data['lang'] = $lang;
	        $data['sort'] = 1;
	        $data['status'] = 1;
	        if($this->pdo->check_exist("SELECT id FROM posts
    				WHERE type='image' AND lang='$lang' AND taxonomy_id=".$_POST['taxonomy_id']." AND media_id='".$data['media_id']."'")){
    				$rt['msg'] = 1;
    				echo json_encode($rt); exit();
	        }
	        if($ins_id = $this->pdo->insert("posts", $data)){
// 	            $tax = $this->pdo->fetch_one("SELECT name FROM taxonomy WHERE taxonomy_id=".$_POST['taxonomy_id']);
	            $str = "";
	            $str .= "<tr id=\"field$ins_id\">";
	            $str .= "<td class=\"text-center\"><img class=\"imgrls\" src=\"".$this->media->get_image_byid($data['media_id'])."\" onclick=\"ViewImage('".$data['media_id']."');\"></td>";
	            $str .= "<td></td>";
	            $str .= "<td>".$a_category[$_POST['taxonomy_id']]."</td>";
	            $str .= "<td></td>";
	            $str .= "<td class=\"text-left\"><input class=\"form-control sort_input\" type=\"number\" name=\"sort\" value=\"1\" min=\"0\" max=\"9999\" oninput=\"sortItem('posts', $ins_id, this.value);\" /></td>";
	            $str .= "<td class=\"text-center\" id=\"stt$ins_id\">".$this->help_get_status(1, 'posts', $ins_id)."</td>";
	            $str .= "<td class=\"text-right\"><button type=\"button\" class=\"btn btn-default btn-xs\" onclick=\"LoadFormImage($ins_id);\"><i class=\"fa fa-pencil fa-fw\"></i></button>";
	            $str .= "<button type=\"button\" class=\"btn btn-default btn-xs\" title=\"Xóa\" onclick=\"LoadDeleteItem('posts', $ins_id, 'ajax_delete');\"><i class=\"fa fa-trash fa-fw\"></i></button></td>";
	            $str .= "</tr>";
	            unset($data);
	            $rt['inserted'] = $str;
	            $rt['id'] = $ins_id;
	            echo json_encode($rt); exit();
	        }
	        echo 0; exit();
	    }else if(isset($_POST['ajax']) && $_POST['ajax']=='save_image_update'){
	        $data['media_id'] = $_POST['media_id'];
	        $this->pdo->update('posts', $data, "id=".$_POST['id']);
	        echo $this->media->get_image_byid($_POST['media_id']);
	        exit();
	    }else if(isset($_POST['ajax']) && $_POST['ajax']=='load_image'){
	        $post = $this->pdo->fetch_one("SELECT id,title,alias,description,position FROM posts WHERE id=".$_POST['id']);
	        $post['select_position'] = $this->help->get_select_from_array($a_position, @$post['position']);
	        echo json_encode($post);
	        exit();
	    }else if(isset($_POST['ajax']) && $_POST['ajax']=='update_image'){
	        $data['alias'] = trim($_POST['alias']);
	        $data['title'] = trim($_POST['title']);
	        $data['description'] = trim($_POST['description']);
	        $data['position'] = intval($_POST['position']);
	        $this->pdo->update("posts", $data, "id=".$_POST['id']);
	        echo 1; exit();
	    }else if(isset($_POST['ajax']) && $_POST['ajax']=='show_image'){
	        echo $this->img->get_image($_POST['image'], 1);
	        exit();
	    }
	    
	    $out['a_category'] = $a_category;
	    $out['filter_category'] = $this->help->get_select_from_array($a_category, isset($_GET['cat']) ? $_GET['cat'] : 0, 'Chọn danh mục');
	    $out['filter_position'] = $this->help->get_select_from_array($a_position, isset($_GET['position']) ? $_GET['position'] : 0);
	    $out['filter_display'] = $this->help->get_select_from_array($a_display, isset($_GET['display']) ? $_GET['display'] : 0);
	    $out['select_media_folder'] = $this->taxonomy->get_select_taxonomy('folder', 0, 0, null, null, 0);
// 	    $categories = $this->pdo->fetch_one("SELECT GROUP_CONCAT(taxonomy_id) AS ids FROM taxonomy WHERE type='image' AND status=1");
	    
	    $sql = "SELECT id,title,sort,status,position,alias,featured,media_id,taxonomy_id
                FROM posts WHERE type='image' AND lang='$lang' AND province_id=$location";
	    if (isset($_GET['cat']) && intval($_GET['cat']) != 0) $sql .= " AND taxonomy_id=".$_GET['cat'];
	    if (isset($_GET['position']) && intval($_GET['position']) != 0) $sql .= " AND position=".$_GET['position'];
        $sql .= " ORDER BY taxonomy_id,sort, id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $item ['status'] = $this->help_get_status($item ['status'], 'posts', $item['id']);
            $item ["featured"] = $this->help_get_featured($item['featured'], 'posts', $item['id']);
            $item ['position'] = @$this->posts->image_position[$item['position']];
            $item ['avatar'] = $item ['avatar'] = $this->media->get_image_byid($item['media_id'], 1);
            $item['taxonomy'] = $a_category[$item['taxonomy_id']];
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        if (isset($_POST['submit_comment'])) {
            $data['media_title'] = trim(preg_replace("/[\\'\"`{}]/", "", $_POST['post_title']));
            $data['description'] = $_POST['post_description'];
            $data['position'] = $_POST['position'];
            $data['updated'] = time();
            $this->pdo->update('vsc_media', $data, "media_id=".$_POST['id']);
            lib_redirect("?mod=image&site=index");
        }
        
        $cate_select = $this->pdo->fetch_all("SELECT taxonomy_id, name FROM taxonomy WHERE type='image' AND status=1");
        $this->smarty->assign('cate_select', $cate_select);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
	}
	

	function detail(){
		$PostId = isset($_GET['Id']) ? intval($_GET['Id']) : 0;
		$post = $this->pdo->fetch_one("SELECT a.*,
				(SELECT name FROM vsc_users WHERE a.user_id=user_id) AS username,
				(SELECT GROUP_CONCAT(c.name) FROM taxonomy c WHERE c.type='category'
				AND c.taxonomy_id IN (SELECT r.taxonomy_id FROM taxonomyrls r WHERE r.id=a.id)) AS categories
				FROM posts a WHERE a.id=$PostId");
		$post['avatar'] = $this->img->get_image(@$post['image'], 1);
		 
		$this->smarty->assign('post', $post);
		$this->smarty->display("none.tpl");
	}



	/** =========================================================================== */
	function ajax_delete_page() {
	    $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
	    $data = [];
	    $data['code'] = 1;
	    $data['msg'] = "Xóa thành công";
	    $this->pdo->query("DELETE FROM eventpages WHERE id=$id");
	    echo json_encode($data);
	    exit();
	}
	
	
	function ajax_delete() {
		$id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
		$data = [];
		$data['code'] = 1;
		$data['msg'] = "Xóa thành công";
		$this->pdo->query("DELETE FROM posts WHERE id=$id");
		echo json_encode($data);
		exit();
	}

	function ajax_bulk_delete() {
		$id = isset($_POST ['id']) ? $_POST ['id'] : 0;
		if($id == 0) lib_redirect_back();

		$input_arr = explode(',', $id);
		$deleted_arr = [];
		$notdeleted_arr = [];
		$deleted_id = [];

		foreach ($input_arr as $v) {
			$check_parent = $this->pdo->check_exist("SELECT comment_id FROM vsc_comments WHERE id=$v");
			$value = $this->pdo->fetch_one("SELECT id,title FROM posts WHERE id=$v");
			if (!$check_parent) {
				array_push($deleted_arr, $value['title']);
				array_push($deleted_id, $value['id']);
				$this->pdo->query("DELETE FROM posts WHERE id=$v");
				$this->pdo->query("DELETE FROM vsc_taxonomyrls WHERE id=$v");
				$this->pdo->query("DELETE FROM vsc_postmeta WHERE id=$v");
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

		$data = [];
		$data['deleted'] = implode('<br>', $deleted_arr);
		$data['notdeleted'] = implode('<br>', $notdeleted_arr);
		$data['deleted_id'] = implode('-', $deleted_id);

		echo json_encode($data);
	}
}
