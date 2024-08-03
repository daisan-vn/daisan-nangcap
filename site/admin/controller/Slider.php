<?php
class Slider extends Admin{
    function __construct() {
		parent::__construct();	
    }
    function index() {
	    global $login, $lang;
        $out = [];
        $out['key'] = isset($_GET['key']) ? $_GET['key'] : '';
        $where = "a.parent=0 AND a.type='product' AND a.lang='$lang' AND a.status=1";
        if($out['key']!='' && $out['key']!=null) 
			$where .= " AND (name LIKE '%".$out['key']."%')";
        $sql = "SELECT * FROM taxonomy a WHERE $where ORDER BY id DESC";
		$paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
		$sql = $paging->get_sql_limit($sql);
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		while ($item = $stmt->fetch()){
			$item['status'] = $this->help_get_status($item ['status'], 'users', $item['id']);
			$result[] = $item;
        }
        $this->smarty->assign('result', @$result);
        $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
    }
   
    function image(){
        global $login, $lang;
		$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
		$status= isset($_GET['status']) ? $_GET['status'] : -1;
		$type= isset($_GET['type']) ? $_GET['type'] : "slider";
		
		$a_position = array( 
			0=> "Chọn vị trí",
			1 => "Trang chủ",
			2 => "Trang danh mục",
		);
        $a_type = array (
		    'slider' => 'Slider',
		    'banner' => 'Banner',
		);
      
		$out = [];
		$out['filter_status']= $this->help->get_select_from_array($this->page->status, $status, 'Trạng thái');
		$out['filter_type']= $this->help->get_select_from_array($a_type, $type);
		$out['filter_category'] = $this->taxonomy->get_select_taxonomy('product', $id, 0);
		$category = $this->pdo->fetch_one("SELECT id,name FROM taxonomy WHERE id = $id");
        $out['category'] = $category;
       
        if(isset($_POST['ajax']) && $_POST['ajax']=='save_image'){
	        $rt['msg'] = 0;
	        $data['taxonomy_id'] = $_POST['taxonomy_id'];
	        $data['media_id'] = $_POST['media_id'];
	        $data['created'] = time();
	        $data['updated'] = time();
	        $data['lang'] = $lang;
	        $data['sort'] = 1;
	        $data['status'] = 1;
	        if($this->pdo->check_exist("SELECT id FROM posts
    				WHERE type='slider' AND lang='$lang' AND taxonomy_id=".$_POST['taxonomy_id']." AND media_id='".$data['media_id']."'")){
    				$rt['msg'] = 1;
    				echo json_encode($rt); exit();
	        }
	        if($ins_id = $this->pdo->insert("posts", $data)){
	            $tax = $this->pdo->fetch_one("SELECT name FROM taxonomy WHERE taxonomy_id=".$_POST['taxonomy_id']);
	            $str = "";
	            $str .= "<tr id=\"field$ins_id\">";
	            $str .= "<td class=\"text-center\"><img class=\"imgrls\" src=\"".$this->media->get_image_byid($data['media_id'])."\" onclick=\"ViewImage('".$data['media_id']."');\"></td>";
	            $str .= "<td></td>";
	            $str .= "<td>fd</td>";
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
	        $post = $this->pdo->fetch_one("SELECT id,title,alias,description,position,type FROM posts WHERE id=".$_POST['id']);
			$post['select_position'] = $this->help->get_select_from_array($a_position, @$post['position']);
			$post['select_type'] = $this->help->get_select_from_array($a_type, @$post['type']);
	        echo json_encode($post);
	        exit();
	    }else if(isset($_POST['ajax']) && $_POST['ajax']=='update_image'){
	        $data['alias'] = trim($_POST['alias']);
	        $data['title'] = trim($_POST['title']);
	        $data['description'] = trim($_POST['description']);
			$data['position'] = intval($_POST['position']);
			$data['type'] = trim($_POST['type']);
	        $this->pdo->update("posts", $data, "id=".$_POST['id']);
	        echo 1; exit();
	    }else if(isset($_POST['ajax']) && $_POST['ajax']=='show_image'){
	        echo $this->img->get_image($_POST['image'], 1);
	        exit();
	    }
          
        $sql = "SELECT id,title,sort,status,position,alias,featured,media_id,taxonomy_id
                FROM posts WHERE 1=1 AND lang='$lang' AND type='$type'";
	    if (isset($_GET['id']) && intval($_GET['id']) != 0) $sql .= " AND taxonomy_id=".$_GET['id'];
		$sql .= " ORDER BY taxonomy_id,sort, id DESC";
	
        $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $item ['status'] = $this->help_get_status($item ['status'], 'posts', $item['id']);
			$item ['avatar'] = $item ['avatar'] = $this->media->get_image_byid($item['media_id'], 1);
			$item['position'] = $a_position[$item['position']];
            $item['taxonomy'] = $out['category']['name'];
            $result [] = $item;
		}
		
        $this->smarty->assign("result", $result);
        $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	
	function banners(){
		$a_position = array( 
			1 => "Toprank sản phẩm",
			2 => "Top sản phẩm mới",
			3 => "Top sản phẩm sẵn kho",
			4 => "Top sản phẩm khuyến mãi",
			5 => "Top nhà sản xuất",
			6 => "Top nhà cung cấp hàng đầu",
			7 => 'Banner trang search',
            8 => 'Banner trang nhập khẩu'
		);
		$metas = json_decode(@file_get_contents(FILE_CONF_CONTENT), true);
        if(!is_array($metas)) $metas = [];
        $profile = [];
        $out = [];
        $folder = $this->media->path_image;
        $out['folder'] = $folder;
        $out['a_slider_size'] = array(
            '8.3478' => '1920x230'
        );
        $out['a_ads_size'] = array(
            '8.3478' => '1920x230'
        );
        $out['position'] = $this->help->get_select_from_array($a_position,0,"Chọn vị trí");
        $out['img_slider_size'] = isset($metas['img_slider_size'])?$metas['img_slider_size']:3;
        $out['img_ads_size'] = isset($metas['img_ads_size'])?$metas['img_ads_size']:1;
        
        if(isset($metas['img_logo'])&&$metas['img_logo']!='')
            $profile['img_logo_show'] = $this->img->get_image($folder, @$metas['img_logo']);
            if(isset($metas['img_logo_mobile'])&&$metas['img_logo_mobile']!='')
                $profile['img_logo_mobile_show'] = $this->img->get_image($folder, @$metas['img_logo_mobile']);
                
                $sliders = (isset($metas['img_sliders'])&&$metas['img_sliders']!='') ?$metas['img_sliders']: [];
                $a_sliders=[];
                if(count($sliders)>0){
                    foreach($sliders as $key=>$value){
                        $a_sliders[$key]=$value['image'];
                    }
                }
                
                $a_sliders_show = [];
                for ($i=0; $i<4; $i++){
                    if(isset($a_sliders[$i]) && is_file(DIR_UPLOAD.$folder.$a_sliders[$i])){
                        $a_sliders_show[$i] = $this->img->get_image($folder, $a_sliders[$i]);
                    }else{
                        $a_sliders_show[$i] = NO_IMG;
                        unset($a_sliders[$i]);
                    }
                }
                $profile['img_sliders'] = implode(";", $a_sliders);
                
                $sliders_mobile = (isset($metas['img_sliders_mobile'])&&$metas['img_sliders_mobile']!='') ?$metas['img_sliders_mobile']: [];
                $a_sliders_mobile=[];
                if(count($sliders_mobile)>0){
                    foreach($sliders_mobile as $key=>$value){
                        $a_sliders_mobile[$key]=$value['image'];
                    }
                }
                $a_sliders_mobile_show = [];
                for ($i=0; $i<4; $i++){
                    if(isset($a_sliders_mobile[$i]) && is_file(DIR_UPLOAD.$folder.$a_sliders_mobile[$i])){
                        $a_sliders_mobile_show[$i] = $this->img->get_image($folder, $a_sliders_mobile[$i]);
                    }else{
                        $a_sliders_mobile_show[$i] = NO_IMG;
                        unset($a_sliders_mobile[$i]);
                    }
                }
                
                $profile['img_sliders_mobile'] = implode(";", $a_sliders_mobile);
                $ads = (isset($metas['img_ads'])&&$metas['img_ads']!='') ?$metas['img_ads']: [];
                $a_ads=[];
                $i=0;
                $profile['img_ads']='';
                if(count($ads)>0){
                    foreach($ads as $key=>$value){
                        foreach($ads[$key] as $key1=>$value1){
							$ads[$key][$key1]['slide'] = $this->img->get_image($folder, $value1['image']);
							$ads[$key][$key1]['showpage'] = @$a_position[$value1['position']];
                            if(!$profile['img_ads']){
                                $profile['img_ads']=$value1['image'];
                            }else{
                                $profile['img_ads'].=';'.$value1['image'];
                            }
                        }
                    }
				}
                
                if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_slider'){
                    $upload = $this->img->upload_image_base64($out['folder'], @$_POST['img'], trim(@$_POST['imgname']), 700, $out['img_slider_size']);
                    $metas = json_decode(@file_get_contents(FILE_CONF_CONTENT), true);
                    $type = 'img_sliders';
                    $values = is_array(@$metas[$type])?$metas[$type]:[];
                    $metas[$type][(count($values)+1)]['image'] = $upload;
                    $metas[$type][(count($values)+1)]['title']='';
                    $metas[$type][(count($values)+1)]['link']='';
                    $metas[$type][(count($values)+1)]['description']='';
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    echo $upload;
                    exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_slider_size'){
                    if($out['img_slider_size']!=$_POST['size']){
                        foreach ($a_sliders AS $item){
                            unlink(DIR_UPLOAD.$folder.$item);
                        }
                        $metas['img_sliders'] = null;
                        $metas['img_slider_size'] = $_POST['size'];
                        @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    }
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_ads_size'){
                    if($out['img_ads_size']!=$_POST['size']){
                        $metas['img_ads_size'] = $_POST['size'];
                        @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    }
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_slider_info'){
                    $title= isset($_POST['title'])?$_POST['title']:"";
                    $link= $_POST['link'];
                    $description = $_POST['description'];
                    $number = $_POST['number'];
                    $sliders[$number]['title']=$title;
                    $sliders[$number]['link']=$link;
                    $sliders[$number]['description']=$description;
                    $metas['img_sliders'] = $sliders;
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='get_slider_info'){
                    $number = $_POST['number'];
                    echo json_encode($sliders[$number]);
                    exit();
                }
                elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_slider'){
                    @unlink(DIR_UPLOAD.$folder.@$_POST['imgname']);
                    foreach($sliders as $key=>$value){
                        if(!is_file(DIR_UPLOAD.$folder.$value['image']))
                            unset($sliders[$key]);
                    }
                    $i=1;
                    foreach($sliders as $key=>$value){
                        $sliders[$i]=$value;
                        if($key!=$i){
                            unset($sliders[$key]);
                        }
                        $i++;
                    }
                    $metas['img_sliders'] = $sliders;
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_slider_mobile'){
                    $upload = $this->img->upload_image_base64($out['folder'], @$_POST['img'], trim(@$_POST['imgname']), 700, 2);
                    $metas = json_decode(@file_get_contents(FILE_CONF_CONTENT), true);
                    $type = 'img_sliders_mobile';
                    $values = is_array(@$metas[$type])?$metas[$type]:[];
                    $metas[$type][(count($values)+1)]['image'] = $upload;
                    $metas[$type][(count($values)+1)]['title']='';
                    $metas[$type][(count($values)+1)]['link']='';
                    $metas[$type][(count($values)+1)]['description']='';
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    echo $upload;
                    exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_slider_mobile'){
                    @unlink(DIR_UPLOAD.$folder.@$_POST['imgname']);
                    foreach($sliders_mobile as $key=>$value){
                        if(!is_file(DIR_UPLOAD.$folder.$value['image']))
                            unset($sliders_mobile[$key]);
                    }
                    $i=1;
                    foreach($sliders_mobile as $key=>$value){
                        $sliders_mobile[$i]=$value;
                        if($key!=$i){
                            unset($sliders_mobile[$key]);
                        }
                        $i++;
                    }
                    $metas['img_sliders_mobile'] = $sliders_mobile;
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_slider_mobile_info'){
                    $title= isset($_POST['title'])?$_POST['title']:"";
                    $link= $_POST['link'];
                    $description = $_POST['description'];
                    $number = $_POST['number'];
                    $sliders_mobile[$number]['title']=$title;
                    $sliders_mobile[$number]['link']=$link;
                    $sliders_mobile[$number]['description']=$description;
                    $metas['img_sliders_mobile'] = $sliders_mobile;
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='get_slider_mobile_info'){
                    $number = $_POST['number'];
                    echo json_encode($sliders_mobile[$number]);
                    exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_banner'){
                    $type = trim(@$_POST['type']);
                    $width = intval(@$_POST['width']);
                    $upload = $this->img->upload_image_base64($folder, @$_POST['img'], trim(@$_POST['imgname']), $width, -1);
                    $rt = 0;
                    if($upload){
                        @unlink(DIR_UPLOAD.$folder.$metas[$type]);
                        $metas[$type] = $upload;
                        @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                        $rt = $this->img->get_image($folder, $upload);
                    }
                    echo $rt; exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_banner'){
                    @unlink(DIR_UPLOAD.$folder.@$metas[@$_POST['key']]);
                    $metas[$_POST['key']] = '';
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    exit();
                }if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_ads'){
                    $width = intval(@$_POST['width']);//chưa lấy ddc giá trị này
                    $upload = $this->img->upload_image_base64($out['folder'], @$_POST['img'], trim(@$_POST['imgname']), null, $out['img_ads_size']);
                    $metas = json_decode(@file_get_contents(FILE_CONF_CONTENT), true);
                    $type = 'img_ads';
                    $values = is_array(@$metas[$type][$metas['img_ads_size']])?$metas[$type][$metas['img_ads_size']]:[];
                    
                    $metas[$type][$metas['img_ads_size']][(count($values)+1)]['image'] = $upload;
                    $metas[$type][$metas['img_ads_size']][(count($values)+1)]['title']='';
                    $metas[$type][$metas['img_ads_size']][(count($values)+1)]['link']='';
                    $metas[$type][$metas['img_ads_size']][(count($values)+1)]['position']='';
                    $metas[$type][$metas['img_ads_size']][(count($values)+1)]['description']='';
                    $metas[$type][$metas['img_ads_size']][(count($values)+1)]['size']=$metas['img_ads_size'];
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    echo $upload;
                    exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_ads'){
                    $metas = json_decode(@file_get_contents(FILE_CONF_CONTENT), true);
                    $type = 'img_ads';
                    $size = $_POST['size'];
                    @unlink(DIR_UPLOAD.$folder.@$metas[$type][$size][$_POST['key']]['image']);
                    foreach($ads as $key=>$value){
                        foreach($ads[$key] AS $key1=>$value1){
                            if(!is_file(DIR_UPLOAD.$folder.$value1['image']))
                                unset($ads[$size][$key1]);
                        }
                    }
                    $i=1;
                    foreach($ads[$size] as $key=>$value){
                        $ads[$size][$i]=$value;
                        if($key!=$i){
                            unset($ads[$size][$key]);
                        }
                        $i++;
                    }
                    $metas['img_ads'] = $ads;
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                    exit();
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_ads_info'){
                    $title= isset($_POST['title'])?$_POST['title']:"";
                    $link= $_POST['link'];
                    $position= $_POST['position'];
                    $description = $_POST['description'];
                    $size= $_POST['size'];
                    $number = $_POST['number'];
                    $ads[$size][$number]['title']=$title;
                    $ads[$size][$number]['link']=$link;
                    $ads[$size][$number]['position']=$position;
                    $ads[$size][$number]['description']=$description;
                    $metas['img_ads'] = $ads;
                    @file_put_contents(FILE_CONF_CONTENT, json_encode($metas));
                }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='get_ads_info'){
                    $number = $_POST['number'];
                    $size= $_POST['size'];
                    echo json_encode($ads[$size][$number]);
                    exit();
				}
				
                $this->smarty->assign('a_sliders_show', $a_sliders_show);
                $this->smarty->assign('a_sliders_mobile_show', $a_sliders_mobile_show);
                $this->smarty->assign('a_ads_show', $ads);
                $this->smarty->assign('profile', $profile);
                $this->smarty->assign('out', $out);
                $this->smarty->display(LAYOUT_DEFAULT);
    }
    function ajax_delete() {
		$id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
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

		foreach ($input_arr as $k => $v) {
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

		$data['deleted'] = implode('<br>', $deleted_arr);
		$data['notdeleted'] = implode('<br>', $notdeleted_arr);
		$data['deleted_id'] = implode('-', $deleted_id);

		echo json_encode($data);
	}
}
?>