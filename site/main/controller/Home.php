<?php

class Home extends Main
{

    private $folder_rfq;

    function __construct()
    {
        parent::__construct();
        $this->folder_rfq = "rfq/";
        $this->folder = 'images/nations/';
        $this->help = \Lib\Dbo\Help::instance();
    }

    function index()
    {
        global $location;
        $out = [];
        $out['location'] = $location;
        // $a_slider = $this->media->get_images(2, 1, 8, $location);
        // $this->smarty->assign('a_slider', $a_slider);
        
        $cont = $this->get_afjson_file(FILE_CONT);
        if(!is_array($cont)||count($cont)==0||(time()-@filemtime(FILE_CONT))>86400) $cont = $this->set_cont_home();
        
        $this->smarty->assign('a_home_category', $cont['a_home_category']);
        $this->smarty->assign('a_product_new', $cont['a_product_new']);
        $this->smarty->assign('a_product_toprank', $cont['a_product_toprank']);
        $this->smarty->assign('a_product_readytoship', $cont['a_product_readytoship']);
        $this->smarty->assign('a_product_promo', $cont['a_product_promo']);
        $this->smarty->assign('a_product_import', $cont['a_product_import']);
        $this->smarty->assign('a_product_wholesaler', $cont['a_product_wholesaler']);
        $this->smarty->assign('a_product_page_oem', $cont['a_product_page_oem']);
        $this->smarty->assign('a_product_page_toprank', $cont['a_product_page_toprank']);
       
        $sql = "SELECT a.id,a.name,a.image FROM events a
                WHERE a.status=1 AND a.date_start<='".date('Y-m-d')."' AND a.date_finish>='".date('Y-m-d')."'
                ORDER BY a.sort ASC LIMIT 3";
        $event = $this->pdo->fetch_all($sql);
        foreach ($event AS $k=>$item){
            $event[$k]['avatar'] = $this->img->get_image('images/events/', $item['image']);
            $event[$k]['url'] = DOMAIN."event/".$this->str->str_convert($item['name'])."-".$item['id'];
        }
        $this->smarty->assign("event", $event);
        
        $a_slider = $this->media->get_images(2, 1, 8, $location);
        $this->smarty->assign('a_slider', $a_slider);

        $home_slider = $this->media->get_images(7, 0, 8, $location);
        $this->smarty->assign('home_slider', $home_slider);
           
        $a_ad = [];
        $a_ad['adhome']['p1'] = $this->media->get_images(3, 1, 2);
        $this->smarty->assign('a_ad', $a_ad);
       

        $hot_location = $this->pdo->fetch_all('SELECT Id,Name FROM locations WHERE Status=1 AND Featured=1 AND Parent=0 LIMIT 14');
        foreach ($hot_location AS $k=>$v){
            $hot_location[$k]['img'] = $this->arg['img_gen'].$this->str->str_convert($v['Name']).'.png';
        }
        $this->smarty->assign("hot_location", $hot_location);

        $sql_page_featured="SELECT id,name,name_short,logo,logo_custom,page_name FROM pages
        WHERE status=1 AND package_id>0 AND package_end>'".date('Y-m-d')."'ORDER BY featured DESC LIMIT 24";
        //AND package_homelogo >='".date('Y-m-d')."'
      
        $a_page_featured = $this->pdo->fetch_all($sql_page_featured);
        foreach ($a_page_featured AS $k=>$item){
            $a_page_featured[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
            $a_page_featured[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
            $a_page_featured[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
        }
        $this->smarty->assign('a_page_featured', $a_page_featured);

        $this->smarty->assign('headsearch', 1);

        $this->smarty->assign("out", $out);
        $this->smarty->display(LAYOUT_HOME);
    }

    
    function run_cache(){
        $this->set_cont_home();
        $this->set_tax();
    }
    
    function sitemap(){
        
        $this->smarty->display(LAYOUT_HOME);
    }
    
    function aboutus_home()
    {
        $a_post_service = $this->tax->get_tax_position("category", "a.position='service'");
        $this->smarty->assign('a_post_service', $a_post_service);
        $this->smarty->display(LAYOUT_ABOUTUS);
    }

    function nation()
    {
        $result = $this->pdo->fetch_all("SELECT * FROM nations");
        foreach ($result as $k => $item) {
            $result[$k]['logo'] = $this->img->get_image($this->folder, @$item['Image']);
            $result[$k]['url'] = "https://" . strtolower($item['Name']) . ".daisan.vn";
        }
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_HOME);
    }

    function get_login_result()
    {
        $fb = new Facebook\Facebook([
            'app_id' => '1152764341547099',
            'app_secret' => 'e03a834010b7270a134ed8a888077266',
            'default_graph_version' => 'v3.1'
        ]);
        $helper = $fb->getRedirectLoginHelper();

        try {
            $accessToken = $helper->getAccessToken();
        } catch (Facebook\Exceptions\FacebookResponseException $e) {
            // When Graph returns an error
            echo 'Graph returned an error: ' . $e->getMessage();
            exit();
        } catch (Facebook\Exceptions\FacebookSDKException $e) {
            // When validation fails or other local issues
            echo 'Facebook SDK returned an error: ' . $e->getMessage();
            exit();
        }

        if (! isset($accessToken)) {
            $permissions = array(
                'public_profile',
                'email'
            ); // Optional permissions
            $loginUrl = $helper->getLoginUrl('https://daisan.vn/?mod=home&site=get_login_result', $permissions);
            header("Location: " . $loginUrl);
            exit();
        }

        try {
            // Returns a `Facebook\FacebookResponse` object
            $fields = array(
                'id',
                'name',
                'email'
            );
            $response = $fb->get('/me?fields=' . implode(',', $fields) . '', $accessToken);
        } catch (Facebook\Exceptions\FacebookResponseException $e) {
            echo 'Graph returned an error: ' . $e->getMessage();
            exit();
        } catch (Facebook\Exceptions\FacebookSDKException $e) {
            echo 'Facebook SDK returned an error: ' . $e->getMessage();
            exit();
        }

        $user = $response->getGraphUser();
        global $domain;
        if ($this->pdo->check_exist("SELECT 1 FROM users WHERE username='" . $user['id'] . "'")) {
            $userlogin = $this->pdo->fetch_one("SELECT id FROM users WHERE username='" . $user['id'] . "'");
            if (is_localhost())
                setcookie(COOKIE_LOGIN_ID, $userlogin["id"], time() + (86400 * 7));
            else
                setcookie(COOKIE_LOGIN_ID, $userlogin["id"], time() + (86400 * 7), "/", "." . $domain);
            $_SESSION[SESSION_LOGIN_DEFAULT] = $userlogin['id'];
        } else {
            $data = [];
            $data['username'] = $user['id'];
            $data['name'] = $user['name'];
            if (isset($user['email']))
                $data['email'] = $user['email'];
            $data['created'] = time();
            $data['status'] = 1;
            $user_id = $this->pdo->insert('users', $data);
            if (is_localhost())
                setcookie(COOKIE_LOGIN_ID, $user_id, time() + (86400 * 7));
            else
                setcookie(COOKIE_LOGIN_ID, $user_id, time() + (86400 * 7), "/", "." . $domain);
            $_SESSION[SESSION_LOGIN_DEFAULT] = $user_id;
        }

        echo 'Faceook ID: ' . $user['id'];
        echo '<br />Faceook Name: ' . $user['name'];
        if (isset($user['email']))
            echo '<br />Faceook Email: ' . @$user['email'];
        lib_redirect(DOMAIN);
        exit();
    }

    function tradeassurance()
    {
        $a_product_recommen = $this->product->get_list(0, 0, 'a.ismain=1', 12);
        $this->smarty->assign('a_product_recommen', $a_product_recommen);
        $this->smarty->display('custom.tpl');
    }

    function pricelists()
    {
        $this->smarty->display(LAYOUT_HOME);
    }

    function errorpage()
    {
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function load_search_suggest()
    {
        $key = trim(@$_POST['key']);
        $sql = "SELECT id,name,
                CASE WHEN name LIKE '$key' THEN 5 ELSE 0 END AS S1,
                CASE WHEN name LIKE '$key %' THEN 3 ELSE 0 END AS S2,
                CASE WHEN name LIKE '$key%' THEN 1 ELSE 0 END AS S3,
                CASE WHEN name LIKE '% $key %' THEN 1 ELSE 0 END AS S4
                FROM keywords WHERE name LIKE '%$key%'
                ORDER BY S1+S2+S3+S4 DESC LIMIT 10";
        if ($key == null)
            $sql = null;
        $result = $this->pdo->fetch_all($sql);
        foreach ($result as $k => $item) {
            $result[$k]['url'] = DOMAIN . "product?k=" . $item['name'] . "&kid=" . $item['id'];
        }
        $this->smarty->assign('result', $result);
        $this->smarty->display(LAYOUT_NONE);
    }

    function load_keyword_json()
    {
        $content = file_get_contents(FILE_KEYWORDS);
        echo $content;
    }

    function ajax_handle()
    {
        global $login;
        $data = $rt = [];
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'save_rfq') {
            $rt['code'] = 0;
            if ($login == 0)
                $rt['msg'] = "Vui lòng đăng nhập trước khi thực hiện chức năng.";
            elseif (! is_numeric($_POST['number']))
                $rt['msg'] = 'Vui lòng nhập số lượng chính xác.';
            else {
                $product_id = intval($_POST['product_id'] ?? 0);
                if ($product_id) {
                    $data['product_id'] = $product_id;
                }
                $data['user_id'] = $login;
                $data['title'] = trim($_POST['title']);
                $data['number'] = trim($_POST['number']);
                $data['unit_id'] = intval($_POST['unit']);
                $data['created'] = time();
                $data['status'] = 1;
                $this->pdo->insert('rfq', $data);
                $rt['code'] = 1;
                $rt['msg'] = 'Gửi yêu cầu của bạn thành công.';
            }
            echo json_encode($rt);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'save_keyhistory') {
            $key = htmlentities(trim(@$_POST['key']));
//             $kid = intval(@$_POST['kid']);
            if (preg_match_all("/select|insert|update|delete|location|script|<|>/", $key)) {
                echo "Error";
            } else if (strlen($key) > 2) {
                if (! $this->pdo->check_exist("SELECT 1 FROM keyhistory WHERE keyword_name='$key' AND user_id=$login AND created>" . (time() - 20 * 60))) {
                    $data['keyword_name'] = trim(@$_POST['key']);
                    $data['keyword_id'] = intval(@$this->pdo->fetch_one_fields('keywords', 'id', "name='$key'"));
                    $data['user_id'] = $login;
                    $data['user_ip'] = $this->str->get_client_ip();
                    $data['created'] = time();
                    $this->pdo->insert('keyhistory', $data);
                }
            }
        }else if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'send_phone_contact') {
            $data = [];
            $product_id = intval($_POST['product_id'] ?? 0);
            if ($product_id) {
                $data['product_id'] = $product_id;
            }
            $data['location_id'] = intval($_POST['location_id']);
            if ($_POST['name'] != null) $data['title'] = $_POST['name'];
            else $data['title'] = "Khách hàng cần báo giá!";
            $description = trim($_POST['description']);
            $phone = trim($_POST['phone']);
            $data['description'] = $description . ". Số điện thoại: " . $phone;
            $data['taxonomy_id'] = isset($_POST['taxonomy_id']) ? $_POST['taxonomy_id'] : 0;
            if($_POST['product_id']!=0){
                $product = $this->pdo->fetch_one("SELECT id,name,images,page_id,minorder FROM products WHERE id=".$product_id);
                $data['image'] = $this->product->get_avatar($product['page_id'], $product['images']);
                $data['title'] = $product['name'];
                $data['number'] = $product['minorder']>0?$product['minorder']:1;
            }
            $data['user_id'] = $this->arg['login'];
            $data['created'] = time();
            $data['status'] = 1;
            $id = $this->pdo->insert('rfq', $data);
            if ($id) {
                unset($data);
                $a_mail_to = ['admin@daisan.vn'];
                $a_mail_cc = ['nhamphongdaijsc@gmail.com','info@daisan.vn'];
                $a_mail_bcc = ['chungit.dsc@daisan.vn','cntt.dsc@daisan.vn'];
                if ($_POST['name'] != null) $mail_title = $_POST['name'];
                else $mail_title = "[$id]" . $_POST['description'];
                $mail_to = ['TO' => $a_mail_to, 'CC' => $a_mail_cc, 'BCC' => $a_mail_bcc];
                $mail_content = get_ssl_page(URL_SOURCING . '?site=set_mail_content&id=' . $id);
                send_mail($mail_to, 'RFQ Report', $mail_title, $mail_content);
                echo 1;
                exit();
            }
        }
    }

    // function __demo() {
    //     $id = isset($_GET['id'])? intval($_GET['id']): 0;
    //     if ($id) {
    //         $mail_content = get_ssl_page(URL_SOURCING . '?site=set_mail_content&id=' . $id);
    //         echo $mail_content;
    //     }
    // }
}