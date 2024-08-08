<?php

class Theme extends Pageadmin{
	function __construct() {
		parent::__construct ();
		
		$a_menu = array(
				'index' => "Giao diện đang sử dụng",
				'images' => "Hình ảnh trên website",
				'allthemes' => 'Kho giao diện',
		);
		$page_menu = "";
		foreach ($a_menu AS $k=>$item){
			if($k==$this->arg['site'])
				$page_menu .= '<a href="?mod='.$this->arg['mod'].'&site='.$k.'" class="btn btn-primary">'.$item.'</a> ';
			else
				$page_menu .= '<a href="?mod='.$this->arg['mod'].'&site='.$k.'" class="btn btn-secondary">'.$item.'</a> ';
		}
		$this->smarty->assign('page_menu', $page_menu);
		
	}
	
	
	function index(){
		global $login;
		$out = [];
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='active_theme'){
			$theme = $this->pdo->fetch_one("SELECT * FROM themes WHERE id=".$_POST['id']);
			$a_pagethemes = @parse_ini_file(FILE_LAYOUTS);
			//if(isset($a_pagethemes[$theme['id']])) $a_pagethemes[]
			$a_pagethemes[$this->page_id] = $theme['name'];
			$a_pagethemes[$this->profile['page_name']] = $theme['name'];
			@file_put_contents(FILE_LAYOUTS, lib_arr_to_ini($a_pagethemes));
			
			$this->pdo->query("UPDATE pagethemes SET status=0 WHERE page_id=".$this->page_id);
			$data['status'] = 1;
			$this->pdo->update('pagethemes', $data, "page_id=".$this->page_id." AND theme_id=".$_POST['id']);
			exit();
		}
		
		$themes = $this->pdo->fetch_all("SELECT t.id,t.name,t.avatar,a.status,t.title,t.date_update
				FROM pagethemes a LEFT JOIN themes t ON a.theme_id=t.id
				WHERE t.status=1 AND a.page_id=".$this->page_id."
				ORDER BY a.id DESC" );
		foreach ($themes AS $k=>$item){
			$themes[$k]['avatar'] = $this->img->get_image("themes/", $item['avatar']);
			$themes[$k]['url_demo'] = URL_THEME.$item['name']."/?pageId=".$this->page_id;
		}
		$this->smarty->assign('themes', $themes);
		
		
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}

	
	function images(){
		global $login;
		$out = [];
		
		$profile = $this->pdo->fetch_one("SELECT img_sliders,img_intro,img_service,img_product,img_contact
				FROM pageprofiles WHERE page_id=".$this->page_id);
		$a_sliders = strlen(@$profile['img_sliders'])>30 ? explode(";", @$profile['img_sliders']) : [];
		for ($i=0; $i<3; $i++){
			if(isset($a_sliders[$i]) && is_file($this->page->get_folder_img_upload($this->page_id).$a_sliders[$i])){
				$a_sliders_show[$i] = $this->img->get_image($this->page->get_folder_img($this->page_id), $a_sliders[$i]);
			}else{
				$a_sliders_show[$i] = NO_IMG;
				unset($a_sliders[$i]);
			}
		}
		$profile['img_sliders'] = implode(";", $a_sliders);
		
		$profile['img_intro_show'] = $this->img->get_image($this->page->get_folder_img($this->page_id), @$profile['img_intro']);
		$profile['img_product_show'] = $this->img->get_image($this->page->get_folder_img($this->page_id), @$profile['img_product']);
		$profile['img_service_show'] = $this->img->get_image($this->page->get_folder_img($this->page_id), @$profile['img_service']);
		$profile['img_contact_show'] = $this->img->get_image($this->page->get_folder_img($this->page_id), @$profile['img_contact']);
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_images'){
			$upload = $this->img->upload_image_base64($this->page->get_folder_img($this->page_id), @$_POST['img'], trim(@$_POST['imgname']), 1200, 2.5);
		   // $upload = $this->img->upload_image_base64($this->page->get_folder_img($this->page_id), @$_POST['img'], trim(@$_POST['imgname']), 1200, 0);
			$a_sliders[] = $upload;
			$data['img_sliders'] = implode(";", $a_sliders);
			$this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
			echo $upload;
			exit();
		}elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_images'){
			@unlink($this->page->get_folder_img_upload($this->page_id).@$_POST['imgname']);
			foreach ($a_sliders AS $k=>$item){
				if(!is_file($this->page->get_folder_img_upload($this->page_id).$item))
					unset($a_sliders[$k]);
			}
			$data['img_sliders'] = implode(";", $a_sliders);
			$this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
			exit();
		}
		
		$this->smarty->assign('a_sliders_show', $a_sliders_show);
		$this->smarty->assign('profile', $profile);
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function allthemes(){
		global $login;
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_theme'){
			$data['page_id'] = $this->page_id;
			$data['theme_id'] = $_POST['id'];
			$data['created'] = time();
			$data['status'] = 0;
			if(!$this->pdo->check_exist("SELECT 1 FROM pagethemes WHERE page_id=".$this->page_id." AND theme_id=".$_POST['id'])){
				//$this->pdo->query("UPDATE pagethemes SET status=0 WHERE page_id=".$this->page_id);
				$this->pdo->insert('pagethemes', $data);
			}
			exit();
		}
		
		$themes = $this->pdo->fetch_all("SELECT id,name,avatar,status,title,date_update
				FROM themes a WHERE status=1 AND id NOT IN (SELECT theme_id FROM pagethemes WHERE page_id=".$this->page_id.") 
				ORDER BY id DESC" );
		foreach ($themes AS $k=>$item){
			$themes[$k]['avatar'] = $this->img->get_image("themes/", $item['avatar']);
			$themes[$k]['url_demo'] = URL_THEME.$item['name']."/?pageId=".$this->page_id;
		}
		$this->smarty->assign('themes', $themes);
		
		
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function ajax_upload_img(){
		$type = trim(@$_POST['type']);
		$width = intval(@$_POST['width']);
		$profile = $this->pdo->fetch_one("SELECT img_sliders,img_intro,img_service,img_product,img_contact
				FROM pageprofiles WHERE page_id=".$this->page_id);
		
		$upload = $this->img->upload_image_base64($this->page->get_folder_img($this->page_id), @$_POST['img'], trim(@$_POST['imgname']), $width, 0);
		$rt = 0;
		if($upload){
			unset($data);
			@unlink($this->page->get_folder_img_upload($this->page_id).$profile[$type]);
			$data[$type] = $upload;
			$this->pdo->update('pageprofiles', $data, "page_id=".$this->page_id);
			$rt = URL_UPLOAD.$this->page->get_folder_img($this->page_id).$upload;
		}
		echo $rt; exit();
	
	}
	
}
