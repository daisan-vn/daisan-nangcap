<?php

class Scandb extends Admin {
    
    private $folder;
    
    function __construct() {
        parent::__construct();
        
        $this->folder = "./scancache/";
    }
    
    
    function index(){
        $out = [];
        $out['key'] = '';
        $sql = "SELECT a.id,a.name,a.website,a.logo,a.created,a.page_name,
                (SELECT COUNT(1) FROM products p WHERE p.page_id=a.id) AS products
                FROM pages a WHERE 1=1";
        if(isset($_GET['key'])&&@$_GET['key']!=''){
            $key = trim(base64_decode(@$_GET['key']));
            if(filter_var($key, FILTER_VALIDATE_URL)){
                $a_url = parse_url($key);
                $key = $a_url['host'];
            }
            $sql .= " AND (a.name LIKE '%$key%' OR a.website LIKE '%$key%')";
            $out['key'] = $key;
        }
        $sql .= " ORDER BY a.id DESC LIMIT 20";
        //var_dump($sql); exit();
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        $result = [];
        while ($item = $stmt->fetch()) {
            $item ['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
            $item ['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
            $result [] = $item;
        }
        $this->smarty->assign("result", $result);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function confrun(){
        if(isset($_POST['action']) && $_POST['action']=='load_prefix_auto'){
            $url = isset($_POST['url']) ? trim($_POST['url']) : '';
            $domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST);
            $page = $this->pdo->fetch_one("SELECT prefix_auto FROM pages WHERE website LIKE '$domain%'");
            echo @$page['prefix_auto'];
            exit();
        }elseif(isset($_POST['action']) && $_POST['action']=='save_autorun'){
            if(@$_POST['id']>0){
                $prefix = [];
                $prefix['url'] = trim(@$_POST['url']);
                $prefix['name'] = trim(@$_POST['name']);
                $prefix['image'] = trim(@$_POST['image']);
                $prefix['price'] = trim(@$_POST['price']);
                $prefix['code'] = trim(@$_POST['code']);
                $prefix['content'] = trim(@$_POST['content']);
                $prefix['metas'] = trim(@$_POST['metas']);
                
                $a_check = explode(',', trim(@$_POST['insite_check']));
                foreach ($a_check AS $k=>$v){
                    if(strlen($v)>4) $a_check[$k] = $this->string->str_convert($v);
                    else unset($a_check);
                }
                $prefix['insite_check'] = implode(',', $a_check);
                
                $data = [];
                $data['prefix_auto'] = json_encode($prefix);
                $this->pdo->update('pages', $data, 'id='.$_POST['id']);
            }
            exit();
        }
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $page = $this->pdo->fetch_one('SELECT * FROM pages WHERE id=' . $id);
        $prefix = json_decode($page['prefix_auto'],true);
        if(!is_array($prefix)){
            if($page['prefix_auto']!=''){
                $a_pre = explode('&&', @$page['prefix_auto']);
                foreach ($a_pre AS $v){
                    $a_v = explode('=', $v);
                    if(count($a_v)==2 && $a_v[0]!='') $prefix[$a_v[0]] = trim($a_v[1]);
                }
            }else $prefix = [];
        }
        if(!filter_var(@$prefix['url'], FILTER_VALIDATE_URL)) $prefix['url'] = @$page['website'];
        
        
        $info = [];
        if(filter_var($prefix['url'], FILTER_VALIDATE_URL)){
            $info = $this->_parse_html(['url'=>$prefix['url'],'prefix'=>$prefix,'conf'=>1]);
        }
        if(@$prefix['insite_check']=='' && count(@$info['text_insite'])>0) $prefix['insite_check'] = implode(',', $info['text_insite']);

        $this->smarty->assign('info', $info);
        $this->smarty->assign('prefix', $prefix);
        $this->smarty->assign('page', $page);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function load_pagecontent(){
        $url = isset($_POST['url'])?trim($_POST['url']):null;
        $pre = isset($_POST['prefix'])?trim($_POST['prefix']):'';
        $metas = ['url'=>$url,'prefix'=>$pre];
        
        $data = $this->_parse_html($metas);
        unset($data['a_links']);
        $data['a_metas'] = is_array(@$data['a_metas'])?$data['a_metas']:[];
        $this->smarty->assign('data', $data);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function reset(){
        if(isset($_POST['action']) && $_POST['action']=='scan'){
            $id = isset($_POST['id'])?intval($_POST['id']):1;
            $product = $this->pdo->fetch_one("SELECT id,images,page_id FROM products WHERE id=".$id);
            if($product){
                $a_img = explode(';', $product['images']);
                if(!is_file(DIR_UPLOAD.'pages/'.$product['page_id'].'/'.$a_img[0])){
                    $data = ['status'=>0];
                    $this->pdo->update('products', $data, 'id='.$id);
                }else{
                    if(!is_dir(DIR_UPLOAD.'thumb/'.$product['page_id'].'/')){
                        mkdir(DIR_UPLOAD.'thumb/'.$product['page_id'].'/', 0777);
                    }
                    
                    copy(DIR_UPLOAD.'pages/'.$product['page_id'].'/'.$a_img[0], DIR_UPLOAD.'thumb/'.$product['page_id'].'/'.$a_img[0]);
                    $this->img->resize_img_upload(DIR_UPLOAD.'thumb/'.$product['page_id'].'/'.$a_img[0], 270, 1);
                }
            }
            $newdb = $this->pdo->fetch_one("SELECT id FROM products WHERE id>".$id." ORDER BY id ASC LIMIT 1");
            echo intval(@$newdb['id']);
            exit();
        }
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function autorun(){
        $step = 10;
        $limit_prod = isset($_REQUEST['limit'])?intval($_REQUEST['limit']):50;
        if($limit_prod==0) $limit_prod = 1000000;
        $method = isset($_REQUEST['method'])?intval($_REQUEST['method']):0;
        if(isset($_POST['action']) && $_POST['action']=='start'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $links = json_decode(@file_get_contents($this->folder.$id.".json"), true);
            $links['scanned'] = is_array(@$links['scanned'])?$links['scanned']:[];
            $links['waiting'] = is_array(@$links['waiting'])?$links['waiting']:[];
            if($method==1){
                foreach ($links['scanned'] AS $v) $links['waiting'][] = $v;
                $links['scanned'] = [];
            }
            $cf = [];
            $cf['number_product'] = $this->pdo->count_item('products', 'page_id='.$id);
            $conf = $this->page_detail($id);
            if(!filter_var(@$conf['metas']['url'], FILTER_VALIDATE_URL)) $conf['metas']['url'] = @$conf['website'];
            $cf['metas'] = is_array(@$conf['metas'])?$conf['metas']:[];
            //$cf['prefix'] = $conf['prefix_auto'];
            $cf['running'] = [];
            if($cf['number_product']<=$limit_prod){
                if(isset($links['waiting']) && count($links['waiting'])>0){
                    for ($i=0; $i<$step; $i++){
                        if(isset($links['waiting'][$i])){
                            $cf['running'][] = $links['waiting'][$i];
                            unset($links['waiting'][$i]);
                        }
                    }
                    $links['waiting'] = @array_unique($links['waiting']);
                    $links['waiting'] = @array_values($links['waiting']);
                    if($method==1) $links['scanned'] = [];
                    file_put_contents($this->folder.$id.".json", json_encode($links));
                }else{
                    $cf['running'][] = $conf['metas']['url'];
                }
                $cf['scanned'] = [];
                $cf['newlink'] = [];
                $cf['stop'] = 0;
                $cf['time'] = 0;
                $cf['number'] = 0;
                $_SESSION['page_'.$id] = $cf;
                echo 1;
            }else echo 0;
            exit();
        }elseif(isset($_POST['action'])&&$_POST['action']=='scan'){
            $start = microtime(true);
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $k = isset($_POST['k']) ? intval($_POST['k']) : 0;
            $cf = is_array(@$_SESSION['page_'.$id])?$_SESSION['page_'.$id]:[];
            $url = @$cf['running'][$k];
            unset($cf['running'][$k]);
            $cf['scanned'][] = $url;
            
            $data = $this->_parse_html(['prefix'=>$cf['metas'],'url'=>$url]);
            if(is_array(@$data['a_links']) && count($data['a_links'])>0){
                foreach ($data['a_links'] AS $v) $cf['newlink'][] = $v;
            }
            
            $rt = $data;
            $rt['code'] = 0;
            if(@$data['image']=='') $rt['msg'] = 'Không có ảnh';
            elseif(@$data['name']!=''&&@$data['image']!=''&&@$data['is_product']==1){
                unset($data['a_links']);
                $data['src'] = $url;
                $data['page_id'] = $id;
                $data['user_id'] = @$this->login;
                $data['timer'] = round(microtime(true)-$start, 4);
                $save = $this->save_product($data, $id);
                if(@$save['code']==1){
                    $cf['number_product'] += 1;
                    $rt['code'] = 1;
                }
                $rt['msg'] = $save['msg'];
            }else $rt['msg'] = 'Dữ liệu không chính xác';
            
            if($cf['number_product']>=$limit_prod||($cf['number']>=5 && intval($cf['time']/$cf['number'])>=10)){
                foreach ($cf['running'] AS $v) $cf['newlink'][] = $v;
                $cf['running'] = [];
                $cf['stop'] = 1;
            }
            
            $rt['number'] = count($cf['running']);
            echo json_encode($rt);
            $cf['number'] += 1;
            $cf['time'] += (microtime(true)-$start);
            $_SESSION['page_'.$id] = $cf;
            exit();
        }elseif(isset($_POST['action'])&&$_POST['action']=='reset'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $cf = is_array(@$_SESSION['page_'.$id])?$_SESSION['page_'.$id]:[];
            $links = json_decode(@file_get_contents($this->folder.$id.".json"), true);
            $waiting = is_array(@$links['waiting'])?$links['waiting']:[];
            $scanned = is_array(@$links['scanned'])?$links['scanned']:[];
            
            foreach ($cf['scanned'] AS $v){
                $scanned[] = $v;
            }
            $scanned = @array_unique($scanned);
            $scanned = @array_values($scanned);
            
            foreach ($cf['newlink'] AS $v){
                $waiting[] = $v;
            }
            $waiting = @array_diff($waiting, $scanned);
            $waiting = $this->get_trueLink($waiting, @$cf['metas']['url'], @$cf['metas']['url_check']);
            $waiting = @array_unique($waiting);
            $waiting = @array_values($waiting);
            
            $cf['running'] = [];
            $number_product = $this->pdo->count_item('products', 'page_id='.$id);
//             if($cf['number']>=3 && intval($cf['time']/$cf['number'])>=10){
//                 $cf['stop'] = 1;
//             }
            
            if(@$cf['stop']==0&&$number_product<=$limit_prod){
                for ($i=0; $i<$step; $i++){
                    if(isset($waiting[$i])){
                        $cf['running'][] = $waiting[$i];
                        unset($waiting[$i]);
                    }
                }
                $waiting = @array_values($waiting);
            }
            
            $cf['scanned'] = [];
            $cf['newlink'] = [];
            
            $data = [];
            $data['waiting'] = $waiting;
            $data['scanned'] = $scanned;
            file_put_contents($this->folder.$id.".json", json_encode($data));
            echo count($cf['running']);
            if(count($cf['running'])==0) unset($_SESSION['page_'.$id]);
            else $_SESSION['page_'.$id] = $cf;
            exit();
        }elseif(isset($_POST['action']) && $_POST['action']=='stop'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $_SESSION['page_'.$id]['stop'] = 1;
            exit();
        }elseif(isset($_POST['action']) && $_POST['action']=='load_new_id'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $limit = isset($_POST['limit']) ? intval($_POST['limit']) : 0;
            echo $this->get_new_id_for_autorun($id, $limit);
            exit();
        }
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 1;
        $a_method = [0=>'Quét các link mới',1=>'Quét lại toàn bộ link'];
        $a_limit = [0=>'Lấy tất cả SP',50=>'Lấy 50 SP',100=>'Lấy 100 SP',200=>'Lấy 200 SP',300=>'Lấy 300 SP',500=>'Lấy 500 SP'];
        
        $db = $this->pdo->fetch_one("SELECT * FROM pages WHERE id=".$id);
        
        $db['select_method'] = $this->help->get_select_from_array($a_method, $method);
        $db['select_limit'] = $this->help->get_select_from_array($a_limit, 0);
        $db['scan'] = isset($_GET['scan']) ? intval($_GET['scan']) : 0;
        $this->smarty->assign('db', $db);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function repeat(){
        $step = 10;
        $limit_prod = 200;
        $limit_link = 1000;
        
        if(isset($_POST['action']) && $_POST['action']=='start'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $cf = [];
            $cf['number_scanned'] = 0;
            $cf['number_product'] = 0;
            $links = json_decode(@file_get_contents($this->folder.$id.".json"), true);
            $links['scanned'] = is_array(@$links['scanned'])?$links['scanned']:[];
            $links['waiting'] = is_array(@$links['waiting'])?$links['waiting']:[];
            
            $conf = $this->page_detail($id);
            if(!filter_var(@$conf['metas']['url'], FILTER_VALIDATE_URL)) $conf['metas']['url'] = @$conf['website'];
            $cf['metas'] = $conf['metas'];
            //$cf['prefix'] = $conf['prefix_auto'];
            $cf['running'] = [];
            
            if(isset($links['waiting']) && count($links['waiting'])>0){
                for ($i=0; $i<$step; $i++){
                    if(isset($links['waiting'][$i])){
                        $cf['running'][] = $links['waiting'][$i];
                        unset($links['waiting'][$i]);
                    }
                }
                $links['waiting'] = @array_unique($links['waiting']);
                $links['waiting'] = @array_values($links['waiting']);
                file_put_contents($this->folder.$id.".json", json_encode($links));
            }else $cf['running'][] = $conf['metas']['url'];
            
            $cf['scanned'] = [];
            $cf['newlink'] = [];
            $cf['stop'] = 0;
            $cf['time'] = 0;
            $cf['number'] = 0;
            $_SESSION['page_'.$id] = $cf;
            echo 1; exit();
        }elseif(isset($_POST['action'])&&$_POST['action']=='scan'){
            $start = microtime(true);
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $k = isset($_POST['k']) ? intval($_POST['k']) : 0;
            $cf = is_array(@$_SESSION['page_'.$id])?$_SESSION['page_'.$id]:[];
            $url = @$cf['running'][$k];
            unset($cf['running'][$k]);
            $cf['scanned'][] = $url;
            $cf['number_scanned'] += 1;
            
            $metas = ['prefix'=>$cf['metas'],'url'=>$url];
            $data = $this->_parse_html($metas);
            if(is_array(@$data['a_links']) && count($data['a_links'])>0){
                foreach ($data['a_links'] AS $v) $cf['newlink'][] = $v;
            }
            
            $rt = [];
            $rt['code'] = 0;
            if(@$data['image']=='') $rt['msg'] = 'Không có ảnh';
            elseif(@$data['name']!=''&&@$data['image']!=''&&@$data['is_product']==1){
                unset($data['a_links']);
                $data['src'] = $url;
                $data['page_id'] = $id;
                $data['user_id'] = @$this->login;
                $data['timer'] = round(microtime(true)-$start, 4);
                $save = $this->save_product($data, $id);
                if(@$save['code']==1){
                    $cf['number_product'] += 1;
                    $rt['code'] = 1;
                }
                $rt['msg'] = $save['msg'];
            }else $rt['msg'] = 'Dữ liệu không chính xác';
            
            if($cf['number_scanned']>=$limit_link||$cf['number_product']>=$limit_prod||($cf['number']>=5&&intval($cf['time']/$cf['number'])>=10)){
                foreach ($cf['running'] AS $v) $cf['newlink'][] = $v;
                $cf['running'] = [];
                $cf['stop'] = 1;
            }
            
            $rt['number'] = count($cf['running']);
            echo json_encode($rt);
            $cf['number'] += 1;
            $cf['time'] += (microtime(true)-$start);
            $_SESSION['page_'.$id] = $cf;
            exit();
        }elseif(isset($_POST['action'])&&$_POST['action']=='reset'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            $cf = is_array(@$_SESSION['page_'.$id])?$_SESSION['page_'.$id]:[];
            $links = json_decode(@file_get_contents($this->folder.$id.".json"), true);
            $waiting = is_array(@$links['waiting'])?$links['waiting']:[];
            $scanned = is_array(@$links['scanned'])?$links['scanned']:[];
            
            foreach ($cf['scanned'] AS $v){
                $scanned[] = $v;
            }
            $scanned = @array_unique($scanned);
            $scanned = @array_values($scanned);
            
            foreach ($cf['newlink'] AS $v){
                $waiting[] = $v;
            }
            $waiting = @array_diff($waiting, $scanned);
            $waiting = $this->get_trueLink($waiting, @$cf['metas']['url'], @$cf['metas']['url_check']);
            $waiting = @array_unique($waiting);
            $waiting = @array_values($waiting);
            
            $cf['running'] = [];
            if($cf['number']>=3 && intval($cf['time']/$cf['number'])>=10){//check load quá time định mức
                $cf['stop'] = 1;
            }elseif($cf['number_product']>=$limit_prod||$cf['number_scanned']>=$limit_link) $cf['stop'] = 1;
            
            if(@$cf['stop']==0){
                for ($i=0; $i<$step; $i++){
                    if(isset($waiting[$i])){
                        $cf['running'][] = $waiting[$i];
                        unset($waiting[$i]);
                    }
                }
                $waiting = @array_values($waiting);
            }
            
            $cf['scanned'] = [];
            $cf['newlink'] = [];
            
            $data = [];
            $data['waiting'] = $waiting;
            $data['scanned'] = $scanned;
            file_put_contents($this->folder.$id.".json", json_encode($data));
            echo count($cf['running']);
            if(count($cf['running'])==0) unset($_SESSION['page_'.$id]);
            else $_SESSION['page_'.$id] = $cf;
            exit();
        }elseif(isset($_POST['action']) && $_POST['action']=='load_new_id'){
            $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
            //$limit = isset($_POST['limit']) ? intval($_POST['limit']) : 0;
            echo $this->get_new_id_for_autorun($id);
            exit();
        }
        
        
        if (isset($_GET['id'])) {
            $id = intval($_GET['id']);
        }
        else {
            $last_page = $this->pdo->fetch_one("SELECT id FROM pages ORDER BY id DESC LIMIT 1");
            $id = $last_page? $last_page['id']: 0;
        }

        $db = $this->pdo->fetch_one("SELECT * FROM pages WHERE id=".$id);
        if(!$db && $id != 0){
            $new_id = $this->get_new_id_for_autorun($id);
            lib_redirect(URL_ADMIN.'?mod=scandb&site=repeat&id='.$new_id);
        }
        $db['scan'] = isset($_GET['scan']) ? intval($_GET['scan']) : 0;
        $this->smarty->assign('db', $db);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function autorun_reload(){
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $cf = is_array(@$_SESSION['page_'.$id])?$_SESSION['page_'.$id]:[];
        $db = is_array(@$cf['running'])?$cf['running']:[];
        $this->smarty->assign('db', $db);
        
        $links = json_decode(@file_get_contents("./scancache/".$id.".json"), true);
        $out = [];
        $out['waiting'] = intval(@count(@$links['waiting']));
        $out['scanned'] = intval(@count(@$links['scanned']));
        $out['number'] = $this->pdo->count_item('products', 'page_id='.$id);
        $out['number_product'] = @$cf['number_product'];
        $out['number_scanned'] = @$cf['number_scanned'];
        $out['process'] = 0;
        if($out['waiting']>0){
            $out['process'] = round($out['scanned']/($out['waiting']+$out['scanned'])*100,2);
        }
        $out['estimate'] = 0;
        if($cf['number_product']>0) $out['estimate'] = intval($cf['time']/$cf['number_product']*$out['waiting']/60);
            
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function autoupdate(){
        if(isset($_POST['action']) && $_POST['action']=='start'){
            $_SESSION['auto_update_running'] = $this->get_link_for_update(intval(@$_POST['id']),intval(@$_POST['page']));
            $_SESSION['auto_update_stop'] = 0;
            echo json_encode($_SESSION['auto_update_running']);
            exit();
        }elseif(isset($_POST['action'])&&$_POST['action']=='scan'){
            $start = microtime(true);
            $id = 0;
            $conf = @$_SESSION['auto_update_running'][$id];
            
            $prefix = json_decode(@$conf['prefix_auto'],true);
            if(!is_array($prefix)){
                if(@$conf['prefix_auto']!=''){
                    $prefix = [];
                    $a_pre = explode('&&', @$conf['prefix_auto']);
                    foreach ($a_pre AS $v){
                        $a_v = explode('=', $v);
                        if(count($a_v)==2 && $a_v[0]!='') $prefix[$a_v[0]] = trim($a_v[1]);
                    }
                }else $prefix = [];
            }
            
            
            $metas = ['prefix'=>$prefix,'url'=>@$conf['url']];
            $data = $this->_parse_html($metas);
            if(!is_array($data)) $data = ['price'=>0,'name'=>'','image'=>''];
            unset($data['a_links']);
            $data['id'] = $_SESSION['auto_update_running'][$id]['id'];
            //$data['old_image'] = $_SESSION['auto_update_running'][$id]['image'];
            $data['timer'] = round(microtime(true)-$start, 4);
            $data['user_id'] = @$this->login;
            $rt = $this->update_product($data);
            
            unset($_SESSION['auto_update_running'][$id]);
            if($_SESSION['auto_update_stop']==1) $_SESSION['auto_update_running'] = [];
            else $_SESSION['auto_update_running'] = @array_values($_SESSION['auto_update_running']);
            //echo count($_SESSION['auto_update_running']);
            $rt['number'] = count($_SESSION['auto_update_running']);
            echo json_encode($rt);
            exit();
        }elseif(isset($_POST['action'])&&$_POST['action']=='reset'){
            $_SESSION['auto_update_running'] = [];
            if($_SESSION['auto_update_stop']==0){
                $_SESSION['auto_update_running'] = $this->get_link_for_update(intval(@$_POST['id']),intval(@$_POST['page']));
            }
            echo count($_SESSION['auto_update_running']);
            exit();
        }elseif(isset($_POST['action']) && $_POST['action']=='stop'){
            $_SESSION['auto_update_stop'] = 1;
            exit();
        }elseif(isset($_POST['action']) && $_POST['action']=='load_new_id'){
            echo $this->help->api_get_str('page#item', $_POST);
            exit();
        }
        
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
        $method = [
            0=>'Tự động chuyển trang khi hoàn thành',
        ];
        
        $db = $this->page_detail($id);
        $db['select_method'] = $this->help->get_select_from_array($method);
        $db['scan'] = isset($_GET['scan']) ? intval($_GET['scan']) : 0;
        $db['page'] = $page;
        $this->smarty->assign('db', $db);
        
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function autoupdate_reload(){
        $out = [];
        $out['waiting'] = intval(@count($_SESSION['auto_update_running']));
        $out['scanned'] = 0;
        
        $this->smarty->assign('db', $_SESSION['auto_update_running']);
        
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function get_link_for_update($id=0, $page=1){
        $start = ((@$page<1?1:$page)-1)*10;
        $limit = $start.',10';
        $sql = "SELECT a.id,a.source AS url,a.images,p.prefix_auto FROM products a LEFT JOIN pages p ON a.page_id=p.id
                WHERE a.source IS NOT NULL";
        if($id!=0) $sql .= " AND a.page_id=".$id;
        $sql .= " ORDER BY ".($id!=0? " p.id DESC, ": "")." a.created ASC LIMIT $limit";
        $db = $this->pdo->fetch_all($sql);
        foreach ($db AS $k=>$v){
            $a_img = explode(';', $v['images']);
            $db[$k]['image'] = trim(@$a_img[0]);
            unset($db[$k]['images']);
        }
        
        return $db;
    }
    
    function ex_metas($str){
        $rt = [];
        if($str!=''){
            $a_obj = explode('&&', $str);
            foreach ($a_obj AS $v){
                $a_pre = explode('=', $v);
                if(count($a_pre)==2) $rt[trim($a_pre[0])] = trim($a_pre[1]);
            }
        }
        return $rt;
    }
    
    function save_product(array $a_value, $page_id){
        $desc = $this->get_true_value(@$a_value['description']);
        if(isset($a_value['content'])&&$a_value['content']!='') $desc = $this->get_true_value(@$a_value['content']);
        $data['page_id'] = $page_id;
        $data['name'] = $this->get_true_value(@$a_value['name']);
        $data['code'] = $this->get_true_value(@$a_value['sku']);
        $data['description'] = $desc;
        $data['keyword'] = $this->get_true_value(@$a_value['category']);
        $data['price'] = $this->get_true_value(@$a_value['price']);
        $data['trademark'] = $this->get_true_value(@$a_value['brand']);
        $data['source'] = @$a_value['url'];
        $data['user_id'] = intval(@$a_value['user_id']);
        $data['created'] = time();
        $data['status']=1;
        
        $rt = ['code' => 0];
        if(@$a_value['is_product']==0){
            $rt['msg'] = "Nội dung không phù hợp";
        }elseif(@$a_value['image']==null || $data['name']==null || $page_id==0){
            $rt['msg'] = "Nội dung bị thiếu";
        }elseif($db=$this->pdo->fetch_one("SELECT id FROM products WHERE source='".$data['source']."'")){
            $this->pdo->update('products', $data, 'id='.$db['id']);
            $rt['code'] = 1;
            $rt['msg'] = 'Update sản phẩm '.$db['id'];
        }elseif($this->pdo->check_exist("SELECT 1 FROM products WHERE name='".$data['name']."' AND page_id=".$page_id)){
            $rt['msg'] = "Sản phẩm đã tồn tại";
        }elseif($product_id = $this->pdo->insert('products', $data)){
            $taxonomy_id = 0;
            if(is_array(@$a_value['categories'])&&count($a_value['categories'])>0){
                foreach ($a_value['categories'] AS $v){
                    if($db=$this->pdo->fetch_one("SELECT id FROM taxonomy WHERE type='product' AND alias='".$this->string->str_convert($v)."'")){
                        $taxonomy_id = intval(@$db['id']);
                        break;
                    }
                }
            }
            
            $a_img = explode('.', $a_value['image']);
            $img_type = end($a_img);
            $img_type = mb_strtolower($img_type);
            if(!in_array($img_type, ['jpg','jpeg','png','gif','webp'])) $img_type = 'png';
            $imgname = time().'_'.md5($a_value['image']).'.'.$img_type;
            
            $data = [];
            $data['taxonomy_id'] = $taxonomy_id;
            if($upload=$this->img->upload_webp($page_id, $a_value['image'], $imgname)) $data['images'] = $upload;
            $this->pdo->update('products', $data, "id=".$product_id);
            $this->save_keywords(@$a_value['keyword'], $product_id);
            
            if($a_value['price']>0){
                $data = [];
                $data['product_id'] = $product_id;
                $data['version'] = 'Giá';
                $data['price'] = @$a_value['price'];
                $this->pdo->insert('productprices', $data);
            }
            
            $a_value['a_metas'] = is_array(@$a_value['a_metas'])?$a_value['a_metas']:[];
            foreach ($a_value['a_metas'] AS $k=>$item){
                if($k!='' && $item!=''){
                    $data = [];
                    $data['meta_key'] = $k;
                    $data['meta_value'] = $item;
                    $data['product_id'] = $product_id;
                    $this->pdo->insert('productmetas', $data);
                }
            }
            
            $rt['code'] = 1;
            $rt['msg'] = "Thêm mới sản phẩm";
        }else{
            $rt['msg'] = "Không lưu được";
        }
        return $rt;
    }
    
    
    function update_product(array $a_value){
        $data = [];
        $desc = $this->get_true_value(@$a_value['description']);
        if(isset($a_value['content'])&&$a_value['content']!='') $desc = $this->get_true_value(@$a_value['content']);
        
        //$data['page_id'] = $page_id;
        $data['name'] = $this->get_true_value(@$a_value['name']);
        $data['code'] = $this->get_true_value(@$a_value['sku']);
        $data['description'] = $desc;
        $data['keyword'] = $this->get_true_value(@$a_value['category']);
        $data['price'] = $this->get_true_value(@$a_value['price']);
        $data['trademark'] = $this->get_true_value(@$a_value['brand']);
        $data['user_id'] =intval(@$a_value['user_id']);
        $data['created'] = time();
        
        $db = $this->pdo->fetch_one("SELECT id,images,page_id,taxonomy_id FROM products WHERE id=".$a_value['id']);
        $folder = DIR_UPLOAD.'pages/'.$db['page_id']."/";
        $images = explode(';', $db['images']);
        foreach ($images AS $k=>$v) if($v=='') unset($images[$k]);
            
        $rt['code'] = 0;
        if(@$a_value['is_product']==0){
            $rt['msg'] = "Không đúng sản phẩm";
            $this->pdo->query("DELETE FROM products WHERE id=".$db['id']);
        }elseif($data['name']==''||@$a_value['image']==''){
            $rt['msg'] = "Nội dung không phù hợp";
            foreach ($images AS $v){
                if($v!='') @unlink($folder.$v);
            }
            $this->pdo->query("DELETE FROM products WHERE id=".$db['id']);
            $this->pdo->query("DELETE FROM productsearch WHERE product_id=".$db['id']);
        }else{
            $tax_id = intval(@$db['taxonomy_id']);
            if($tax_id==0&&is_array($a_value['categories'])&&count($a_value['categories'])>0){
                foreach ($a_value['categories'] AS $v){
                    if($tax=$this->pdo->fetch_one("SELECT id FROM taxonomy WHERE type='product' AND alias='".$this->string->str_convert($v)."'")){
                        $tax_id = intval(@$tax['id']);
                        break;
                    }
                }
            }
            $data['taxonomy_id'] = $tax_id;
            
            if(count($images)==0||(count($images)==1&&!is_file($folder.@$images[0]))){
                $a_img = explode('.', $a_value['image']);
                $img_type = end($a_img);
                $img_type = mb_strtolower($img_type);
                if(!in_array($img_type, ['jpg','jpeg','png','gif','webp'])) $img_type = 'png';
                $imgname = time().'_'.md5($a_value['image']).'.'.$img_type;
                if($upload=$this->img->upload_webp($db['page_id'], $a_value['image'], $imgname)){
                    $data['images'] = $upload;
                    foreach ($images AS $v){
                        if($v!='') @unlink($folder.$v);
                    }
                }
            }
            
            $this->pdo->update('products', $data, 'id='.$db['id']);
            $rt['code'] = 1;
            $rt['msg'] = 'Update sản phẩm '.$db['id'];
            
            $this->pdo->query("DELETE FROM productprices WHERE product_id=".$db['id']);
            if($data['price']>0){
                $data = [];
                $data['product_id'] = $db['id'];
                $data['version'] = 'Giá';
                $data['price'] = @$a_value['price'];
                $this->pdo->insert('productprices', $data);
            }
        }
        unset($data);
        return $rt;
    }
    
    
    function get_true_value($str){
        $str = str_replace("&nbsp;", "", $str);
        return $str;
    }
    
    function save_keywords($keywords, $product_id){
        $a_keywords = explode(",", $keywords);
        $a_keywords = @array_unique($a_keywords);
        foreach ($a_keywords AS $item){
            $item = trim($item);
            $item = str_replace(".", "", $item);
            $item = str_replace("  ", " ", $item);
            if(strlen($item)<=50 && strlen($item)>2){
                $keyword = $this->pdo->fetch_one("SELECT id FROM keywords WHERE name='$item' LIMIT 1");
                if(!$keyword){
                    $data['created'] = time();
                    $data['name'] = $item;
                    $this->pdo->insert('keywords', $data);
                    unset($data);
                }
            }
        }
    }
    
    
    function page_detail($id){
        $db = $this->pdo->fetch_one("SELECT * FROM pages WHERE id=" . $id);
        $db['metas'] = [];
        
        $db['metas'] = json_decode(@$db['prefix_auto'],true);
        if(!is_array($db['metas'])){
            if(@$db['prefix_auto']!=''){
                $db['metas'] = [];
                $a_pre = explode('&&', @$db['prefix_auto']);
                foreach ($a_pre AS $v){
                    $a_v = explode('=', $v);
                    if(count($a_v)==2 && $a_v[0]!='') $db['metas'][$a_v[0]] = trim($a_v[1]);
                }
            }else $db['metas'] = [];
        }
        
        
//         if (@$db['prefix_auto'] != '') {
//             $a_obj = explode('&&', $db['prefix_auto']);
//             foreach ($a_obj as $v) {
//                 $a_pre = explode('=', $v);
//                 if (count($a_pre) == 2) $db['metas'][trim($a_pre[0])] = trim($a_pre[1]);
//             }
//         }
        return $db;
    }
    
    
    function get_new_id_for_autorun($id, $limit=0){
        $sql = "SELECT a.id FROM pages a WHERE a.status>0 AND a.website IS NOT NULL AND a.id<".$id;
        if($limit>0) $sql .= " AND (SELECT COUNT(1) FROM products p WHERE p.page_id=a.id)<".$limit;
        $sql .= " ORDER BY a.id DESC LIMIT 1";
        $db = $this->pdo->fetch_one($sql);
        return @$db['id']>0?$db['id']:0;
    }
    
    
    function get_trueLink($a_url, $url=null, $pre_remove=null){
        if(count($a_url)>0){
            if($pre_remove==''){
                $pre_remove = '/tin-tuc,tu-van,/tro-giup,/huong-dan,/gio-hang,/news,/so-sanh,/thuong-hieu,/tra-gop,/tim-kiem,/timkiem,/lien-he';
                $pre_remove .= ',add-to-,add_to_,shoppingcart,/AddToCart,/cart,mua-tra-gop,quick-buy,login,keyword=,selected_section,per_page';
                $pre_remove .= ',/user,/dich-vu,/bai-viet,/blog,account,prices=,gclid=,pro=,o=,noscript,ft=,?sef_rewrite=,?category=';
                $pre_remove .= ',sort_by=,sortby=,sort=,min=,max=,price=,brand=,thuong-hieu=,&order,orderby=,show=,gia_tu=,filter,action=,search=';
                $pre_remove .= ',/search,.jpg,.png';
            }
            $Domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST);
            if(parse_url($url, PHP_URL_HOST)=='www.ketnoitieudung.vn'){
                $pre_remove .= ',/c1,/c2';
            }elseif(parse_url($url, PHP_URL_HOST)=='www.hanoicomputer.vn'){
                $pre_remove .= ',cpu-pc=,nhu-cau=,dvd-pc=,ram-pc=,dloc=,o-cung-pc=,he-dieu-hanh-pc=,kich-co-man-hinh-pc=,5trieu,10trieu,12trieu,18trieu';
            }
            $a_url = @array_unique($a_url);
            $a_url = is_array($a_url) ? $a_url : [];
            
            if($pre_remove && $pre_remove!=''){
                $a_remove = explode(",", $pre_remove);
                foreach ($a_url AS $k=>$item){
                    foreach ($a_remove AS $v){
                        if(strpos($a_url[$k], trim($v))!==false){
                            unset($a_url[$k]);
                            break;
                        }
                    }
                }
            }
            $a_url = array_values($a_url);
            
            foreach ($a_url AS $k=>$item){
                $a_item = explode(".", $item);
                $typeurl = end($a_item);
                if($item==''||$item=='/'||$item=='./'||@$item[0]=='#'||@$item[0]=="'") unset($a_url[$k]);
                elseif(substr_count($item, '?')>1||substr_count($item, '"')>0||substr_count($item, '|')>0) unset($a_url[$k]);
                elseif(strpos($item, '{')!==false && strpos($item, '}')!==false) unset($a_url[$k]);
                elseif(@$item[0]=='j'&&@$item[1]=='a'&&@$item[2]=='v'&&@$item[3]=='a') unset($a_url[$k]);
                elseif($url && ($Domain==$item||$Domain."/"==$item||$Domain."/."==$item)) unset($a_url[$k]);
                elseif(strpos($item, 'tel:')!==false||strpos($item, 'skype:')!==false||strpos($item, 'mailto:')!==false) unset($a_url[$k]);
                elseif(strpos($item, '../')!==false) unset($a_url[$k]);
                elseif(strpos($item, '#')!==false){
                    $ex_url = explode('#', $item);
                    $a_url[$k] = $ex_url[0];
                }
                elseif(in_array(strtoupper($typeurl), array('JPG','JPEG','PNG','GIF','PDF','SWF','RAR','ZIP','TXT','DOC','DOCX','MP4','MP3'))) unset($a_url[$k]);
                elseif($url && filter_var($item, FILTER_VALIDATE_URL) === FALSE){
                    if(!parse_url($item, PHP_URL_SCHEME)){
                        if(@$item[0]=='?'){
                            $a_ex_url = explode("?", $url);
                            $a_url[$k] = $a_ex_url[0] . $item;
                        }elseif(@$item[0]==@$item[1] && @$item[1]=="/"){
                            $a_url[$k] = parse_url($Domain, PHP_URL_SCHEME).":".$item;
                        }elseif(@$item[0]=="." && @$item[1]=="/"){
                            $a_url[$k] = $Domain.substr($item, 1);
                        }else{
                            $item = $Domain . (@$item[0]=='/'?$item:'/'.$item);
                            $a_url[$k] = $item;
                        }
                    }else unset($a_url[$k]);
                }elseif(filter_var($item, FILTER_VALIDATE_URL) && parse_url($url, PHP_URL_SCHEME)!=parse_url($item, PHP_URL_SCHEME)){
                    unset($a_url[$k]);
                }
                
                if(isset($a_url[$k])){
                    if(strlen($a_url[$k])>260) unset($a_url[$k]);
                    elseif(filter_var($a_url[$k], FILTER_VALIDATE_URL) === FALSE) unset($a_url[$k]);
                    elseif($url && parse_url($Domain, PHP_URL_HOST)!=parse_url($a_url[$k], PHP_URL_HOST)) unset($a_url[$k]);
                    elseif(strpos(parse_url($Domain, PHP_URL_HOST), 'http://')!==false||strpos(parse_url($Domain, PHP_URL_HOST), 'https://')!==false) unset($a_url[$k]);
                }
            }
        }
        return @array_values($a_url);
    }
    
    
    function _parse_html(array $input, $debug=0){
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_POST, 1);
        if(is_array($input)) curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($input));
        curl_setopt($curl, CURLOPT_URL, scrape_product_endpoint('parseurl#_db'));
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 12);
        curl_setopt($curl, CURLOPT_TIMEOUT, 12);
        curl_setopt($curl, CURLOPT_MAXREDIRS, 12);
        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $result = curl_exec($curl);
        curl_close($curl);
        if($debug==1){
            var_dump($result);
            exit();
        }else{
            $result = json_decode($result, true);
            if(!is_array($result)) $result = [];
            return $result;
        }
    }
    
}