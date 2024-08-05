<?php

class Blog {

    public $pdo, $str, $img;
    public $help, $post, $tax, $media, $menu, $page, $product, $user;
    public $smarty, $_get, $arg;
    public $lang, $translate;

    function __construct() {
        global $tpl, $mod, $site, $smarty, $login, $reg, $lang, $_get;

        $this->smarty = $smarty;
        $this->pdo = \Lib\DB::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->help = \Lib\Dbo\Help::instance();
        $this->user = \Lib\Dbo\User::instance();
        $this->post = \Lib\Dbo\Post::instance();
        $this->product = \Lib\Dbo\Product::instance();
        $this->menu = \Lib\Dbo\Menu::instance();
        $this->page = \Lib\Dbo\Page::instance();
        $this->tax = \Lib\Dbo\Taxonomy::instance();
        $this->media = \Lib\Dbo\Media::instance();

        $this->option = array ();
        $this->option ['contact'] = $this->get_options ( 'contact' );
        $this->option ['seo'] = $this->get_options ( 'seo' );
        $this->option ['link'] = $this->get_options ( 'link' );
        $this->_get = $_get;

        $this->hcache = isset($_COOKIE['HodineCache'])?json_decode($_COOKIE['HodineCache'], true):[];
        if($login!=0 && $this->hcache['user']==null){
            $user = $this->pdo->fetch_one("SELECT id,name,avatar,phone,email,isadmin FROM users WHERE id=$login");
            $user['avatar'] = $this->img->get_image($this->user->get_folder_img($login), $user['avatar']);
            $this->hcache['user'] = $user;
            setcookie('HodineCache', json_encode($this->hcache), time() + (86400 * 30 * 30), "/");
        }elseif($login==0 && @$this->hcache['user']['id']!=0){
            $_SESSION[SESSION_LOGIN_DEFAULT] = intval(@$this->hcache['user']['id']);
            $login = intval(@$this->hcache['user']['id']);
        }
        $this->cache_tax = $this->get_afjson_file(FILE_TAX);
        if(!is_array($this->cache_tax)||count($this->cache_tax)==0) $this->cache_tax = $this->set_tax();
        $this->key_trend = $this->get_afjson_file(FILE_KEYWORD_TREND);

        $a_filter_type = array('Products','Suppliers','Quotes');
        $a_filter = array(
        		'type' => $this->help->get_select_from_array($a_filter_type, isset($_GET['t'])?$_GET['t']:0),
        		'key' => isset($_GET['k'])?$_GET['k']:''
        );

        $this->arg = array(
            'stylesheet' => DOMAIN . "site/blog/webroot/",
    		'timenow' => time(),
            'domain' => DOMAIN,
            'thislink' => THIS_LINK,
            'mod' => $mod,
            'site' => $site,
    		'lang' => $lang,
    		'login' => $login,
    		'noimg' => NO_IMG,
            'logo' => $this->media->get_image_byid(1),
            'search_key' => isset($_GET['key'])?trim($_GET['key']):null,
            'url_blog' => URL_BLOG,
            'client_id' => GOOGLE_CLIENT_ID,
        );
        
        $this->get_seo_metadata();
        
        $this->smarty->assign('a_main_category', $this->tax->get_taxonomy('category', 0, null, null, 1));
        $user = $this->pdo->fetch_one("SELECT * FROM users WHERE id=$login");
        $user['avatar'] = $this->img->get_image($this->user->get_folder_img($login), $user['avatar']);
        $this->smarty->assign('user', $user);

        $this->smarty->assign('filter_key', isset($_GET['key'])?trim($_GET['key']):'');

        $taxs['p1'] = $this->post->get_array_posts_with_taxposition(1,'category',1,8);
		$taxs['p2'] = $this->post->get_array_posts_with_taxposition(2,'category',1,5);
		$taxs['p3'] = $this->post->get_array_posts_with_taxposition(3,'category',1);
		$this->smarty->assign('taxs',$taxs);

        $sql_tag = "SELECT a.id,a.name,a.alias FROM taxonomy a WHERE a.status=1 AND a.type='tag' ORDER BY a.featured DESC,a.lft LIMIT 8";
		$stmt = $this->pdo->getPDO()->prepare($sql_tag);
        $stmt->execute();
        while ($item = $stmt->fetch()) {
				//$item['url'] = DOMAIN . ROUTER_BLOG_TAG . $item['alias'];
                $item['url'] = ROUTER_BLOG_TAG . $item['alias'];
                $tags[] = $item;
        }
		$this->smarty->assign('tags', $tags);
        
        $this->smarty->assign('arg', $this->arg);
        $this->smarty->assign('js_arg', json_encode($this->arg));
        $this->smarty->assign('filter', $a_filter);
        $this->smarty->assign('hcache', $this->hcache);
        $this->smarty->assign('tax', $this->cache_tax);
        $this->smarty->assign('is_mobile',isMobile());
        $this->smarty->assign('a_menu_top', $this->menu->get_menu_arr('top'));
        $this->smarty->assign('a_menu_main',$this->menu->get_menu_arr('main'));
        $this->smarty->assign('a_menu_foot', $this->menu->get_menu_arr('foot'));
        $this->smarty->assign('content', $tpl);
    }
    
    
    function get_seo_metadata($title=null, $keyword=null, $description=null, $image=null) {
    	if($image==NO_IMG) $image = URL_UPLOAD."generals/metaimage.jpg";
    
    	$metadata = [];
    	$metadata['title'] = $title;
    	$metadata['keyword'] = $keyword;
    	$metadata['description'] = $description;
    	$metadata['image'] = $image;
    	if ($title == null || $title=='')  $metadata['title'] = @$this->option['seo']['title'];
    	if ($keyword == null || $title=='') $metadata['keyword'] = @$this->option['seo']['keyword'];
    	if ($description == null || $title=='') $metadata['description'] = @$this->option['seo']['description'];
    	$this->smarty->assign('metadata', $metadata);
    	return $metadata;
    }
    
    
    function get_menu_tree($id, $str=null){
        $taxonomy = $this->pdo->fetch_one("SELECT id,name,parent,type,level FROM taxonomy WHERE id=$id");
        if($taxonomy){
            $taxonomy['url'] = "?mod=posts&site=index&cid=".$taxonomy['id'];
            $strli = "<li class=\"breadcrumb-item\"><a href=\"".$taxonomy['url']."\">".$taxonomy['name']."</a></li>";
            $str = $strli.$str;
        }
        if($taxonomy['parent']!=0){
            $str = self::get_menu_tree($taxonomy['parent'], $str);
        }
        return $str;
    }
    function get_min_of_category($category=[]){
        $mintax['id'] = 0;
        $mintax['level'] = -1;
        foreach ($category AS $k=>$item){
            if($item['level']>$mintax['level']){
                $mintax['id'] = $item['id'];
                $mintax['level'] = $item['level'];
            }
        }
        return $mintax['id'];
    }
    function get_taxonomy_rls_array($post_id, $type='post'){
        global $lang;
        $result = [];
        $sql = "SELECT id,name,alias,level FROM taxonomy
    			WHERE status=1 AND lang='$lang' AND id IN
    				(SELECT taxonomy_id FROM taxonomyrls WHERE type='$type' AND post_id=$post_id)
    			ORDER BY lft";
        
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        while ($item = $stmt->fetch()) {
            $prefix = null;
            for ($i=0; $i<$item['level']; $i++) {
                $prefix .= "&#8212; ";
            }
            $item['sub_name'] = $prefix . $item['name'];
            $item['url'] = "?mod=posts&site=index&cid=".$item['id'];
            $result[] = $item;
        }
        return $result;
    }
    function get_type_with_posttype($post_type){
        $type = 'category';
        switch ($post_type){
            case 'post':
                $type = 'category';
                break;
            case 'product':
                $type = 'product_cate';
                break;
            case 'project':
            case 'page':
            case 'album':
            case 'image':
                $type = null;
                break;
        }
        return $type;
    }
//     function get_breadcrumb($type='category', $post_id=0, $taxonomy_id=0, $custom=null){
//         $str = "<li class='breadcrumb-item'/><a href='./' title='Trang chủ'>".@$this->translate['home']."</a></li>";
//         if($type=='category' || $type=='product_cate'){
//             $str .= $this->tax->get_breadcrumb($type, $taxonomy_id, $this->translate);
//         }else if($type==null && $custom!=null){
//             $str .= "<li class='breadcrumb-item'>$custom</li>";
//         }
//         if($post_id!=0){
//             if($type=='category')
//                 $str .= $this->post->get_breadcrumb($post_id);
//                 elseif ($type=='product_cate')
//                 $str .= $this->product->get_breadcrumb($post_id);
//         }
//         $this->smarty->assign('breadcrumb', $str);
//     }
   
    function get_breadcrumb($taxonomy_id){
        $str = "<ol class=\"breadcrumb\">";
        $str .= "<li class=\"breadcrumb-item\"><a href=\"./\">Blog</a></li>";
        $str .= $this->get_menu_tree($taxonomy_id);
        $str .= "</ol>";
        $this->smarty->assign('breadcrumb', $str);
    }
    
    
    function get_options($type = null, $use_lang = 1){
    	global $lang;
    	$options = array ();
    	$sql = "SELECT name,value FROM options WHERE name IS NOT NULL";
    	if($use_lang == 1) $sql .= " AND lang='$lang'";
    	if($type != null) $sql .= " AND type='$type'";
    
    	$stmt = $this->pdo->getPDO()->prepare($sql);
    	$stmt->execute ();
    	while($item = $stmt->fetch()){
    		$options[$item['name']] = $item['value'];
    	}
    	return $options;
    }
    function get_afjson_file($file){
        $db = json_decode(@file_get_contents($file), true);
        if(!is_array($db)) $db = [];
        return $db;
    }
}
