<?php

class Scandb extends Pageadmin {
    
    private $folder;
    
    function __construct() {
        parent::__construct();
        $this->folder = "./scancache/";
    }
    
    
    function index(){
        $out = [];
        $out['key'] = '';
        $sql = "SELECT a.id,a.name,a.website,a.logo,a.created FROM pages a WHERE 1=1";
        if(isset($_GET['key'])&&@$_GET['key']!=''){
            $key = trim(base64_decode(@$_GET['key']));
            if(filter_var($key, FILTER_VALIDATE_URL)){
                $a_url = parse_url($key);
                $key = $a_url['host'];
            }
            $sql .= " AND (a.name LIKE '%$key%' OR a.website LIKE '%$key%')";
            $out['key'] = $key;
        }
        $sql .= " ORDER BY a.id DESC LIMIT 10";
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
    
    
    function load_pagecontent(){
        $url = isset($_POST['url'])?trim($_POST['url']):null;
        $pre = isset($_POST['prefix'])?trim($_POST['prefix']):'';
        $metas = ['url'=>$url,'prefix'=>$pre];
        
//         if(@$pre!=''){
//             $a_obj = explode('&&', $pre);
//             foreach ($a_obj AS $v){
//                 $a_pre = explode('=', $v);
//                 if(count($a_pre)==2) $metas[trim($a_pre[0])] = trim($a_pre[1]);
//             }
//         }
        
        $data = $this->_parsehtml($metas);
        unset($data['a_links']);
        $this->smarty->assign('data', $data);
        lib_dump($data);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function autorun(){
        $step = 10;
        $limit_prod = isset($_REQUEST['limit'])?intval($_REQUEST['limit']):50;
        if($limit_prod==0) $limit_prod = 1000000;
        $method = isset($_REQUEST['method'])?intval($_REQUEST['method']):0;
        $limit_link = $limit_prod*3;
        $limit_link = ($limit_link<100)?100:$limit_link;
        $limit_link = ($limit_link>600)?690:$limit_link;
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
            $cf['number_product'] = $this->page->number_product($id);
            $conf = $this->page->detail($id);
            if(!filter_var(@$conf['metas']['url'], FILTER_VALIDATE_URL)) $conf['metas']['url'] = @$conf['website'];
            $cf['metas'] = $conf['metas'];
            $cf['prefix'] = $conf['prefix_auto'];
            $cf['running'] = [];
            if(count($links['scanned'])<=$limit_link && $cf['number_product']<=$limit_prod){
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
            
            //$metas = is_array(@$cf['metas'])?$cf['metas']:[];
            $metas = ['prefix'=>isset($cf['prefix'])?$cf['prefix']:'','url'=>$url];
            //$metas['url'] = $url;
            $data = $this->_parsehtml($metas);
            if(is_array(@$data['a_links']) && count($data['a_links'])>0){
                foreach ($data['a_links'] AS $v) $cf['newlink'][] = $v;
            }
            
            $rt = [];
            $rt['code'] = 0;
            if(@$data['image']==''&&@$data['price']!=0) $rt['msg'] = 'Không có ảnh';
            elseif(@$data['name']!=''&&@$data['image']!=''&&@$data['price']!=0){
                unset($data['a_links']);
                $data['src'] = $url;
                $data['page_id'] = $id;
                $data['user_id'] = @$this->login;
                $data['timer'] = round(microtime(true)-$start, 4);
                $save = $this->product->save_product($data, $id);
                if(@$save['code']==1){
                    $cf['number_product'] += 1;
                    $rt['code'] = 1;
                }
                $rt['msg'] = $save['msg'];
            }else $rt['msg'] = 'Dữ liệu không chính xác';
            
//             $data['a_domains'] = is_array(@$data['a_domains'])?$data['a_domains']:[];
//             if(count($data['a_domains'])>0){
//                 foreach ($data['a_domains'] AS $v){
//                     $this->page->create_domain($v);
//                 }
//             }
            
            
            if($cf['number_product']>=$limit_prod ||
                ($cf['number']>=5 && intval($cf['time']/$cf['number'])>=10)){
                    foreach ($cf['running'] AS $v) $cf['newlink'][] = $v;
                    $cf['running'] = [];
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
            $waiting = $this->help->get_trueLink($waiting, @$cf['metas']['url'], @$cf['metas']['c_url_check']);
            $waiting = @array_unique($waiting);
            $waiting = @array_values($waiting);
            
            $cf['running'] = [];
            $number_product = $this->page->number_product($id);
            if($cf['number']>=3 && intval($cf['time']/$cf['number'])>=10){
                $cf['stop'] = 1;
            }elseif($number_product==0&&count($scanned)>=200){
                $cf['stop'] = 1;
            }
            
            
            if(@$cf['stop']==0&&$number_product<=$limit_prod&&count($scanned)<=$limit_link){
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
            echo $this->page->get_new_id_for_autorun($id, $limit);
            exit();
        }
        
//         $url = 'https://meta.vn/may-khoan-dong-luc-bosch-gsb-550-re-06011a15k7-bo-set-100-mon-p34606';
//         $data = $this->_parsehtml(['url'=>$url]);
//         $data['src'] = $url;
//         $data['page_id'] = 1;
//         $data['user_id'] = @$this->login;
        
//         $save = $this->product->save_product($data, 1);
//         lib_dump($save);
//         exit();
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 1;
        $a_method = [0=>'Quét các link mới',1=>'Quét lại toàn bộ link'];
        $a_limit = [0=>'Lấy tất cả SP',50=>'Lấy 50 SP',100=>'Lấy 100 SP',200=>'Lấy 200 SP',300=>'Lấy 300 SP',500=>'Lấy 500 SP'];
        
        $db = $this->pdo->fetch_one("SELECT * FROM pages WHERE id=".$id);
        
        $db['select_method'] = $this->help->get_select_from_array($a_method, $method);
        $db['select_limit'] = $this->help->get_select_from_array($a_limit, $limit_prod);
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
        $out['number'] = $this->page->number_product($id);
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
            $_SESSION['auto_update_running'] = $this->get_link_for_update(intval(@$_POST['id']));
            $_SESSION['auto_update_stop'] = 0;
            echo json_encode($_SESSION['auto_update_running']);
            exit();
        }elseif(isset($_POST['action'])&&$_POST['action']=='scan'){
            $start = microtime(true);
            $id = 0;
            //$metas = $_SESSION['auto_update_running'][$id]['metas'];
            $data = $this->_parsehtml(@$_SESSION['auto_update_running'][$id]);
            if(!is_array($data)) $data = ['price'=>0,'name'=>'','image'=>''];
            unset($data['a_links']);
            $data['id'] = $_SESSION['auto_update_running'][$id]['id'];
            $data['old_image'] = $_SESSION['auto_update_running'][$id]['image'];
            $data['timer'] = round(microtime(true)-$start, 4);
            $rt = $this->product->update_product($data);
            
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
                $_SESSION['auto_update_running'] = $this->get_link_for_update(intval(@$_POST['id']));
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
        
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 1;
        $method = [
            0=>'Tự động chuyển trang khi hoàn thành',
        ];
        
        $db = $this->page->detail($id);
        $db['select_method'] = $this->help->get_select_from_array($method);
        $db['scan'] = isset($_GET['scan']) ? intval($_GET['scan']) : 0;
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
    
    
//     function get_link_for_update($id=0){
//         $sql = "SELECT source FROM products WHERE source IS NOT NULL";
//         if($id!=0) $sql .= " AND page_id=".$id;
//         $sql .= " ORDER by created DESC LIMIT 10";
//         $rt = $this->pdo->fetch_all($sql);
//         $products = [];
//         foreach ($rt AS $v){
//             $products[] = $v['source'];
//         }
//         return $products;
//     }
    
    function get_link_for_update($id=0){
        $sql = "SELECT a.id,a.source AS url,a.images,p.prefix_auto AS prefix FROM products a LEFT JOIN pages p ON a.page_id=p.id
                WHERE a.source IS NOT NULL";
        if($id!=0) $sql .= " AND a.page_id=".$id;
        $sql .= " ORDER BY a.created ASC LIMIT 10";
        $db = $this->pdo->fetch_all($sql);
        foreach ($db AS $k=>$v){
//             $metas = $this->ex_metas(@$v['prefix_auto']);
//             if(!is_array($metas)) $metas = [];
//             $metas['url'] = $v['source'];
//             $db[$k]['metas'] = $metas;
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
    
    
}