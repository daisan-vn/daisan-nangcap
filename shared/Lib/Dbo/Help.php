<?php

namespace Lib\Dbo;

class Help {

    use \Lib\Singleton;

    private $pdo, $str;
	public $a_status;
	
	protected function __construct(){
		$this->pdo = \Lib\DB::instance();
		$this->str = \Lib\Core\Text::instance();
		
		$this->a_status = array(
				0 => 'Chưa hoạt động',
				1 => 'Hoạt động',
				2 => 'Đang khóa'
		);
	}
	
	
	function get_select_location($active=0, $parent=0, $default='Lựa chọn') {
		$result = "";
		if($default != null) $result .= '<option value="0">' . $default . '</option>';
		$sql = "SELECT Id,Name,Prefix FROM locations a WHERE Status=1  AND Parent=$parent ORDER BY Featured DESC,Sort DESC,Name";
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		while ($item = $stmt->fetch()) {
			if ($item['Id']==$active) $result .= '<option value="'.$item ['Id'].'" selected>';
			else $result .= '<option value="'.$item['Id'].'">';
			$result .= $item ['Name'];
			$result .= '</option>';
		}
		return $result;
	}

	
	function get_location($parent=0) {
	    $sql = "SELECT Id,Name,Prefix FROM locations a WHERE Status=1  AND Parent=$parent ORDER BY Featured DESC,Sort DESC,Name";
	    $db = $this->pdo->fetch_all($sql);
	    return $db;
	}
	
	
	function get_select_location_multi($active=null, $parent=0, $default='Lựa chọn') {
		$a_active = explode(",", $active);
		$result = "";
		if($default != null) $result .= '<option value="0">' . $default . '</option>';
		$sql = "SELECT Id,Name,Prefix FROM locations a WHERE Status=1  AND Parent=$parent ORDER BY Sort,Name";
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		while ($item = $stmt->fetch()) {
			if (in_array($item['Id'], $a_active)) $result .= '<option value="'.$item ['Id'].'" selected>';
			else $result .= '<option value="'.$item['Id'].'">';
			$result .= $item ['Name'];
			$result .= '</option>';
		}
		return $result;
	}
	
	
	function get_select_from_table($table, $fieldid='Id', $fieldname='Name', $active=0, $default='Lựa chọn'){
		$result = "";
		if($default != null) $result .= '<option value="0">'.$default.'</option>';
		$sql = "SELECT $fieldid,$fieldname FROM $table";
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		while ($item = $stmt->fetch()) {
			if ($item[$fieldid]==$active) $result .= '<option value="'.$item [$fieldid].'" selected>';
			else $result .= '<option value="'.$item[$fieldid].'">';
			$result .= $item [$fieldname];
			$result .= '</option>';
		}
		return $result;
	}
	
	
	function get_select_from_dbtable($table, $Key, $Name, $active=0, $prefix=null, $where=null, $sort=null){
		$result = null;
		if($prefix!==null) $result = "<option value=\"0\">".$prefix."</option>";
		$sql = "SELECT $Key,$Name FROM $table";
		if($where!=null && $where!='') $sql .= " WHERE $where";
		if($sort!=null && $sort!='') $sql .= " ORDER BY $sort";
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		while ($item = $stmt->fetch()){
			if($item[$Key]===$active) $result .= '<option value="'.$item[$Key].'" selected>';
			else $result .= '<option value="'.$item[$Key].'">';
			$result .= $item[$Name];
			$result .= '</option>';
		}
		return $result;
	}
	
	
	function get_select_from_array(array $array, $active=0, $prefix=0){
		$df_value = isset($array[0])?-1:0;
		$result = "";
		if($prefix!==0) $result = "<option value='$df_value'>$prefix</option>";
	
		foreach ($array AS $k => $item){
			if($k == $active) $result .= "<option value='".$k."' selected>";
			else $result .= "<option value='".$k."'>";
			$result .= $item;
			$result .= "</option>";
		}
		return $result;
	}

	
	function get_select_array_value(array $array){
	    $result = '';
	    foreach ($array AS $v){
	        //$k = $this->str->str_convert($v);
	        
	        $result .= "<option value='".$v."'>";
	        $result .= $v;
	        $result .= "</option>";
	    }
	    
	    return $result;
	}
	
	
	function get_checkbox_from_array(array $array, $active=null, $idname=null){
	    $idname = $idname==null?'defaultCheck':$idname;
		$result = "";
		foreach ($array AS $k => $item){
			$result .= "<div class=\"form-check\">";
			if(!in_array($k, explode(",", $active))) $result .= "<input class=\"form-check-input\" type=\"checkbox\" value=\"$k\" id=\"$idname$k\">";
			else $result .= "<input class=\"form-check-input\" type=\"checkbox\" value=\"$k\" id=\"$idname$k\" checked>";
			$result .= "<label class=\"form-check-label\" for=\"$idname$k\"> $item </label>";
			$result .= "</div>";
		}
		return $result;
	}
	
	
	function array_sort($array, $on, $order=SORT_ASC){
		$new_array = [];
		$sortable_array = [];
	
		if (count($array) > 0) {
			foreach ($array as $k => $v) {
				if (is_array($v)) {
					foreach ($v as $k2 => $v2) {
						if ($k2 == $on) $sortable_array[$k] = $v2;
					}
				} else $sortable_array[$k] = $v;
			}
	
			switch ($order) {
				case SORT_ASC:
					asort($sortable_array);
					break;
				case SORT_DESC:
					arsort($sortable_array);
					break;
			}
	
			foreach ($sortable_array as $k => $v) {
				$new_array[$k] = $array[$k];
			}
		}
	
		return $new_array;
	}
	
	
	function get_btn_status($status, $table, $id, $custom_js=null) {
	    $onclick = "onclick=\"$custom_js('$table', '$id');\"";
	    if($custom_js===null) $onclick = "onclick=\"activeItem('$table', '$id');\"";
	    elseif ($custom_js===0) $onclick = null;
	    
	    $result = NULL;
	    if($status==0){
	        $result .= "<button type=\"button\" class=\"btn btn-default btn-sm\" title=\"Đổi trạng thái\" $onclick>";
	        $result .= "<i class=\"fa fa-clock-o fa-fw\"></i>";
	        $result .= "</button>";
	    }elseif($status==1){
	        $result .= "<button type=\"button\" class=\"btn btn-success btn-sm\" title=\"Đổi trạng thái\" $onclick>";
	        $result .= "<i class=\"fa fa-check fa-fw\"></i>";
	        $result .= "</button>";
	    }else{
	        $result .= "<button type=\"button\" class=\"btn btn-danger btn-sm\" title=\"Chưa được kích hoạt\" $onclick>";
	        $result .= "<i class=\"fa fa-lock fa-fw\"></i>";
	        $result .= "</button>";
	    }
	    return $result;
	}
	
