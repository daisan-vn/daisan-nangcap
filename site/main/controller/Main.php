<?php

class Main {
    
    public $pdo, $str, $img, $api;
    public $help, $post, $tax, $media, $menu, $page, $product, $user;
    public $smarty, $_get, $arg;
    public $lang, $translate, $login;
    public $option, $file_tax, $file_cont, $hcache, $cache_tax;
    
    function __construct() {
        global $mod, $site, $smarty, $lang, $_get, $login;
        
        $this->smarty = $smarty;
        $this->pdo = \Lib\DB::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->api = \Lib\Core\Api::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->help = \Lib\Dbo\Help::instance();
        $this->user = \Lib\Dbo\User::instance();
        $this->post = \Lib\Dbo\Post::instance();
        $this->product = \Lib\Dbo\Product::instance();
        $this->menu = \Lib\Dbo\Menu::instance();
        $this->page = \Lib\Dbo\Page::instance();
        $this->tax = \Lib\Dbo\Taxonomy::instance();
        $this->media = \Lib\Dbo\Media::instance();
        $this->option = [];
        $this->option['contact'] = $this->get_options('contact');
        $this->_get = $_get;

        // $this->hcache = $this->set_login();
        $this->hcache = isset($_COOKIE['HodineCache'])?json_decode($_COOKIE['HodineCache'], true):[];

        // $this->login = intval(@$this->hcache['user']['id']);
        $this->login = $login;
        
        $this->get_seo_metadata();
        $this->cache_tax = $this->get_afjson_file(FILE_TAX);
        if(!is_array($this->cache_tax)||count($this->cache_tax)==0) $this->cache_tax = $this->set_tax();
        $this->key_trend = $this->get_afjson_file(FILE_KEYWORD_TREND);
        
        $a_filter_type = array('Products','Suppliers','Quotes');
        $a_filter = array(
            'type' => $this->help->get_select_from_array($a_filter_type, isset($_GET['t'])?$_GET['t']:0),
            'key' => isset($_GET['k'])?$_GET['k']:'',
            't' => isset($_GET['t'])?intval($_GET['t']):0,
            't_txt' => 'Tất cả'
        );
        if($a_filter['t']!=0){
            foreach ($this->cache_tax['category'] AS $v){
                if($v['id']==$a_filter['t']) $a_filter['t_txt'] = $v['name'];
            }
        }
        $banners = json_decode(@file_get_contents(FILE_CONF_CONTENT), true);
        $a_ads=[];
        $i=1;
        foreach (@$banners['img_ads'] AS $key=>$value){
            foreach($banners['img_ads'][$key] AS $key1=>$value1){
                if(is_file(DIR_UPLOAD.$this->media->path_image.$value1['image']))
                    $a_ads[$i]['image'] = $this->img->get_image($this->media->path_image, $value1['image']);
                    $a_ads[$i]['link'] = $value1['link'];
                    $a_ads[$i]['position'] = $value1['position'];
                    $a_ads[$i]['description'] = $value1['description'];
                    $a_ads[$i]['size'] = $value1['size'];
                    $i++;
            }
        }
        $this->smarty->assign("banner", $a_ads);

        $a_cate_number = @parse_ini_file(FILE_CATEGORY_NUMBER);
        $this->smarty->assign('a_cate_number', $a_cate_number);
        
        $sugest_cate = [];
        foreach ($this->cache_tax['category'] AS $v){
            if($a_filter['t']==$v['id'] || $a_filter['key']==$v['name']){
                foreach ($v['sub'] AS $sub){
                    $sugest_cate[] = $sub['name'];
                }
            }
        }
        if(!$sugest_cate){
            foreach ($this->cache_tax['category'] AS $v){
                $sugest_cate[] = $v['name'];
            }
        }
        $sugest_key = (is_array(@$this->hcache['key']))?$this->hcache['key']:[];
        //lib_dump($this->cache_tax['category']);
       
        $client_id = '356627533944-f84pull2l3ipfiied3vuluqi15udap0p.apps.googleusercontent.com';
        if(check_is_localhost()) $client_id = '356627533944-gei9tqhav75602dbqgnh0u5a06olq7cn.apps.googleusercontent.com';
        $this->arg = array(
            'stylesheet' => DOMAIN . "site/main/webroot/",
            'timenow' => time(),
            'domain' => DOMAIN,
            'thislink' => THIS_LINK,
            'mod' => $mod,
            'site' => $site,
            'lang' => $lang,
            'login' => $this->login,
            'noimg' => NO_IMG,
            'img_gen' => URL_UPLOAD . "generals/",
            'url_img' => URL_UPLOAD . "images/",
            'loginimg' => LOGIN_IMG_DEFAULT,
            'url_sourcing' => URL_SOURCING,
            'url_helpcenter' => URL_HELPCENTER,

            'url_search' => 'https://search.daisan.vn/',

            // 'url_seller' => 'https://sellercenter.daisan.vn/',
            // 'url_account' => 'https://account.daisan.vn/',
            'url_seller' => '/sellercenter',
            'url_account' => '/?mod=account&site=index',

            'url_blog' => 'https://blog.daisan.vn/',
            'logo' => $this->media->get_images(1),
            'background' => $this->media->get_images(5),
            'json_keyword' => DOMAIN.'constant/info/keywords.json',
            'json_sugest_cate' => $sugest_cate,
            'json_sugest_key' => $sugest_key,
            'isadmin' => isset($this->hcache['user']['isadmin'])?$this->hcache['user']['isadmin']:0,
            'ismobile' => isMobile(),
            'client_id' => $client_id,
            'end_countdown' => date("Y/m/d", strtotime('monday next week')),
            'src' => 'construction',
            'login_token' => base64_encode(THIS_LINK)
        );
        $this->smarty->assign('a_main_category', $this->cache_tax['category']);
        $this->smarty->assign('a_sup_category', $this->cache_tax['category_sup']);
        $this->smarty->assign('hcache', $this->hcache);
        $this->smarty->assign('tax', $this->cache_tax);
        $this->smarty->assign('key_trend', $this->key_trend);
        $this->smarty->assign('arg', $this->arg);
        $this->smarty->assign('option',$this->option);
        $this->smarty->assign('js_arg', json_encode($this->arg));
        $this->smarty->assign('main_filter', $a_filter);
        $this->smarty->assign('is_mobile',isMobile());
        $this->smarty->assign('content', "../" . str_replace('_', '/', $mod) . "/" . $site . ".tpl");
    }
    
    
    function set_login(){
        $token = isset($_GET['set_login_token']) ? trim($_GET['set_login_token']) : '';
        $rt = isset($_COOKIE['HodineCache'])?json_decode($_COOKIE['HodineCache'], true):[];
        if($token!=''){
            $a_token = explode('_', base64_decode($token));
            $user = $this->pdo->fetch_one("SELECT id,name,avatar,phone,email FROM users WHERE email='".trim(@$a_token[2])."'");
            if(@$user['id']>0&&$a_token[1]>(time()-120)){
            // if(@$user['id']>0){
                $user['avatar'] = $this->img->get_image($this->user->get_folder_img($user['id']), $user['avatar']);
                $rt['user'] = $user;
                setcookie('HodineCache', json_encode($rt), time() + (86400 * 30 * 30), "/");
            }
        }elseif(isset($_GET['set_logout_token'])){
            $rt['user'] = [];
            setcookie('HodineCache', json_encode($rt), time() + (86400 * 30 * 30), "/");
        }
        return $rt;
    }
    
    
    function set_tax(){
        $db = json_decode(@file_get_contents(FILE_TAX), true);
        lib_dump($db);
        if(!is_array($db)) $db = [];
        $db['category'] = $this->tax->get_taxonomy('product', 0, null, null, 1);
        $db['category_sup'] = $this->tax->get_taxonomy('product', 0, null, null, 1,1,1);
        $db['category_hot'] = $this->tax->get_tax_position('product','a.featured=1',16);
        $db['menu_top'] = $this->menu->get_menu_arr('top');
        $db['menu_top_right'] = $this->menu->get_menu_arr('top_right');
        $db['menu_top_suggest'] = $this->menu->get_menu_arr('top_suggest');
        $db['menu_main'] = $this->menu->get_menu_arr('main');
        $db['menu_foot'] = $this->menu->get_menu_arr('foot');
        $db['menu_foot_link'] = $this->menu->get_menu_arr('foot_link');
        $db['menu_foot_other'] = $this->menu->get_menu_arr('foot_other');
        $db['province'] = $this->pdo->fetch_all("SELECT Id,Name,Prefix FROM locations a WHERE Status=1 AND Parent=0 ORDER BY Featured DESC,Sort DESC,Name");
        file_put_contents(FILE_TAX, json_encode($db));
        return $db;
    }
    

