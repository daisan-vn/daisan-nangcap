<?php

class Pageadmin {

    public $pdo, $str;
    public $help, $page, $img, $user;
    public $taxonomy, $product, $media;
    public $smarty, $arg, $page_id, $profile;
    public $lang, $login;

    function __construct() {
        global $tpl, $mod, $site, $smarty, $login, $reg, $lang, $location;

        $this->smarty = $smarty;
        $this->pdo = \Lib\DB::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->help = \Lib\Dbo\Help::instance();
        $this->page = \Lib\Dbo\Page::instance();
        $this->user = \Lib\Dbo\User::instance();
        $this->taxonomy = \Lib\Dbo\Taxonomy::instance();
        $this->product = \Lib\Dbo\Product::instance();
        $this->media = \Lib\Dbo\Media::instance();
        $this->login = $login;

        if ($site == 'connect') {
            return;
        }
        
        $manager = \Auth::getPageManager();
        if ($manager) {
            $this->page_id = $manager['page_id'];
        }
        else {
            lib_redirect(DOMAIN);
        }

        $this->profile = $this->page->get_profile($this->page_id);

        if ($manager['type'] == 'user') {
            $pageuser = $this->pdo->fetch_one("SELECT u.id,u.name,u.avatar
                    FROM pageusers a LEFT JOIN users u ON u.id=a.user_id
                    WHERE a.user_id=".$login." AND a.page_id=".$this->page_id. " LIMIT 1");

            if ($this->profile['status'] != 1) {
                echo 'Gian hàng bạn truy cập đã bị khóa hoặc không tồn tại.';
                exit();
            }

            $pageuser['panel_url'] = '?mod=account&site=index';
            $pageuser['avatar'] = $this->img->get_image($this->user->get_folder_img($pageuser['id']), $pageuser['avatar']);
        }
        else {
            $pageuser = [];
            $pageuser['panel_url'] = '/ds_admin/';
            $pageuser['name'] = 'Admin';
            $pageuser['avatar'] = URL_UPLOAD . 'logo/super_admin_avatar.png';
        }

        $this->profile['neworders'] = $this->pdo->count_item('productorders', 'status=0 AND page_id='.$this->page_id);
        $this->profile['newcontact'] = $this->pdo->count_item('pagemessages', 'parent=0 AND status=0 AND page_id='.$this->page_id);
        
        $this->arg = array(
            'stylesheet' => DOMAIN . "site/sellercenter/webroot/",
            'timenow' => time(),
            'domain' => DOMAIN,
            'url_pageadmin' => URL_PAGEADMIN,
            'url_upload' => URL_UPLOAD,
            'thislink' => THIS_LINK,
            'mod' => $mod,
            'site' => $site,
            'lang' => $lang,
            'login' => $login,
            'noimg' => NO_IMG,
            'logo' => '/site/upload/logo/sellercenter_logo.png',
        );

        $this->smarty->assign('page', $this->profile);
        $this->smarty->assign('user', $pageuser);
        $this->smarty->assign('arg', $this->arg);
        $this->smarty->assign('js_arg', json_encode($this->arg));
        $this->smarty->assign('content', $tpl);
    }
    
    
    function get_pagemenu($menu, $name='page_menu'){
    	$page_menu = "";
    	foreach ($menu AS $k=>$item){
    		if($k==$this->arg['site'])
    			$page_menu .= '<a href="?mod='.$this->arg['mod'].'&site='.$k.'" class="btn btn-primary">'.$item.'</a> ';
    		else
    			$page_menu .= '<a href="?mod='.$this->arg['mod'].'&site='.$k.'" class="btn btn-secondary">'.$item.'</a> ';
    	}
    	$this->smarty->assign($name, $page_menu);
    }
    function get_option_item($option_name) {
        $value = $this->pdo->fetch_one("SELECT value FROM options WHERE name='$option_name'");
        if ($value) return $value['value'];
        else return false;
    }
    function get_options($type = null, $use_lang = 1){
        global $lang;
        $options = [];
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
    function curl_search_get_product($id)
    {
        $url = "http://103.63.215.40:8080/api/products/$id";
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "GET");
        // curl_setopt($curl, CURLOPT_POSTFIELDS, $dataCURL_str);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
        )
            );
        $resultCURL = curl_exec($curl);
        curl_close($curl);
        $resultCURL_arr = json_decode($resultCURL, true);
        return $resultCURL_arr;
    }
    
    function curl_search_update_index($id, $data)
    {
        $url = "http://103.63.215.40:8080/api/products/$id";
        
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
        )
            );
        $resultCURL = curl_exec($curl);
        curl_close($curl);
        
        // $resultCURL_arr = json_decode($resultCURL, true);
        // return $resultCURL_arr;
    }
    
    function curl_search_delete_product($id)
    {
        $url = "http://103.63.215.40:8080/api/products/$id";
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");
        // curl_setopt($curl, CURLOPT_POSTFIELDS, $dataCURL_str);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
        )
            );
        $resultCURL = curl_exec($curl);
        curl_close($curl);
        $resultCURL_arr = json_decode($resultCURL, true);
        return $resultCURL_arr;
    }
    
    function callAPIUpload($url, $data, $method = 'POST')
    {
        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_VERBOSE => 1,
            CURLOPT_CUSTOMREQUEST => $method,
            CURLOPT_POSTFIELDS => $data,
        ));
        
        //create the multiple cURL handle
        $mh = curl_multi_init();
        //add the handle
        curl_multi_add_handle($mh, $curl);
        //execute the handle
        do {
            $status = curl_multi_exec($mh, $active);
            if ($active) {
                curl_multi_select($mh);
            }
        } while ($active && $status == CURLM_OK);
        //close the handles
        curl_multi_remove_handle($mh, $curl);
        curl_multi_close($mh);
        // all of our requests are done, we can now access the results
        //        echo curl_multi_getcontent($curl);
        //        $result = curl_exec($curl);
        //        if (! $result) {
        //            die("Connection Failure");
        //        }
        //        $resultCURL_arr = json_decode($result, true);
        //        return $resultCURL_arr;
        
    }
    
    function callAPI($url, $data, $method = 'POST')
    {
        $curl = curl_init();
        switch ($method) {
            case "POST":
                curl_setopt($curl, CURLOPT_POST, 1);
                if ($data)
                    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
                    break;
            case "PUT":
                curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
                if ($data)
                    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
                    break;
            default:
                if ($data)
                    $url = sprintf("%s?%s", $url, http_build_query($data));
        }
        
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'APIKEY: 111111111111111111111',
            'Content-Type: application/json'
        ));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $result = curl_exec($curl);
        //        if (! $result) {
        //            die("Connection Failure");
        //        }
        //        $resultCURL_arr = json_decode($result, true);
        return $result;
    }
    function _parsehtml(array $input){
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_POST, 1);
        if(is_array($input)) curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($input));
        curl_setopt($curl, CURLOPT_URL, scrape_product_endpoint('parseurl#_db'));
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $result = curl_exec($curl);
        curl_close($curl);
        $result = json_decode($result, true);
        if(!is_array($result)) $result = [];
        return $result;
    }
}