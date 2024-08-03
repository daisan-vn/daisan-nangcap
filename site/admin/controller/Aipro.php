<?php

class Aipro extends Admin {
    
    private $dom;
    private $folder, $file_waitinglinks, $file_scannedlinks, $file_savedlinks;
    
    function __construct() {
        parent::__construct();
        
        $this->folder = "./file_autorun/";
        $this->file_waitinglinks = "./file_autorun/waitinglinks.ini";
        $this->file_scannedlinks = "./file_autorun/scannedlinks.ini";
        $this->file_savedlinks = "./file_autorun/savedlinks.ini";
    }
    
    function index() {
        global $smarty, $login;
        ini_set('memory_limit', '-1');
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_prefix_auto'){
            $url = isset($_POST['url']) ? trim($_POST['url']) : '';
            $domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST);
            $page = $this->pdo->fetch_one("SELECT prefix_auto FROM pages WHERE website LIKE '$domain%'");
            echo @$page['prefix_auto'];
            exit();
        }
        //         $a_url[] = "https://www.robins.vn/gucci-kinh-mat-t%C3%ADm-800967.html";
        //         $a_url[] = "holster-giay-sandal-nu-heaven-espadrille-trang-tr%E1%BA%AFng-684827.html";
        //         $a_url = $this->get_trueLink($a_url);
        //         var_dump($a_url);
        
        //         $ch = curl_init();
        //         curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        //         curl_setopt($ch,CURLOPT_URL,"http://rangdongvn.com/den-ban-bao-ve-thi-luc-pr770.html");
        //         curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
        //         curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.A.B.C Safari/525.13");
        //         $data = curl_exec($ch);
        //         curl_close($ch);
        
        //echo($data);
        //echo file_get_contents("http://rangdongvn.com/den-ban-bao-ve-thi-luc-pr770.html");
        
        
        $smarty->display(LAYOUT_DEFAULT);
    }
    
    
    function autorun_start(){
        global $login;
        $limit = 20;
        $url = isset($_POST['url']) ? trim($_POST['url']) : '';
        $restart = isset($_POST['restart']) ? intval($_POST['restart']) : 0;
        $domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST);
        $page = $this->pdo->fetch_one("SELECT id,name FROM pages WHERE website LIKE '$domain%'");
        $page_id = @$page['id'];
        if(!$page){
            $data['name'] = parse_url($url, PHP_URL_HOST);
            $data['website'] = $domain;
            $data['prefix_auto'] = isset($_POST['prefix'])?trim($_POST['prefix']):null;
            $data['created'] = time();
            $data['admin_id'] = $login;
            $page_id = $this->pdo->insert('pages', $data);
        }else{
            if($page['name']==null) $data['name'] = parse_url($url, PHP_URL_HOST);
            $data['prefix_auto'] = isset($_POST['prefix'])?trim($_POST['prefix']):null;
            $this->pdo->update('pages', $data, "id=$page_id");
        }
        $a_url = [];
        if($restart==0) $a_url[] = $url;
        else{
            $ex_prefix = explode("&&", $_POST['prefix']);
            $a_prefix = [];
            foreach ($ex_prefix AS $item){
                $ex_item = explode("=", $item);
                if(count($ex_item)==2) $a_prefix[$ex_item[0]] = $ex_item[1];
            }
            
            $a_url = @parse_ini_file($this->folder.$page_id.".waitinglinks.ini");
            if(isset($a_prefix['remove_url'])){
                $a_url = $this->get_trueLink($a_url, $url, $a_prefix['remove_url']);
                @file_put_contents($this->folder.$page_id.".waitinglinks.ini", lib_arr_to_ini($a_url));
            }
            if(!is_array($a_url) || count($a_url)==0) $a_url = [];
            elseif (count($a_url)>$limit) $a_url = array_splice($a_url, 0, $limit);
        }
        
        $rt['number'] = 0;
        if(count($a_url)>0){
            $_SESSION['AUTORUN_URL_SCAN_LINKS_'.$page_id] = $a_url;
            reset($a_url);
            $rt['url_id'] = key($a_url);
            $rt['str_links'] = $this->get_str_links($_SESSION['AUTORUN_URL_SCAN_LINKS_'.$page_id]);
            $rt['number'] = count($a_url);
            $rt['page_id'] = $page_id;
        }
        echo json_encode($rt); exit();
    }
    
    
    function autorun_handle(){
        $url_id = isset($_POST['url_id']) ? trim($_POST['url_id']) : 0;
        $page_id = isset($_POST['page_id']) ? trim($_POST['page_id']) : 0;
        $url = @$_SESSION['AUTORUN_URL_SCAN_LINKS_'.$page_id][$url_id];
        unset($_SESSION['AUTORUN_URL_SCAN_LINKS_'.$page_id][$url_id]);
        
        $file_waitinglinks = $this->folder.$page_id.".waitinglinks.ini";
        $file_scannedlinks = $this->folder.$page_id.".scannedlinks.ini";
        
        $a_waiting_links = is_file($file_waitinglinks)?@parse_ini_file($file_waitinglinks):[];
        $a_scanned_links = is_file($file_scannedlinks)?@parse_ini_file($file_scannedlinks):[];
        
        $data = $this->get_page_content($url, isset($_POST['prefix'])?trim($_POST['prefix']):null);
        $a_links = $data['a_links'];
        $rt = $this->save_product($data, $page_id);
        
        $a_scanned_links[] = $url;
        $a_links = array_diff($a_links, $a_waiting_links);
        $a_links = array_diff($a_links, $a_scanned_links);
        foreach ($a_links AS $item){
            $a_waiting_links[] = $item;
        }
        $a_waiting_links = array_diff($a_waiting_links, $a_scanned_links);
        $a_waiting_links = @array_unique($a_waiting_links);
        $a_waiting_links = @array_values($a_waiting_links);
        @file_put_contents($file_waitinglinks, lib_arr_to_ini($a_waiting_links));
        
        $a_scanned_links = @array_unique($a_scanned_links);
        $a_scanned_links = @array_values($a_scanned_links);
        @file_put_contents($file_scannedlinks, lib_arr_to_ini($a_scanned_links));
        
        $a_url = $_SESSION['AUTORUN_URL_SCAN_LINKS_'.$page_id];
        reset($a_url);
        $rt['url_id'] = key($a_url);
        $rt['number'] = count($_SESSION['AUTORUN_URL_SCAN_LINKS_'.$page_id]);
        echo json_encode($rt);
        exit();
    }
    
    function save_product(array $a_value, $page_id){
        global $login;
        $data['page_id'] = $page_id;
        $data['name'] = $this->get_true_value(@$a_value['name']);
        $data['code'] = $this->get_true_value(@$a_value['code']);
        $data['description'] = $this->get_true_value(@$a_value['content']);
        $data['trademark'] = $this->get_true_value(@$a_value['trademark']);
        $data['source'] = @$a_value['url'];
        $data['created'] = time();
        $data['admin_id'] = $login;
        
        $rt['code'] = 0;
        if($data['code']==null || $data['name']==null || $page_id==0){
            $rt['msg'] = "Nội dung bị thiếu";
        }elseif($this->pdo->check_exist("SELECT 1 FROM products WHERE code='".$data['code']."'")){
            $rt['msg'] = "Mã sản phẩm đã tồn tại";
        }elseif($this->pdo->check_exist("SELECT 1 FROM products WHERE name='".$data['name']."'")){
            $rt['msg'] = "Tên sản phẩm đã tồn tại";
        }elseif($product_id = $this->pdo->insert('products', $data)){
            if(is_array($a_value['a_metas']) && count($a_value['a_metas'])>0){
                foreach ($a_value['a_metas'] AS $k=>$item){
                    if($k!='' && $item!=''){
                        $data['product_id'] = $product_id;
                        $data['meta_key'] = $k;
                        $data['meta_value'] = $item;
                        $this->pdo->insert('productmetas', $data);
                        unset($data);
                    }
                }
            }
            
            $data['images'] = $this->img->upload_image_fromurl($this->product->get_folder_img($product_id), @$a_value['image'], 600, 1);
            $this->pdo->update('products', $data, "id=$product_id");
            
            
            $rt['code'] = 1;
            $rt['msg'] = "Lưu sản phẩm thành công";
        }else{
            $rt['msg'] = "Không lưu được sản phẩm";
        }
        unset($data);
        return $rt;
    }
    
    
    function get_true_value($str){
        $str = str_replace("&nbsp;", "", $str);
        return $str;
    }
    
    
    function _load_pagecontent(){
        $url = isset($_POST['url'])?trim($_POST['url']):null;
        $data = $this->get_page_content($url, isset($_POST['prefix'])?trim($_POST['prefix']):null);
        $this->smarty->assign('data', $data);
        
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function load_pagecontent(){
        $url = isset($_POST['url'])?trim($_POST['url']):null;
        $pre = isset($_POST['prefix'])?trim($_POST['prefix']):'';
        $metas = ['url'=>$url,'prefix'=>$pre];
        
        if(@$pre!=''){
            $a_obj = explode('&&', $pre);
            foreach ($a_obj AS $v){
                $a_pre = explode('=', $v);
                if(count($a_pre)==2) $metas[trim($a_pre[0])] = trim($a_pre[1]);
            }
        }
        
        $data = $this->_parsehtml($metas);
        unset($data['a_links']);
        $this->smarty->assign('data', $data);
        lib_dump($data);
        $this->smarty->display(LAYOUT_NONE);
    }
    
    
    function get_page_content($url, $prefix=null){
        ini_set('memory_limit', '-1');
        $domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST)."/";
        $html = false;
        if(filter_var($url, FILTER_VALIDATE_URL)) $html = \Lib\Help\HtmlDomParser::file_get_html($url);
        //var_dump($html);
        //$html->
        $data = [];
        $data['url'] = $url;
        $data['a_links'] = [];
        $data['a_metas'] = [];
        $data['content'] = '';
        $data['trademark'] = '';
        if($html){
            $a_prefix = [];
            $ex_prefix = explode("&&", $prefix);
            foreach ($ex_prefix AS $item){
                $ex_item = explode("=", $item);
                if(count($ex_item)==2) $a_prefix[$ex_item[0]] = $ex_item[1];
            }
            
            foreach(@$html->find('a') as $element){
                $data['a_links'][] = trim($element->href);
            }
            $data['a_links'] = $this->get_trueLink($data['a_links'], $url, @$a_prefix['remove_url']);
            
            $data['name'] = @$html->find('title', 0)->plaintext;
            if(@$a_prefix['name']!=null) $data['name'] = @$html->find(@$a_prefix['name'], 0)->plaintext;
            
            if(@$a_prefix['code']=='end_name') $data['code'] = $this->string->get_value_of_endstr($data['name']);
            elseif(@$a_prefix['code']!=null){
                $code = @$this->get_html_value($html, @$a_prefix['code']);
                $data['code'] = $code;
                if(substr_count($code, ":")!=0){
                    $ex_code = explode(":", $code);
                    if(trim(@$ex_code[1])!=null) $data['code'] = trim(@$ex_code[1]);
                }
            }
            if(@$a_prefix['trademark']!=null) $data['trademark'] = @$html->find(@$a_prefix['trademark'], 0)->plaintext;
            
            $Content = null;
            if(isset($a_prefix['content']) && trim($a_prefix['content'])!=null){
                foreach($html->find('script') as $element){
                    $element->outertext = '';
                }
                if(isset($a_prefix['content']) && trim($a_prefix['content'])!=null){
                    $a_remove = explode(";", trim(@$a_prefix['remove']));
                    foreach ($a_remove AS $item){
                        foreach($html->find($item) as $element){
                            $element->outertext = '';
                        }
                    }
                }
                $Content = trim(@$html->find($a_prefix['content'], 0)->innertext);
            }
            $data['content'] = $Content;
            
            $data['image'] = @$html->find("meta[property=og:image]", 0)->content;
            if(isset($a_prefix['image']) && $a_prefix['image']!=null){
                foreach (@$html->find($a_prefix['image']) AS $element){
                    $data['image'] = $element->src;
                    break;
                }
                if(filter_var($data['image'], FILTER_VALIDATE_URL) === FALSE){
                    if($data['image'][0]=='/') $data['image'] = substr($data['image'], 1);
                    $data['image'] = $domain.$data['image'];
                }
            }
            if(strpos($data['image'], '?')!==FALSE){
                $a_ex_image = explode('?', $data['image']);
                $data['image'] = @$a_ex_image[0];
            }
            
            $data['a_metas'] = [];
            if(isset($a_prefix['a_metas'])){
                $a_metas = [];
                foreach(@$html->find($a_prefix['a_metas']) AS $element){
                    $a_metas[] = trim($element->plaintext);
                }
                $data['a_metas'] = $this->get_metas($a_metas);
            }
        }
        return $data;
    }
    
    
    function get_metas(array $a_metas){
        $type = 2;
        $number_type = 0;
        $number_meta = count($a_metas);
        foreach ($a_metas AS $item){
            $ex_item = explode(':', $item);
            
            if(count($ex_item)==2 && trim(@$ex_item[0])!=null && trim(@$ex_item[1])!=null){
                $number_type++;
                if($number_meta/2<$number_type){
                    $type = 1;
                    break;
                }
            }
        }
        
        $result = [];
        if($type==1){
            foreach ($a_metas AS $item){
                $ex_item = explode(':', $item);
                if(trim(@$ex_item[0])!=null && trim(@$ex_item[1])!=null) $result[trim($ex_item[0])] = trim($ex_item[1]);
            }
        }else{
            $number = count($a_metas)/2;
            for($i=0; $i<$number; $i++){
                $result[@$a_metas[$i*2]] = @$a_metas[$i*2+1];
            }
        }
        return $result;
    }
    
    
    /**
     *
     * @param object $html
     * @param string $prefix
     * @return string
     */
    function get_html_value($html, $prefix=null){
        $str = null;
        if($prefix!=null){
            if(strpos($prefix, '||')!==false){//Lấy giá trị hoặc
                $a_prefix = explode("||", $prefix);
                foreach ($a_prefix AS $item){
                    $str = $this->get_html_value($html, $item);
                    if($str!=null && $str!='') break;
                }
            }else{
                $nth = 0;
                $pre_remove = null;
                if(strpos($prefix, '---')!==false){//Loại bỏ giá trị con
                    $a_prefix = explode("---", $prefix);
                    $prefix = $a_prefix[0];
                    $pre_remove = $a_prefix[1];
                }
                if(strpos($prefix, '-->')!==false){//Lấy theo thứ tự
                    $a_prefix = explode("-->", $prefix);
                    $nth = $a_prefix[1];
                    $prefix = $a_prefix[0];
                }
                if($pre_remove) $html = $this->remove_html_value($html, $prefix." ".$pre_remove);
                $a_str = [];
                foreach($html->find($prefix) AS $element){
                    $a_str[] = trim($element->plaintext);
                }
                if($nth==='array') $str = $a_str;
                else if($nth==='n') $str = trim(implode(" ", @$a_str));
                else if($nth==='end') $str = trim(@end($a_str));
                else if($nth==='array-0'){
                    $str = $a_str;
                    unset($str[0]);
                }else $str = $a_str[$nth];
            }
        }
        return $str;
    }
    
    
    function remove_html_value($html, $selector){
        foreach ($html->find($selector) as $node){
            $node->outertext = '';
        }
        return $html->load($html->save());
    }
    
    
    function get_trueLink($a_url, $url=null, $pre_remove=null){
        if(count($a_url)>0){
            $url = ($url==null)?$a_url[0]:$url;
            $Domain = parse_url($url, PHP_URL_SCHEME)."://".parse_url($url, PHP_URL_HOST);
            $a_url = @array_unique($a_url);
            $a_url = is_array($a_url) ? $a_url : [];
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
                }
                
                if(isset($a_url[$k])){
                    if(strlen($a_url[$k])>120) unset($a_url[$k]);
                    elseif(filter_var($a_url[$k], FILTER_VALIDATE_URL) === FALSE) unset($a_url[$k]);
                    elseif($url && parse_url($Domain, PHP_URL_HOST)!=parse_url($a_url[$k], PHP_URL_HOST)) unset($a_url[$k]);
                    elseif(strpos(parse_url($Domain, PHP_URL_HOST), 'http://')!==false||strpos(parse_url($Domain, PHP_URL_HOST), 'https://')!==false) unset($a_url[$k]);
                    elseif($pre_remove && $pre_remove!=''){
                        $a_remove = explode(";", $pre_remove);
                        foreach ($a_remove AS $itemremove){
                            if(strpos($a_url[$k], $itemremove)!==false){
                                unset($a_url[$k]);
                                break;
                            }
                        }
                    }
                }
            }
            @asort($a_url);
        }
        return @array_values($a_url);
    }
    
    
    function get_str_links($a_links){
        $str = "<url id=\"scanlinks\">";
        foreach ($a_links AS $k=>$item){
            $str .= "<li id=\"uid$k\">";
            $str .= "<a href='".@$item."' target='_blank'>";
            $str .= "<i class=\"fa fa-fw fa-link\"></i> ".@$item;
            $str .= "</a>";
            $str .= "</li>";
        }
        $str .= "</ul>";
        return $str;
    }
}