    function set_cont_home(){
        $db = json_decode(@file_get_contents(FILE_CONT), true);
        if(!is_array($db)) $db = [];
        
        $a_pid = [];
        $a_product_readytoship = $this->product->get_list_simple('a.number>0', 16, 'a.featured DESC,a.inventory DESC');
        foreach ($a_product_readytoship AS $v){
            $a_pid[] = $v['id'];
        }
        $db['a_product_readytoship'] = is_array($a_product_readytoship)?$a_product_readytoship:[];
        
        $a_product_promo = $this->product->get_list_promo("a.id NOT IN (".implode(',', $a_pid).")",16,'a.featured DESC,a.ismain DESC');
        foreach ($a_product_promo AS $v){
            $a_pid[] = $v['id'];
        }
        $db['a_product_promo'] = is_array($a_product_promo)?$a_product_promo:[];
        
        $a_product_toprank = $this->product->get_list_simple("a.featured=1 AND a.id NOT IN (".implode(',', $a_pid).")", 16, 'a.views DESC');
        //$a_product_toprank = $this->product->get_list(0, 0, "a.featured=1 AND a.id NOT IN (".implode(',', $a_pid).")", 4, null, "a.featured=1 DESC,a.score ASC,a.ismain DESC,a.views ASC");
        foreach ($a_product_toprank AS $v){
            $a_pid[] = $v['id'];
        }
        $db['a_product_toprank'] = is_array($a_product_toprank)?$a_product_toprank:[];
        
        $a_product_new = $this->product->get_list_simple("a.id NOT IN (".implode(',', $a_pid).")", 16, 'a.id DESC');
        foreach ($a_product_new AS $v){
            $a_pid[] = $v['id'];
        }
        $db['a_product_new'] = is_array($a_product_new)?$a_product_new:[];

        $a_product_import = $this->product->get_list_simple("a.isimport=1", 4,null, "a.score ASC,a.ismain DESC,a.views DESC");
        foreach ($a_product_import AS $v){
            $a_pid[] = $v['id'];
        }
        $db['a_product_import'] = is_array($a_product_import)?$a_product_import:[];

        $a_product_wholesaler = $this->product->get_list_simple("a.iswhole=1", 16,null, "a.views DESC");
        foreach ($a_product_wholesaler AS $v){
            $a_pid[] = $v['id'];
        }
        $db['a_product_wholesaler'] = is_array($a_product_wholesaler)?$a_product_wholesaler:[];
        
        $a_home_category = $this->tax->get_taxonomy('product', 0, 'a.featured=1', 8);
        foreach ($a_home_category as $k => $item) {
            $a_home_category[$k]['sub'] = $this->tax->get_taxonomy('product', $item['id'], null, 4);
           // $a_home_category[$k]['products'] = $this->product->get_list_bycate($item['id'], null, 5, 'b.featured DESC,a.featured DESC,a.views DESC');
            $a_home_category[$k]['banner'] = $this->media->get_images($item['id'],1,1,0,'banner');
        }
        $db['a_home_category'] = is_array($a_home_category)?$a_home_category:[];
        
        $a_product_page_oem = $this->product->get_list_of_page('a.is_oem=1', 3, 'b.featured,b.views DESC');
        $db['a_product_page_oem'] = is_array($a_product_page_oem)?$a_product_page_oem:[];
        
        $a_product_page_toprank = $this->product->get_list_of_page('a.featured=1',4, 'a.featured DESC,a.id DESC');
        $db['a_product_page_toprank'] = is_array($a_product_page_toprank)?$a_product_page_toprank:[];
        
        file_put_contents(FILE_CONT, json_encode($db));
        return $db;
    }
    
