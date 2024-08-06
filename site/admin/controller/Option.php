<?php
/**
 * 24/05/2016
 * @namespace Configuration
 * @author LUCTV
 *
 */
class Option extends Admin {

	function __construct() {
		parent::__construct ();
		
		$this->smarty->assign ( 'sidebar_type', 'setting' );
	}
	
	
	function index() {
		global $login;
		$this->smarty->assign('contact', @$this->get_conf_values('contact'));
		$this->smarty->assign('seo', @$this->get_conf_values('seo'));
		$this->smarty->assign('link', @$this->get_conf_values('link'));
		
		$this->smarty->display ( LAYOUT_DEFAULT );
	}

	
	function contact() {
		global $login;
		$type = 'contact';
		$values = $this->get_conf_values ( $type );
		
		if (isset ( $_POST ['submit'] )) {
			$this->save_conf_values ( $type, 'name', trim ( $_POST ['name'] ) );
			$this->save_conf_values ( $type, 'name_short', trim ( $_POST ['name_short'] ) );
			$this->save_conf_values ( $type, 'slogan', trim ( $_POST ['slogan'] ) );
			$this->save_conf_values ( $type, 'description', trim ( $_POST ['description'] ) );
			$this->save_conf_values ( $type, 'phone', trim ( $_POST ['phone'] ) );
			$this->save_conf_values ( $type, 'opentime', trim ( $_POST ['opentime'] ) );
			$this->save_conf_values ( $type, 'email', trim ( $_POST ['email'] ) );
			$this->save_conf_values ( $type, 'address',  trim ( $_POST ['address']  ) );
			lib_redirect ("?mod=option&site=index");
		}
		$this->smarty->assign ( 'values', @$values );
		$this->smarty->display ( LAYOUT_DEFAULT );
	}
	
	
	function link() {
		global $login;
		$type = 'link';
		$values = $this->get_conf_values ( $type );
		if (isset ( $_POST ['submit'] )) {
			$this->save_conf_values ( $type, 'website', trim ( $_POST ['website'] ) );
			$this->save_conf_values ( $type, 'twitter', trim ( $_POST ['twitter'] ) );
			$this->save_conf_values ( $type, 'facebook', trim ( $_POST ['facebook'] ) );
			$this->save_conf_values ( $type, 'google', trim ( $_POST ['google'] ) );
			$this->save_conf_values ( $type, 'skype', trim ( $_POST ['skype'] ) );
			$this->save_conf_values ( $type, 'youtube', trim ( $_POST ['youtube'] ) );
			lib_redirect ("?mod=option&site=index");
		}
		$this->smarty->assign ( 'values', @$values );
		$this->smarty->display ( LAYOUT_DEFAULT );
	}
	
	
	function seo() {
		global $login;
		$type = 'seo';
		$values = $this->get_conf_values ( $type );
		if (isset ( $_POST ['submit'] )) {
			$this->save_conf_values ( $type, 'title', trim ( $_POST ['title'] ) );
			$this->save_conf_values ( $type, 'keyword', trim ( $_POST ['keyword'] ) );
			$this->save_conf_values ( $type, 'description', trim ( $_POST ['description'] ) );
			lib_redirect ("?mod=option&site=index");
		}
		$this->smarty->assign ( 'values', @$values );
		$this->smarty->display ( LAYOUT_DEFAULT );
	}
	
	
	function mail() {
		global $login;
		$type = 'mail';
		$values = $this->get_conf_values ( $type, 0 );
		
		if (isset ( $_POST ['submit'] )) {
			if (isset ( $_POST ['mail_on'] )) {
				if (trim ( $_POST ['send_mail'] ) == '' || trim ( $_POST ['send_pass'] ) == '' || trim ( $_POST ['receive_mail'] ) == '') {
					lib_alert ( 'Luu khong thanh cong. Cac truong bat buoc khong duoc de trong' );
					lib_redirect ();
				}
			}
				
			$this->save_conf_values ( $type, 'mail_on', isset($_POST['mail_on'])?1:0, 0 );
			$this->save_conf_values ( $type, 'send_mail', trim ( $_POST ['send_mail'] ), 0 );
			if ($_POST ['send_pass'] != $values ['send_pass'])
				$this->save_conf_values ( $type, 'send_pass', $this->string->encrypt_string ( trim ( $_POST ['send_pass'] ) ), 0 );
			$this->save_conf_values ( $type, 'send_name', trim ( $_POST ['send_name'] ), 0 );
			$this->save_conf_values ( $type, 'send_title', trim ( $_POST ['send_title'] ), 0 );
			$this->save_conf_values ( $type, 'receive_mail', trim ( $_POST ['receive_mail'] ), 0 );
			$this->save_conf_values ( $type, 'receive_name', trim ( $_POST ['receive_name'] ), 0 );
			lib_alert ( 'Luu cau hinh thanh cong' );
			lib_redirect ();
		}
		
		$this->smarty->assign ( 'values', @$values );
		$this->smarty->display ( LAYOUT_DEFAULT );
	}
	
	
	function map() {
		global $login;
		$type = 'contact';
		$values = $this->get_conf_values ( $type );
		if (isset ( $_POST ['frmSubmit'] )) {
			$this->save_conf_values ( $type, 'map_ip', trim ( $_POST ['map_id'] ) );
			lib_redirect ( THIS_LINK );
		}
		$this->smarty->assign ( 'values', @$values );
		$this->smarty->display ( DEFAULT_LAYOUT );
	}
	
	
	function thumb() {
		global $login;
		$type = 'thumb';
		$values = $this->get_conf_values ( $type, 0 );
		
		$out ['thumbsize'] = $this->help->get_select_from_array ( $this->media->thumbsize, @$values['thumbsize'], 0 );
		$out ['thumbratio'] = $this->help->get_select_from_array ( $this->media->thumbratio, @$values['thumbratio'], 0 );
		$out ['thumbposition'] = $this->help->get_select_from_array ( $this->media->thumbposition, @$values['thumbposition'], 0 );
		$out ['image_width'] = $this->help->get_select_from_array ( $this->media->imagewidth, @$values['image_width'], 0 );
		if (isset ( $_POST ['submit'] )) {
			$this->save_conf_values ( $type, 'thumbsize', trim ( $_POST ['thumbsize'] ), 0 );
			$this->save_conf_values ( $type, 'thumbratio', trim ( $_POST ['thumbratio'] ), 0 );
			$this->save_conf_values ( $type, 'thumbposition', trim ( $_POST ['thumbposition'] ), 0 );
			$this->save_conf_values ( $type, 'image_size', trim ( $_POST ['image_size'] ), 0 );
			$this->save_conf_values ( $type, 'image_width', trim ( $_POST ['image_width'] ), 0 );
			lib_redirect ();
		}
		$this->smarty->assign ( 'out', $out );
		$this->smarty->assign ( 'values', @$values );
		$this->smarty->display ( LAYOUT_DEFAULT );
	}
	
	
	function get_conf_values($type, $use_lang=1) {
		global $lang;
		$sql = "SELECT name,value FROM options WHERE type='$type'";
		if($use_lang==1)
			$sql .= " AND Lang='$lang'";
		$stmt = $this->pdo->getPDO()->prepare ( $sql );
		$stmt->execute ();
		
		$values = [];
		while ( $item = $stmt->fetch () ) {
			$values [$item ['name']] = $item ['value'];
		}
	
		return $values;
	}
	
	
	function save_conf_values($type, $field, $value, $use_lang=1) {
		global $lang;
		$data ['value'] = $value;
		$where_use_lang = "AND Lang='$lang'";
		if($use_lang==0)
			$where_use_lang = "";
		
		if($this->pdo->check_exist("SELECT id FROM options WHERE type='$type' AND name='$field' $where_use_lang")){
			$this->pdo->update ( 'options', $data, "type='$type' AND name='$field' $where_use_lang" );
		} else {
			if($use_lang==1)
			$data ['Lang'] = $lang;
			$data ['type'] = $type;
			$data ['name'] = $field;
			$id = $this->pdo->insert ( 'options', $data );
		}
		unset ( $data );
	}
	
}