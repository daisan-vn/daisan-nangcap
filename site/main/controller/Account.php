<?php

class Account extends Main
{
    function index()
    {
        global $login;
        if ($login == 0) lib_redirect(DOMAIN . "?mod=account&site=login");

        $user = $this->pdo->fetch_one("SELECT * FROM users WHERE id=$login");
        $user['avatar'] = $this->img->get_image($this->user->get_folder_img($login), $user['avatar']);

        $this->smarty->assign('user', $user);
        
        $category = $this->tax->get_taxonomy('support',0,null,6);
        foreach ($category AS $k=>$v){
            $category[$k]['posts'] = $this->pdo->fetch_all("SELECT id,title FROM posts WHERE status=1 AND type='support'
                AND id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id=".$v['id'].")
                ORDER BY featured DESC LIMIT 10");
            unset($v);
        }
        
        $this->smarty->assign('category', $category);
        $this->smarty->display('user.tpl');
    }

    function profile()
    {
        global $login;
        if ($login == 0) lib_redirect(DOMAIN . "?mod=account&site=login");
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'load_account_content') {
            $account = $this->pdo->fetch_one("SELECT * FROM users WHERE id=$login");
            echo json_encode($account);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'save_account_content') {
            $type = trim(@$_POST['type']);
            if ($type == 'name') {
                $data = [];
                $data['name'] = trim($_POST['name']);
                $this->pdo->update('users', $data, "id=$login");
            }else if($type=='phone'){
                $data = [];
                $data['phone'] = trim($_POST['phone']);
                $this->pdo->update('users', $data, "id=$login");
            }else if($type=='email'){
                $data = [];
                $data['email'] = trim($_POST['email']);
                $this->pdo->update('users', $data, "id=$login");
            }
            echo 1;
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'change_password') {
            $oldpass = trim($_POST['oldpass']);
            $newpass = trim($_POST['newpass']);
            $renewpass = trim($_POST['renewpass']);
            $rt = [];
            $rt['code'] = 0;
            if (strlen($oldpass) < 6 || strlen($newpass) < 6 || strlen($renewpass) < 6) {
                $rt['msg'] = "Vui lòng nhập tối thiểu 6 ký tự không chứa khoảng trắng.";
            } elseif ($newpass != $renewpass) {
                $rt['msg'] = "Mật khẩu xác nhận không chính xác.";
            } elseif (! preg_match("/^[a-zA-Z0-9_*#@]{6,20}$/", $newpass)) {
                $rt['msg'] = "Mật khẩu chứa các ký tự không phù hợp.";
            } elseif (! $this->pdo->check_exist("SELECT 1 FROM users WHERE id=$login AND password='" . md5($oldpass) . "'")) {
                $rt['msg'] = "Mật khẩu cũ không chính xác.";
            } else {
                $data['password'] = md5($newpass);
                $this->pdo->update('users', $data, "id=$login");
                $rt['code'] = 1;
                $rt['msg'] = "Thay đổi mật khẩu thành công.";
            }
            echo json_encode($rt);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'change_avatar') {
            $upload = $this->img->upload_image_base64($this->user->get_folder_img($login), @$_POST['avatar'], null, 160, 1);
            if ($upload) {
                $user = $this->pdo->fetch_one("SELECT avatar FROM users WHERE id=$login");
                @unlink($this->user->get_folder_img_upload($login) . $user['avatar']);
                $data['avatar'] = $upload;
                $this->pdo->update('users', $data, "id=$login");
            }
            echo $upload;
            exit();
        }
        
        $user = $this->pdo->fetch_one("SELECT * FROM users WHERE id=$login");
        $user['avatar'] = $this->img->get_image($this->user->get_folder_img($login), $user['avatar']);
        
