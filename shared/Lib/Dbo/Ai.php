<?php

namespace Lib\Dbo;

class Ai {

    use \Lib\Singleton;

    private $pdo, $str;
	
	public $type, $status;
	public $a_imgtype, $a_domaintype;
	public $folder_aimemory;
	
	protected function __construct(){
		$this->pdo = \Lib\DB::instance();
		$this->str = \Lib\Core\Text::instance();

        $this->status = array( 0 => "Chưa kích hoạt", 1 => "Hoạt động", 2 => "Khóa");
        $this->a_imgtype = array('jpg','jpeg','png','gif');
        $this->a_img_type = array("image/gif" => "gif", "image/jpg" => "jpg", "image/jpeg" => "jpeg", "image/png" => "png");
        $this->a_domaintype = array('com','net','org','edu','vn','gov');
        $this->folder_aimemory = "aimemory/";
	}
	
	
	function get_posts($limit, $where=NULL, $orderby=NULL){
		global $lang;
		$sql = "SELECT Id,Title,Description,Price,Promo,Image,Url,Created,
		        (SELECT Name FROM domains WHERE posts.Domain=domains.Domain LIMIT 1) AS Name
		        FROM posts WHERE Status=1";
		if($where!=NULL && $where!='') $sql .= " AND $where";
		if($orderby != NULL) $sql .= " ORDER BY $orderby";
		else $sql .= " ORDER BY Id DESC";
		$sql .= " LIMIT $limit";
		$posts = $this->pdo->fetch_all($sql);
	    foreach ($posts AS $k=>$item){
	        $posts[$k]['Avatar'] = $item['Image']?DOMAIN."site/upload/".$item['Image']:null;
	        $posts[$k]['Domain'] = parse_url($item['Url'], PHP_URL_SCHEME)."://".parse_url($item['Url'], PHP_URL_HOST);
	        $posts[$k]['Url_onpage'] = DOMAIN . ROUTER_DETAIL_NEWS . "?UrlId=" . $item['Id'];
	        $posts[$k]['Url_domain'] = DOMAIN . ROUTER_SEARCH . "?k=".parse_url($item['Url'], PHP_URL_HOST)."&lg=vi&pg=1";
	        if(!$item['Name']) $posts[$k]['Name'] = parse_url($item['Url'], PHP_URL_HOST);
        }
		return $posts;
	}

	
	function get_Values($html, $prefix=null){
		$str = null;
		if($prefix!=null){
			if(strpos($prefix, '||')!==false){
				$a_prefix = explode("||", $prefix);
				foreach ($a_prefix AS $item){
					$str = $this->get_Values($html, $item);
					if($str!=null && $str!='') break;
				}
			}else{
				$nth = 0;
				$pre_remove = null;
				if(strpos($prefix, '---')!==false){
					$a_prefix = explode("---", $prefix);
					$prefix = $a_prefix[0];
					$pre_remove = $a_prefix[1];
				}
				if(strpos($prefix, '-->')!==false){
					$a_prefix = explode("-->", $prefix);
					$nth = $a_prefix[1];
					$prefix = $a_prefix[0];
				}
				if($pre_remove) $this->remove_html_value($html, $prefix." ".$pre_remove);
				if($nth==='n'){
					$a_str = [];
					foreach($html->find($prefix) AS $element){
						$a_str[] = trim($element->plaintext);
					}
					$str = implode(" ", @$a_str);
				}else $str = @$html->find(trim($prefix), $nth)->plaintext;
			}
		}
		return trim($str);
	}

	
	function get_Description($html){
		$str = trim(@$html->find('meta[name=description]', 0)->content);
		if($str=='') $str = trim(@$html->find('meta[property=og:description]', 0)->content);
		if($str=='') $str = trim(@$html->find('meta[name=keywords]', 0)->content);
		if(strlen($str)<100){
			$a_h2 = [];
			foreach($html->find("body h2") AS $element){
				if(strlen(trim($element->plaintext)) > 30)
					$a_h2[] = trim($element->plaintext);
			}

			$a_h3 = [];
			foreach($html->find("body h3") AS $element){
				if(strlen(trim($element->plaintext)) > 30)
					$a_h3[] = trim($element->plaintext);
			}
			
			$a_h4 = [];
			foreach($html->find("body h4") AS $element){
				if(strlen(trim($element->plaintext)) > 30)
					$a_h4[] = trim($element->plaintext);
			}
			$str .= " ".implode(" ", $a_h2)." ".implode(" ", $a_h3)." ".implode(" ", $a_h4);
			
			if(strlen($str) < 120){
				$a_p = [];
				foreach($html->find("body p") AS $element){
					if(strlen(trim($element->plaintext)) > 30)
						$a_p[] = trim($element->plaintext);
				}
				$str .= " ".implode(" ", $a_p);
			}
		}
		return trim($str);
	}
	
	
	function remove_html_value($html, $selector){
		foreach ($html->find($selector) as $node){
			$node->outertext = '';
		}
		return $html->load($html->save());
	}
	
	
	function get_trueLink($a_url, $Url=null, $PreRemove=null, $PreActive=null){
		if(count($a_url)>0){
			$Domain = parse_url($Url, PHP_URL_SCHEME)."://".parse_url($Url, PHP_URL_HOST);
			$a_url = @array_unique($a_url);
			$a_url = is_array($a_url) ? $a_url : [];
			foreach ($a_url AS $k=>$item){
				$a_item = explode(".", $item);
				$typeurl = end($a_item);
				if($item==''||$item=='/'||$item=='./'||@$item[0]=='#'||@$item[0]=="'") unset($a_url[$k]);
				elseif(substr_count($item, '?')>1||substr_count($item, '"')>0) unset($a_url[$k]);
				elseif(strpos($item, '{')!==false && strpos($item, '}')!==false) unset($a_url[$k]);
				elseif(@$item[0]=='j'&&@$item[1]=='a'&&@$item[2]=='v'&&@$item[3]=='a') unset($a_url[$k]);
				elseif($Url && ($Domain==$item||$Domain."/"==$item||$Domain."/."==$item)) unset($a_url[$k]);
				elseif(strpos($item, 'tel:')!==false||strpos($item, 'skype:')!==false||strpos($item, 'mailto:')!==false) unset($a_url[$k]);
				elseif(strpos($item, '../')!==false) unset($a_url[$k]);
				elseif(in_array(strtoupper($typeurl), array('JPG','JPEG','PNG','GIF','PDF','SWF','RAR','ZIP','TXT','DOC','DOCX','MP4','MP3'))) unset($a_url[$k]);
				elseif($Url && filter_var($item, FILTER_VALIDATE_URL) === FALSE){
					if(!parse_url($item, PHP_URL_SCHEME)){
						if(@$item[0]=='?'){
							$a_ex_url = explode("?", $Url);
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
				}
				
				if(isset($a_url[$k])){
					if(filter_var($a_url[$k], FILTER_VALIDATE_URL) === FALSE) unset($a_url[$k]);
					elseif($Url && parse_url($Domain, PHP_URL_HOST)!=parse_url($a_url[$k], PHP_URL_HOST)) unset($a_url[$k]);
					elseif(strpos(parse_url($Domain, PHP_URL_HOST), 'http://')!==false||strpos(parse_url($Domain, PHP_URL_HOST), 'https://')!==false) unset($a_url[$k]);
					elseif($PreRemove && $PreRemove!=''){
						$a_remove = explode(";", $PreRemove);
						foreach ($a_remove AS $itemremove){
							if(strpos($a_url[$k], $itemremove)!==false){
								unset($a_url[$k]);
								break;
							}
						}
					}elseif($PreActive && $PreActive!=''){
						$a_active = explode(";", $PreActive);
						foreach ($a_active AS $itemactive){
							if(strpos($a_url[$k], $itemactive)===false){
								unset($a_url[$k]);
								break;
							}
						}
					}
				}
			}
			@asort($a_url);
		}
		return @array_values($a_url);
	}
	
	
	function get_domains($a_url){
		$a_url = @array_unique($a_url);
		foreach ($a_url AS $k=>$item){
			if(filter_var($item, FILTER_VALIDATE_URL) === FALSE){
				unset($a_url[$k]);
			}else{
				$scheme = strtolower(parse_url($item, PHP_URL_SCHEME));
				$host = strtolower(parse_url($item, PHP_URL_HOST));
				$a_host = explode('.', $host);
				$a_removehost = array_diff($a_host, $this->a_domaintype, array('www'));
				$a_removehost = array_values($a_removehost);
				if(count($a_removehost)>1 && strpos(@$a_removehost[0], 'mail')!==false) unset($a_url[$k]);
				elseif(in_array(end($a_host), $this->a_domaintype) && ($scheme==='http'||$scheme==='https'))
					$a_url[$k] = $scheme."://".strtolower(parse_url($item, PHP_URL_HOST));
				else unset($a_url[$k]);
			}
		}
		$a_url = @array_unique($a_url);
		asort($a_url);
		return @array_values($a_url);
	}
	
	
	function save_urltomemory($a_url, $Url, $filename=null){
		$a_url = $this->get_trueLink($a_url, $Url);
		$Domain = $this->get_domainname($Url);
		if($filename===null) $file = $this->folder_aimemory.$Domain.".ini";
		else $file = $this->folder_aimemory.$filename;
		$a_url_saved = is_file($file)?parse_ini_file($file):[];
		$a_url_new = array_diff($a_url, $a_url_saved);
		if(count($a_url_new)>0){
			foreach ($a_url_new AS $k=>$item){
				$a_url_saved[] = $a_url[$k];
			}
			$a_url_saved = @array_unique($a_url_saved);
			@asort($a_url_saved);
			@file_put_contents($file, lib_arr_to_ini(@array_values($a_url_saved)));
		}
	}
	
	
	function get_imgsource($imagesource, $Domain){
		if($imagesource!=null){
			$sourceDomain = parse_url($imagesource, PHP_URL_HOST)?(parse_url($imagesource, PHP_URL_SCHEME)."://".parse_url($imagesource, PHP_URL_HOST)):null;
			if($sourceDomain!=null && $sourceDomain==$Domain){
				$a_source = explode("/", $imagesource);
				$imgname = rawurlencode(end($a_source));
				array_pop($a_source);
				$imagesource = implode("/", $a_source)."/".$imgname;
			}elseif($sourceDomain==null){
				$imagesource = $imagesource[0]=="/"?$Domain.$imagesource:$Domain."/".$imagesource;
			}elseif(!parse_url($imagesource, PHP_URL_SCHEME) && parse_url($imagesource, PHP_URL_HOST)){
				if($imagesource[0]=="/" && $imagesource[1]=="/")
					$imagesource = parse_url($Domain, PHP_URL_SCHEME).":".$imagesource;
				elseif($imagesource[0]=="/" && $imagesource[1]!="/")
					$imagesource = parse_url($Domain, PHP_URL_SCHEME).":/".$imagesource;
				else $imagesource = parse_url($Domain, PHP_URL_SCHEME)."://".$imagesource;
			}
		}
		$imagetype = null;
		if(isset($imagesource) && $imagesource!=null){
			$type = "jpg";
			foreach ($this->a_imgtype AS $item){
				if(strpos($imagesource, $item)!==false){
					$type = $item;
					break;
				}elseif(strpos($imagesource, strtoupper($item))!==false){
					$type = strtoupper($item);
					break;
				}
			}
			$a_image = explode($type, $imagesource);
			$imagesource = $a_image[0].strtolower($type);
		}
		return $imagesource;
	}
	
	
	function get_allLink_from_url($Url){
		$html = $this->get_html_obj($Url);
		
		$a_url = [];
		if($html){
			foreach($html->find('a') as $element){
				$a_url[] = $element->href;
			}
			$a_url = $this->get_trueLink($a_url, $Url, null, 0);
		}
		return $a_url;
	}
	
	
	function get_html_obj($Url){
		$html = \Lib\Help\HtmlDomParser::file_get_html($Url);
		if($html===false){
			$context = stream_context_create(array('http' => array('header' => 'User-Agent: Mozilla compatible')));
			$str = @file_get_contents($Url, false, $context);
			if(strlen($str)<100){
				$str = $this->get_fcontent($Url);
				$str = $str[0];
			}
			$html = \Lib\Help\HtmlDomParser::str_get_html($str);
		}
		return $html;
	}
	
	
	function get_Code($str){
		$a_str = explode(":", $str);
		if(count($a_str)>1) $str = trim($a_str[1]);
		return $str;
	}
	
	
	function get_Price($str){
		$a_str = explode(":", $str);
		if(count($a_str)>1) $str = trim(@$a_str[1]);
		$str = str_replace("&#8363;", "", $str);
		$str = preg_replace("/[^0-9]/","",$str);
		if(($str%100)!=0) $str = 0;
		return $str;
	}
	
	
	function show_price($price=0, $promo=0){
		$str = @number_format($price)." đ";
		if($promo!=0 && $price>0) $str = @number_format($promo)." đ ~ ".@number_format($price)." đ";
		return $str;
	}
	
	
	function get_size_imgthumb(array $size, $max=200){
		$result['w'] = 0;
		$result['h'] = 0;
		if($size){
			if($size[0]>$size[1]){
				$result['w'] = $max;
				$result['h'] = intval(($max/$size[0])*$size[1]);
			}elseif($size[0]<$size[1]){
				$result['h'] = $max;
				$result['w'] = intval(($max/$size[1])*$size[0]);
			}else{
				$result['w'] = $max;
				$result['h'] = $max;
			}
		}
		return $result;
	}
	
	
	function get_Timer($str){
		$a_str = explode(" ", $str);
		$h = null;
		$d = null;
		foreach ($a_str AS $item){
			if(strpos($item, ':')!==false && strlen($item)>=5) $h = $item;
			if((strpos($item, '/')!==false || strpos($item, '-')!==false) && strlen($item)>=5) $d = $item;
		}
		$d = str_replace("/","-",$d);
		$a_d = explode("-", $d);
		$d_true = false;
		foreach ($a_d AS $item){
			if(strlen($item)==4){
				$d_true = true;
				break;
			}
		}
		if(!$d_true){
			$y = end($a_d);
			$y = date("Y", strtotime("$y-01-01"));
			$d = date("Y-m-d", strtotime($y."-".@$a_d[1]."-".@$a_d[0]));
		}
		if($h && $d) $time = $d." ".$h;
		else $time = date("Y-m-d H:i:s");
		 
		return date("Y-m-d H:i:s", strtotime($time));
	}
	
	
	function parse_Address($str){
		$a_address = [];
		$a_str = [];
		if(substr_count($str, ',')>2) $a_str = @explode(",", $str);
		elseif(substr_count($str, '-')>2) $a_str = @explode("-", $str);
		
		if(count($a_str)>3){
			if(mb_strtolower(trim(end($a_str)))=='việt nam') @array_pop($a_str);
			$number = count($a_str);
			$a_address['province'] = $this->get_address(trim(@$a_str[$number-1]));
			unset($a_str[$number-1]);
			$a_address['district'] = $this->get_address(trim(@$a_str[$number-2]));
			unset($a_str[$number-2]);
			$a_address['wards'] = $this->get_address(trim(@$a_str[$number-3]));
			unset($a_str[$number-3]);
			$a_address['address'] = trim(implode(",", $a_str));
		}
		
		return $a_address;
	}
	
	
	function convert_address_full($str){
		$a_address = [];
		$a_str = [];
		if(substr_count($str, ',')>2) $a_str = @explode(",", $str);
		elseif(substr_count($str, '-')>2) $a_str = @explode("-", $str);
		foreach ($a_str AS $k=>$item){
			$a_str[$k] = trim($item);
		}
		return implode(", ", $a_str);
	}
	
	
	function get_address($str){
		$result = null;
		if($str){
			$a_prefix = array(
					'tỉnh','thành phố','quận','huyện','thị xã','xã','phường','thị trấn',
					't.','tp.','q.','h.','tx.','x.','p.','tt.','t','tp','q','h','tx','p','tt'
			);
			$str = $this->str->get_position_ofstr_byprefix($str, "(|[");
			if($str!=''&&$str!=null){
				$a_str = explode(' ', $str);
				if(in_array(mb_strtolower(@$a_str[0]), $a_prefix)){
					unset($a_str[0]);
				}elseif(in_array(mb_strtolower(@$a_str[0]." ".@$a_str[1]), $a_prefix)){
					unset($a_str[0]);
					unset($a_str[1]);
				}
				$result = implode(" ", $a_str);
			}
		}
		return trim($result);
	}
	
	
	function get_locationId($str){
		$a_address = $this->parse_Address($str);
		$province = $this->pdo->fetch_one("SELECT Id FROM locations WHERE Parent=0 AND Name='".@$a_address['province']."'");
		$a_value = [];
		if($province){
			$a_value['ProvinceId'] = $province['Id'];
			$district = $this->pdo->fetch_one("SELECT Id FROM locations WHERE Parent=".$province['Id']." AND Name='".@$a_address['district']."'");
			if($district){
				$a_value['DistrictId'] = $district['Id'];
				$wards = $this->pdo->fetch_one("SELECT Id FROM locations WHERE Parent=".$district['Id']." AND Name='".@$a_address['wards']."'");
				$a_value['WardsId'] = $wards['Id'];
			}
		}
		return $a_value;
	}
	
	
	function get_AiNextlink($id, $url){
		$str = "<li id=\"Url$id\">";
		$str .= "<i class=\"fa fa-fw fa-spinner fa-spin fa-2x\"></i> ";
		$str .= $url;
		$str .= "</li>";
		return $str;
	}
	
	
	function get_fcontent( $url,  $javascript_loop = 0, $timeout = 5 ) {
		$url = str_replace( "&amp;", "&", urldecode(trim($url)) );
	
		$cookie = tempnam ("/tmp", "CURLCOOKIE");
		$ch = curl_init();
		curl_setopt( $ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; rv:1.7.3) Gecko/20041001 Firefox/0.10.1" );
		curl_setopt( $ch, CURLOPT_URL, $url );
		curl_setopt( $ch, CURLOPT_COOKIEJAR, $cookie );
		@curl_setopt( $ch, CURLOPT_FOLLOWLOCATION, true );
		curl_setopt( $ch, CURLOPT_ENCODING, "" );
		curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
		curl_setopt( $ch, CURLOPT_AUTOREFERER, true );
		curl_setopt( $ch, CURLOPT_SSL_VERIFYPEER, false );    # required for https urls
		curl_setopt( $ch, CURLOPT_CONNECTTIMEOUT, $timeout );
		curl_setopt( $ch, CURLOPT_TIMEOUT, $timeout );
		curl_setopt( $ch, CURLOPT_MAXREDIRS, 10 );
		$content = curl_exec( $ch );
		$response = curl_getinfo( $ch );
		curl_close ( $ch );
		if ($response['http_code'] == 301 || $response['http_code'] == 302) {
			ini_set("user_agent", "Mozilla/5.0 (Windows; U; Windows NT 5.1; rv:1.7.3) Gecko/20041001 Firefox/0.10.1");
			if ( $headers = @get_headers($response['url']) ) {
				foreach( $headers as $value ) {
					if ( substr( strtolower($value), 0, 9 ) == "location:" )
						return $this->get_fcontent( trim( substr( $value, 9, strlen($value) ) ) );
				}
			}
		}
	
		if (( preg_match("/>[[:space:]]+window\.location\.replace\('(.*)'\)/i", $content, $value) || preg_match("/>[[:space:]]+window\.location\=\"(.*)\"/i", $content, $value) ) && $javascript_loop < 5) {
			return $this->get_fcontent( $value[1], $javascript_loop+1 );
		} else {
			return array( $content, $response );
		}
	}
	
	
	function ai_curl($base){
		$timeout=30;
		$curl = curl_init();
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($curl, CURLOPT_HEADER, false);
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($curl, CURLOPT_URL, $base);
		curl_setopt($curl, CURLOPT_REFERER, $base);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, TRUE);
		$str = curl_exec($curl);
		curl_close($curl);
		return $str;
	}
	
	
	function get_url_nextstep(array $a_url){
		$result['number'] = count($a_url);
		if(count($a_url)>0){
			reset($a_url);
			$UrlId = @key($a_url);
			$result['UrlId'] = $UrlId;
			$result['str'] = "<li id=\"Url$UrlId\">";
			$result['str'] .= "<i class=\"fa fa-fw fa-spinner fa-spin fa-2x\"></i> ";
			$result['str'] .= "<a href='".@$a_url[$UrlId]."' target='_blank'>";
			$result['str'] .= @$a_url[$UrlId];
			$result['str'] .= "</a>";
			$result['str'] .= "</li>";
		}
		return $result;
	}
	
	
	function is_subdomain($Domain){
		$a_ex_domain = explode(".", parse_url($Domain, PHP_URL_HOST));
		$a_true_dname = array_diff($a_ex_domain, $this->a_domaintype, array('www'));
		return count($a_true_dname)>1 ? true : false;
	}
	
	
	function is_vilang($html){
		foreach(@$html->find('a') as $element){
			if(in_array($this->str->str_convert(trim($element->plaintext)), $this->set_a_vilang())) return true;
		}
		foreach(@$html->find('button') as $element){
			if(in_array($this->str->str_convert(trim($element->plaintext)), $this->set_a_vilang())) return true;
		}
		foreach(@$html->find('h1') as $element){
			if(in_array($this->str->str_convert(trim($element->plaintext)), $this->set_a_vilang())) return true;
		}
		foreach(@$html->find('h2') as $element){
			if(in_array($this->str->str_convert(trim($element->plaintext)), $this->set_a_vilang())) return true;
		}
		foreach(@$html->find('h3') as $element){
			if(in_array($this->str->str_convert(trim($element->plaintext)), $this->set_a_vilang())) return true;
		}
		foreach(@$html->find('h4') as $element){
			if(in_array($this->str->str_convert(trim($element->plaintext)), $this->set_a_vilang())) return true;
		}
		return false;
	}
	
	
	function set_a_vilang(){
		$a_vilang = array(
				'trang-chu','gioi-thieu','lien-he','tin-tuc','san-pham','dang-ky','dang-nhap','tim-kiem',
				'chi-tiet','xem-them','xem-tiep','xem-tin','mua-hang','dat-hang',
				'tin-nong','tin-noi-bat','tin-lien-quan'
		);
		return $a_vilang;
	}
	
	function get_domainname($Url){
		if(filter_var($Url, FILTER_VALIDATE_URL) === FALSE)
			return false;
		else{
			$a_ex_domain = explode(".", parse_url($Url, PHP_URL_HOST));
			return implode(".", array_diff($a_ex_domain, array('www')));
		}
	}
	
	function check_domaintype($Url, $type){
		$rt = 0;
		if(filter_var($Url, FILTER_VALIDATE_URL) !== FALSE && strlen($type)>=2){
			$lentype = strlen($type)+1;
			if(substr($item, -$lentype, $lentype)==='.'.$type) $rt = 1;
		}
		return $rt;
	}
	
	
	function get_array_value($html, $prefix){
		$a_value = [];
		foreach($html->find($prefix) AS $element){
			if(strlen(trim($element->plaintext)) > 0) $a_value[] = trim($element->plaintext);
		}
		return $a_value;
	}

}