    function get_afjson_file($file){
        $db = json_decode(@file_get_contents($file), true);
        if(!is_array($db)) $db = [];
        return $db;
    }
    
    function get_location() {
        $sql = "SELECT Id,Name,Prefix FROM locations a WHERE Status=1 AND Parent=0 ORDER BY Featured DESC,Sort DESC,Name";
        $stmt = $this->pdo->getPDO()->prepare ( $sql );
        $stmt->execute ();
        $result = array ();
        while ( $item = $stmt->fetch () ) {
            $result [] = $item;
        }
        return $result;
    }
    function get_session_country_id(){
        $id = isset($_GET[country_id])?$_GET[country_id]:0;
        $result = $this->pdo->fetch_one("SELECT Id,Name FROM nations WHERE Id=$id");
        $_SESSION[SESSION_COUNTRY_ID] = $result['Id'];
        $url = "https://".strtolower($result['Name']).".daisan.vn";
        
        lib_redirect($url);
    }
    function get_seo_metadata($title = null, $keyword = null, $description = null, $image = null) {
        if($image == null) $image = URL_UPLOAD . "generals/metaimage.jpg";
        $this->option ['seo'] = $this->get_options ( 'seo' );
        $this->option ['contact'] = $this->get_options ( 'contact' );
        $this->option ['link'] = $this->get_options ( 'link' );
        $metadata = array ();
        $metadata ['title'] = $title;
        $metadata ['keyword'] = $keyword;
        $metadata ['description'] = $description;
        $metadata ['image'] = $image;
        if ($title == null || $title == '')
            $metadata ['title'] = @$this->option ['seo'] ['title'];
        if ($keyword == null || $title == '')
            $metadata ['keyword'] = @$this->option ['seo'] ['keyword'];
        if ($description == null || $title == '')
            $metadata ['description'] = @$this->option ['seo'] ['description'];
        $this->smarty->assign ( 'metadata', $metadata );
        return $metadata;
    }
    
