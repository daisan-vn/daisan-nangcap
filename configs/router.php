<?php

define('ROUTER_PRODUCT', 'product/');
define('ROUTER_PRODUCT_LIST', 'products/');
define('ROUTER_PRODUCT_CATEGORY', 'categories/');
define('ROUTER_EVENT', 'event/');
define('ROUTER_NATION', 'nations/');
define('ROUTER_POST', 'post/');
define('ROUTER_POST_LIST', 'posts/');
define('ROUTER_ALBUM', 'album/');
define('ROUTER_POST_TAG', 'tag/');
define('ROUTER_BLOG', '/');
define('ROUTER_BLOG_TAG', 'tag/');
define('ROUTER_SHOP', 'shop/');
define('ROUTER_SUPPLIER', 'supplier/');

// domain, api

$domain_api = "v1.api.daisan.vn/api";
$domain = "xaydung.daisan.asia";

if(is_localhost()){
	$domain = "daisan";
	$domain_api = "v1.api.daisan.vn/api";

	define("DOMAIN_API", "http://".$domain_api."/");
    define("DOMAIN", "http://" . $domain);
    define('URL_ADMIN', "http://" . $domain.'ds_admin/');
    define("URL_PAGEADMIN", "http://" .$domain."sellercenter/");
    define("URL_PAGE", "http://" . $domain."shop/");
    define("URL_HELPCENTER", "http://" . $domain."helpcenter/");
    define("URL_SOURCING", "http://" . $domain."sourcing/");
	define("URL_BLOG", "http://$domain/blog");
}else{
    define("DOMAIN_API", "http://".$domain_api."/");
    define("DOMAIN", "http://".$domain."/");
    define('URL_ADMIN', DOMAIN . 'ds_admin/');
    define("URL_PAGEADMIN", "http://".$domain."/sellercenter/");
    define("URL_PAGE", "http://".$domain."/shop/");
    define("URL_SOURCING", "http://$domain/sourcing/");
	define("URL_HELPCENTER", "http://$domain/helpcenter/");
	define("URL_BLOG", "http://blog.$domain/");
}
define('ROUTER_SEARCH', 'product');
define("URL_IMAGE", "http://static.daisan.vn/");
define("URL_IMAGE_S3", "http://daisan-image.s3.amazonaws.com/upload/");
define("URL_IMAGE_CDN", "http://daisan.vn/site/upload/");
//define("URL_IMAGE_CDN", "http://static01.daisan.vn/site/upload/");

$router = [];
$router[ROUTER_PRODUCT_CATEGORY."(:val)"] = array('mod'=>'product', 'site'=>'category', 'id'=>'$1');
$router[ROUTER_PRODUCT_LIST."(:val)"] = array('mod'=>'product', 'site'=>'index', 'id'=>'$1');
$router[ROUTER_EVENT."(:val)"] = array('mod'=>'event', 'site'=>'products','id'=>'$1');
$router[ROUTER_EVENT] = array('mod'=>'event', 'site'=>'index');
$router[ROUTER_SEARCH] = array('mod'=>'product', 'site'=>'search');
$router[ROUTER_NATION] = array('mod'=>'home', 'site'=>'nation');
//$router[ROUTER_BLOG] = array('mod'=>'home','site'=>'index');
$router[ROUTER_BLOG."(:val)"] = array('mod'=>'posts','site'=>'index','id'=>'$1');
$router[ROUTER_BLOG_TAG."(:val)"] = array('mod'=>'posts','site'=>'tag','id'=>'$1');
$router['login'] = array('mod'=>'account', 'site'=>'login');
$router['supplier'] = array('mod'=>'page', 'site'=>'index');
$router[ROUTER_SUPPLIER."(:val)"] = array('mod'=>'page', 'site'=>'category', 'id'=>'$1');
$router['supplier/search'] = array('mod'=>'page', 'site'=>'search');
$router['quote'] = array('mod'=>'home', 'site'=>'quote');
$router['store/finder'] = array('mod'=>'home', 'site'=>'map');
$router['product/toprank'] = array('mod'=>'product', 'site'=>'toprank');
$router['product/new'] = array('mod'=>'product', 'site'=>'new');
$router['product/readytoship'] = array('mod'=>'product', 'site'=>'readytoship');
$router['product/promotions'] = array('mod'=>'product', 'site'=>'promotions');
$router['product/allcategory'] = array('mod'=>'product', 'site'=>'allcategory');
$router['product/justforyou'] = array('mod'=>'product', 'site'=>'justforyou');
$router['product/imports'] = array('mod'=>'product', 'site'=>'imports');  
$router['product/wholesaler'] = array('mod'=>'product', 'site'=>'wholesaler');
$router['cart'] = array('mod'=>'product', 'site'=>'cart');
$router['payment'] = array('mod'=>'product', 'site'=>'payment');
$router['supplier/oem'] = array('mod'=>'page', 'site'=>'oem');
$router['supplier/toprank'] = array('mod'=>'page', 'site'=>'toprank');
$router['newshop'] = array('mod'=>'account', 'site'=>'createpage');
$router['sitemap'] = array('mod'=>'home', 'site'=>'sitemap');

