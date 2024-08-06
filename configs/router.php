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

$domain_api = 'v1.api.daisan.vn/api';
$domain = 'xaydung.daisan.asia';

if(is_localhost()){
	$domain = 'daisan';
	$domain_api = 'v1.api.daisan.vn/api';

	define('DOMAIN_API', 'http://'.$domain_api.'/');
    define('DOMAIN', 'http://' . $domain.'/');
	define('URL_ADMIN', DOMAIN . 'ds_admin/');
    define('URL_PAGEADMIN', DOMAIN.'sellercenter/');
    define('URL_PAGE', DOMAIN.'shop/');
    define('URL_SOURCING', DOMAIN.'sourcing/');
	define('URL_HELPCENTER', DOMAIN.'helpcenter/');
	define('URL_BLOG', DOMAIN.'blog/');
}else{
    define('DOMAIN_API', 'http://'.$domain_api.'/');
    define('DOMAIN', 'http://'.$domain.'/');
    define('URL_ADMIN', DOMAIN . 'ds_admin/');
    define('URL_PAGEADMIN', DOMAIN.'sellercenter/');
    define('URL_PAGE', DOMAIN.'shop/');
    define('URL_SOURCING', DOMAIN.'sourcing/');
	define('URL_HELPCENTER', DOMAIN.'helpcenter/');
	define('URL_BLOG', 'http://blog'.$domain.'/');
}

define('ROUTER_SEARCH', 'product');
define("URL_IMAGE", DOMAIN. 'site/upload/');
define("URL_IMAGE_S3", "http://daisan-image.s3.amazonaws.com/upload/");

// define("URL_IMAGE_CDN", "http://daisan.vn/site/upload/");
// define("URL_IMAGE_CDN", "http://static01.daisan.vn/site/upload/");

$router = [];
$router[ROUTER_PRODUCT_CATEGORY."(:id)"] = array('mod'=>'product', 'site'=>'category');
$router[ROUTER_PRODUCT_LIST."(:id)"] = array('mod'=>'product', 'site'=>'index');
$router[ROUTER_EVENT."(:id)"] = array('mod'=>'event', 'site'=>'products');
$router[ROUTER_EVENT] = array('mod'=>'event', 'site'=>'index');
$router[ROUTER_SEARCH] = array('mod'=>'product', 'site'=>'search');
$router[ROUTER_NATION] = array('mod'=>'home', 'site'=>'nation');
$router[ROUTER_BLOG."(:id)"] = array('mod'=>'posts','site'=>'index');
$router[ROUTER_BLOG_TAG."(:id)"] = array('mod'=>'posts','site'=>'tag');
$router['login'] = array('mod'=>'account', 'site'=>'login');
$router['supplier'] = array('mod'=>'page', 'site'=>'index');
$router[ROUTER_SUPPLIER."(:id)"] = array('mod'=>'page', 'site'=>'category');
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

$router['shop/(:pageId)'] = array('mod'=>'shop', 'site'=>'index');
$router['sourcing'] = array('mod'=>'sourcing', 'site'=>'index');

$router['helpcenter'] = array('mod'=>'helpcenter', 'site'=>'index');
$router['helpcenter/detail.html'] = array('mod'=>'helpcenter', 'site'=>'detail');
$router['helpcenter/search.html'] = array('mod'=>'helpcenter', 'site'=>'search');

$router['blog/(:cid)'] = array('mod'=>'posts', 'site'=>'index');
$router['blog/tag/(:id)'] = array('mod'=>'posts', 'site'=>'tag');

$router['dangkynhaban'] = array('mod'=>'page', 'site'=>'dangkynhaban');

function router_rewrire_url() {
	global $router;

	$url = trim($_SERVER['REQUEST_URI'], '/');

	$parse_query = parse_url($url, PHP_URL_QUERY);
	if ($parse_query) {
        parse_str($parse_query, $param);
        if (isset($param['mod'])) {
			$param['site'] = $param['site']?? 'index';
            return $param;
        }
    }
	
	$url = rtrim(explode('?', $url, 2)[0], '/');

	if (isset($router[$url])) {
		return $router[$url];
	}
	elseif ($url == '') {
		return ['mod'=>'home', 'site'=>'index'];
	}
	else {
		foreach ($router as $r => $item) {
			$r = preg_replace('#\(\:([a-zA-Z0-9_]+)\)#', '(?<\1>[0-9]+)', $r);
			if (preg_match('#^'.$r.'$#', $url, $match)) {
				unset($match[0]);
				foreach ($match as $k => $v) {
					if (!is_int($k)) {
						$item[$k] = $v;
					}
				}
				return $item;
			}
		}

		if (preg_match("/[a-z0-9_-]*([0-9]+)\.(html|htm)$/i", $url, $match)) {
			$id = $match[1];
			$type = $match[2];
			if ($type == 'html') {
				return ['mod'=>'product', 'site'=>'detail', 'id'=>$id];
			}
			else {
				return ['mod'=>'posts', 'site'=>'post_detail', 'id'=>$id];
			}
		}
	}
	// return ['mod'=>'home', 'site'=>'error404'];
	return ['mod'=>'home', 'site'=>'index'];
}

function simple_html_s($pre=''){
    $rt = URL_API_MAIN;
    $m = 'parseurl';
    $s = '_db';
    if(strpos($pre, '#')!==false) list($m,$s) = explode('#', $pre, 2);
    $rt .= '?mod='.$m.'&site='.$s;
    return $rt;
}