        $this->smarty->assign('user', $user);
        $this->smarty->display('user.tpl');
    }
    
    function createpage()
    {
        global $login;
        if (isset($_POST['action']) && $_POST['action'] == 'create_page') {
            $rt = [];
            $rt['code'] = 0;
            $rt['msg'] = 'Đăng ký thất bại, vui lòng thử lại sau.';
            $data = [];
            $data['name'] = trim($_POST['Name']);
            $data['code'] = trim($_POST['Code']);
            $data['type'] = intval($_POST['Type']);
            $data['province_id'] = intval($_POST['ProvinceId']);
            $data['district_id'] = intval($_POST['DistrictId']);
            $data['wards_id'] = intval($_POST['WardsId']);
            $data['address'] = trim($_POST['Address']);
            $data['phone'] = trim($_POST['Phone']);
            $data['email'] = trim($_POST['Email']);
            $data['website'] = trim($_POST['Website']);
            $data['created'] = time();
            $data['date_start'] = gmdate("Y-m-d", time());
            $data['user_id'] = $login;
            $data['status'] = 2;
            if ($this->pdo->check_exist("SELECT 1 FROM pages WHERE name='" . $data['name'] . "'")) {
                $rt['msg'] = 'Tên trang đã tồn tại, vui lòng chọn lại';
            } elseif ($pageId = $this->pdo->insert('pages', $data)) {
                $rt['code'] = 1;
                $rt['msg'] = 'Đăng ký gian hàng thành công.';
                $data['page_name'] = "pid" . $pageId . time();
                ##Gửi email
                $a_mail_bcc = array('admin@daisan.vn','chungit.dsc@daisan.vn');
               // $value = $this->pdo->fetch_one("SELECT email FROM users WHERE id=$login");
                $a_mail_bcc[] = $data['email'];
                $mail_title = "Xác minh gian hàng ".$data['name']." trên Daisan.vn";
                $mail_to = array(
                    'TO' => array('info@daisan.vn'),
                    'CC' => array('chungit.dsc@daisan.vn'),
                    'BCC' => $a_mail_bcc
                );
                $mail_content = get_ssl_page(DOMAIN.'?mod=account&site=set_mail_content_create_page&id='.$pageId);
                send_mail($mail_to,"Liên Hệ Daisan",$mail_title,$mail_content);     
                $this->pdo->update('pages', $data, "id=" . $pageId);
                unset($data);

                $data['page_id'] = $pageId;
                $data['user_id'] = $login;
                $data['created'] = time();
                $data['status'] = 1;
                $this->pdo->insert('pageusers', $data);
                unset($data);
                $data['page_id'] = $pageId;
                $this->pdo->insert('pageprofiles', $data);
                $rt['code'] = 1;
            }
            echo json_encode($rt);
            exit();
        }

        if ($login == 0) lib_redirect(DOMAIN . "login");

        $out = [];
        $out['Province'] = $this->help->get_select_location(0, 0, 'Tỉnh thành phố');
        $out['type'] = $this->help->get_select_from_array($this->page->type);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_CUSTOM);
    }
    function set_mail_content_create_page(){
        $id = isset($_GET['id'])?intval($_GET['id']):0;
        $page = $this->pdo->fetch_one("SELECT a.* FROM pages a
                WHERE a.id=$id");
        $page['time'] = date("H:i d-m-Y", strtotime("+24 hour"));
        $page['url'] = URL_SOURCING.'?site=rfq_detail&id='.$id;
        $this->smarty->assign('data', $page);
        $this->smarty->display(LAYOUT_NONE);
    }
    function pages()
    {
        global $login;

        if ($login == 0) lib_redirect(DOMAIN . "login");

        $key = isset($_GET['key']) ? trim($_GET['key']) : '';
        $package_id = isset($_GET['package_id']) ? intval($_GET['package_id']) : 0;
        $location_id = isset($_GET['location_id']) ? intval($_GET['location_id']) : 0;
        $keyid = intval(substr($key, 2));

        $where = "b.user_id=$login";
        if($key !== null) $where .= " AND (a.name LIKE '%$key%' OR a.id='$keyid')";
        if($package_id!=0) $where .= " AND a.package_id=".$package_id;
        if($location_id!=0) $where .= " AND a.province_id=".$location_id;

        $sql = "SELECT a.id,a.name,a.page_name,a.logo,b.position,c.name AS package,a.package_end,
                (SELECT GROUP_CONCAT(u.name) FROM pageusers pu LEFT JOIN users u ON u.id=pu.user_id WHERE pu.page_id=b.page_id) AS users
				FROM pageusers b LEFT JOIN pages a ON a.id=b.page_id LEFT JOIN packages c ON a.package_id=c.id
				WHERE $where
				ORDER BY a.id DESC";

        $paging = new \Lib\Core\Pagination($this->pdo->count_item('pageusers', 'user_id=' . $login), 10);
        $sql = $paging->get_sql_limit($sql);

        $pages = $this->pdo->fetch_all($sql);
        $a_page_id = [];
        foreach ($pages as $k => $item) {
            $pages[$k]['url_admin'] = URL_PAGEADMIN . "?mod=home&site=connect&userId=".$login."&pageId=".$item['id'];
            $pages[$k]['url_page'] = $this->page->get_pageurl($item['id'], $item['page_name']);
            $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
            $pages[$k]['position'] = $this->user->admin_position[$item['position']];
            $pages[$k]['idcode'] = $this->page->get_idcode($item['id']);
            
            $a_page_id[] = $item['id'];
        }
        
        $numb_product = $this->pdo->fetch_all('SELECT COUNT(1) AS number,page_id FROM products
                WHERE page_id IN ('.implode(',', $a_page_id).') GROUP BY page_id');
        $a_product = [];
        foreach ($numb_product AS $item){
            $a_product[$item['page_id']] = $item['number'];
        }
        $this->smarty->assign('a_product', $a_product);
        
        $package = $this->pdo->fetch_all('SELECT id,name FROM packages WHERE status=1 ORDER BY sort');
        $a_package = [];
        foreach ($package AS $item){
            $a_package[$item['id']] = $item['name'];
        }
        $out = [];
        $out['key'] = $key;
        $out['filter_package'] = $this->help->get_select_from_array($a_package, $package_id, 'Gói dịch vụ');
        $out['filter_location'] = $this->help->get_select_location($location_id, 0, 'Chọn tỉnh thành');
        $this->smarty->assign('out', $out);
        $this->smarty->assign('pages', $pages);
        $this->smarty->display(LAYOUT_CUSTOM);
    }

    function ajax_check_page()
    {
        $page_name = isset($_POST['value']) ? trim($_POST['value']) : null;
        $rt = [];
        $rt['code'] = 1;
        if ($this->pdo->check_exist("SELECT 1 FROM pages WHERE name='$page_name'")) {
            $rt['code'] = 0;
        }
        echo json_encode($rt);
        exit();
    }

    function orders()
    {
        global $login;
        if ($login == 0) lib_redirect(DOMAIN);
        $out = [];

        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'change_status') {
            $id = intval(@$_POST['id']);
            $order = $this->pdo->fetch_one("SELECT status FROM productorders WHERE id=$id AND user_id=$login");
            $rt = [];
            $rt['code'] = 0;
            if (!$order) {
                $rt['msg'] = 'Xảy ra lỗi, vui lòng thử lại';
            } elseif (! in_array($order['status'], array(0,1))) {
                $rt['msg'] = 'Đơn hàng đã được xử lý từ phía shop';
            } else {
                $data = [];
                $data['status'] = $_POST['status'];
                $data['updated'] = time();
                $this->pdo->update('productorders', $data, "id=$id AND user_id=$login");
                $rt['msg'] = 'Cập nhật đơn hàng thành công';
            }
            echo json_encode($rt);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'load_content') {
            $id = intval(@$_POST['id']);
            $order = $this->pdo->fetch_one("SELECT * FROM productorders WHERE id=$id");
            echo json_encode($order);
            exit();
        } elseif (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'save_content') {
            $id = intval(@$_POST['id']);
            $data['customer'] = trim($_POST['customer']);
            $data['phone'] = trim($_POST['phone']);
            $data['email'] = trim($_POST['email']);
            $data['address'] = trim($_POST['address']);
            $data['description'] = trim($_POST['description']);
            $this->pdo->update('productorders', $data, "id=$id AND user_id=$login");
            exit();
        }

        $key = isset($_GET['key']) ? $_GET['key'] : null;
        $status = isset($_GET['status']) ? $_GET['status'] : - 1;

        $where = "a.user_id=$login";
        if ($key != null)
            $where .= " AND a.customer LIKE '%$key%'";
        if ($status != - 1)
            $where .= " AND a.status=$status";

        $sql = "SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a WHERE $where ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('productorders', $where), 20);
        $sql = $paging->get_sql_limit($sql);

        $result = $this->pdo->fetch_all($sql);
        foreach ($result as $k => $item) {
            $result[$k]['code'] = "#OID" . $item['page_id'] . $item['id'];
            $result[$k]['status_show'] = $this->product->order_status[$item['status']];
        }
        $this->smarty->assign('result', $result);

        $out['select_status'] = $this->help->get_select_from_array($this->product->order_status, $status, "Chọn trạng thái");
        $out['key'] = $key;
        $this->smarty->assign('out', $out);
        $this->smarty->display('user.tpl');
    }

    function order_detail()
    {
        global $login;
        $id = isset($_REQUEST['id']) ? intval($_REQUEST['id']) : 0;

        $order = $this->pdo->fetch_one("SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a WHERE a.id=$id AND a.user_id=$login");
        $this->smarty->assign('order', $order);

        $detail = $this->pdo->fetch_all("SELECT a.price,a.number,b.name AS productname
                FROM productorderitems a LEFT JOIN products b ON b.id=a.product_id
                WHERE a.order_id=$id");
        $this->smarty->assign('detail', $detail);
        $this->smarty->display(LAYOUT_NONE);
    }

    function pagefavorites()
    {
        global $login;

        $pages = $this->pdo->fetch_all("SELECT a.id,a.name,a.page_name,a.logo,a.address,a.created,a.status
				FROM pages a
				WHERE a.id IN (SELECT b.page_id FROM pagefavorites b WHERE b.user_id=$login AND b.status=1)
				ORDER BY a.id DESC");
        foreach ($pages as $k => $item) {
            $pages[$k]['url_page'] = $this->page->get_pageurl($item['id'], $item['page_name']);
            $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
        }
        $this->smarty->assign('pages', $pages);

        $this->smarty->display(LAYOUT_ACCOUNT);
    }

    function productfavorites()
    {
        global $login;

        $where = "a.status=1 AND a.id IN (SELECT b.product_id FROM productfavorites b WHERE b.user_id=$login AND b.status=1)";
        $number = $this->pdo->count_item('productfavorites', "user_id=$login AND status=1");
        $paging = new \Lib\Core\Pagination($number, 20, 0);
        $limit = $paging->get_page_limit();
        $result = $this->product->get_product_fullvalue(0, $where, $limit);
        $this->smarty->assign('result', $result);

        $pages = $this->pdo->fetch_all("SELECT a.id,a.name,a.page_name,a.logo,a.address,a.created,a.status
				FROM pages a
				WHERE a.id IN (SELECT b.page_id FROM pagefavorites b WHERE b.user_id=$login AND b.status=1)
				ORDER BY a.id DESC");
        foreach ($pages as $k => $item) {
            $pages[$k]['url_page'] = $this->page->get_pageurl($item['id'], $item['page_name']);
            $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
        }
        $this->smarty->assign('pages', $pages);

        $this->smarty->display(LAYOUT_ACCOUNT);
    }

    function messages()
    {
        global $login;

        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'send_msg') {
            $data = [];
            $data['user_id'] = $login;
            $data['message'] = trim($_POST['message']);
            $data['parent'] = trim($_POST['parent']);
            $data['created'] = time();
            $data['status'] = 1;
            $id = $this->pdo->insert('pagemessages', $data);
            unset($data);
            echo $id;
            exit();
        }

        $status = isset($_GET['status']) ? intval($_GET['status']) : - 1;
        $type = isset($_GET['type']) ? intval($_GET['type']) : - 1;
        $key = isset($_GET['key']) ? trim($_GET['key']) : '';
        if ($login == 0)
            lib_redirect(DOMAIN . "?mod=account&site=login");
        $where = "a.parent=0 AND a.user_id=$login";
        if ($key)
            $where .= " AND (u.name LIKE '%$key%' OR a.message LIKE '%$key%')";
        if ($type != - 1)
            $where .= " AND " . ($type == 1 ? "a.product_id=0" : "a.product_id<>0");
        if ($status != - 1)
            $where .= " AND a.status=$status";

        $sql = "SELECT a.id,a.user_id,u.name,u.avatar,a.message,a.created
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id
				WHERE $where ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('pagemessages', $where), 10);
        $sql = $paging->get_sql_limit($sql);
        $parents = $this->pdo->fetch_all($sql);
        foreach ($parents as $k => $item) {
            $parents[$k]['url'] = "?mod=account&site=messages&parent=" . $item['id'];
            $parents[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['user_id']), $item['avatar']);
        }

        $parent_id = isset($_GET['parent']) ? intval($_GET['parent']) : intval(@$parents[0]['id']);
        $info = $this->pdo->fetch_one("SELECT a.id,a.user_id,u.name,u.avatar,a.created,a.product_id,a.page_id,p.name AS productname,p.images,
                (SELECT name FROM pages b WHERE b.id=a.page_id) AS page_name
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id LEFT JOIN products p ON a.product_id=p.id
				WHERE a.id=$parent_id");
        if ($info) {
            $info['avatar'] = $this->img->get_image($this->user->get_folder_img($info['user_id']), $info['avatar']);
            $info['productavatar'] = $this->product->get_avatar($info['page_id'], $info['images']);
            $info['producturl'] = $this->product->get_url($info['product_id'], $info['productname']);
        }
        $this->smarty->assign('info', $info);

        $contacts = $this->pdo->fetch_all("SELECT a.id,a.user_id,u.name,u.avatar,a.message,a.created,a.isreply
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id
				WHERE (a.parent=$parent_id OR a.id=$parent_id) AND a.user_id=$login
				ORDER BY a.id ASC");
        foreach ($contacts as $k => $item) {
            $contacts[$k]['url'] = "?mod=contact&site=index&parent=" . $item['id'];
            $contacts[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['user_id']), $item['avatar']);
        }

        $this->smarty->assign('parents', $parents);
        $this->smarty->assign('contacts', $contacts);

        $a_status = array(
            1 => 'Đã phản hồi',
            0 => 'Chưa phản hồi'
        );

        $a_type = array(
            0 => 'Thể loại',
            1 => 'Liên hệ gian hàng',
            2 => 'Liên hệ sản phẩm'
        );

        $out = [];
        $out['parent_id'] = $parent_id;
        $out['select_status'] = $this->help->get_select_from_array($a_status, $status, "Trạng thái");
        $out['select_type'] = $this->help->get_select_from_array($a_type, $type, 0);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_ACCOUNT);
    }

    function rfq()
    {
        global $login;
        $where = "a.user_id=$login";
        $sql = "SELECT a.id,a.title,a.image,a.description,a.number,a.created,t.name AS unit,
                (SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS taxonomy,
                (SELECT t.name FROM locations t WHERE t.id=a.location_id) AS location,
                (SELECT COUNT(1) FROM rfqquotations q WHERE a.id=q.rfq_id) AS number_quotation
                FROM rfq a LEFT JOIN taxonomy t ON a.unit_id=t.id WHERE $where ORDER BY a.id DESC";
        $out = [];
        $out['number'] = $this->pdo->count_item('rfq', $where);
        $paging = new \Lib\Core\Pagination($out['number'], 20, 0);
        $sql = $paging->get_sql_limit($sql);
        $rfq = $this->pdo->fetch_all($sql);
        foreach ($rfq as $k => $item) {
            $rfq[$k]['url'] = URL_SOURCING . "?site=rfq_detail&id=" . $item['id'];
            $rfq[$k]['url_edit'] = URL_SOURCING . "?site=createRfq&id=" . $item['id'];
            $rfq[$k]['url_quote'] = "?mod=account&site=rfq_quote&id=" . $item['id'];
            $rfq[$k]['avatar'] = $this->img->get_image("rfq/", $item['image']);
        }
        $this->smarty->assign('rfq', $rfq);

        $this->smarty->display('user.tpl');
    }

    function rfq_quote()
    {
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $rfq = $this->pdo->fetch_one("SELECT * FROM rfq WHERE id=$id");

        $quotations = $this->pdo->fetch_all("SELECT a.id,a.description,a.created,a.status,a.page_id,a.price,
                p.name AS page_name,p.logo AS page_logo
                FROM rfqquotations a LEFT JOIN pages p ON p.id=a.page_id
                WHERE a.rfq_id=$id ORDER BY id DESC");
        foreach ($quotations as $k => $item) {
            $quotations[$k]['page_logo'] = $this->img->get_image($this->page->get_folder_img($item['page_id']), $item['page_logo']);
            $quotations[$k]['page_url'] = $this->page->get_pageurl($item['page_id']);
        }

        $this->smarty->assign('quotations', $quotations);
        $this->smarty->assign('rfq', $rfq);
        $this->smarty->display(LAYOUT_ACCOUNT);
    }

    /*
     * ---------------------------------------------------------------------------------
     * ---------------------------------------------------------------------------------
     * ---------------------------------------------------------------------------------
     */
    function login()
    {
        global $login;

        $out = [];

        $token = isset($_GET['token']) ? trim($_GET['token']) : null;
        $out['url'] = $token == null ? DOMAIN : base64_decode($token);
       
        if (isset($_POST['action']) && $_POST['action'] == 'ajax_login') {
            $Email = trim($_POST['Email']);
            $Password = trim($_POST['Password']);
            $Rt = [];
            $Rt['Code'] = 0;
            $Rt['Msg'] = null;
            if (!filter_var($Email, FILTER_VALIDATE_EMAIL)){
                $Rt['Msg'] = "Không đúng định dạng Email";
            }
           elseif (! preg_match("/^[a-zA-Z0-9_*#@]{6,20}$/", $Password)) {
                $Rt['Msg'] = "Mật khẩu không hợp lệ, vui lòng nhập mật khẩu tối thiểu 6 ký tự chữ và số.";
            } else {
                $user = $this->pdo->fetch_one("SELECT id,name,avatar,phone,email,isadmin,status FROM users WHERE email='$Email' AND password='" . md5($Password) . "'");
                if (! $user)
                    $Rt['Msg'] = "Sai tên đăng nhập hoặc mật khẩu, vui lòng kiểm tra lại.";
                else if ($user && $user['status'] != 1)
                    $Rt['Msg'] = "Tài khoản của bạn đang bị khóa hoặc chưa được kích hoạt, vui lòng liên hệ với quản trị để biết thêm thông tin.";
                else {
                    $Rt['Code'] = 1;
                    $Rt['Msg'] = "Đăng nhập thành công.";
                    $Rt['UserId'] = $user['id'];
                    $this->hcache['user'] = $user;
                    setcookie('HodineCache', json_encode($this->hcache), time() + (86400 * 30 * 30), "/");
                    $_SESSION[SESSION_LOGIN_DEFAULT] = $user['id'];
                }
            }
            echo json_encode($Rt);
            exit();
        }elseif (isset($_POST['action']) && $_POST['action'] == 'ajax_login_google') {
            $Rt['code'] = 0;
            if($this->pdo->check_exist("SELECT 1 FROM users WHERE email='".$_POST['email']."'")){
                $userlogin = $this->pdo->fetch_one("SELECT id,name,avatar,phone,email,isadmin,status FROM users WHERE email='".$_POST['email']."'");
                $this->hcache['user'] = $userlogin;
                setcookie('HodineCache', json_encode($this->hcache), time() + (86400 * 30 * 30), "/");
                $_SESSION[SESSION_LOGIN_DEFAULT] = $userlogin['id'];
                $Rt['code'] = 1;
            }else{
                $data = [];
                $data['username'] = $_POST['id'];
                $data['name'] = $_POST['name'];
                if(isset($_POST['email'])) $data['email'] = $_POST['email'];
                $data['created'] = time();
                $data['status'] = 1;
                $user_id = $this->pdo->insert('users', $data);
                $data['id'] = $user_id;
                $this->hcache['user'] = $data;
                setcookie('HodineCache', json_encode($this->hcache), time() + (86400 * 30 * 30), "/");
                $_SESSION[SESSION_LOGIN_DEFAULT] = $user_id;
                $Rt['code'] = 1;
            }

            echo json_encode($Rt);

            exit();
        }
        // if ($login != 0) lib_redirect(DOMAIN);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_CUSTOM);
    }
    function login_socical()
    {
        global $login;

        $out = [];

        $token = isset($_GET['token']) ? trim($_GET['token']) : null;
        $out['url'] = $token == null ? DOMAIN : base64_decode($token);

        if(isset($_GET['url']) && $_GET['url']=='back_url_cart'){
            $out['url'] = DOMAIN."?mod=product&site=payment";
        }
        if(isset($_GET['url']) && $_GET['url']=='back_url_contact'){
            $page_id = $_GET['page_id'];
            $product_id = $_GET['product_id'];
            $mes = $_GET['mes'];
            $out['url'] = DOMAIN."?mod=page&site=contact&page_id=$page_id&product_id=$product_id&mes=$mes";
        }
       if (isset($_POST['action']) && $_POST['action'] == 'ajax_login_google') {
            $Rt['code'] = 0;
            if($this->pdo->check_exist("SELECT 1 FROM users WHERE email='".$_POST['email']."'")){
                $userlogin = $this->pdo->fetch_one("SELECT id,name,avatar,phone,email,isadmin,status FROM users WHERE email='".$_POST['email']."'");
                $this->hcache['user'] = $userlogin;
                setcookie('HodineCache', json_encode($this->hcache), time() + (86400 * 30 * 30), "/");
                $_SESSION[SESSION_LOGIN_DEFAULT] = $userlogin['id'];
                $Rt['code'] = 1;
            }else{
                $data = [];
                $data['username'] = $_POST['id'];
                $data['name'] = $_POST['name'];
                if(isset($_POST['email'])) $data['email'] = $_POST['email'];
                $data['created'] = time();
                $data['status'] = 1;
                $user_id = $this->pdo->insert('users', $data);
                $data['id'] = $user_id;
                $this->hcache['user'] = $data;
                setcookie('HodineCache', json_encode($this->hcache), time() + (86400 * 30 * 30), "/");
                $_SESSION[SESSION_LOGIN_DEFAULT] = $user_id;
                $Rt['code'] = 1;
            }
            echo json_encode($Rt);
            exit();
        }
        // if ($login != 0) lib_redirect(DOMAIN);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_CUSTOM);

    }
    function register()
    {
        if(isset($_POST['action']) && $_POST['action'] == 'ajax_register') {
            $Name = trim($_POST['Name']?? '');
            $Email = trim($_POST['Email']?? '');
            $Password = trim($_POST['Password']?? '');
            $RePass = trim($_POST['RePass']?? '');
            $Rt = [];
            $Rt['Code'] = 0;
            $Rt['Msg'] = '';
            if ($Name == ''){
                $Rt['Msg'] = "Không được bỏ trống thông tin họ tên.";
            }elseif (!filter_var($Email, FILTER_VALIDATE_EMAIL)){
                $Rt['Msg'] = "Không đúng định dạng Email";
            }elseif (! preg_match("/^[a-zA-Z0-9_*#@]{6,20}$/", $Password)) {
                $Rt['Msg'] = "Mật khẩu không hợp lệ, vui lòng nhập mật khẩu tối thiểu 6 ký tự chữ và số.";
            }elseif ($RePass != $Password) {
                $Rt['Msg'] = "Mật khẩu xác nhận không chính xác, vui lòng nhập lại.";
            }elseif ($this->pdo->check_exist("SELECT 1 FROM users WHERE email='$Email' LIMIT 1")) {
                $Rt['Msg'] = "Tài khoản đã tồn tại trên hệ thống, vui lòng chọn tài khoản khác.";
            }else {
                $data = [];
                $data['name'] = $Name;
                $data['email'] = $Email;
                $data['password'] = md5($Password);
                $data['created'] = time();
                $data['status'] = 0;

                if($UserId = $this->pdo->insert('users', $data)){
                    // -- Gửi email
                    $a_mail_bcc = array('nhamphongdaijsc@gmail.com');
                    $a_mail_bcc[] = $data['email'];
                    $mail_title = "Kích hoạt tài khoản ".$data['name']." trên Daisan.vn";
                    $mail_to = array(
                        'TO' => array('info@daisan.vn'),
                        'CC' => array('chungit.dsc@daisan.vn'),
                        'BCC' => $a_mail_bcc
                    );
                    $mail_content = get_ssl_page(DOMAIN.'?mod=account&site=set_mail_content_create_account&id='.$UserId);
                    send_mail($mail_to,"Kích hoạt Daisan",$mail_title,$mail_content);
                    // -- end gửi mail

                //    setcookie(COOKIE_LOGIN_ID, $UserId, time() + (86400 * 30));

                    $Rt['Code'] = 1;
                    $Rt['Msg'] = "Đăng ký tài khoản thành công.";
                }
            }
            echo json_encode($Rt);
            exit();
        }
        $this->smarty->display(LAYOUT_CUSTOM);
    }
    function verify_register(){
        $this->smarty->display(LAYOUT_CUSTOM);
    }
    function set_mail_content_create_account(){
        $id = isset($_GET['id'])?intval($_GET['id']):0;
        $page = $this->pdo->fetch_one("SELECT a.name,a.phone,a.email FROM users a
                WHERE a.id=$id");
        $page['token'] = md5($page['email'] . time());
        $page['url'] = DOMAIN.'?mod=account&site=set_active_account&id='.$id.'&token='.$page['token'];
        $this->smarty->assign('data', $page);
        $this->smarty->display(LAYOUT_NONE);
    }
    function set_active_account(){
        $id = isset($_GET['id'])?intval($_GET['id']):0;
        $data = [];
        $data['status']=1;
        $this->pdo->update('users', $data, "id=$id");
        $this->smarty->display(LAYOUT_HOME);
    }
    function forgetpass()
    {
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'forget_password') {
            $email = trim(@$_POST['email']);
            $rt = [];
            $rt['code'] = 0;
            if (! filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $rt['msg'] = "Không đúng định dạng email.";
            } elseif (! $this->pdo->check_exist("SELECT 1 FROM users WHERE email='$email'")) {
                $rt['msg'] = "Email không tồn tại trên hệ thống.";
            } elseif ($this->pdo->check_exist("SELECT 1 FROM users WHERE email='$email' AND status<>1")) {
                $rt['msg'] = "Tài khoản này đã bị khóa.";
            } else {
                $user = $this->pdo->fetch_one("SELECT id,name FROM users WHERE email='$email' AND status=1");
                if (! $user) {
                    $rt['msg'] = "Tài khoản không chính xác.";
                } else {
                    $data = [];
                    $data['token'] = md5($email . time());
                    $data['tokentime'] = time() + 2 * 60 * 60;
                    $this->pdo->update('users', $data, "id=" . $user['id']);

                    $url = DOMAIN . "?mod=account&site=resetpass&user_id=" . $user['id'] . "&token=" . $data['token'];
                    $mail_content = null;
                    $mail_content .= "<h3>Chức năng quên mật khẩu đăng nhập</h3>";
                    $mail_content .= "<p>Vui lòng click vào đường dẫn bên dưới để thực hiện chức năng lấy lại mật khẩu.</p>";
                    $mail_content .= "<p>$url</p>";
                    $mail_content .= "<p>Thời hạn xử lý trong vòng 2 giờ, sẽ hết hạn vào " . date("H:i d-m-Y", strtotime("+2 hour")) . ".</p>";
                    $mail_content .= "<p>Rất hân hạnh được phục vụ.</p>";
                    $mail_content .= "<p>Trân trọng !</p>";

                    $mail_to = array(
                        'TO' => array(
                            $email
                        )
                    );
                    send_mail($mail_to, 'Noreply', "Đặt lại mật khẩu", $mail_content);
                    $rt['code'] = 1;
                    $rt['msg'] = "Email đã được gửi tới hòm thư của bạn. Vui lòng kiểm tra và làm theo hướng dẫn.";
                }
            }
            echo json_encode($rt);
            exit();
        }
        
        $this->smarty->display(LAYOUT_CUSTOM);
    }

    function resetpass()
    {
        if (isset($_POST['ajax_action']) && $_POST['ajax_action'] == 'change_password') {
            $newpass = trim($_POST['pass']);
            $renewpass = trim($_POST['repass']);
            $rt = [];
            $rt['code'] = 0;
            if (strlen($newpass) < 6 || strlen($renewpass) < 6) {
                $rt['msg'] = "Vui lòng nhập tối thiểu 6 ký tự không chứa khoảng trắng.";
            } elseif ($newpass != $renewpass) {
                $rt['msg'] = "Mật khẩu xác nhận không chính xác.";
            } elseif (! preg_match("/^[a-zA-Z0-9_*#@]{6,20}$/", $newpass)) {
                $rt['msg'] = "Mật khẩu chứa các ký tự không phù hợp.";
            } else {
                $data = [];
                $data['password'] = md5($newpass);
                $this->pdo->update('users', $data, "id=" . intval($_POST['user_id']));
                $rt['code'] = 1;
                $rt['msg'] = "Thay đổi mật khẩu thành công.";
            }
            echo json_encode($rt);
            exit();
        }

        $token = @$_GET['token'];
        $user_id = @$_GET['user_id'];
        $user = $this->pdo->fetch_one("SELECT tokentime FROM users WHERE id=$user_id AND token='$token'");
        $status = 1;
        $message = null;
        if (! $user) {
            $status = 0;
            $message = "Token không có hiệu lực, vui lòng thực hiện lại chức năng quên mật khẩu.";
        } elseif ($user['tokentime'] < time()) {
            $status = 2;
            $message = "Thời gian hiệu lực cho token này đã hết, vui lòng thực hiện lại chức năng để tạo token mới.";
        }

        $out = [];
        $out['status'] = $status;
        $out['message'] = $message;
        $out['user_id'] = $user_id;

        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_CUSTOM);
    }

    function logout()
    {
        $this->hcache['user'] = [];
        setcookie('HodineCache', json_encode($this->hcache), time() + (86400 * 30 * 30), "/");
        
        unset($_SESSION[SESSION_LOGIN_DEFAULT]);
        lib_redirect(DOMAIN);
    }
}