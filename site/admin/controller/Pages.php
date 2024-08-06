<?php
# ================================ #
# Module for Pages management
# ================================ #

class Pages extends Admin {
    private $folder;
    function __construct() {
        parent::__construct();
        $this->folder = 'images/nations/';
    }
    
    function index() {
        global $login, $lang, $location;
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_package'){
            $id = intval(@$_POST['id']);
            $result = $this->pdo->fetch_one("SELECT id,page_id,package_id,endtime FROM pagepackage WHERE page_id=$id AND endtime>='".date("Y-m-d")."'");
            $result["s_package"] = $this->help->get_select_from_table('packages', 'id', 'name', @$result['package_id'], '-- Chọn gói --');
            echo json_encode($result);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_package'){
            $page_id = intval($_POST['page_id'] ?? 0);

            $package_id = intval($_POST['package_id'] ?? 0);
            $package_end = empty($_POST['endtime']) ? '' : date('Y-m-d H:i', strtotime($_POST['endtime']));

            $package = $this->page->set_package($page_id, $package_id, $package_end);

            if ($package) {
                $this->page->set_score_ads($page_id, $package['numb_ads']);
            }
            else {
                $this->page->set_score_ads($page_id, 0);
            }
            
            // $product = $this->pdo->fetch_all("SELECT id FROM products WHERE page_id=".$page_id);
            // foreach ($product AS $item){
            //     $curl_get_product = $this->curl_search_get_product($item['id']);
            //     $curl_get_product['fields']['package_id'] = (int)$data['package_id'];
            //     $curl_get_product['fields']['package_end'] = $data['package_end'];
            //     $dataCURL_str = json_encode($curl_get_product['fields']);
            //     $this->curl_search_update_index($item['id'], $dataCURL_str);
            //     usleep(10000);
            // }

            echo 1; 
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_nation'){
            $id = intval(@$_POST['id']);
            $sql = "SELECT * FROM pages WHERE id=$id";
            $result = $this->pdo->fetch_one($sql);
            $result["s_nation"] = $this->help->get_select_from_table('nations', 'Id', 'Name', @$result['nation_id'], 'Lựa chọn');
            echo json_encode($result);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_nation'){
            $data['nation_id'] = trim(@$_POST['nation_id']);
            $this->pdo->update('pages', $data, "id=".trim(@$_POST['page_id']));
            echo 1; exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_category'){
            $page = $this->pdo->fetch_one('SELECT taxonomy_id FROM pages WHERE id='.intval($_POST['page_id']));
            echo $this->taxonomy->get_select_taxonomy_tree('product', @$page['taxonomy_id'], 0, 'a.level<2', 'Chọn danh mục');
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_category'){
            $data = [];
            $data['taxonomy_id'] = intval($_POST['taxonomy_id']);
            $data['created'] = time();
            $data['admin_id'] = $login;
            $this->pdo->update('pages', $data, 'id='.intval($_POST['page_id']));
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='copy_page'){
            $id = isset($_POST['page_id']) ? intval($_POST['page_id']) : 0;
            $sqll = "SELECT * FROM pages WHERE id=$id";
            $page = $this->pdo->fetch_one($sqll);
            unset($page['id']);
            foreach ($page AS $k=>$item){
                if($item===null || $item==='0' || $item==='' || $item==='0000-00-00') unset($page[$k]);
            }
            if(isset($page['name'])) $page['name'] = $page['name'].' (copy)';
            $page['created'] = time();
            $page['admin_id'] = $login;
            $page_id = 0;

            if($page_id = $this->pdo->insert('pages', $page)){
                unset($page);
                $profile = $this->pdo->fetch_one('SELECT * FROM pageprofiles WHERE page_id='.$id);
                unset($profile['id']);
                $profile['page_id'] = $page_id;
                $this->pdo->insert('pageprofiles', $profile);
                unset($profile);
                
                lib_copy_folder($this->page->get_folder_img_upload($id), $this->page->get_folder_img_upload($page_id));
                
                $supporters = $this->pdo->fetch_all('SELECT * FROM pagesupporters WHERE page_id='.$id);
                foreach ($supporters AS $item){
                    $data = [];
                    $data['page_id'] = $page_id;
                    $data['name'] = $item['name'];
                    $data['phone'] = $item['phone'];
                    $data['email'] = $item['email'];
                    $data['skype'] = $item['skype'];
                    $data['avatar'] = $item['avatar'];
                    $data['created'] = time();
                    $this->pdo->insert('pagesupporters', $data);
                }
                
                $partners = $this->pdo->fetch_all('SELECT * FROM pagepartners WHERE page_id='.$id);
                foreach ($partners AS $item){
                    $data = [];
                    $data['page_id'] = $page_id;
                    $data['partner_id'] = $item['partner_id'];
                    $data['year_start'] = $item['year_start'];
                    $data['year_finish'] = $item['year_finish'];
                    $data['description'] = $item['description'];
                    $data['created'] = time();
                    $this->pdo->insert('pagepartners', $data);
                }
                
                $products = $this->pdo->fetch_all('SELECT id FROM products WHERE page_id='.$id);
                foreach ($products AS $item){
                    $this->copy_product($item['id'], $page_id);
                }
            }
            echo $page_id; exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='refresh_page'){
            $page_id = isset($_POST['page_id'])?intval($_POST['page_id']):0;
            $product_file = $this->page->get_folder_img_upload($page_id).'products.json';
            $products = $this->product->get_list_bypage($page_id);
            file_put_contents($product_file, json_encode($products));
            exit();
        }
        