$router['dangkynhaban'] = array('mod'=>'page', 'site'=>'dangkynhaban');
$router['dangkynhaban/'] = array('mod'=>'page', 'site'=>'dangkynhaban');

function router_rewrire_url(){
	// global $domain, $router;
	// $exp_domain = explode($domain.'/', $_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']);
	// $url = @$exp_domain[1];
	// unset($exp_domain);

	global $router;
	$exp_domain = explode('/', $_SERVER['REQUEST_URI'], 2);
	$url = @$exp_domain[1];
	
	if(strpos($url, 'mod=') && strpos($url, 'site=')){
		$result = router_get_value_url($url);
	}else{
		$exurl = explode("?", $url);
		$url = @$exurl[0];
		unset($exurl);
		if(isset($router[$url])){
			$result = $router[$url];
		}elseif(strpos($url, '/')){
			$exurl = explode("/", $url);
			foreach ($router AS $k=>$item){
				$exk = explode("/", $k);
				if(count($exurl)==count($exk) && $exurl[0]==$exk[0]){
				    $result = $item;
				    if($exk[1]=='(:val)') $result['id'] = $exurl[1];
					if(preg_match("/[_a-z0-9-]+(\.[_a-z0-9-]+)*.htm$/i", $result['id'])){
						$key = str_replace(".htm", "", $result['id']);
						$result = router_get_value_url("?mod=posts&site=post_detail&id=$key");
					}
				    break;
				}elseif($exurl[1]==$exk[0]){
				    $result = $item;
				    if($exk[1]=='(:val)') $result['id'] = $exurl[2];
				    break;
				}
			}
		}elseif(preg_match("/[_a-z0-9-]+(\.[_a-z0-9-]+)*.html$/i", $url)){
			$key = str_replace(".html", "", $url);
			$a_key = explode('-', $key);
			$key = end($a_key);
			$result = router_get_value_url("?mod=product&site=detail&id=$key");
		}else{
			$result = router_get_value_url("?mod=home&site=index");
		}
	}
	
	return @$result;
}


function router_get_value_url($url){
	list(,$url) = explode('?', $url);
	// if(strpos($url, '/')){
	// 	$a_url = explode('/',$url);
	// 	$url = $a_url[1];
	// }
	$url = str_replace('?', '', $url);
	$split_parameters = explode('&', $url);
	
	$split_complete = [];
	for($i = 0; $i < count($split_parameters); $i++) {
		$final_split = explode('=', $split_parameters[$i]);
		$split_complete[$final_split[0]] = @$final_split[1];
	}
	
	return $split_complete;
}

function simple_html_s($pre=''){
    $rt = URL_API_MAIN;
    $m = 'parseurl';
    $s = '_db';
    if(strpos($pre, '#')!==false) list($m,$s) = explode('#', $pre);
    $rt .= '?mod='.$m.'&site='.$s;
    return $rt;
}

function get_ssl_page($url) {
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_REFERER, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	$result = curl_exec($ch);
	curl_close($ch);
	return $result;
}