	function get_trueLink($a_url, $url=null, $pre_remove=null){
	    if(count($a_url)>0){
	        if($pre_remove==''){
	            $pre_remove = '/tin-tuc,tu-van,/tro-giup,/huong-dan,/gio-hang,/news,/so-sanh,/thuong-hieu,/tra-gop,/tim-kiem,/timkiem,/lien-he';
	            $pre_remove .= ',add-to-,add_to_,shoppingcart,/AddToCart,/cart,mua-tra-gop,quick-buy,login,keyword=,selected_section,per_page';
	            $pre_remove .= ',/user,/dich-vu,/bai-viet,/blog,account,prices=,gclid=,pro=,o=,noscript,ft=,?sef_rewrite=,?category=';
	            $pre_remove .= ',sort_by=,sortby=,sort=,min=,max=,price=,brand=,thuong-hieu=,&order,orderby=,show=,gia_tu=,filter,action=,search=';
	            $pre_remove .= ',/search,.jpg,.png';
	        }
	        $Domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST);
	        if(parse_url($url, PHP_URL_HOST)=='www.ketnoitieudung.vn'){
	            $pre_remove .= ',/c1,/c2';
	        }elseif(parse_url($url, PHP_URL_HOST)=='www.hanoicomputer.vn'){
	            $pre_remove .= ',cpu-pc=,nhu-cau=,dvd-pc=,ram-pc=,dloc=,o-cung-pc=,he-dieu-hanh-pc=,kich-co-man-hinh-pc=,5trieu,10trieu,12trieu,18trieu';
	        }
	        $a_url = @array_unique($a_url);
	        $a_url = is_array($a_url) ? $a_url : [];
	        
	        if($pre_remove && $pre_remove!=''){
	            $a_remove = explode(",", $pre_remove);
	            foreach ($a_url AS $k=>$item){
	                foreach ($a_remove AS $v){
	                    if(strpos($a_url[$k], trim($v))!==false){
	                        unset($a_url[$k]);
	                        break;
	                    }
	                }
	            }
	        }
	        $a_url = array_values($a_url);
	        
	        foreach ($a_url AS $k=>$item){
	            $a_item = explode(".", $item);
	            $typeurl = end($a_item);
	            if($item==''||$item=='/'||$item=='./'||@$item[0]=='#'||@$item[0]=="'") unset($a_url[$k]);
	            elseif(substr_count($item, '?')>1||substr_count($item, '"')>0||substr_count($item, '|')>0) unset($a_url[$k]);
	            elseif(strpos($item, '{')!==false && strpos($item, '}')!==false) unset($a_url[$k]);
	            elseif(@$item[0]=='j'&&@$item[1]=='a'&&@$item[2]=='v'&&@$item[3]=='a') unset($a_url[$k]);
	            elseif($url && ($Domain==$item||$Domain."/"==$item||$Domain."/."==$item)) unset($a_url[$k]);
	            elseif(strpos($item, 'tel:')!==false||strpos($item, 'skype:')!==false||strpos($item, 'mailto:')!==false) unset($a_url[$k]);
	            elseif(strpos($item, '../')!==false) unset($a_url[$k]);
	            elseif(strpos($item, '#')!==false){
	                $ex_url = explode('#', $item);
	                $a_url[$k] = $ex_url[0];
	            }
	            elseif(in_array(strtoupper($typeurl), array('JPG','JPEG','PNG','GIF','PDF','SWF','RAR','ZIP','TXT','DOC','DOCX','MP4','MP3'))) unset($a_url[$k]);
	            elseif($url && filter_var($item, FILTER_VALIDATE_URL) === FALSE){
	                if(!parse_url($item, PHP_URL_SCHEME)){
	                    if(@$item[0]=='?'){
	                        $a_ex_url = explode("?", $url);
	                        $a_url[$k] = $a_ex_url[0] . $item;
	                    }elseif(@$item[0]==@$item[1] && @$item[1]=="/"){
	                        $a_url[$k] = parse_url($Domain, PHP_URL_SCHEME).":".$item;
	                    }elseif(@$item[0]=="." && @$item[1]=="/"){
	                        $a_url[$k] = $Domain.substr($item, 1);
	                    }else{
	                        $item = $Domain . (@$item[0]=='/'?$item:'/'.$item);
	                        $a_url[$k] = $item;
	                    }
	                }else unset($a_url[$k]);
	            }elseif(filter_var($item, FILTER_VALIDATE_URL) && parse_url($url, PHP_URL_SCHEME)!=parse_url($item, PHP_URL_SCHEME)){
	                unset($a_url[$k]);
	            }
	            
	            if(isset($a_url[$k])){
	                if(strlen($a_url[$k])>260) unset($a_url[$k]);
	                elseif(filter_var($a_url[$k], FILTER_VALIDATE_URL) === FALSE) unset($a_url[$k]);
	                elseif($url && parse_url($Domain, PHP_URL_HOST)!=parse_url($a_url[$k], PHP_URL_HOST)) unset($a_url[$k]);
	                elseif(strpos(parse_url($Domain, PHP_URL_HOST), 'http://')!==false||strpos(parse_url($Domain, PHP_URL_HOST), 'https://')!==false) unset($a_url[$k]);
	            }
	        }
	    }
	    return @array_values($a_url);
	}
	
	
	function aasort(&$array, $key){
	    $sorter = [];
	    $ret = [];
	    reset($array);
	    foreach ($array as $ii => $va) {
	        $sorter[$ii] = $va[$key];
	    }
	    asort($sorter);
	    foreach ($sorter as $ii => $va) {
	        $ret[$ii] = $array[$ii];
	    }
	    $array = $ret;
	}
	
	
	function convert_value_concat($str, $field1 = 'key', $field2 = 'value'){
	    $ex_str = explode(';', $str);
	    $a_str = [];
	    foreach ($ex_str as $k => $item) {
	        $a_item = explode(':', $item, 2);
	        if (count($a_item) == 2) {
	            $a_str[$k][$field1] = trim($a_item[0]);
	            $a_str[$k][$field2] = trim($a_item[1]);
	        }
	    }
	    return $a_str;
	}

	function set_keyword($key, $user_id, $ip){
	    if(strlen($key)>2){
	        $history = $this->pdo->fetch_one("SELECT id FROM keyhistory
                WHERE keyword_name='".$key."' AND user_id=".$user_id." AND user_ip='".$ip."'");
	        if($history){
	            $this->pdo->query("UPDATE keyhistory SET number=number+1 WHERE id=".$history['id']);
	        }else{
				$db = $this->pdo->fetch_one("SELECT * FROM keywords WHERE name='".$key."'");
				if ($db) {
					$data = [];
					$data['keyword_id'] = intval(@$db['id']);
					$data['keyword_name'] = mb_strtolower($key);
					$data['user_id'] = $user_id;
					$data['user_ip'] = $ip;
					$data['created'] = time();
					$this->pdo->insert('keyhistory', $data);
				}
	        }
	    }
	    //$this->pdo->query("DELETE FROM keyhistory WHERE created<".strtotime("-90 day"));
	}
	
	
	function get_ip(){
	    $rt = getenv('HTTP_CLIENT_IP')?:
	    getenv('HTTP_X_FORWARDED_FOR')?:
	    getenv('HTTP_X_FORWARDED')?:
	    getenv('HTTP_FORWARDED_FOR')?:
	    getenv('HTTP_FORWARDED')?:
	    getenv('REMOTE_ADDR');
	    return $rt;
	}
}