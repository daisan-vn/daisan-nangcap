<?php

class Media extends Pageadmin {

    private $upload_path, $thumb_path, $position;
    
    function __construct() {
        parent::__construct();

		$this->upload_path = URL_UPLOAD."media/images/";
		$this->thumb_path = URL_UPLOAD."media/thumbnails/";
		
		$this->position= array(
			1 => "Position 1",
			2 => "Position 2",
			3 => "Position 3",
			4 => "Position 4",
			5 => "Position 5",
			6 => "Position 6",
			7 => "Position 7"
		);
    }


    function index() {
    	global $smarty, $login, $lang;
    	$out = [];
        $out['active_folder'] = $this->get_a_folder(1);
		$out['position'] = $this->help->get_select_from_array($this->position);
        $out['folder_list'] = $this->get_folder_list();
        
    	$smarty->assign('out', $out);
        $this->fetch_media($out['active_folder']);
    	$smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function detail(){
    	$media_id = isset($_POST['media_id']) ? $_POST['media_id'] : 0;
    	$media = $this->pdo->fetch_one("SELECT a.*,t.alias AS folder FROM media a LEFT JOIN taxonomy t ON a.taxonomy_id=t.id WHERE a.id=$media_id");
    
    	if($media){
	    	$media['avatar'] = $this->media->get_image_byid($media_id);
	    	
	    	$image = @getimagesize($this->upload_path.$media['folder']."/".$media['name']);
	    	$thumb = @getimagesize($this->thumb_path.$media['folder']."/".$media['name']);
	    	$media['imagesize'] = @$image[0]."x".@$image[1];
	    	$media['thumbsize'] = @$thumb[0]."x".@$thumb[1];
    	}
    	$this->smarty->assign('media', $media);
    	$this->smarty->display(LAYOUT_NONE);
    }


    function ajax_load_modal_folder() {
        global $smarty;

        $out['active_folder'] = $this->get_a_folder(1);
        $out['folder_list'] = $this->get_folder_list();
        $smarty->assign('out', $out);
        echo $smarty->display('../media/folder.tpl');
        exit();
    }


    function reload_folder() {
        global $smarty;
        if (isset($_POST['active_folder'])) {
            $active = $_POST['active_folder'];
            $out['show_file'] = isset($_POST['show_file']) ? $_POST['show_file'] : 1;
            $out['folder_list'] = $this->get_folder_list($active);
            $smarty->assign('out', $out);
            echo $smarty->display('../media/folder.tpl');
            exit();
        }
    }


    function reload_folder_select() {
    	if (isset($_POST['active_folder'])) {
    		$active = $_POST['active_folder'];
    		echo $this->get_folder_list($active);
    		exit();
    	}
    }
    

    function reload_media() {
        global $smarty;
        if (isset($_POST['folder'])) {
            $folder = isset($_POST['folder'])?$_POST['folder']:0;
            $page = $_POST['page'];
            $this->fetch_media($folder, $page);
            echo $smarty->display('../media/media.tpl');
            exit();
        }
    }

    
    function reload_select_media() {
        global $smarty;
        $action = isset($_POST['action']) ? $_POST['action'] : '';
        $folder = isset($_POST['folder']) ? $_POST['folder'] : 0;
        $page = isset($_POST['page']) ? $_POST['page'] : 1;
        if($action=='File2Editor') $this->fetch_media($folder, $page, $action, 25, 'file');
        else $this->fetch_media($folder, $page, $action, 25);
        echo $smarty->display('../media/select_media.tpl');
        exit();
    }


    function fetch_media($folder=0, $page=1, $action=null, $limit=48, $type='image') {
        global $smarty,$login;
        $folder_id = $folder == 0 ? $this->get_a_folder(1) : $folder;
        $number = $limit;
        $offset = ($page - 1) * $number;
        $sql = "SELECT id,name FROM media WHERE user_id = $login AND name IS NOT NULL";
        if($type=='file') $sql .= " AND Type='file'";
        else $sql .= " AND taxonomy_id=".$folder_id;
        $number_row = $this->pdo->count_rows($sql);
		$sql .= " ORDER BY id DESC LIMIT $offset, $number";
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $paging = new \Lib\Core\PageAjax($number_row, $number, $page, null, 0);
        $out_paging = $paging->building();
        $result = [];
        $folder_name = $this->pdo->fetch_one_fields("taxonomy", "alias", "id=$folder_id");
        while ($item = $stmt->fetch()) {
            $item['post_avatar'] = $this->img->get_image($this->media->get_path($folder_name, 1), $item['name']);
            $item['action'] = $action.'('.$item['id'].');';
            $result [] = $item;
        }
        $smarty->assign("result", $result);
        $smarty->assign("out_paging", $out_paging);
        $this->smarty->assign('type', $type);
    }


    function get_folder_list($active=0) {
        $default_folder = $this->get_a_folder(1);
        $sql = "SELECT id,name,alias FROM taxonomy WHERE type='folder' ORDER BY id";
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = '';
        while ($item = $stmt->fetch()) {
            if (($active == 0 && $item['id'] == $default_folder) || ($active != 0 && $active == $item['id'])) {
                $result .= '<li role="presentation" class="nav-item"><a class="nav-link active" href="javascript:void(0);" onclick="ChangeFolder('.$item['id'].');"><i class="fa fa-folder-o fa-fw"></i> '.$item['name'].'</a></li>';
            }else {
                $result .= '<li role="presentation"><a class="nav-link" href="javascript:void(0);" onclick="ChangeFolder('.$item['id'].');"><i class="fa fa-folder-o fa-fw"></i> '.$item['name'].'</a></li>';
            }
        }
        return $result;
    }


    function ajax_save_folder() {
        $id = isset($_POST['folder_id']) ? $_POST['folder_id'] : 0;
        $data['name'] = $this->string->del_danger($_POST['folder_name']);
        if ($id == 0) {
            $check = $this->pdo->check_exist("SELECT id FROM taxonomy WHERE type='folder' AND name='".$data['name']."'");
            if ($check) {
                $data['mes'] = 'exist';
                echo json_encode($data);
                exit();
            }

            $data['alias'] = $this->string->str_convert($data['name']);
            if (is_dir($this->upload_path.$data['alias'].'/')) {
                $data['alias'] = $data['alias'].substr(time(), -8);
            }
            $data['type'] = 'folder';
            $data['status'] = 1;
            $insertId = $this->pdo->insert('taxonomy', $data);
            @mkdir($this->upload_path.$data['alias'].'/', 0777);
            @chmod($this->upload_path.$data['alias'].'/', 0777);
            @mkdir($this->thumb_path.$data['alias'].'/', 0777);
            @chmod($this->thumb_path.$data['alias'].'/', 0777);
        }else {
            $check = $this->pdo->check_exist("SELECT id FROM taxonomy WHERE id<>$id AND name='".$data['name']."'");
            if ($check) {
                $data['mes'] = 'exist';
                echo json_encode($data);
                exit();
            }
            $this->pdo->update('vsc_taxonomy', $data, 'taxonomy_id='.$id);
        }
        $count_folder = $this->pdo->count_rows("SELECT id FROM taxonomy WHERE type='folder'");
        if ($id == 0 && $count_folder == 1) {
            $data['mes'] = 'unique';
            $data['folder_unique'] = $insertId;
        }
        elseif ($id == 0 && $count_folder != 0) {
            $data['mes'] = 0;
        }

        echo json_encode($data);
    }


    function ajax_delete_folder() {
        if (isset($_POST['id'])) {
            $id = $_POST['id'];
            $check = $this->pdo->check_exist("SELECT id FROM media WHERE taxonomy_id=$id");
            $folder = $this->pdo->fetch_one("SELECT name,alias FROM taxonomy WHERE id=$id");
            if ($check) {
                $data['ok'] = 0;
                $data['mes'] = "Không thể xóa thư mục <b>".$folder['name']."</b> vì còn chứa file";
            }
            else {
                $data['ok'] = 1;
                $data['mes'] = "Đã xóa thư mục <b>".$folder['name']."</b>";
                $this->pdo->query("DELETE FROM taxonomy WHERE id=$id AND type='folder'");
                @rmdir($this->upload_path.$folder['alias'].'/');
                @rmdir($this->thumb_path.$folder['alias'].'/');
            }
            $count_folder = $this->pdo->count_rows("SELECT id FROM taxonomy WHERE type='folder'");
            if ($count_folder == 0) $data['count'] = 0;
            echo json_encode($data);
        }
    }


    function get_a_folder($return=0) {
        $value = $this->pdo->fetch_one("SELECT id FROM taxonomy WHERE type='folder' ORDER BY id LIMIT 1");
        if ($return == 0) {
            echo $value['id'];
            exit();
        }
        return $value['id'];
    }


    function upload(){
        global $smarty, $login, $lang;
        $out = [];

        if(isset($_FILES['images']) && count($_FILES['images'])>0){
            $check_folder = $this->pdo->check_exist("SELECT id FROM taxonomy WHERE type='folder' LIMIT 1");
            if (!$check_folder) {
                $data_f['name'] = 'General';
                $data_f['alias'] = 'general';
                $data_f['type'] = 'folder';
                $data_f['status'] = 1;
                $folder_id = $this->pdo->insert('taxonomy', $data_f);
            }

            $taxonomy_id = isset($_POST['taxonomy_id']) ? $_POST['taxonomy_id'] : $folder_id;
            $folder = $this->pdo->fetch_one_fields('taxonomy', 'alias', "id=$taxonomy_id");
            $number = count($_FILES['images']['name']);
            for($i=0; $i<$number; $i++){
                $img['name'] = $_FILES['images']['name'][$i];
                $img['type'] = $_FILES['images']['type'][$i];
                $img['tmp_name'] = $_FILES['images']['tmp_name'][$i];
                $img['error'] = $_FILES['images']['error'][$i];
                $img['size'] = $_FILES['images']['size'][$i];
                $imgname = $this->img->upload($this->media->get_path($folder), $img, $_POST['image_width']);
                unset($img);
                if($imgname){
	                $data['name'] = $imgname;
	                $data['taxonomy_id'] = $taxonomy_id;
	                $data['user_id'] = $login;
	                $data['created'] = time();
	                $id = $this->pdo->insert('media', $data);
	                $this->make_thumb($folder, $imgname, $_POST['thumbsize'], $_POST['thumbratio']);
                }
            }
            lib_redirect("?mod=media&site=index");
        }

		$out ['thumbsize'] = $this->help->get_select_from_array ( $this->media->thumbsize, $this->get_option_item ( 'thumbsize' ), 0 );
		$out ['thumbratio'] = $this->help->get_select_from_array ( $this->media->thumbratio, $this->get_option_item ( 'thumbratio' ), 0 );
		$out ['image_width'] = $this->help->get_select_from_array ( $this->media->imagewidth, $this->get_option_item ( 'image_width' ), 0 );
        $out['select_folder'] = $this->taxonomy->get_select_taxonomy('folder', 0, 0, null, null, 0);
        $out['select_type'] = $this->taxonomy->get_select_taxonomy('image', 0, 0, null, 'Chọn danh mục ảnh', 0);
        $out['position'] = $this->help->get_select_from_array($this->position);
        $smarty->assign('out', $out);
        $smarty->display(LAYOUT_DEFAULT);
    }


    function ajax_upload() {
        // ini_set('display_errors', true);
        // error_reporting(E_ALL);

        global $login;

        if(isset($_FILES['image'])){
            $check_folder = $this->pdo->check_exist("SELECT id FROM taxonomy WHERE type='folder' LIMIT 1");
            $taxonomy_id = isset($_POST['taxonomy_id']) ? $_POST['taxonomy_id'] : 0;
            if (!$check_folder || $taxonomy_id==0) {
                $data_f['name'] = 'General';
                $data_f['alias'] = 'general';
                $data_f['type'] = 'folder';
                $data_f['status'] = 1;
                $taxonomy_id = $this->pdo->insert('taxonomy', $data_f);
            }

            $img['name'] = $_FILES['image']['name'];
            $img['type'] = $_FILES['image']['type'];
            $img['tmp_name'] = $_FILES['image']['tmp_name'];
            $img['error'] = $_FILES['image']['error'];
            $img['size'] = $_FILES['image']['size'];
            $folder = $this->pdo->fetch_one_fields('taxonomy', 'alias', 'id='.$taxonomy_id);
            $imgname = $this->img->upload($this->media->get_path($folder), $img, $this->get_option_item('image_width'));
            unset($img);

            $data['name'] = $imgname;
            $data['taxonomy_id'] = $taxonomy_id;
            $data['user_id'] = $login;
            $data['created'] = time();
            $data['user_id'] = $login;
            $id = $this->pdo->insert('media', $data);
            $this->make_thumb($folder, $imgname);
            echo $id;
        }
    }


    function edit() {
        global $smarty, $login, $lang;

        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        if ($id == 0) lib_redirect_back();
        $media = $this->pdo->fetch_one("SELECT id,name,taxonomy_id FROM media WHERE id=$id");
        $folder = $this->pdo->fetch_one_fields('taxonomy', 'alias', 'id='.$media['taxonomy_id']);
        $media['image'] = $this->img->get_image($this->media->get_path($folder), $media['name']);
        $smarty->assign('media', $media);

        if (isset($_POST['submit'])) {
            $pos['start_x'] = intval($_POST['crop_x']);
            $pos['start_y'] = intval($_POST['crop_y']);
            $pos['width'] = intval($_POST['crop_width']);
            $pos['height'] = intval($_POST['crop_height']);
            $pos['end_x'] = intval($_POST['crop_width'] + $_POST['crop_x']);
            $pos['end_y'] = intval($_POST['crop_height'] + $_POST['crop_y']);
            $pos['rotate'] = intval($_POST['crop_rotate']);
            $pos['fliph'] = intval($_POST['crop_scaleX']);
            $pos['flipv'] = intval($_POST['crop_scaleY']);

            $crop = new \Lib\Core\Zebra();
            $crop_path = $this->img->get_dir_upload('images/'.$folder.'/'.$media['MediaName']);
            $new_name = 'vsc'.time().'.'.pathinfo($crop_path, PATHINFO_EXTENSION);
            $crop->source_path = $crop_path;
            $crop->target_path = $this->img->get_dir_upload('images/'.$folder.'/').$new_name;
            $crop->jpeg_quality = 100;
            $crop->preserve_aspect_ratio = true;
            $do_crop = $crop->crop($pos['start_x'], $pos['start_y'], $pos['end_x'], $pos['end_y']);

            if ($pos['fliph'] != 1 || $pos['flipv'] != 1) {
                $flip = new \Lib\Core\Zebra();
                $flip_path = $this->img->get_dir_upload('images/'.$folder.'/' . $new_name);
                $flip->source_path = $flip_path;
                $flip->target_path = $this->img->get_dir_upload('images/'.$folder.'/') . $new_name;
                $flip->jpeg_quality = 100;
                $flip->preserve_aspect_ratio = true;
                if ($pos['fliph'] == -1 && $pos['flipv'] == 1) {
                    $do_flip = $flip->flip_horizontal();
                } elseif ($pos['flipv'] == -1 && $pos['fliph'] == 1) {
                    $do_flip = $flip->flip_vertical();
                } elseif ($pos['flipv'] == -1 && $pos['fliph'] == -1) {
                    $do_flip = $flip->flip_both();
                }
            }

            if ($pos['rotate'] != 0) {
                $rotate = new \Lib\Core\Zebra();
                $rotate_path = $this->img->get_dir_upload('images/'.$folder.'/' . $new_name);
                $rotate->source_path = $rotate_path;
                $rotate->target_path = $this->img->get_dir_upload('images/'.$folder.'/') . $new_name;
                $rotate->jpeg_quality = 100;
                $rotate->preserve_aspect_ratio = true;
                $do_rotate = $rotate->rotate($pos['rotate']);
            }

            $this->make_thumb($folder.'/'.$new_name);

            $data['MediaName'] = $new_name;
            $this->pdo->update('media', $data, 'id='.$id);
            $this->img->remove($folder . '/'. $media['MediaName']);

            lib_redirect('?mod=media&site=index');
        }

        $smarty->display(LAYOUT_DEFAULT);
    }


    function make_thumb($folder, $imgname, $thumbsize=null, $thumbratio=null) {
    	$path_image = $this->media->get_path_upload($folder);
    	$path_thumb = $this->media->get_path_upload($folder, 1);
        $thumbsize = $thumbsize==null?$this->get_option_item('thumbsize'):$thumbsize;
        $thumbratio = $thumbratio==null?$this->get_option_item('thumbratio'):$thumbratio;

        if ($thumbratio == 0) {
            $thumbheight = $thumbsize;
            $thumbposition = 1;
        }else {
            $thumbheight = intval(intval($thumbsize) / floatval($thumbratio));
            $thumbposition = $this->get_option_item('thumbposition');
        }

        $thumbnail = new \Lib\Core\Zebra();
        $thumbnail->source_path = $path_image.$imgname;
        if (!is_dir($path_image)) {
            @mkdir($path_image, 0775);
            @chmod($path_image, 0775);
        }
        if (!is_dir($path_thumb)) {
            @mkdir($path_thumb, 0775);
            @chmod($path_thumb, 0775);
        }
        $thumbnail->target_path = $path_thumb.$imgname;
        $thumbnail->jpeg_quality = 70;
        $this->png_compression = 6;
        $thumbnail->preserve_aspect_ratio = true;
        $thumbnail->resize($thumbsize, $thumbheight, $thumbposition, -1);
    }

    
	function ajax_load_delete_media(){
		$id = isset($_POST ['id']) ? $_POST ['id'] : 0;
		if($id==0) exit();

		$input_arr = explode(',', $id);
		$deleted_arr = [];
		$notdeleted_arr = [];
		$deleted_id = [];

		foreach ($input_arr as $k => $v) {
			$value = $this->pdo->fetch_one("SELECT id,name,taxonomy_id FROM media WHERE id=$v");
			@array_push($deleted_arr, $value['name']);
			@array_push($deleted_id, $value['id']);
			$this->media->remove_media($value['id']);
		}

		$data['deleted'] = implode('<br>', $deleted_arr);
		$data['notdeleted'] = implode('<br>', $notdeleted_arr);
		$data['deleted_id'] = implode('-', $deleted_id);

		echo json_encode($data);
		exit();
	}


	function ajax_load_media(){
		if (isset($_POST ['id'])) {
			$id = isset($_POST ['id']) ? $_POST ['id'] : 0;
			$value = $this->pdo->fetch_one("SELECT a.*,t.alias FROM media a LEFT JOIN taxonomy t ON a.taxonomy_id=t.id WHERE a.id= $id");

			$value['image'] = $this->img->get_image($this->media->get_path($value['alias']), @$value['name']);
			$value['Position'] = $this->help->get_select_from_array($this->position, @$value['Position']);
			echo json_encode($value);
			exit();
		}
	}

	
	function ajax_get_image(){
		$thumb = isset($_POST['thumb']) ? intval($_POST['thumb']) : 1;
		$id = isset($_POST['id']) ? intval($_POST['id']) : 0;
		$media = $this->media->get_image_byid($id, $thumb);
		echo $media;
	}
	
	
	function ajax_load_modal_media(){
		$rt['select_category'] = $this->taxonomy->get_select_taxonomy('folder', 0, 0, null, 0, 0);
		echo json_encode($rt);
		exit();
	}
	
	function ajax_delete(){
		$id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
		if($id == 0) exit();
		$data['code'] = 1;
		$data['msg'] = "Xóa hình ảnh thành công";
		$this->media->remove_media($id);
		echo json_encode($data);
		exit();
	}
	
}