     function get_menu_tree($id, $str=null){
        $taxonomy = $this->pdo->fetch_one("SELECT id,name,parent,type,level,alias FROM taxonomy WHERE id=$id");
        if($taxonomy){
            $taxonomy['url'] = $this->tax->get_url('product', $taxonomy['id'],$taxonomy['alias'],$taxonomy['level']);
            $strli = "<li class=\"breadcrumb-item\"><a href=\"".$taxonomy['url']."\">".$taxonomy['name']."</a></li>";
            $str = $strli.$str;
        }
        if($taxonomy['parent']!=0){
            $str = self::get_menu_tree($taxonomy['parent'], $str);
        }
        return $str;
    }
    
    function get_breadcrumb($taxonomy_id){
        $str = null;
        $str .= "<li class=\"breadcrumb-item\"><a href=\"./\">Trang chủ</a></li>";
        $str .= $this->get_menu_tree($taxonomy_id);
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
    function get_keywords($table, $where=null,$limit=8){
        $sql = "SELECT * FROM $table WHERE 1=1";
        if($where != null) $sql .=" AND $where";
        $sql .=" ORDER BY id DESC";
        $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        return $result;
    }
    function set_useronline($page_id)
    {
        global $login;
        $step_time = time() - 30 * 60;
        $ip = $this->get_iplog();
        $date = date("Y-m-d");
        $online = $this->pdo->fetch_one("SELECT updated,number FROM useronlines
    			WHERE user_id=$login AND date_log='$date' AND user_ip='$ip' AND page_id=$page_id");
        $data = [];
        $data['updated'] = time();
        if (!$online) {
            $data['page_id'] = $page_id;
            $data['user_id'] = $login;
            $data['user_ip'] = $ip;
            $data['date_log'] = $date;
            $data['number'] = 1;
            $this->pdo->insert('useronlines', $data);
        } elseif ($online && $online['updated'] < $step_time) {
            $data['number'] = $online['number'] + 1;
            $this->pdo->update('useronlines', $data, "user_id=$login AND date_log='$date' AND user_ip='$ip' AND page_id=$page_id");
        } else {
            $this->pdo->update('useronlines', $data, "user_id=$login AND date_log='$date' AND user_ip='$ip' AND page_id=$page_id");
        }
        //$this->pdo->query("DELETE FROM useronlines WHERE updated<=".strtotime('-30day'));
    }
    
    function get_iplog(){
        return getenv('HTTP_CLIENT_IP')?:
        getenv('HTTP_X_FORWARDED_FOR')?:
        getenv('HTTP_X_FORWARDED')?:
        getenv('HTTP_FORWARDED_FOR')?:
        getenv('HTTP_FORWARDED')?:
        getenv('REMOTE_ADDR');
    }
    
    
    function accesslogs(){
        global $login;
        if(!$this->pdo->check_exist("SELECT 1 FROM accesslogs WHERE user_id=$login
            AND url='".THIS_LINK."' AND date_log='".date('Y-m-d')."' AND user_ip='".$this->str->get_client_ip()."'")){
            $data = [];
            $data['url'] = THIS_LINK;
            $data['user_id'] = $login;
            $data['date_log'] = date('Y-m-d');
            $data['updated'] = time();
            $data['user_ip'] = $this->str->get_client_ip();
            $data['ismobile'] = $this->isMobile();
            // $details = json_decode(file_get_contents("http://ipinfo.io/".$this->str->get_client_ip()."/json"));
            // if($details){
            //     $a_address = [];
            //     if(isset($details->region)) $a_address[] = $details->region;
            //     if(isset($details->city)) $a_address[] = $details->city;
            //     if(isset($details->country)) $a_address[] = $details->country;
            //     $data['location'] = implode(', ', $a_address);
            //     unset($a_address);
            // }
            
            $this->pdo->insert('accesslogs', $data);
        }
    }
    function isMobile() {
        return preg_match("/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i", @$_SERVER["HTTP_USER_AGENT"]);
    }
}