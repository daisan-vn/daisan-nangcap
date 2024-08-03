<?php

class Admin {

    public $pdo, $string, $img;
    public $arg;
    public $help, $user, $posts,$page, $product, $taxonomy, $media;
    public $smarty, $lang, $location, $login;

    function __construct() {
        global $tpl, $mod, $site, $smarty, $lang, $location, $login;
        $this->string = \Lib\Core\Text::instance();
        $this->pdo = \Lib\DB::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->lang = \Lib\Core\Language::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->help = \Lib\Dbo\Help::instance();
        $this->posts = \Lib\Dbo\Post::instance();
        $this->taxonomy = \Lib\Dbo\Taxonomy::instance();
        $this->user = \Lib\Dbo\User::instance();
        $this->media = \Lib\Dbo\Media::instance();
        $this->page = \Lib\Dbo\Page::instance();
        $this->product = \Lib\Dbo\Product::instance();
        $this->smarty = $smarty;
        $this->login = $login;

        // lib_dump("SELECT level,permissions FROM useradmin WHERE user_id=$login");

        $this->arg = array(
            'stylesheet' => DOMAIN . "site/admin/webroot/",
            'today' => gmdate("d-m-Y", time() + 7 * 3600),
            'this_month' => gmdate("m", time() + 7 * 3600),
            'this_year' => gmdate("Y", time() + 7 * 3600),
            'domain' => DOMAIN,
            'admin' => URL_ADMIN,
            'this_link' => THIS_LINK,
            'mod' => $mod,
            'site' => $site,
            'user' => @$this->user->get_profile(),
            'url_upload' => URL_UPLOAD,
            'img_gen' => URL_UPLOAD . "generals/",
            'noimg' => NO_IMG,
            'lang' => $lang
        );
       // $this->check_user_permission();
        $this->smarty->assign('arg', $this->arg);
        $this->smarty->assign('js_arg', json_encode($this->arg));
        $this->smarty->assign('content', $tpl);
        $this->smarty->assign('sidebar_type', 'default');
        $this->smarty->assign('use_languages', $this->lang->languages);
        $this->smarty->assign('s_location', $this->help->get_select_location($location));
    }


    function check_user_permission() {
        global $mod, $site, $login;
        $user = $this->pdo->fetch_one("SELECT level,permissions FROM useradmin WHERE user_id=$login");
        if ($user === false) {
            unset($_SESSION[SESSION_LOGIN_ADMIN]);
        }elseif ($user['level']!=6){
            $check_user_permission = $this->pdo->fetch_one("SELECT a.permission_id FROM useradminpermis a WHERE a.permission_mod='$mod' AND a.permission_site='$site' AND a.permission_id IN (" . $user['permissions'] . ")");
            $check_permission = $this->pdo->fetch_one("SELECT a.permission_id FROM useradminpermis a WHERE a.permission_mod='$mod' AND a.permission_site='$site' LIMIT 1");
            if (!$user && $check_permission) lib_redirect(URL_ADMIN."?mod=home&site=denied");
            elseif (!$check_user_permission && $check_permission) lib_redirect(URL_ADMIN."?mod=home&site=denied");
        }
    }

    function help_get_status($status, $table, $id, $custom_js=null) {
        $onclick = "onclick=\"$custom_js('$table', '$id');\"";
        if($custom_js===null) $onclick = "onclick=\"activeItem('$table', '$id');\"";
        elseif ($custom_js===0) $onclick = null;

        $result = NULL;
        if($status==0){
            $result .= "<button type=\"button\" class=\"btn btn-default btn-xs\" title=\"Đổi trạng thái\" $onclick>";
            $result .= "<i class=\"fa fa-clock-o fa-fw\"></i>";
            $result .= "</button>";
        }elseif($status==1){
            $result .= "<button type=\"button\" class=\"btn btn-success btn-xs\" title=\"Đổi trạng thái\" $onclick>";
            $result .= "<i class=\"fa fa-check fa-fw\"></i>";
            $result .= "</button>";
        }else{
            $result .= "<button type=\"button\" class=\"btn btn-danger btn-xs\" title=\"Chưa được kích hoạt\" $onclick>";
            $result .= "<i class=\"fa fa-lock fa-fw\"></i>";
            $result .= "</button>";
        }
        return $result;
    }


    function help_get_featured($status, $table, $id) {
        $onclick = "onclick=\"setFeatured('$table', '$id');\"";
        $result = NULL;
        if($status==0){
            $result .= "<button type=\"button\" class=\"btn btn-default btn-xs\" title=\"Đặt làm mục nổi bật\" $onclick>";
            $result .= "<i class=\"fa fa-close fa-fw\"></i>";
            $result .= "</button>";
        }elseif($status==1){
            $result .= "<button type=\"button\" class=\"btn btn-success btn-xs\" title=\"Bỏ nổi bật\" $onclick>";
            $result .= "<i class=\"fa fa-check fa-fw\"></i>";
            $result .= "</button>";
        }
        return $result;
    }


    function help_get_delete_value($Id, $table, $mod='help', $site='ajax_delete'){
        return "ConfirmDelete($Id, '$table', '$mod', '$site');";
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

    function get_option_item($option_name) {
        $value = $this->pdo->fetch_one("SELECT value FROM options WHERE name='$option_name'");
        if ($value) return $value['value'];
        else return false;
    }

    function savetablechangelogs($type, $table, $content=[]){
        global $login;
        $data = [];
        $data['obj'] = $table;
        $data['type'] = $type;
        $data['content'] = json_encode($content);
        $data['user_id'] = $login;
        $data['date_log'] = date('Y-m-d');
        $data['created'] = time();
        $data['source'] = 'admin';
        if($this->pdo->insert('tablechangelogs', $data)){
            $rt = true;
        }else $rt = false;
        unset($data);
        return $rt;
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
//        echo "<pre>";
//        print_r($data);
//        echo "</pre>";die;
//         all of our requests are done, we can now access the results
//        echo curl_multi_getcontent($curl);
//        $result = curl_exec($curl);
//
//        if (! $result) {
//            die("Connection Failure");
//        }
//
//
//        $resultCURL_arr = json_decode($result, true);
//        return $resultCURL_arr;

    }

    function callAPI($url, $data, $method = 'POST'){
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

    function curl_search_get_product($id){
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

    function curl_search_update_index($id, $data){
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

    function curl_search_delete_product($id){
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

    
    function _parsehtml(array $input){
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_POST, 1);
        if(is_array($input)) curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($input));
        curl_setopt($curl, CURLOPT_URL, simple_html_s('parseurl#_db'));
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