        $out = [];
        $status= isset($_GET['status']) ? $_GET['status'] : -1;
        $user_id = isset($_GET['user_id'])?$_GET['user_id']:0;
        $category_id = isset($_GET['category_id'])?$_GET['category_id']:-1;
        $key = isset($_GET['key'])?trim($_GET['key']):null;
        $verified = isset($_GET['verified']) ? intval($_GET['verified']):0;
        $out['filter_status']= $this->help->get_select_from_array($this->page->status, $status, 'Trạng thái');
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_user'] = $this->help->get_select_from_table('users','id','name',isset($_GET['user_id'])?$_GET['user_id']:0);
        $out['filter_category'] = $this->taxonomy->get_select_taxonomy_tree('product', $category_id, 0, 'a.level<2', 'Chưa chọn danh mục');
        
        $count_product = $this->pdo->fetch_all("SELECT page_id,COUNT(1) AS number FROM products GROUP BY page_id");
        $a_count = [];
        foreach ($count_product AS $item){
            $a_count[$item['page_id']] = $item['number'];
        }
        
        $count_product_active = $this->pdo->fetch_all("SELECT page_id,COUNT(1) AS number FROM products WHERE status=1 GROUP BY page_id");
        $a_count_active = [];
        foreach ($count_product_active AS $item){
            $a_count_active[$item['page_id']] = $item['number'];
        }
        
