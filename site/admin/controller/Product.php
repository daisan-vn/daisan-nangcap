<?php

class Product extends Admin {
    
    function __construct() {
        parent::__construct();
        $this->product = \Lib\Dbo\Product::instance();
    }
    
    function index() {
        global $login;
        ini_set('memory_limit', '-1');
        $out = [];
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $toprank = isset($_GET['toprank']) ?   $_GET['toprank'] : -1;
        $page_id = isset($_GET['page_id']) ? $_GET['page_id'] : 0;
        $cate_id = isset($_GET['cat'])?intval($_GET['cat']):-1;
        $out['filter_toprank']= $this->help->get_select_from_array([0=>'Không Top',1=>'Toprank'], $toprank, 'Thể loại');
        $out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status, 'Trạng thái');
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_category'] = $this->taxonomy->get_select_taxonomy_tree('product', $cate_id, 0, null, 'Không có danh mục');
        $out['page_id'] = $page_id;
        
        $where = "1=1";
        $key = isset($_GET['key'])?trim($_GET['key']):'';
        if($status!=-1) $where.=" AND a.status=$status";
        if($toprank!=-1) $where.=" AND a.featured=$toprank";
        //if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.code LIKE '%".$_GET['key']."%')";
        if($page_id!=0) $where .= " AND a.page_id=$page_id";
        if($cate_id != -1){
            if($cate_id==0){
                $where .= " AND a.taxonomy_id=0";
            }else{
                $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cate_id) AND (SELECT rgt FROM taxonomy WHERE id=$cate_id))
                ORDER BY lft)";
            }
        }
        $sql = "SELECT a.id,a.name,a.code,a.images,a.status,a.created,a.featured,ad.name AS admin,a.number,a.promo,a.promo_date,a.page_id,a.source,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT b.name FROM pages b WHERE b.id=a.page_id) AS page,
                (SELECT b.page_name FROM pages b WHERE b.id=a.page_id) AS page_name,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price,
                (SELECT u.name FROM users u WHERE u.id=a.user_id) AS user_name";
        if($key!=''){
            $sql .= ",CASE WHEN a.name='$key' THEN 5 ELSE 0 END AS S1,
                CASE WHEN a.name LIKE '$key %' THEN 3 ELSE 0 END AS S2,
                CASE WHEN a.name LIKE '$key%' THEN 1 ELSE 0 END AS S3,
                CASE WHEN a.name LIKE '% $key %' THEN 1 ELSE 0 END AS S4";
            $a_key = explode(' ', $key);
            foreach ($a_key AS $k=>$v){
                if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1 ELSE 0 END AS F";
                $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X".$k;
            }
        }
        $sql .= " FROM products a LEFT JOIN useradmin ad ON ad.id=a.admin_id WHERE ".$where;
        if($key=='') $sql .= " ORDER BY a.created DESC";
        else{
            $values = "(S1+S2+S3+S4+F";
            $a_key = explode(' ', $key);
            foreach ($a_key AS $k=>$v){
                $values .= "+X".$k;
            }
            $values .= ")";
            
            $sql .= " HAVING $values > 0";
            $sql .= " ORDER BY $values DESC";
        }

        //$number = $this->pdo->count_rows($sql);
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 50);
//         $paging = new \Lib\Core\Pagination($number, 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        
        while ($item = $stmt->fetch()) {
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
            if(strtotime($item['promo_date'].' 23:59:59')-time() < 0) $item['promo'] = 0;
            $item['url']=$this->product->get_url($item['id'], $this->string->str_convert($item['name']));
            $item['page_url'] = $this->page->get_pageurl($item['page_id'], $item['page_name']);
            $item['url_seller'] = URL_PAGEADMIN . "?mod=home&site=connect&adminId=".$login."&pageId=".$item['page_id'];
            $item['status'] = $this->help_get_status($item ['status'], 'products', $item['id']);
            $item['featured'] = $this->help_get_featured($item['featured'], 'products', $item['id']);
            $result[] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function frontend() {
        $today = date("Y-m-d");
        ini_set('memory_limit', '-1');
        $out = [];
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $toprank = isset($_GET['toprank']) ? $_GET['toprank'] : -1;
        $page_id = isset($_GET['page_id']) ? $_GET['page_id'] : 0;
        $cate_id = isset($_GET['cat'])?intval($_GET['cat']):-1;
        $out['filter_toprank']= $this->help->get_select_from_array([0=>'Không Top',1=>'Toprank'], $toprank, 'Thể loại');
        $out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status, 'Trạng thái');
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_category'] = $this->taxonomy->get_select_taxonomy_tree('product', $cate_id, 0, null, 'Không có danh mục');
        $out['page_id'] = $page_id;
        
        $where = "1=1";
        $key = isset($_GET['key'])?trim($_GET['key']):'';
        if($status!=-1) $where.=" AND a.status=$status";
        if($toprank!=-1) $where.=" AND a.featured=$toprank";
        //if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.code LIKE '%".$_GET['key']."%')";
        if($page_id!=0) $where .= " AND a.page_id=$page_id";
        if($cate_id != -1){
            if($cate_id==0){
                $where .= " AND a.taxonomy_id=0";
            }else{
                $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cate_id) AND (SELECT rgt FROM taxonomy WHERE id=$cate_id))
                ORDER BY lft)";
            }
        }
        $sql = "SELECT a.product_id AS id,a.name,a.images,a.minorder,a.isimport,a.taxonomy_id,a.page_id,a.metas,(a.pagefee+a.pageverify) AS spage,
                    CASE WHEN a.price>0 THEN 1 ELSE 0 END AS isprice";
            if($key!=''){
                // Lấy danh sách sản phẩm
                $sql .= ",CASE WHEN a.name='$key' THEN 5 
                    WHEN a.name LIKE '$key %' THEN 3
                    WHEN a.name LIKE '$key%' THEN 1
                    WHEN a.name LIKE '% $key %' THEN 1
                    WHEN a.name LIKE '%$key%' THEN 1
                    ELSE 0 END AS S1";

                $a_key = explode(' ', $key);
                $c_key = count($a_key);
                if($c_key>=3 && $c_key<=4){
                    $new_a_key = [];
                    for($i=0; $i<=($c_key-2); $i++){
                        $new_a_key[] = $a_key[$i].' '.$a_key[$i+1];
                    }
                    foreach ($new_a_key AS $k=>$v){
                        //Điều kiện cho sản phẩm
                        if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS FG";
                        $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS XG".$k;
                    }
                }
                if($c_key>=4 && $c_key<=8){
                    $new_a_key_3c = [];
                    for($i=0; $i<=($c_key-3); $i++){
                        $new_a_key_3c[] = $a_key[$i].' '.$a_key[$i+1].' '.$a_key[$i+2];
                    }
                    foreach ($new_a_key_3c AS $k=>$v){
                        // Điều kiện cho sản phẩm
                        if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS F3C";
                        $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X3C".$k;
                    }
                    
                }
                if($c_key>1 && $c_key<=8){
                    foreach ($a_key AS $k=>$v){
                         // Điều kiện cho sản phẩm
                        if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 0.5 ELSE 0 END AS F";
                        $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1 WHEN a.name LIKE '% $v %' THEN 1 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X".$k;
                    }
                }
            }
            $sql .= ",CASE WHEN a.package_end < '$today' THEN 0
                        WHEN a.package_end >= '$today' THEN 1
                    ELSE 0
                    END AS flag_check";
            $sql .= " FROM productsearch a WHERE ".$where;
            if($key==''){
                $sql .= " GROUP BY a.page_id";
                $sql .= " ORDER BY flag_check DESC,a.featured DESC,a.ismain DESC,a.score DESC,a.id DESC,RAND()";
            }else{
                $values = "(S1";
                if($c_key>1 && $c_key<=8){
                    $values .= "+F";
                    foreach ($a_key AS $k=>$v){
                        $values .= "+X".$k;
                    }
                }
                if($c_key>=3 && $c_key<=4){
                    $values .= "+FG";
                    foreach ($new_a_key AS $k=>$v){
                        $values .= "+XG".$k;
                    }
                }
                $values .= ")";
                
                $sql .= " HAVING $values >= 1";
                if(isset($_GET['sort']) && $_GET['sort']=='price'){
                    $sql .= " ORDER BY $values DESC,a.price ASC,a.score DESC,a.ismain DESC,a.featured DESC";
                }else $sql .= " ORDER BY S1 DESC,$values DESC,flag_check DESC,a.ismain DESC,a.score DESC,a.id DESC";
            }
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 50);
//         $paging = new \Lib\Core\Pagination($number, 20);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        
        while ($item = $stmt->fetch()) {
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
           // if(strtotime($item['promo_date'].' 23:59:59')-time() < 0) $item['promo'] = 0;
            $item['url']=$this->product->get_url($item['id'], $this->string->str_convert($item['name']));
            $item['page'] = $this->pdo->fetch_one_fields('pages','name','id='.$item['page_id']);
            $item['category'] = $this->pdo->fetch_one_fields('taxonomy','name','id='.$item['taxonomy_id']);
          //  $item ['status'] = $this->help_get_status($item ['status'], 'products', $item['id']);
          //  $item ['featured'] = $this->help_get_featured($item['featured'], 'products', $item['id']);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function showcase() {
        $out = [];
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $page_id = isset($_GET['page_id']) ? $_GET['page_id'] : 0;
        $cate_id = isset($_GET['cat'])?intval($_GET['cat']):-1;
        $out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status, 'Trạng thái');
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_category'] = $this->taxonomy->get_select_taxonomy_tree('product', $cate_id, 0, null, 'Không có danh mục');
        $out['page_id'] = $page_id;
        
        $where = "a.ismain=1";
        if($status!=-1) $where.=" AND a.status = $status";
        if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.code LIKE '%".$_GET['key']."%')";
        if(isset($_GET['cat']) && intval($_GET['cat']) != 0) $where .= " AND a.taxonomy_id=".intval($_GET['cat']);
        if($page_id!=0) $where .= " AND a.page_id=$page_id";
        if($cate_id != -1){
            if($cate_id==0){
                $where .= " AND a.taxonomy_id=0";
            }else{
                $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cate_id) AND (SELECT rgt FROM taxonomy WHERE id=$cate_id))
                ORDER BY lft)";
            }
        }
        $sql = "SELECT a.id,a.name,a.code,a.images,a.status,a.created,a.featured,ad.name AS admin,a.page_id,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT b.name FROM pages b WHERE b.id=a.page_id) AS page,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price,
                (SELECT u.name FROM users u WHERE u.id=a.user_id) AS user_name
				FROM products a LEFT JOIN useradmin ad ON ad.id=a.admin_id WHERE $where ORDER BY a.created DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 50);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
            $item ['url'] = DOMAIN."?mod=product&site=detail&pid=".$item['id'];
            $item ['status'] = $this->help_get_status($item ['status'], 'products', $item['id']);
            $item ['featured'] = $this->help_get_featured($item['featured'], 'products', $item['id']);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function toprank() {
        $out = [];
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $cate_id = isset($_GET['cat'])?intval($_GET['cat']):-1;
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_category'] = $this->taxonomy->get_select_taxonomy_tree('product', $cate_id, 0, 'a.level<=1', 'Không có danh mục');
        
        $where = "a.featured=1 AND a.status=1";
        if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.code LIKE '%".$_GET['key']."%')";
        if($cate_id != -1){
            if($cate_id==0){
                $where .= " AND a.taxonomy_id=0";
            }else{
                $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cate_id) AND (SELECT rgt FROM taxonomy WHERE id=$cate_id))
                ORDER BY lft)";
            }
        }
        $sql = "SELECT a.id,a.name,a.code,a.images,a.page_id,a.score,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT b.name FROM pages b WHERE b.id=a.page_id) AS page,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price
				FROM products a WHERE $where ORDER BY a.score ASC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 50);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $item['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $item['avatar'] = @$item['a_img'][0];
            $item ['url'] = DOMAIN."?mod=product&site=detail&pid=".$item['id'];
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function attribute() {
        global $login;
        // EDIT
        if (isset($_GET['id'])) {
            $id = intval($_GET['id']);
            // get 1 attr
            $result = $this->pdo->fetch_one("SELECT * FROM groupattributes WHERE id=$id");
            $result['content'] = "";
            $result_contents = JSON_decode($result['contents']);
            foreach ($result_contents as $k => $v) {
                $result['content'] .= "$v->name\n";
            }
            $this->smarty->assign("result", $result);
            
            if(isset($_POST['submit'])){
                $attribute = $_POST['attribute'];
                $name = $_POST['name'];
                $tmp = explode(PHP_EOL, $attribute);
                
                $content = [];
                foreach ($tmp as $k => $v) {
                    if (strlen($v) > 1) {
                        foreach ($result_contents as $k2 => $v2) {
                            if (trim(@$v) === trim(@$v2->name)) {
                                $arr_push = [
                                    "name"      => chop($v),
                                    "contents"   => $v2->contents
                                ];
                                unset($result_contents[$k2]);
                                unset($tmp[$k]);
                                array_push($content, $arr_push);
                            }
                        }
                    }
                }
                foreach ($tmp as $k => $v) {
                    if (strlen($v) > 1){
                        $arr_push = [
                            "name"      => chop($v),
                            "contents"   => []
                        ];
                        array_push($content, $arr_push);
                    }
                }
                
                $data = [
                    "name" => $name,
                    "key_name" => $this->stripVN($name),
                    "contents" => json_encode($content, JSON_UNESCAPED_UNICODE),
                ];
                $this->pdo->update('groupattributes', $data, "id=".$id);
                lib_redirect("?mod=product&site=list_attribute");
            }
            // ADD
        }else {
            if(isset($_POST['submit'])){
                $attribute = $_POST['attribute'];
                $name = $_POST['name'];
                $tmp = explode(PHP_EOL, $attribute);
                $content = [];
                foreach ($tmp as $k => $v) {
                    if (strlen($v) > 1) {
                        $arr_push = [
                            "name"      => chop($v),
                            "contents"   => []
                        ];
                        array_push($content, $arr_push);
                    }
                }
                
//                 $json_content = json_encode($content, JSON_UNESCAPED_UNICODE);
                
                $data = [
                    "name" => $name,
                    "key_name" => $this->stripVN($name),
                    "contents" => json_encode($content, JSON_UNESCAPED_UNICODE ),
                    "created" => time(),
                    "admin_id" => $login,
                ];
                
                $this->pdo->insert('groupattributes', $data);
                lib_redirect("?mod=product&site=list_attribute");
            }
        }
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function list_attribute(){
        $result = $this->pdo->fetch_all("SELECT * FROM groupattributes ORDER BY id DESC");
        new \Lib\Core\Pagination($this->pdo->count_item('groupattributes', null), 50);
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function delete_attribute(){
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        if ($id != 0) {
            $this->pdo->query("DELETE FROM groupattributes WHERE id=$id");
        }
        
        lib_redirect("?mod=product&site=list_attribute");
    }
    
    function opt_attribute(){
        // $groupAttributes = $this->pdo->fetch_one("SELECT id,name FROM groupattributes ORDER BY id");
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        
        if ($id != 0) {
            $contents = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id =$id");
            $result = json_decode($contents['contents'], true);
            // echo "<pre>";
            // print_r($result);
            // echo "</pre>";
            foreach ($result as $k => $v) {
                $result[$k]['show_content'] = "";
                foreach ($v['contents'] as $v2) {
                    $v2_name = $v2['name'];
                    $result[$k]['show_content'] .= "$v2_name\n";
                }
            }
            // edit
            if(isset($_POST['submit'])){
                $lenght_attribute = $_POST['lenght_attribute'];
                $attr_contents = [];
                for ($i=1; $i <= $lenght_attribute; $i++) {
                    $attr_name = $_POST["name_$i"];
                    $attr_content =  $_POST["contents_$i"];
//                     $lenght_attribute_child = $_POST["lenght_attribute_child_$i"];
                    
                    $tmp = explode(PHP_EOL, $attr_content);
                    $arr_push = [
                        "name"      => chop($attr_name),
                        "contents"  => []
                    ];
                    foreach ($tmp as $k => $v) {
                        if(strlen($v) > 1) {
                            $arr_push_child = [
                                'name'      => chop($v),
                                'img_id'    => '',
                                'img_name'  => ''
                            ];
                            
                            array_push($arr_push['contents'], $arr_push_child);
                        }
                    }
                    
                    array_push($attr_contents, $arr_push);
                }
                
                foreach ($result as $va) {
                    foreach ($attr_contents as $kb => $vb) {
                        if (chop($va['name'] == chop($vb['name']))) {
                            foreach ($va['contents'] as $va2) {
                                foreach ($vb['contents'] as $kb2 => $vb2) {
                                    if (chop($va2['name'] == chop($vb2['name']))) {
                                        $attr_contents[$kb]['contents'][$kb2]['img_id']     = $va2['img_id'];
                                        $attr_contents[$kb]['contents'][$kb2]['img_name']   = $va2['img_name'];
                                    }
                                }
                            }
                        }
                    }
                }
                $data_update = [
                    "contents" => json_encode($attr_contents, JSON_UNESCAPED_UNICODE )
                ];
                $this->pdo->update('groupattributes', $data_update, "id=".$id);
                lib_redirect("?mod=product&site=list_attribute");
            }
        }else {
            lib_redirect("?mod=product&site=list_attribute");
        }
        
        $this->smarty->assign('result', $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function opt_attribute_img(){
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        
        if ($id != 0) {
            $contents = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id =$id");
            $result = json_decode($contents['contents'], true);
            $folder = URL_UPLOAD."attribute/";
            if(isset($_POST['submit'])){
                $lenght_attribute = $_POST['lenght_attribute'];
                $attr_contents = [];
                for ($i=0; $i < $lenght_attribute; $i++) {
                    $attr_name = $_POST["name_$i"];
                    $lenght_attribute_child = $_POST["lenght_attribute_$i"];
                    
                    $arr_push = [
                        "name"      => chop($attr_name),
                        "contents"  => []
                    ];
                    for ($j=0; $j < $lenght_attribute_child; $j++) {
                        $str_name_child = "name_".$i."_".$j;
                        $attr_name_child = $_POST[$str_name_child];
                        
                        $str_fileName = "fileName_".$i."_".$j;
//                         $attr_fileName = $_POST[$str_fileName];
                        
                        $str_imgName = "imgName_".$i."_".$j;
                        $attr_imgName = $_POST[$str_imgName];
                        
                        // upload img
                        if ($_FILES[$str_fileName]['error'] == 0) {
                            $img_name = $this->img->upload("attribute/", $_FILES[$str_fileName], 75);
                            $data_img = [
                                'name' => $img_name,
                            ];
                            $lastInsertId = $this->pdo->insert('attributeimages', $data_img);
                            $arr_push_child = [
                                'name'      => chop($attr_name_child),
                                'img_id'    => $lastInsertId,
                                'img_name'  => $img_name
                            ];
                        }else {
                            if ($attr_imgName != '') {
                                $arr_push_child = [
                                    'name'      => chop($attr_name_child),
                                    'img_id'    => '',
                                    'img_name'  => $attr_imgName
                                ];
                            }else {
                                $arr_push_child = [
                                    'name'      => chop($attr_name_child),
                                    'img_id'    => '',
                                    'img_name'  => ''
                                ];
                            }
                            
                        }
                        array_push($arr_push['contents'], $arr_push_child);
                    }
                    array_push($attr_contents, $arr_push);
                }
                $data_update = [
                    "contents" => json_encode($attr_contents, JSON_UNESCAPED_UNICODE )
                ];
                $this->pdo->update('groupattributes', $data_update, "id=".$id);
                lib_redirect("?mod=product&site=list_attribute");
            }
        }else {
            lib_redirect("?mod=product&site=list_attribute");
        }
        
        $this->smarty->assign('result', $result);
        $this->smarty->assign('folder', $folder);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function form(){
        global $login;
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        
        if(isset($_POST['submit'])){
            // $taxonomy_id = isset($_POST['taxonomy_id']) ? intval($_POST['taxonomy_id']) : 0;
            if (isset($_POST['taxonomy_id']) || $_POST['taxonomy_id'] != 0) {
                $taxonomy_id = intval(@$_POST['taxonomy_id']);
            }
            if (isset($_POST['taxonomy_id_c1']) && $_POST['taxonomy_id_c1'] != 0 && $_POST['taxonomy_id'] == 0) {
                $taxonomy_id = intval(@$_POST['taxonomy_id_c1']);
            }
            if (isset($_POST['taxonomy_id_c']) && $_POST['taxonomy_id_c'] != 0 && $_POST['taxonomy_id'] == 0 && $_POST['taxonomy_id_c1'] == 0) {
                $taxonomy_id = intval(@$_POST['taxonomy_id_c']);
            }
            // attribute_contents - start
            $lenght_attribute = intval(@$_POST['lenght_attribute']);
            $attribute_detail = [];
            $attribute_id = intval(@$_POST['attribute_id']);
            $attribute_db = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id=$attribute_id");
            $attribute_get_db = json_decode($attribute_db['contents'], true);
            $attribute_get_db = !is_array($attribute_get_db)?[]:$attribute_get_db;
            
            for ($i=1; $i <= $lenght_attribute; $i++) {
                $key = $_POST["detail_attribute_name_$i"];
                $value = $_POST["detail_attribute_content_$i"];
                $attribute_detail_push = [
                    "name" => $key,
                    "contents" => $value
                ];
                array_push($attribute_detail, $attribute_detail_push);
            }
            $attribute_user_custom = $attribute_detail;
            
            $attr_data = [];
            foreach ($attribute_get_db as $ka => $va) {
                foreach ($attribute_user_custom as $vb) {
                    if (chop($va['name'] == chop($vb['name']))) {
                        $attr_data_push = [
                            'name' => chop($vb['name']),
                            'contents' => []
                        ];
                        foreach ($va['contents'] as $ka2 => $va2) {
                            foreach ($vb['contents'] as $vb2) {
                                if (chop($va2['name']) == chop($vb2)) {
                                    $attr_data_child_push = [
                                        'name'      => chop($vb2),
                                        'img_id'    => $va2['img_id'],
                                        'img_name'  => $va2['img_name'],
                                    ];
                                    array_push($attr_data_push['contents'], $attr_data_child_push);
                                }
                            }
                        }
                        array_push($attr_data, $attr_data_push);
                    }
                }
            }
            $attribute_contents = json_encode($attr_data, JSON_UNESCAPED_UNICODE);
            
            // attribute_contents - end
            $data = [];
            $data['name'] = trim(@$_POST['name']);
            $data['taxonomy_id'] = $taxonomy_id;
            $data['code'] = trim(@$_POST['code']);
            $data['trademark'] = trim(@$_POST['trademark']);
            $data['ability'] = trim(@$_POST['ability']);
            $data['ordertime'] = trim(@$_POST['ordertime']);
            $data['minorder'] = intval(@$_POST['minorder']);
            $data['unit_id'] = intval(@$_POST['unit_id']);
            $data['description'] = trim(@$_POST['description']);
            $data['package'] = trim(@$_POST['package']);
            $data['qa'] = trim(@$_POST['qa']);
            $data['created'] = time();
            $data['admin_id'] = $login;
            $data['groupattributes_id'] = intval(@$_POST['attribute_id']);
            $data['attribute_contents'] = $attribute_contents;

            $html = \Lib\Help\HtmlDomParser::str_get_html($data['description']);
            $a_img = [];
            foreach(@$html->find('img') as $element){
                if(strpos($element->src,'../site/upload')===false&&
                    strpos($element->src,'https://daisan-image.s3.amazonaws.com/')===false&&
                    strpos($element->src,'https://daisan.vn/site/upload/')===false&&
                    strpos($element->src,'https://imgs.daisan.vn/')===false&&
                    strpos($element->src,'https://static01.daisan.vn/site/upload/')===false
                    ){
                    $a_img[] = trim($element->src);
                    $rt = $this->img->upload_image_fromurl('caches/',$element->src,800,0);
                    if($rt){
                        $rt = 'https://daisan.vn/site/upload/caches/'.$rt;
                        $data['description'] = str_replace($element->src, $rt, $data['description']);
                    }
                }
            }
            
            if(isset($_POST['key']) && is_array($_POST['key'])){
                $a_key = [];
                foreach ($_POST['key'] AS $k=>$item){
                    if(strlen($item)>2) $a_key[] = $this->product->get_keyword_id($item);
                }
                $data['keyword'] = implode(",", $a_key);
            }
            
            if($this->pdo->update('products', $data, "id=".$id)){
                // unset($data);
                $content = array('id'=>$id, 'name'=>trim(@$_POST['name']));
                $this->savetablechangelogs('edit', 'products', $content);
                ##Gửi email
//                 $mail_to = array(
//                     'TO' => array('admin@daisan.vn'),
//                     'CC' => array('cntt.dsc@daisan.vn'),
//                     'BCC' => array('chungit.dsc@daisan.vn')
//                 );
                
//                 $user = $this->pdo->fetch_one("SELECT name FROM useradmin WHERE id =$login");
                // mail - start
                // $mail_title = "[".$user['name']."] Edit ".$_POST['name'];
                // $mail_content = null;
                // $mail_content .= DOMAIN."?mod=product&site=detail&pid=$id";
                // send_mail($mail_to,"New Product" , $mail_title, $mail_content);
                // mail - end
                // $user = $this->pdo->fetch_one("SELECT name FROM useradmin WHERE id =$login");
                // $email = 'chungit.dsc@daisan.vn';
                // $mail_title = "[".$user['name']."] Edit ".$_POST['name'];
                // $mail_content = null;
                // $mail_content .= DOMAIN."?mod=product&site=detail&pid=$id";
                // $this->send_mail($email, $mail_title, $mail_content);
                
            }
            
            
            // UPDATE INDEX - START
            
            if ($id != 0 ) {
                $curl_get_product = $this->curl_search_get_product($id);
                $e_category = $this->pdo->fetch_one("SELECT name FROM taxonomy WHERE id=$taxonomy_id");
                
                $e_unit_name = trim(@$_POST['unit_name']);
                $curl_get_product['fields']['taxonomy_id']          = $data['taxonomy_id'];
                $curl_get_product['fields']['category']             = $e_category['name'];
                $curl_get_product['fields']['minorder']             = $data['minorder'];
                $curl_get_product['fields']['name']                 = $data['name'];
                $curl_get_product['fields']['unit']                 = $e_unit_name;
                $curl_get_product['fields']['groupattributes_id']   = $data['groupattributes_id'];
                $curl_get_product['fields']['attribute_contents']   = $data['attribute_contents'];
                
                $dataCURL_str = json_encode($curl_get_product['fields']);
                $this->curl_search_update_index($id, $dataCURL_str);
            }
            
            // UPDATE INDEX - END
            $service_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
            $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
            foreach ($service_detail AS $item){
                if(trim($item['key'])!=null && trim($item['value'])!=null){
                    $data = [];
                    $data['meta_key'] = trim($item['key'],":");
                    $data['meta_value'] = trim($item['value'],":");
                    $data['product_id'] = $id;
                    $this->pdo->insert('productmetas', $data);
                    unset($data);
                }
            }
            unset($_SESSION['service_add_detail']);
            
            $service_price = isset($_SESSION['service_add_price'])?$_SESSION['service_add_price']:[];
            $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
            $price = $this->string->convert_money_to_int($service_price[0]['value']);
            foreach ($service_price AS $item){
                if(trim($item['key'])!='' && trim($item['value'])!=''){
                    $data = [];
                    $data['version'] = $item['key'];
                    $data['price'] = $this->string->convert_money_to_int($item['value']);
                    $data['product_id'] = $id;
                    $this->pdo->insert('productprices', $data);
                    if($data['price']>0 && $data['price']<$price) $price = $data['price'];
                    unset($data);
                }
            }
            unset($_SESSION['service_add_price']);
            $data = [];
            $data['price'] = $price;
            $this->pdo->update('products', $data, "id=".$id);
            lib_redirect("?mod=product&site=index");
        }
        
        //lib_dump($_SESSION['service_add_price']); exit();
        
        $product = $this->pdo->fetch_one("SELECT * FROM products WHERE id=$id");
        $product['folder'] = $this->product->get_url_img($product['page_id']);
        $a_image = strlen($product['images']) > 30 ? explode(";", $product['images']) : [];
        
        $a_image_show = [];
        for ($i = 0; $i < 6; $i++) {
            if (isset($a_image[$i]) && is_file($this->product->get_folder_img_upload($id) . $a_image[$i])) {
                $a_image_show[$i] = $this->img->get_image($this->product->get_folder_img($id), $a_image[$i]);
            } else {
                $a_image_show[$i] = NO_IMG;
                unset($a_image[$i]);
            }
        }

        $product['images'] = implode(";", $a_image);
        
        $product['s_unit'] = $this->taxonomy->get_select_taxonomy('product_unit', @$product['unit_id'], 0, null, 'Chọn đơn vị');
        
        $keywords = $this->pdo->fetch_array_field('keywords', 'name', "id IN (".($product['keyword']==null?0:$product['keyword']).")");
        $this->smarty->assign('keywords', $keywords);
        
        
        $productmetas = $this->pdo->fetch_all("SELECT meta_key,meta_value FROM productmetas WHERE product_id=$id ORDER BY id");
        $_SESSION['service_add_detail'] = [];
        foreach ($productmetas AS $k=>$item){
            $_SESSION['service_add_detail'][$k]['key'] = $item['meta_key'];
            $_SESSION['service_add_detail'][$k]['value'] = $item['meta_value'];
        }
        
        $productprices = $this->pdo->fetch_all("SELECT version,price FROM productprices WHERE product_id=$id ORDER BY id");
        $_SESSION['service_add_price'] = [];
        foreach ($productprices AS $k=>$item){
            $_SESSION['service_add_price'][$k]['key'] = $item['version'];
            $_SESSION['service_add_price'][$k]['value'] = number_format($item['price']);
        }
        
        if($product['taxonomy_id']!==0){
            $tid_1 = $this->taxonomy->get_biggest_parent('product', @$product['taxonomy_id']);
            $taxonomy = $this->pdo->fetch_one("SELECT id,parent,level FROM taxonomy WHERE type='product' AND id=". @$product['taxonomy_id']);
            if($taxonomy && @$taxonomy['parent']!=0){
                $tid_2 = $taxonomy['parent'];
                $tid_3 = $taxonomy['id'];
            }
        }
        $out = [];
        $out['select_category'] = $this->taxonomy->get_select_taxonomy('product', @$tid_1, 0, null, 'Chọn danh mục sản phẩm');
        $out['select_category_sub1'] = '';
        $out['select_category_sub2'] = '';
        if(isset($tid_2) && $tid_2!=0)
            $out['select_category_sub1'] = $this->taxonomy->get_select_taxonomy('product', @$tid_2, @$tid_1, null, 'Chọn danh mục sản phẩm');
        if(isset($tid_3) && $tid_3!=0)
            $out['select_category_sub2'] = $this->taxonomy->get_select_taxonomy('product', @$tid_3, @$tid_2, null, 'Chọn danh mục sản phẩm');
                
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        
        $json_keywords = @file_get_contents(FILE_KEYWORDS);
        $groupAttributes = $this->pdo->fetch_all("SELECT id,name FROM groupattributes ORDER BY id");
        $groupAttributes_id = $product['groupattributes_id'];
        $curGroupAttributes = $this->pdo->fetch_one("SELECT id,name,contents FROM groupattributes WHERE id=$groupAttributes_id");
        $dataAttribute = json_decode($curGroupAttributes['contents'], true);
        $dataAttribute = !is_array($dataAttribute)?[]:$dataAttribute;
        $product_contents = json_decode($product['attribute_contents'], true);
        
        foreach ($dataAttribute as $ka => $va) {
            foreach ($product_contents as $vb) {
                if (chop($va['name']) == chop($vb['name'])) {
                    if (count($vb['contents']) > 0) {
                        $dataAttribute[$ka]['contents_actived'] = $vb['contents'];
                        foreach ($va['contents'] as $ka2 => $va2) {
                            foreach ($vb['contents'] as $vb2) {
                                if (chop($va2['name']) == chop($vb2['name'])) {
                                    $dataAttribute[$ka]['contents'][$ka2]['actived'] = 'true';
                                }
                            }
                        }
                    }
                }
            }
        }
        $folder = URL_UPLOAD."attribute/";
        $this->smarty->assign('folder', $folder);
        $this->smarty->assign('dataAttribute', $dataAttribute);
        $this->smarty->assign('product_contents', $product_contents);
        $this->smarty->assign('groupAttributes', $groupAttributes);
        $this->smarty->assign('json_keywords', $json_keywords);
        $this->smarty->assign('a_image_show', $a_image_show);
        $this->smarty->assign('product', $product);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function add_fast(){
        $out = [];
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $page_id = isset($_GET['page_id']) ? $_GET['page_id'] : 0;
        $cate_id = isset($_GET['cat'])?intval($_GET['cat']):-1;
        $out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status, 'Trạng thái');
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_category'] = $this->taxonomy->get_select_taxonomy_tree('product', $cate_id, 0, null, 'Không có danh mục');
        $out['page_id'] = $page_id;
        
        $where = "1=1";
        if($status!=-1) $where.=" AND a.status = $status";
        if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.code LIKE '%".$_GET['key']."%')";
        if(isset($_GET['cat']) && intval($_GET['cat']) != 0) $where .= " AND a.taxonomy_id=".intval($_GET['cat']);
        if($page_id!=0) $where .= " AND a.page_id=$page_id";
        if($cate_id != -1){
            if($cate_id==0){
                $where .= " AND a.taxonomy_id=0";
            }else{
                $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cate_id) AND (SELECT rgt FROM taxonomy WHERE id=$cate_id))
                ORDER BY lft)";
            }
        }
        $sql = "SELECT a.id,a.name,a.code,a.images,a.status,a.created,a.featured,a.groupattributes_id,a.attribute_contents,ad.name AS admin,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category,
				(SELECT b.name FROM pages b WHERE b.id=a.page_id) AS page,
				(SELECT p.price FROM productprices p WHERE a.id=p.product_id ORDER BY p.price LIMIT 1) AS price,
                (SELECT u.name FROM users u WHERE u.id=a.user_id) AS user_name,
                (SELECT x.contents FROM groupattributes x WHERE x.id=a.groupattributes_id) AS contents_attr
				FROM products a LEFT JOIN useradmin ad ON ad.id=a.admin_id WHERE $where ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('products', $where), 50);
        $sql = $paging->get_sql_limit($sql);
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $a_images = explode(";", $item['images']);
            $item ['avatar'] = $this->img->get_image($this->product->get_folder_img($item['id']), @$a_images[0]);
            //$item ['url'] = DOMAIN."?mod=product&site=detail&pid=".$item['id'];
            $item['url']=$this->product->get_url($item['id'], $this->str->str_convert($item['name']));
            $item ['status'] = $this->help_get_status($item ['status'], 'products', $item['id']);
            $item ['featured'] = $this->help_get_featured($item['featured'], 'products', $item['id']);
            $result [] = $item;
        }
        
        $groupAttr = $this->pdo->fetch_all("SELECT id,name FROM groupattributes ORDER BY id");
        $folder = URL_UPLOAD."attribute/";
        // xfast
        foreach ($result as $k => $v) {
            // $result[$k]['contents_attr_fix']        = json_decode($v['contents_attr'], true);
            $result[$k]['arr_attribute_contents']   = json_decode($v['attribute_contents'], true);
            $result[$k]['arr_contents_attr']        = json_decode($v['contents_attr'], true);
        }
        
        foreach ($result as $k => $v) {
            foreach ($v['arr_contents_attr'] as $ka => $va) {
                foreach ($v['arr_attribute_contents'] as $vb) {
                    if (chop($va['name']) == chop($vb['name'])) {
                        $result[$k]['arr_contents_attr'][$ka]['actived'] == [];
                        foreach ($va['contents'] as $ka2 => $va2) {
                            foreach ($vb['contents'] as $vb2) {
                                if (chop($va2['name']) == chop($vb2['name'])) {
                                    $result[$k]['arr_contents_attr'][$ka]['contents'][$ka2]['actived'] = 'true';
                                }
                            }
                        }
                    }
                }
            }
            
        }
        // echo "<pre>";
        // print_r($result);
        // echo "</pre>";
        // die();
        $this->smarty->assign('folder', $folder);
        $this->smarty->assign("result", $result);
        $this->smarty->assign("groupAttr", $groupAttr);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function load_details(){
        $service_add_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
        $service_add_detail = @array_values($service_add_detail);
        $_SESSION['service_add_detail'] = $service_add_detail;
        $out = [];
        $out['number'] = count($service_add_detail);
        $this->smarty->assign('result', $service_add_detail);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function load_prices(){
        $service_add_price = isset($_SESSION['service_add_price'])?$_SESSION['service_add_price']:[];
        $service_add_price = @array_values($service_add_price);
        $_SESSION['service_add_price'] = $service_add_price;
        $out = [];
        $out['number'] = count($service_add_price);
        $this->smarty->assign('result', $service_add_price);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function ajax_handle(){
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_images'){
            $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
            $page_id = $this->product->get_folder_img($id);
            
            if (empty($_FILES['file'])) {
                echo 'Duong dan anh khong ton tai!';
                exit();
            }
            
            //duong dan upload
            
            $file_data = $_FILES['file']['tmp_name'];
            $type = $_FILES['file']['type'];
            
            list(, $type)	= explode("/", $type);
            $imgname = null;
            $imgname = ($imgname==null||$imgname=='') ? 'hodine_img' : $imgname;
            $filename = time()."_".md5($imgname).".".$type;
            
            $fields = [
                'uploaded_file' => curl_file_create($file_data, $type, $filename),
                'width' => 270,
                'height' => 270,
                'name_file_upload' => DIR_UPLOAD_S3 . $page_id,
                'type_resize' => 'fit',
                'id' => $id,
            ];
            
            $product = $this->pdo->fetch_one("SELECT a.images FROM products a WHERE a.id=$id");
            
            $a_image = strlen($product['images'])>30 ? explode(";", $product['images']) : [];
            for ($i=0; $i<6; $i++){
                if(isset($a_image[$i]) && is_file($this->product->get_folder_img_upload($id).$a_image[$i])){
                    $a_image_show[$i] = $this->img->get_image($this->product->get_folder_img($id), $a_image[$i]);
                }else{
                    $a_image_show[$i] = NO_IMG;
                    unset($a_image[$i]);
                }
            }
            
            $upload = $this->img->upload_image_base64_v1($this->product->get_folder_img($id), @$_POST['img'], $filename, 800, 1);
            if(in_array(DOMAIN, ['https://v2.daisan.vn/','https://daisan.vn/'])&&!is_localhost()){
                $this->callApiUpload(DOMAIN_API.'resize-image',  $fields, 'POST');
            }
            
            $a_image[] = $upload;
            $data = [];
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
            $content = array('id'=>$id, 'image'=>$upload);
            $this->savetablechangelogs('edit', 'products', $content);
            echo $upload;
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='update_score'){
            $data = [];
            $data['score'] = intval(@$_POST['score']);
            $this->pdo->update('products', $data, 'id='.intval(@$_POST['id']));
            $rt = [];
            $rt['code'] = 1;
            $rt['msg'] = 'Cập nhật thành công';
            echo json_encode($_POST);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='update_number'){
            $data = [];
            $data['number'] = intval(@$_POST['number']);
            $this->pdo->update('products', $data, 'id='.intval(@$_POST['id']));
            echo json_encode($_POST);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='update_promo'){
            $data = [];
            $data['promo'] = intval(@$_POST['promo']);
            //$data['promo_date'] = date('Y-m-d', strtotime('+'.(7-date('w')).' days'));
            $data['promo_date'] = date('Y-m-d', strtotime('+1 month'));
            $this->pdo->update('products', $data, 'id='.intval(@$_POST['id']));
            echo json_encode($_POST);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_images'){
            $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
            
            $product = $this->pdo->fetch_one("SELECT a.images FROM products a WHERE a.id=$id");
            $a_image = strlen($product['images'])>30 ? explode(";", $product['images']) : [];
            
            for ($i=0; $i<6; $i++){
                if(isset($a_image[$i]) && is_file($this->product->get_folder_img_upload($id).$a_image[$i])){
                    $a_image_show[$i] = $this->img->get_image($this->product->get_folder_img($id), $a_image[$i]);
                }else{
                    $a_image_show[$i] = NO_IMG;
                    unset($a_image[$i]);
                }
            }
            
            if(in_array(DOMAIN, ['https://v2.daisan.vn/','https://daisan.vn/'])&&!is_localhost()){
                $data = [];
                $data['path_image'] = [
                    $this->product->get_folder_img_upload_s3($id).'270x270/'.@$_POST['imgname'],
                    $this->product->get_folder_img_upload_s3($id).'800x800/'.@$_POST['imgname'],
                ];
                
                $this->callAPI(DOMAIN_API.'delete-image', json_encode($data), 'POST');
            }
            
            @unlink($this->product->get_folder_img_upload($id).@$_POST['imgname']);
            
            foreach ($a_image AS $k=>$item){
                if(!is_file($this->product->get_folder_img_upload($id).$item)) unset($a_image[$k]);
            }
            
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
            $content = array('id'=>$id, 'image'=>'remove image');
            $this->savetablechangelogs('edit', 'products', $content);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_category'){
            $rt = $this->taxonomy->get_select_taxonomy('product', 0, @$_POST['id'], null, 'Chọn danh mục sản phẩm');
            echo $rt;
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_taxonomy_multi_product'){
            $ids = isset($_POST['ids'])?$_POST['ids']:[];
            $taxonomy_id = isset($_POST['taxonomy_id'])?$_POST['taxonomy_id']:0;
            $rt = 0;
            if($taxonomy_id!=0 && count($ids)>0){
                $data = [];
                $data['taxonomy_id'] = $taxonomy_id;
                $this->pdo->update('products', $data, "id IN (".implode(',', $ids).")");
                $rt = 1;
            }
            echo $rt; exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_detail'){
            $service_add_detail = isset($_SESSION['service_add_detail'])?$_SESSION['service_add_detail']:[];
            $number = count($service_add_detail);
            $rt['code'] = 1;
            if($number>14){
                $rt['code'] = 0;
                $rt['msg'] = "Đã vượt quá nội dung cho phép.";
            }else{
                $_SESSION['service_add_detail'][$number+1]['key'] = "";
                $_SESSION['service_add_detail'][$number+1]['value'] = "";
            }
            echo json_encode($rt);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_detail'){
            $_SESSION['service_add_detail'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='delete_detail'){
            unset($_SESSION['service_add_detail'][$_POST['id']]);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='sort_detail'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : -1;
            $type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
            $me = $_SESSION['service_add_detail'][$id];
            if($type=='up'){
                $up = $_SESSION['service_add_detail'][$id-1];
                $_SESSION['service_add_detail'][$id-1] = $me;
                $_SESSION['service_add_detail'][$id] = $up;
            }else{
                $up = $_SESSION['service_add_detail'][$id+1];
                $_SESSION['service_add_detail'][$id+1] = $me;
                $_SESSION['service_add_detail'][$id] = $up;
            }
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_price'){
            $service_add_price = isset($_SESSION['service_add_price'])?$_SESSION['service_add_price']:[];
            $number = count($service_add_price);
            $rt['code'] = 1;
            if($number>10){
                $rt['code'] = 0;
                $rt['msg'] = "Bạn chỉ được phép đưa tối đa 6 nội dung.";
            }else{
                $_SESSION['service_add_price'][$number+1]['key'] = "";
                $_SESSION['service_add_price'][$number+1]['value'] = "";
            }
            echo json_encode($rt);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_price'){
            $_SESSION['service_add_price'][$_POST['id']][$_POST['type']] = trim($_POST['value']);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='delete_price'){
            unset($_SESSION['service_add_price'][$_POST['id']]);
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='sort_price'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : -1;
            $type = isset($_POST['type']) ? trim($_POST['type']) : 'up';
            $me = $_SESSION['service_add_price'][$id];
            if($type=='up'){
                $up = $_SESSION['service_add_price'][$id-1];
                $_SESSION['service_add_price'][$id-1] = $me;
                $_SESSION['service_add_price'][$id] = $up;
            }else{
                $up = $_SESSION['service_add_price'][$id+1];
                $_SESSION['service_add_price'][$id+1] = $me;
                $_SESSION['service_add_price'][$id] = $up;
            }
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_detail_attribute'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            if ($id != 0) {
                $result = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id=$id");
                echo json_encode($result['contents'], JSON_UNESCAPED_UNICODE);
            }
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='upload_image_attribute'){
            $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
            $product = $this->pdo->fetch_one("SELECT a.images FROM products a WHERE a.id=$id");
            $a_image = strlen($product['images'])>30 ? explode(";", $product['images']) : [];
            for ($i=0; $i<6; $i++){
                if(isset($a_image[$i]) && is_file($this->product->get_folder_img_upload($id).$a_image[$i])){
                    $a_image_show[$i] = $this->img->get_image($this->product->get_folder_img($id), $a_image[$i]);
                }else{
                    $a_image_show[$i] = NO_IMG;
                    unset($a_image[$i]);
                }
            }
            
            $upload = $this->img->upload_image_base64($this->product->get_folder_img($id), @$_POST['img'], null, 800, 1);
            $a_image[] = $upload;
            $data['images'] = implode(";", $a_image);
            $this->pdo->update('products', $data, "id=$id");
            $content = array('id'=>$id, 'image'=>$upload);
            $this->savetablechangelogs('edit', 'products', $content);
            echo $upload;
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_image_attribute'){
            
            $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
//             $folder     = $_POST['folder'];
            $imgName    = $_POST['imgName'];
            $imgID      = $_POST['imgID'];
            
            if($imgName != null || $imgName != ''){
                if(is_file(DIR_UPLOAD ."attribute/". $imgName)){
                    @unlink(DIR_UPLOAD ."attribute/". $imgName);
                }
            }
            
            $this->pdo->query("DELETE FROM attributeimages WHERE id=$imgID");
            echo true;
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_fast_one'){
            $id             = intval($_POST['id']);
            $attribute_id   = intval($_POST['attribute_id']);
            $attr           = $_POST['attr'];
            
            $result_attr_contents = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id=".$attribute_id);
            $attr_contents = json_decode($result_attr_contents['contents'], true);
            $new_data = [];
            foreach ($attr_contents as $va) {
                foreach ($attr as $vb) {
                    if (chop($va['name']) == chop($vb['name'])) {
                        $arr_push = [
                            'name' => chop($va['name']),
                            'contents' => [],
                        ];
                        
                        foreach ($va['contents'] as $va2) {
                            foreach ($vb['contents'] as $vb2) {
                                if (chop($va2['name']) == chop($vb2)) {
                                    $arr_push_child = [
                                        'name' => chop($va2['name']),
                                        'img_id' => $va2['img_id'],
                                        'img_name' => $va2['img_name']
                                    ];
                                    array_push($arr_push['contents'], $arr_push_child);
                                }
                            }
                        }
                        
                        array_push($new_data, $arr_push);
                    }
                }
            }
            
            $new_data = json_encode($new_data, JSON_UNESCAPED_UNICODE );
            $new_update = [
                'groupattributes_id' => $attribute_id,
                'attribute_contents' => $new_data,
            ];
            
            $this->pdo->update('products', $new_update, "id=$id");
            
            // update index
            $curl_get_product = $this->curl_search_get_product($id);
            
            $curl_get_product['fields']['groupattributes_id'] = $new_update['groupattributes_id'];
            $curl_get_product['fields']['attribute_contents'] = $new_update['attribute_contents'];
            
            $dataCURL_str = json_encode($curl_get_product['fields']);
            $this->curl_search_update_index($id, $dataCURL_str);
            
            exit();
        }else if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='add_fast_select'){
            $ids             = $_POST['ids'];
            $attribute_id   = intval($_POST['attribute_id']);
            $attr           = $_POST['attr'];
            
            $result_attr_contents = $this->pdo->fetch_one("SELECT contents FROM groupattributes WHERE id=".$attribute_id);
            $attr_contents = json_decode($result_attr_contents['contents'], true);
            $new_data = [];
            foreach ($attr_contents as $va) {
                foreach ($attr as $vb) {
                    if (chop($va['name']) == chop($vb['name'])) {
                        $arr_push = [
                            'name' => chop($va['name']),
                            'contents' => [],
                        ];
                        
                        foreach ($va['contents'] as $va2) {
                            foreach ($vb['contents'] as $vb2) {
                                if (chop($va2['name']) == chop($vb2)) {
                                    $arr_push_child = [
                                        'name' => chop($va2['name']),
                                        'img_id' => $va2['img_id'],
                                        'img_name' => $va2['img_name']
                                    ];
                                    array_push($arr_push['contents'], $arr_push_child);
                                }
                            }
                        }
                        
                        array_push($new_data, $arr_push);
                    }
                }
            }
            
            $new_data = json_encode($new_data, JSON_UNESCAPED_UNICODE );
            $new_update = [
                'groupattributes_id' => $attribute_id,
                'attribute_contents' => $new_data,
            ];
            
            foreach ($ids as $k => $v) {
                // update db
                $this->pdo->update('products', $new_update, "id=$v");
                
                // update indexes
                $curl_get_product = $this->curl_search_get_product($v);
                
                $curl_get_product['fields']['groupattributes_id'] = $new_update['groupattributes_id'];
                $curl_get_product['fields']['attribute_contents'] = $new_update['attribute_contents'];
                
                $dataCURL_str = json_encode($curl_get_product['fields']);
                $this->curl_search_update_index($v, $dataCURL_str);
            }
            
            echo $_POST['url'];
            exit();
        }
    }
    
    function set_mail_content(){
        $id = isset($_GET['id'])?intval($_GET['id']):0;
        $rfq = $this->pdo->fetch_one("SELECT a.title,a.description,a.number,a.price,a.created,
                un.name AS unit,u.name AS user,l.name AS location
                FROM rfq a LEFT JOIN taxonomy un ON un.id=a.unit_id LEFT JOIN users u ON u.id=a.user_id
                    LEFT JOIN locations l ON l.id=a.location_id
                WHERE a.id=$id");
        $rfq['url'] = URL_SOURCING.'?site=rfq_detail&id='.$id;
        $this->smarty->assign('data', $rfq);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    function productmetas(){
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_metas'){
            $metas = $this->pdo->fetch_one("SELECT meta_key,meta_value FROM taxonomymetas WHERE id=".intval($_POST['id']));
            echo json_encode($metas);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_metas'){
            $data = [];
            $data['meta_key'] = trim($_POST['meta_key']);
            $data['meta_value'] = 1;
            $data['taxonomy_id'] = intval($_POST['taxonomy_id']);
            $rt = [];
            $rt['code'] = 0;
            if($this->pdo->check_exist("SELECT 1 FROM taxonomymetas WHERE taxonomy_id=".$data['taxonomy_id']." AND meta_key='".$data['meta_key']."'")){
                $rt['msg'] = "Thuộc tính trùng lặp";
            }else{
                $id = intval(@$_POST['id']);
                if($id==0) $id = $this->pdo->insert('taxonomymetas', $data);
                else $this->pdo->update('taxonomymetas', $data, "id=$id");
                $rt['code'] = 1;
                $rt['msg'] = 'Lưu thông tin thành công';
            }
            echo json_encode($rt); exit();
        }
        
        $cat_l0 = isset($_GET['cat_l0'])?intval($_GET['cat_l0']):0;
        $cat_l1 = isset($_GET['cat_l1'])?intval($_GET['cat_l1']):0;
        $cat_l2 = isset($_GET['cat_l2'])?intval($_GET['cat_l2']):0;
        if(!$this->pdo->check_exist("SELECT 1 FROM taxonomy WHERE id=$cat_l2 AND parent=$cat_l1"))
            $cat_l2 = 0;
            
        $result = $this->pdo->fetch_all("SELECT id,meta_key,meta_value FROM taxonomymetas WHERE taxonomy_id=$cat_l2");
        
        $out = [];
        $out['s_cat_l0'] = $this->taxonomy->get_select_taxonomy('product', $cat_l0);
        $out['s_cat_l1'] = $this->taxonomy->get_select_taxonomy('product', $cat_l1, -1);
        if($cat_l0!=0) $out['s_cat_l1'] = $this->taxonomy->get_select_taxonomy('product', $cat_l1, $cat_l0);
        $out['s_cat_l2'] = $this->taxonomy->get_select_taxonomy('product', $cat_l2, -1);
        if($cat_l0!=0 && $cat_l1!=0) $out['s_cat_l2'] = $this->taxonomy->get_select_taxonomy('product', $cat_l2, $cat_l1);
        $out['taxonomy_id'] = $cat_l2;
        $this->smarty->assign('out', $out);
        
        $this->smarty->assign("result", $result);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function ads(){
        $out = [];
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $page_id = isset($_GET['page_id']) ? $_GET['page_id'] : 0;
        $campaign_id = isset($_GET['campaign_id']) ? $_GET['campaign_id'] : 0;
        $out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status, 'Trạng thái');
        $out['filter_keyword'] = $k = isset($_GET['key']) ? $_GET['key'] : "";
        $where = "1=1";
        $out['url'] = "?mod=product&site=ads";
        if($status!=-1){
            $where.=" AND a.status=$status";
            $out['url'] .= "&status=".$status;
        }
        if($k!=""){
            $where .= " AND (p.name LIKE '%$k%' OR c.name LIKE '%$k%' OR b.name LIKE '%$k%')";
            $out['url'] .= "&key=$k";
        }
        if($page_id!=0){
            $where.=" AND a.page_id=$page_id";
            $out['url'] .= "&page_id=".$page_id;
        }
        if($campaign_id!=0){
            $where.=" AND a.campaign_id=$campaign_id";
            $out['url'] .= "&campaign_id=".$campaign_id;
        }
        
        $sql = "SELECT a.*,p.name,p.images,c.name AS campaign_name,b.name AS page_name
                FROM adsproducts a
                LEFT JOIN products p ON p.id=a.product_id
                LEFT JOIN adscampaign c ON c.id=a.campaign_id
                LEFT JOIN pages b ON b.id=a.page_id
                WHERE p.status=1 AND c.status=1 AND b.status=1 AND $where ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->product->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url']=$this->product->get_url($item['id'], $this->string->str_convert($item['name']));
            $result[$k]['status'] = $this->help->get_btn_status($item['status'], 'adsproducts', $item['id']);
        }
        $this->smarty->assign("result", $result);
        
        $out['s_position'] = $this->help->get_select_from_array($this->product->ad_position);
        $this->smarty->assign('out', $out);
        
        $json_keywords = @file_get_contents(FILE_KEYWORDS);
        $this->smarty->assign('json_keywords', $json_keywords);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    function order() {
        global $login;
        $out = [];
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_status'){
            $id = intval(@$_POST['id']);
            $order = $this->pdo->fetch_one("SELECT status FROM productorders WHERE id=$id AND page_id=".$this->page_id);
            $rt = [];
            $rt['code'] = 0;
            if(!$order){
                $rt['msg'] = 'Xảy ra lỗi, vui lòng thử lại';
            }elseif($order['status']==4){
                $rt['msg'] = 'Đơn hàng đã được xử lý từ phía người dùng';
            }else{
                $data = [];
                $data['status'] = $_POST['status'];
                $data['updated'] = time();
                $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
                $rt['msg'] = 'Cập nhật đơn hàng thành công';
            }
            echo json_encode($rt);
            exit();
            
            $id = intval(@$_POST['id']);
            $data['status'] = $_POST['status'];
            $data['updated'] = time();
            $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_content'){
            $id = intval(@$_POST['id']);
            $order = $this->pdo->fetch_one("SELECT * FROM productorders WHERE id=$id");
            echo json_encode($order);
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_content'){
            $id = intval(@$_POST['id']);
            $data['customer'] = trim($_POST['customer']);
            $data['phone'] = trim($_POST['phone']);
            $data['email'] = trim($_POST['email']);
            $data['address'] = trim($_POST['address']);
            $data['description'] = trim($_POST['description']);
            $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
            exit();
        }
        
        $key = isset($_GET['key'])?$_GET['key']:null;
        $status = isset($_GET['status'])?$_GET['status']:-1;
        
        $where = "1=1";
        if($key!=null) $where .= " AND a.customer LIKE '%$key%'";
        if($status!=-1) $where .= " AND a.status=$status";
        
        $sql = "SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                p.name AS page_name,p.phone AS page_phone,p.address AS page_address,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a LEFT JOIN pages p ON p.id=a.page_id WHERE $where ORDER BY a.id DESC";
        $paging = new \Lib\Core\Pagination($this->pdo->count_item('productorders', $where), 20);
        $sql = $paging->get_sql_limit($sql);
        
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['url_seller'] = URL_PAGEADMIN . "?mod=home&site=connect&adminId=".$login."&pageId=".$item['page_id'];
            $result[$k]['code'] = "#OID".$item['page_id']."-".$item['id'];
            $result[$k]['status_btn'] = $this->get_status_btn($item['id'], $item['status']);
        }
        $this->smarty->assign('result', $result);
        
        $out['select_status'] = $this->help->get_select_from_array($this->product->order_status, $status, "Chọn trạng thái");
        $out['key'] = $key;
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function order_detail(){
        $id = isset($_REQUEST['id']) ? intval($_REQUEST['id']) : 0;
        
        $order = $this->pdo->fetch_one("SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                p.name AS page_name,p.phone AS page_phone,p.address AS page_address,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a LEFT JOIN pages p ON p.id=a.page_id WHERE a.id=".$id);
        $this->smarty->assign('order', $order);
        
        $detail = $this->pdo->fetch_all("SELECT a.price,a.number,a.product_id,b.name AS productname
                FROM productorderitems a LEFT JOIN products b ON b.id=a.product_id
                WHERE a.order_id=".$id);
        $this->smarty->assign('detail', $detail);

        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    
    
    function get_status_btn($id, $status){
        $status_class = "btn-primary dropdown-toggle";
        if($status==1||$status==2) $status_class = "btn-warning dropdown-toggle";
        elseif($status==3) $status_class = "btn-success";
        elseif($status==4||$status==5) $status_class = "btn-danger";
        
        $str = "<div class=\"btn-group\">";
        $str .= "<button type=\"button\" class=\"btn btn-sm $status_class\" ";
        if($status!=3&&$status!=4&&$status!=5)
            $str .= "data-toggle=\"dropdown\"";
            $str .= ">";
            $str .= $this->product->order_status[$status];
            if($status!=3&&$status!=4&&$status!=5){
                $str .= "<div class=\"dropdown-menu\">";
                if($status==0)
                    $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 1);\">Đang xử lý</a>";
                    if($status==0||$status==1)
                        $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 2);\">Giao hàng</a>";
                        if($status==2){
                            $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 3);\">Thành công</a>";
                            $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 5);\">Trả lại</a>";
                        }
                        $str .= "</div>";
            }
            $str .= "</button>";
            $str .= "</div>";
            return $str;
    }
    /** =========================================================================== */
    /** =========================================================================== */
    
    function ajax_delete() {
        global $login;
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        $rt = [];
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if($this->pdo->check_exist("SELECT 1 FROM products WHERE id=$id")){
            $product = $this->pdo->fetch_one("SELECT id,name,images FROM products WHERE id=$id");
            
            $a_images = explode(";", @$product['images']);
            $folder = $this->product->get_folder_img_upload(@$product['id']);
            foreach ($a_images AS $item){
                @unlink($folder.$item);
            }
            ##Gửi email
            $mail_to = array(
                'TO' => array('admin@daisan.vn'),
                'CC' => array('cntt.dsc@daisan.vn'),
                'BCC' => array('chungit.dsc@daisan.vn')
            );
            $user = $this->pdo->fetch_one("SELECT name FROM useradmin WHERE id =$login");
            $mail_title = "[".$user['name']."] Xóa sản phẩm ".$product['name'];
            $mail_content = "Sản phẩm ".$product['name']." vừa bị xóa khỏi hệ thống Daisan.vn.";
            //send_mail($mail_to,"Delete Product" , $mail_title, $mail_content);
            
            $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
            $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
            $this->pdo->query("DELETE FROM products WHERE id=$id");
            $content = array('id'=>$id, 'name'=>$product['name']);
            $this->savetablechangelogs('deleted', 'products', $content);
            
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
            
            //Remove index api
            $this->curl_search_delete_product($id);
        }
        echo json_encode($rt);
    }
    
    function ajax_delete_multi() {
        global $login;
        $ids = isset($_POST ['id']) ? $_POST ['id'] : 0;
        $deleted_arr = [];
        $notdeleted_arr = [];
        $deleted_id = [];
        
        foreach (explode(',', $ids) AS $id) {
            if(!$this->pdo->check_exist('SELECCT 1 FROM productorderitems WHERE product_id='.$id)){
                $product = $this->pdo->fetch_one("SELECT id,name,images FROM products WHERE id=$id");
                
                $a_images = explode(";", @$product['images']);
                $folder = $this->product->get_folder_img_upload(@$product['id']);
                foreach ($a_images AS $item){
                    @unlink($folder.$item);
                }
                $this->pdo->query("DELETE FROM productmetas WHERE product_id=$id");
                $this->pdo->query("DELETE FROM productprices WHERE product_id=$id");
                $this->pdo->query("DELETE FROM productfavorites WHERE product_id=$id");
                $this->pdo->query("DELETE FROM products WHERE id=$id");
                
                //Remove index api
                $this->curl_search_delete_product($id);
                
                $content = array('id'=>$id, 'name'=>$product['name']);
                $this->savetablechangelogs('deleted', 'products', $content);
                
                array_push($deleted_arr, $product['name']);
                array_push($deleted_id, $product['id']);
                
                ##Gửi email
                $mail_to = array(
                    'TO' => array('admin@daisan.vn'),
                    'CC' => array('cntt.dsc@daisan.vn'),
                    'BCC' => array('chungit.dsc@daisan.vn')
                );
                $user = $this->pdo->fetch_one("SELECT name FROM useradmin WHERE id =$login");
                $mail_title = "[".$user['name']."] Xóa một danh sách sản phẩm";
                $mail_content = "Một danh sách sản phẩm vừa bị xóa khỏi hệ thống Daisan.vn.";
                //send_mail($mail_to,"Delete List Product" , $mail_title, $mail_content);
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
    
    
    function ajax_delete_showcase() {
        $ids = isset($_POST ['id']) ? $_POST ['id'] : 0;
        $deleted_arr = [];
        $notdeleted_arr = [];
        $deleted_id = [];
        
        foreach (explode(',', $ids) AS $id) {
            if(!$this->pdo->check_exist('SELECCT 1 FROM productorderitems WHERE product_id='.$id)){
                $product = $this->pdo->fetch_one("SELECT id,name,images FROM products WHERE id=$id");
                $this->pdo->query("UPDATE products SET ismain=0 WHERE id=$id");
                
                array_push($deleted_arr, $product['name']);
                array_push($deleted_id, $product['id']);
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
    
    
    function ajax_delete_meta() {
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        $rt = [];
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if($this->pdo->check_exist("SELECT 1 FROM taxonomymetas WHERE id=$id")){
            $this->pdo->query("DELETE FROM taxonomymetas WHERE id=$id");
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin sản phẩm thành công.";
        }
        echo json_encode($rt);
    }
    
    
    function ajax_export_metas(){
        $taxonomy = $this->pdo->fetch_array_field('taxonomy', 'id', "type='product' AND level=2");
        $result = [];
        
        foreach ($taxonomy AS $item){
            $result[$item] = [];
            $metas = $this->pdo->fetch_all("SELECT b.taxonomy_id,a.meta_key,COUNT(1) AS number
                FROM productmetas a LEFT JOIN products b ON b.id=a.product_id
                WHERE b.taxonomy_id=$item
                GROUP BY a.meta_key
                HAVING number>0
                ORDER BY number DESC LIMIT 10");
            foreach ($metas AS $ksub=>$itemsub){
                $result[$item][$ksub]['parent'] = $itemsub['meta_key'];
                
                $meta_keys = $this->pdo->fetch_all("SELECT a.meta_value,COUNT(1) AS number
                    FROM productmetas a LEFT JOIN products b ON b.id=a.product_id
                    WHERE b.taxonomy_id=$item AND a.meta_key='".$itemsub['meta_key']."'
                    GROUP BY a.meta_value
                    ORDER BY number DESC LIMIT 10");
                $a_meta_key = [];
                foreach ($meta_keys AS $item2){
                    $a_meta_key[] = $item2['meta_value'];
                }
                $result[$item][$ksub]['sub'] = $a_meta_key;
                
            }
            
        }
        lib_dump($result);
        
        $fp = fopen(FILE_INFO_METAS, 'w');
        fwrite($fp, json_encode($result));
        fclose($fp);
    }
    
    function stripVN($str) {
        $str = preg_replace("/(à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ)/", 'a', $str);
        $str = preg_replace("/(è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ)/", 'e', $str);
        $str = preg_replace("/(ì|í|ị|ỉ|ĩ)/", 'i', $str);
        $str = preg_replace("/(ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ)/", 'o', $str);
        $str = preg_replace("/(ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ)/", 'u', $str);
        $str = preg_replace("/(ỳ|ý|ỵ|ỷ|ỹ)/", 'y', $str);
        $str = preg_replace("/(đ)/", 'd', $str);
        
        $str = preg_replace("/(À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ)/", 'A', $str);
        $str = preg_replace("/(È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ)/", 'E', $str);
        $str = preg_replace("/(Ì|Í|Ị|Ỉ|Ĩ)/", 'I', $str);
        $str = preg_replace("/(Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ)/", 'O', $str);
        $str = preg_replace("/(Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ)/", 'U', $str);
        $str = preg_replace("/(Ỳ|Ý|Ỵ|Ỷ|Ỹ)/", 'Y', $str);
        $str = preg_replace("/(Đ)/", 'D', $str);
        $str = preg_replace("/[-]+/i", "-", $str);
        $str = preg_replace("/[ ]+/i", '-', $str);
        return $str;
    }

    function ajax_copy_product(){
        $ids = isset($_POST['ids'])?$_POST['ids']:[];
        $page_id = isset($_POST['page_id'])?$_POST['page_id']:0;
        $page = $this->pdo->check_exist('SELECT 1 FROM pages WHERE id='.$page_id);

        $rt = [];
        if(!$page){
            $rt['code'] = 0;
            $rt['msg'] = 'Gian hàng không tồn tại';
        }else{
            foreach ($ids AS $item){
                $this->copy_product($item, $page_id);
            }
            $rt['code'] = 1;
            $rt['msg'] = 'Sao chép sản phẩm thành công.';
        }
        echo json_encode($rt);
        exit();
    }

    function copy_product($id, $page_id){
        $product = $this->pdo->fetch_one("SELECT * FROM products WHERE id=$id AND page_id<>$page_id");

        $product_id = 0;
        if($product){
            $old_page_id = $product['page_id'];
            unset($product['id']);
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

                $a_img = explode(";", $product['images']);
                foreach ($a_img AS $imgname){
                    $folder = $this->page->get_folder_img_upload($page_id);
//                    lib_dump($folder);
//                    exit();
                    if(!is_dir($folder)) if (!mkdir($folder, 0775) && !is_dir($folder)) {
                        throw new \RuntimeException(sprintf('Directory "%s" was not created', $folder));
                    }
                    @chmod($folder, 0775);

                    //upload amazon
                    //$file_data = $_FILES['file']['tmp_name'];
//                    $type = $_FILES['file']['type'];

//                    $file_data = strtolower(pathinfo($this->page->get_folder_img_upload($old_page_id).$imgname, PATHINFO_DIRNAME));
                    strtolower(pathinfo($this->page->get_folder_img_upload($old_page_id).$imgname, PATHINFO_EXTENSION));
                    strtolower(pathinfo($this->page->get_folder_img_upload($old_page_id).$imgname, PATHINFO_FILENAME));

//                    $type = strtolower(pathinfo($this->page->get_folder_img_upload(23949).'1594887798_9afdb01339ef137ea2f3fb1aa64a9024.jpeg', PATHINFO_EXTENSION));
//                    $filename = strtolower(pathinfo($this->page->get_folder_img_upload(23949).'1594887798_9afdb01339ef137ea2f3fb1aa64a9024.jpeg', PATHINFO_FILENAME));
//                    $file_data = realpath($this->page->get_folder_img_upload(23949).'1594887798_9afdb01339ef137ea2f3fb1aa64a9024.jpeg');
                    $file_data = realpath($this->page->get_folder_img_upload($old_page_id).$imgname);
//                    echo "<pre>";
//                    print_r($file_data);
//                    echo "</pre>";die;
//                    $curl_file_create = new CurlFile($file_data, $type, $filename);
                    $curl_file_create = new CurlFile($file_data, mime_content_type($file_data), basename($file_data));

                    $fields = [
//                        'uploaded_file' => curl_file_create($file_data, $type, $filename),
                        'uploaded_file' => $curl_file_create,
                        'width' => 270,
                        'height' => 270,
                        'name_file_upload' => DIR_UPLOAD_S3 . 'pages/' . $page_id. '/',
                        'type_resize' => 'fit',
                        'id' => $id,
                    ];

                    $this->callAPIUpload(DOMAIN_API.'resize-image',  $fields, 'POST');

                    @copy($this->page->get_folder_img_upload($old_page_id).$imgname, $folder.$imgname);

                }

            }
        }
        return intval($product_id);
    }
}