        $where = "1=1";
        if($status!=-1 && $status!=3) $where.=" AND a.status=$status";
        if($category_id!=-1){
//             $where.=" AND a.taxonomy_id=$category_id";
            $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$category_id) AND (SELECT rgt FROM taxonomy WHERE id=$category_id))
                ORDER BY lft)";
            
        }
        if($user_id !=0) $where.=" AND a.id IN (SELECT page_id FROM pageusers WHERE user_id=$user_id)";
        if($key!=null) $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.id LIKE '%".$_GET['key']."%')";
        if($location!=0) $where .=" AND a.province_id=$location";
         //$where .= " AND a.is_verification=$verified";
        $sql = "SELECT a.id,a.name,a.address,a.website,a.logo,a.page_name,a.phone,a.email,a.created,a.featured,a.status,a.package_end,a.score_ads,a.nation_id,
                ad.name AS admin,t.name AS category,
                (SELECT COUNT(1) FROM pageusers b WHERE b.page_id=a.id) AS number_admin,
                (SELECT b.name FROM packages b WHERE b.id=a.package_id) AS package,
                (SELECT u.name FROM users u WHERE u.id=a.user_id) AS user_name,
                (SELECT n.Image FROM nations n WHERE n.Id=a.nation_id) AS nation_img";
        if($status==3) $sql .= ",IFNULL((SELECT COUNT(1) FROM products p WHERE p.status=1 AND p.page_id=a.id),0) AS numb_products";
        $sql .= " FROM pages a LEFT JOIN useradmin ad ON ad.id=a.admin_id LEFT JOIN taxonomy t ON t.id=a.taxonomy_id
                WHERE $where";
        
        if($status==3) $sql .= " HAVING numb_products=0";
        $sql .= " ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('pages', $where), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $item['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
            $item['nation_logo'] = (@$item['nation_id']==0)?($this->img->get_image($this->folder, '1538472307_9afdb01339ef137ea2f3fb1aa64a9024.png')):($this->img->get_image($this->folder, @$item['nation_img']));
            $item['products'] = intval(@$a_count[$item['id']]);
            $item['products_active'] = intval(@$a_count_active[$item['id']]);
            $item['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
            $item['url_seller'] = URL_PAGEADMIN . "?mod=home&site=connect&adminId=$login&pageId=".$item['id'];
            $item['status'] = $this->help_get_status($item['status'], 'pages', $item['id']);
            $item['featured']=$this->help_get_featured($item['featured'], 'pages', $item['id']);
            $item['number_admin'] = intval($item['number_admin']);
            $item['package_end'] = ($item['package_end']=='0000-00-00' || $item['package_end']=='1970-00-00')?null:$item['package_end'];
            $item['all_users'] = $this->getall_users_page($item['id']);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        $number['not_verified'] = $this->pdo->count_item('pages','a.is_verification=0');
        $number['verified'] = $this->pdo->count_item('pages','a.is_verification=1');
        $this->smarty->assign("number", $number);
        //$this->page->remove_folder(1);

        $this->smarty->assign('page_verified', empty($_REQUEST['verified'])? false: true);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function getall_users_page($page_id){
        $admin = $this->pdo->fetch_all("SELECT u.id,u.name,u.avatar,a.position,a.created,a.status
				FROM pageusers a LEFT JOIN users u ON u.id=a.user_id
				WHERE a.page_id=$page_id ORDER BY a.position");
        foreach ($admin AS $k=>$item){
            $admin[$k]['name'] = $item['name'];
        }
        
        return $admin;
    }
    
    function payment() {
        global $login, $lang, $location;
        $out = [];
        $status = isset($_GET['status']) ? intval($_GET['status']) : -1;
        $package_id = isset($_GET['package']) ? intval($_GET['package']) : 0;
        
        $a_status = array(0=>'Đã hết hạn', 1=>'Đang hoạt động');
        $package = $this->pdo->fetch_all('SELECT id,name FROM packages WHERE status=1 ORDER BY sort');
        $a_package = [];
        foreach ($package AS $item){
            $a_package[$item['id']] = $item['name'];
        }
        
        $out['filter_status']= $this->help->get_select_from_array($a_status, $status, 'Trạng thái');
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_package'] = $this->help->get_select_from_array($a_package, $package_id, 'Gói dịch vụ');
        
        $where = "p.price>0";
        if($status===0) $where.=" AND a.package_end<'".date('Y-m-d')."'";
        elseif($status===1) $where.=" AND a.package_end>='".date('Y-m-d')."'";
        if($package_id!==0) $where.=" AND a.package_id=$package_id";
        
        if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.id LIKE '%".$_GET['key']."%')";
        $sql = "SELECT a.id,a.name,a.logo,a.page_name,a.created,a.status,a.package_end,ad.name AS admin,
                p.name AS package,p.price AS package_price
				FROM pages a LEFT JOIN useradmin ad ON ad.id=a.admin_id LEFT JOIN packages p ON a.package_id=p.id
                WHERE $where ORDER BY a.id DESC";
        
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('pages', $where), 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $token = md5(time());
            $item['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
            $item['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
            $item['package_end'] = ($item['package_end']=='0000-00-00' || $item['package_end']=='1970-00-00')?null:$item['package_end'];
            $item['url_seller'] = URL_PAGEADMIN . "?mod=home&site=connect&adminId=$login&pageId=" . $item['id'] . "&token=$token";
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function copy_product($id, $page_id){
        global $login;
        $product = $this->pdo->fetch_one("SELECT * FROM products WHERE id=$id");
        unset($product['id']);
        $product['status'] = 1;
        $product['created'] = time();
        $product['user_id'] = 0;
        $product['admin_id'] = 0;
        $product['views'] = 1;
        $product['score'] = 0;
        $product['page_id'] = $page_id;
        
        if($product_id = $this->pdo->insert('products', $product)){
            $productprices = $this->pdo->fetch_all("SELECT * FROM productprices WHERE product_id=$id ORDER BY id");
            foreach ($productprices AS $item){
                $data = [];
                $data['product_id'] = $product_id;
                $data['version'] = $item['version'];
                $data['price'] = $item['price'];
                $this->pdo->insert('productprices', $data);
            }
            
            $productmetas = $this->pdo->fetch_all("SELECT * FROM productmetas WHERE product_id=$id ORDER BY id");
            foreach ($productmetas AS $item){
                $data = [];
                $data['product_id'] = $product_id;
                $data['meta_key'] = $item['meta_key'];
                $data['meta_value'] = $item['meta_value'];
                $this->pdo->insert('productmetas', $data);
            }
        }
        return intval($product_id);
    }
    
    function form(){
        global $login, $lang;
        $id = isset($_GET['id'])?intval($_GET['id']):0;
        
        if(isset($_POST['submit'])){
            $data = [];
            $data['name'] = trim($_POST['name'] ?? '');
            $data['code'] = trim($_POST['code'] ?? '');
            $data['name_short'] = trim($_POST['name_short'] ?? '');
            $data['name_global'] = trim($_POST['name_global'] ?? '');

            $date_start = trim($_POST['date_start'] ?? '');
            if ($date_start) {
                $data['date_start'] = date("Y-m-d", strtotime($date_start));
            }

            $data['type'] = intval($_POST['type'] ?? 0);
            $data['number_mem'] = intval($_POST['number_mem'] ?? 5);
            $data['taxonomy_id'] = intval($_POST['taxonomy_id'] ?? 0);
            $data['province_id'] = intval($_POST['province_id'] ?? 0);
            $data['district_id'] = intval($_POST['district_id'] ?? 0);
            $data['wards_id'] = intval($_POST['wards_id'] ?? 0);
            $data['address'] = trim($_POST['address'] ?? '');
            $data['website'] = trim($_POST['website'] ?? '');
            $data['phone'] = trim($_POST['phone'] ?? '');
            $data['email'] = trim($_POST['email'] ?? '');
            $data['isphone'] = isset($_POST['isphone'])? 1 : 0;
            $data['is_verification'] = isset($_POST['is_verification'])? 1 : 0;
            $data['is_oem'] = isset($_POST['is_oem'])? 1 : 0;
            $data['admin_id'] = $login;
            $data['created'] = time();

            if($id===0){
                $page_id = $this->pdo->insert('pages', $data);
                $package = $this->page->set_package($page_id);
                
                if ($package) {
                    $this->page->set_score_ads($page_id, $package['numb_ads']);
                }
                else {
                    $this->page->set_score_ads($page_id, 0);
                }

                $content = array('id'=>$page_id, 'name'=> $data['name']);
                $this->savetablechangelogs('created', 'pages', $content);
            }else{
                $data['updated'] = time();
                $this->pdo->update('pages', $data, 'id='.$id);

                $content = array('id'=>$id, 'name' => $data['name']);
                $this->savetablechangelogs('edit', 'pages', $content);
            }
            $this->page->update_page_score($id);

            lib_redirect('?mod=pages&site=index');

        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_logo'){
            $upload = $this->img->upload_image_base64($this->page->get_folder_img($_POST['page_id']), @$_POST['img'], null, 200, 1);
            $rt = 0;
            if($upload){
                unset($data);
                @unlink($this->page->get_folder_img_upload($_POST['page_id']).$this->profile['logo']);
                $data['logo'] = $upload;
                $this->pdo->update('pages', $data, "id=".$_POST['page_id']);
                $rt = URL_UPLOAD.$this->page->get_folder_img($_POST['page_id']).$upload;
            }
            echo $rt; exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_logo_custom'){
            $upload = $this->img->upload_image_base64($this->page->get_folder_img($_POST['page_id']), @$_POST['img'], null, 300, 3);
            $rt = 0;
            if($upload){
                unset($data);
                @unlink($this->page->get_folder_img_upload($_POST['page_id']).$this->profile['logo_custom']);
                $data['logo_custom'] = $upload;
                $this->pdo->update('pages', $data, "id=".$_POST['page_id']);
                $rt = URL_UPLOAD.$this->page->get_folder_img($_POST['page_id']).$upload;
            }
            echo $rt; exit();
        }
        
        
        $page = $this->pdo->fetch_one('SELECT * FROM pages WHERE id='.$id);

        if (isset($page['logo'])) {
            $page['logo_img'] = URL_UPLOAD.$this->page->get_folder_img($page['id']).$page['logo'];
        }

        if (isset($page['logo_custom'])) {
            $page['logo_custom_img'] = URL_UPLOAD.$this->page->get_folder_img($page['id']).$page['logo_custom'];
        }

        $out = [];

        $out['Province'] = $this->help->get_select_location($page? $page['province_id']: 0, 0, 'Tỉnh thành phố');

        if ($page) {
            $out['type'] = $this->help->get_select_from_array($this->page->type, $page['type']);
            $out['taxonomy_id'] = $this->taxonomy->get_select_taxonomy('product', $page['taxonomy_id'], 0, 'a.level<2', 'Chưa chọn danh mục');
            $out['number_mem'] = $this->help->get_select_from_array($this->page->number_mem, $page['number_mem']);

            $out['District'] = $this->help->get_select_location($page['district_id'], $page['province_id'], 'Quận huyện');
            $out['Wards'] = $this->help->get_select_location($page['wards_id'], $page['district_id'], 'Phường xã');
        }
        else {
            $page['isphone'] = 0;
            $page['is_oem'] = 0;
            $page['is_verification'] = 0;

            $out['type'] = '';
            $out['taxonomy_id'] = [];
            $out['number_mem'] = 5;

            $out['District'] = [];
            $out['Wards'] = [];
        }
        
        $this->smarty->assign('page', $page);
        $this->smarty->assign('out', $out);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function autorun()
    {
        if(isset($_POST['action']) && $_POST['action']=='save_autorun'){
            if(@$_POST['id']>0){
                $data = [];
                $data['prefix_auto'] = trim(@$_POST['prefix']);
                $this->pdo->update('pages', $data, 'id=' . $_POST['id']);
            }
            exit();
        }
        if (isset($_POST['submit'])) {
            $data = [];
            $data['name'] = trim($_POST['name']);
            $data['updated'] = time();
            $this->pdo->update('pages', $data, 'id=' . $id);
            lib_redirect('?mod=pages&site=index');
        }
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $page = $this->pdo->fetch_one('SELECT * FROM pages WHERE id=' . $id);
        $this->smarty->assign('page', $page);
        $this->smarty->display(LAYOUT_DEFAULT);
    }    
    
    
    
    function intro(){
        $id = isset($_GET['id'])?intval($_GET['id']):0;
        
        if(isset($_POST['submit'])){
            $data = [];
            $data['name'] = trim($_POST['name']);
            $data['code'] = trim($_POST['code']);
            $data['name_short'] = trim($_POST['name_short']);
            $data['name_global'] = trim($_POST['name_global']);
            $data['date_start'] = date("Y-m-d", strtotime(trim($_POST['date_start'])));
            $data['type'] = intval($_POST['type']);
            $data['number_mem'] = intval($_POST['number_mem']);
            $data['taxonomy_id'] = intval($_POST['taxonomy_id']);
            $data['province_id'] = intval($_POST['province_id']);
            $data['district_id'] = intval($_POST['district_id']);
            $data['wards_id'] = intval($_POST['wards_id']);
            $data['address'] = trim($_POST['address']);
            $data['website'] = trim($_POST['website']);
            $data['phone'] = trim($_POST['phone']);
            $data['email'] = trim($_POST['email']);
            $data['isphone'] = isset($_POST['isphone'])? 1 : 0;
            $data['is_verification'] = isset($_POST['is_verification'])? 1 : 0;
            $data['is_oem'] = isset($_POST['is_oem'])? 1 : 0;
            $data['created'] = time();
            if($id===0){
                $id = $this->pdo->insert('pages', $data);
                $content = array('id'=>$id, 'name'=>trim($_POST['name']));
                $this->savetablechangelogs('created', 'pages', $content);
            }else{
                $this->pdo->update('pages', $data, 'id='.$id);
                $content = array('id'=>$id, 'name'=>trim($_POST['name']));
                $this->savetablechangelogs('edit', 'pages', $content);
            }
            $this->page->update_page_score($id);
            lib_redirect('?mod=pages&site=index');
        }
        
        
        $page = $this->pdo->fetch_one('SELECT * FROM pages WHERE id='.$id);
        $this->smarty->assign('page', $page);
        
        $out = [];
        $out['type'] = $this->help->get_select_from_array($this->page->type, @$page['type']);
        $out['taxonomy_id'] = $this->taxonomy->get_select_taxonomy('product', $page['taxonomy_id'], 0, 'a.level<2', 'Chưa chọn danh mục');
        $out['Province'] = $this->help->get_select_location(@$page['province_id'], 0, 'Tỉnh thành phố');
        $out['District'] = $this->help->get_select_location(@$page['district_id'], @$page['province_id'], 'Quận huyện');
        $out['Wards'] = $this->help->get_select_location(@$page['wards_id'], @$page['district_id'], 'Phường xã');
        $out['number_mem'] = $this->help->get_select_from_array($this->page->number_mem, @$page['number_mem']);
        $this->smarty->assign('out', $out);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function package(){
        global $login, $lang;
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_package'){
            $id = intval(@$_POST['id']);
            $result = $this->pdo->fetch_one("SELECT * FROM packages WHERE id=$id");
            echo json_encode($result);
            exit();
        }if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_package'){
            $id = intval(@$_POST['id']);
            $data['name'] = trim(@$_POST['name']);
            $data['description'] = trim(@$_POST['description']);
            $data['numb_showcase'] = trim(@$_POST['numb_showcase']);
            $data['numb_ads'] = trim(@$_POST['numb_ads']);
            $data['numb_sourcing'] = trim(@$_POST['numb_sourcing']);
            $data['numb_product'] = trim(@$_POST['numb_product']);
            $data['numb_event'] = trim(@$_POST['numb_event']);
            $data['numb_homelogo'] = trim(@$_POST['numb_homelogo']);
            $data['price'] = trim(@$_POST['price']);
            $data['sort'] = trim(@$_POST['sort']);
            $data['limit_push_top'] = trim(@$_POST['limit_push_top']);
            if($id==0){
                $data['status'] = 1;
                $this->pdo->insert('packages', $data);
            }else $this->pdo->update('packages', $data, "id=$id");
            echo 1; exit();
        }
        
        $result = $this->pdo->fetch_all("SELECT * FROM packages");
        foreach ($result AS $k=>$item){
            $result[$k]['status'] = $this->help_get_status($item['status'], 'packages', $item['id']);
        }
        
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function nation() {
        global $login, $lang;
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_nation'){
            $id = intval(@$_POST['id']);
            $result = $this->pdo->fetch_one("SELECT * FROM nations WHERE Id=$id");
            $result['banner'] = $this->img->get_image($this->folder, @$result['Image']);
            echo json_encode($result);
            exit();
        }
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_nation'){
            $id = intval(@$_POST['id']);
            $data = [];
            $data['Name'] = trim(@$_POST['name']);
            $data['Description'] = trim(@$_POST['description']);
            if($id==0){
                $data['Created'] = time();
                $data['Status'] = 1;
                $this->pdo->insert('nations', $data);
            }else $this->pdo->update('nations', $data, "Id=$id");
            
            if(isset($_POST['banner']) && $_POST['banner']!=''){
                $imgname = $this->img->upload_image_base64($this->folder, $_POST['banner']);
                $data = [];
                $data['Image'] = $imgname;
                $this->pdo->update('nations', $data, 'Id='.$id);
            }
            echo 1; exit();
        }
        $result = $this->pdo->fetch_all("SELECT * FROM nations");
        foreach ($result AS $k=>$item){
            $result[$k]['Status'] = $this->help_get_status($item['Status'], 'nations', $item['Id']);
            $result[$k]['Logo'] = $this->img->get_image($this->folder, @$item['Image']);
        }
        
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function contact(){
        global $login, $lang;
        
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='send_msg'){
            $data['page_id'] = $this->page_id;
            $data['user_id'] = $login;
            $data['message'] = trim($_POST['message']);
            $data['parent'] = trim($_POST['parent']);
            $data['created'] = time();
            $data['status'] = 1;
            $data['isreply'] = 1;
            $id = $this->pdo->insert('pagemessages', $data);
            unset($data);
            
            $data['status'] = 1;
            $this->pdo->update('pagemessages', $data, 'id='.intval($_POST['parent']));
            
            echo $id; exit();
        }
        
        
        $status = isset($_GET['status']) ? intval($_GET['status']) : -1;
        $type = isset($_GET['type']) ? intval($_GET['type']) : -1;
        $key = isset($_GET['key']) ? trim($_GET['key']) : '';
        $where = "a.parent=0";
        if($key) $where .= " AND (u.name LIKE '%$key%' OR a.message LIKE '%$key%')";
        if($type!=-1) $where .= " AND ".($type==1?"a.product_id=0":"a.product_id<>0");
        if($status!=-1) $where .= " AND a.status=$status";
        
        
        $sql = "SELECT a.id,a.user_id,u.name,u.avatar,a.message,a.created
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id
				WHERE $where ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('pagemessages', $where), 10);
        $sql = $paging->get_sql_limit($sql);
        
        $parents = $this->pdo->fetch_all($sql);
        foreach ($parents AS $k=>$item){
            $parents[$k]['url'] = "?mod=pages&site=contact&parent=".$item['id'];
            $parents[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['user_id']), $item['avatar']);
        }
        
        $parent_id = isset($_GET['parent']) ? intval($_GET['parent']) : intval(@$parents[0]['id']);
        $info = $this->pdo->fetch_one("SELECT a.id,a.user_id,u.name,u.avatar,a.created,a.product_id,a.number,a.unit_id,p.name AS productname,p.images
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id LEFT JOIN products p ON a.product_id=p.id
				WHERE a.id=$parent_id");
        if($info){
            $info['unit'] = $this->pdo->fetch_one_fields('taxonomy', 'name', "id=".@$info['unit_id']);
            $info['unit'] = $info['unit']==''?'Piece':$info['unit'];
            $info['avatar'] = $this->img->get_image($this->user->get_folder_img($info['user_id']), $info['avatar']);
            $info['productavatar'] = $this->product->get_avatar($info['product_id'], $info['images']);
            $info['producturl'] = $this->product->get_url($info['product_id'], $info['productname']);
        }
        $this->smarty->assign('info', $info);
        
        
        
        $contacts = $this->pdo->fetch_all("SELECT a.id,a.user_id,u.name,u.avatar,a.message,a.number,a.unit_id,a.created,a.isreply
				FROM pagemessages a LEFT JOIN users u ON a.user_id=u.id
				WHERE (a.parent=$parent_id OR a.id=$parent_id)
				ORDER BY a.id ASC");
        foreach ($contacts AS $k=>$item){
            $contacts[$k]['url'] = "?mod=contact&site=index&parent=".$item['id'];
            $contacts[$k]['avatar'] = $this->img->get_image($this->user->get_folder_img($item['user_id']), $item['avatar']);
        }
        
        $this->smarty->assign('parents', $parents);
        $this->smarty->assign('contacts', $contacts);
        $out['parent_id'] = $parent_id;

        // $out['select_status'] = $this->help->get_select_from_array($this->status, $status, "Trạng thái");
        // $out['select_type'] = $this->help->get_select_from_array($this->type, $type, 0);

        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    /** =========================================================================== */
    
    function ajax_delete() {
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        $page = $this->pdo->fetch_one("SELECT id,name FROM pages WHERE id=$id");
        if($page){
            $this->page->remove_folder($id);
            
            $this->pdo->query("DELETE FROM pageaddress WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagemessages WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagepartners WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageprofiles WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagesupporters WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagethemes WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageusers WHERE page_id=$id");
            
            $this->pdo->query("DELETE FROM pageservices WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageservicemetas WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageserviceorders WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageserviceprices WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageservicepromos WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageservicesteps WHERE page_id=$id");
            
            $this->pdo->query("DELETE FROM pagepackage WHERE page_id=$id");

            $this->pdo->query("DELETE FROM pages WHERE id=$id");
            
            $content = array('id'=>$id, 'name'=>$page['name']);
            $this->savetablechangelogs('deleted', 'pages', $content);
            
            $products = $this->pdo->fetch_all('SELECT id FROM products WHERE page_id='.$id);
            foreach ($products AS $item){
                $id = $item['id'];
                if(!$this->pdo->check_exist('SELECCT 1 FROM productorderitems WHERE product_id='.$id)){
                    $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
                    $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
                    $this->pdo->query("DELETE FROM productfavorites WHERE product_id=$id");
                    $this->pdo->query("DELETE FROM products WHERE id=$id");
                }
            }
            
            $rt['code'] = 1;
            $rt['msg'] = "Xóa page thành công.";
        }
        
        echo json_encode($rt);
    }
    
    
    function ajax_delete_package() {
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if($this->pdo->check_exist("SELECT 1 FROM packages WHERE id=$id")){
            $this->pdo->query("DELETE FROM packages WHERE id=$id");
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin thành công.";
        }
        echo json_encode($rt);
    }
    
    function ajax_delete_nation() {
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        $value = $this->pdo->fetch_one("SELECT Image FROM nations WHERE Id=$id");
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if($this->pdo->check_exist("SELECT 1 FROM nations WHERE Id=$id")){
            $this->pdo->query("DELETE FROM nations WHERE Id=$id");
            @unlink( $this->img->get_image($this->folder, $value['Image']));
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin thành công.";
        }
        echo json_encode($rt);
    }
    
    
    
    function ajax_add_admin(){
        $page_id = intval($_POST['page_id']);
        $user_id = intval($_POST['user_id']);
        
        $rt = [];
        $rt['code'] = 0;
        if(!$this->pdo->check_exist("SELECT 1 FROM users WHERE id=$user_id")) $rt['msg'] = "Tài khoản không tồn tại";
        else if($this->pdo->check_exist("SELECT 1 FROM pageusers WHERE page_id=$page_id AND user_id=$user_id"))
            $rt['msg'] = "Tài khoản đã được set quản trị cho gian hàng này.";
            else{
                $data = [];
                $data['user_id'] = $user_id;
                $data['page_id'] = intval($_POST['page_id']);
                $data['created'] = time();
                $data['status'] = 1;
                $this->pdo->insert('pageusers', $data);
                $rt['code'] = 1;
                $rt['msg'] = "Tạo quản trị cho gian hàng thành công";
            }
            
            echo json_encode($rt); exit();
    }
    
    function ajax_update_score_monthly() {
        $package = $this->pdo->fetch_all("SELECT id,numb_ads FROM packages WHERE status=1");
        $package_score = [];
        foreach ($package AS $item){
            $package_score[$item['id']] = $item['numb_ads'];
        }
        
        $pages = $this->pdo->fetch_all("SELECT id,package_id FROM pages
                WHERE status=1 AND package_id>0 AND package_end>'".date('Y-m-d')."'
                AND score_updated<>'".date('Y-m').'-01'."'");
       
        foreach ($pages AS $item){
            $data = [];
            $data['score_ads'] = $package_score[$item['package_id']];
            $data['score_updated'] = date('Y-m').'-01';
            $data['created'] = time();
            $this->pdo->update('pages', $data, 'id='.$item['id']);
        }
        echo count($pages);
    }

    function ajax_delete_multi() {
        global $login;
        $ids = isset($_POST ['id']) ? $_POST ['id'] : 0;
        $deleted_arr = [];
        $notdeleted_arr = [];
        $deleted_id = [];
        
        foreach (explode(',', $ids) AS $id) {
            if($this->pdo->check_exist('SELECT 1 FROM pages WHERE id='.$id)){
                $page = $this->pdo->fetch_one("SELECT id,name FROM pages WHERE id=$id");
                $this->page->remove_folder($id);
                $products = $this->pdo->fetch_all("SELECT id FROM products WHERE page_id=$id");
                foreach ($products AS $item){
                    $p_id = $item['id'];
                    if(!$this->pdo->check_exist("SELECCT 1 FROM productorderitems WHERE product_id=$p_id")){
                        $this->pdo->query("DELETE FROM productmetas WHERE product_id=$p_id");
                        $this->pdo->query("DELETE FROM productprices WHERE product_id=$p_id");
                        $this->pdo->query("DELETE FROM productfavorites WHERE product_id=$p_id");
                        $this->pdo->query("DELETE FROM products WHERE id=$p_id");
                    }
                }
                $this->pdo->query("DELETE FROM pages WHERE id=$id");
                
                // $content = array('id'=>$id, 'name'=>$product['name']);
                // $this->savetablechangelogs('deleted', 'products', $content);

                array_push($deleted_arr, $page['name']);
                array_push($deleted_id, $page['id']);
                
                ##Gửi email
                $mail_to = array(
                    'TO' => array('admin@daisan.vn'),
                    'CC' => array('cntt.dsc@daisan.vn'),
                    'BCC' => array('chungit.dsc@daisan.vn')
                );
                $user = $this->pdo->fetch_one("SELECT name FROM useradmin WHERE id =$login");
                $mail_title = "[".$user['name']."] Xóa một danh sách sản phẩm";
                $mail_content = "Một danh sách gian hàng vừa bị xóa khỏi hệ thống Daisan.vn.";
                //send_mail($mail_to,"Delete List Pages" , $mail_title, $mail_content);
            }else{
                array_push($notdeleted_arr, $product['name']);
            }
        }
        
        $data = [];
        $data['deleted'] = implode('<br>', $deleted_arr);
        $data['notdeleted'] = implode('<br>', $notdeleted_arr);
        $data['deleted_id'] = implode('-', $deleted_id);
        
        echo json_encode($data);
    }
}