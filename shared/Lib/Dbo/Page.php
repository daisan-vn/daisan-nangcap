<?php

namespace Lib\Dbo;

class Page {

    use \Lib\Singleton;

    private $pdo, $str, $img;
    
    public $number_mem, $number_mem_sm, $revenue, $all_pages, $type, $status;
    public $dir_img;
    
    protected function __construct(){
        $this->pdo = \Lib\DB::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->set_all_pages();
        
        $this->number_mem = array(
            5 => "Nhỏ hơn 5 nhân viên",
            10 => "5 đến 10 nhân viên",
            50 => "11 đến 50 nhân viên",
            100 => "51 đến 100 nhân viên",
            200 => "101 đến 200 nhân viên",
            500 => "201 đến 500 nhân viên",
            1000 => "501 đến 1000 nhân viên",
            10000 => "Lớn hơn 1000 nhân viên"
        );

        $this->number_mem_sm = array(
            5 => "Nhỏ hơn 5",
            10 => "5 đến 10",
            50 => "11 đến 50",
            100 => "51 đến 100",
            200 => "101 đến 200",
            500 => "201 đến 500",
            1000 => "501 đến 1000",
            10000 => "Lớn hơn 1000"
        );
        
        $this->revenue = array(
            1 => "Dưới 1 triệu USD",
            2 => "1 đến 2,5 triệu USD",
            3 => "2,5 đến 5 triệu USD",
            4 => "5 đến 10 triệu USD",
            5 => "10 đến 50 triệu USD",
            6 => "50 đến 100 triệu USD",
            7 => "Trên 100 triệu USD"
        );
        
        $this->type = array(
            1 => 'Nhà sản xuất, chế tạo',
            2 => 'Công ty thương mại',
            3 => 'Đại lý',
            4 => 'Nhà phân phối, bán sỉ',
            5 => 'Bán lẻ',
            6 => 'Dịch vụ kinh doanh',
            7 => 'Hiệp hội',
            8 => 'Nhập khẩu',
            9 => 'Khác'
        );
        
        $this->status = array(
            0 => 'Chưa active',
            1 => 'Đã active',
            2 => 'Khóa',
            //3 => 'Chưa có SP'
        );
        
        $this->dir_img = "pages/";
    }
    
    
    function get_profile($page_id){
        $result = $this->pdo->fetch_one("SELECT a.id AS pid,a.*,p.*,
                CASE WHEN a.package_end>'".date('Y-m-d')."' THEN a.package_id ELSE 0 END AS package_id,
                CASE WHEN a.package_end>'".date('Y-m-d')."' THEN a.score_ads ELSE 0 END AS score_ads
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
				WHERE a.status=1 AND (a.id='$page_id' OR a.page_name='$page_id' OR a.page_website='$page_id')");
        if($result){
            $page_id = $result['pid'];
            $result['folder'] = $this->get_folder_img($page_id);
            $result['logo_img'] = $this->img->get_image($this->get_folder_img($page_id), @$result['logo']);
            $result['logo_custom_img'] = $this->img->get_image($this->get_folder_img($page_id), @$result['logo_custom']);
            $result['date_start'] = date("d-m-Y", strtotime($result['date_start']));
            $result['province'] = $this->pdo->fetch_one_fields('locations', 'Name', 'id='.$result['province_id']);
            $result['district'] = $this->pdo->fetch_one_fields('locations', 'Name', 'id='.$result['district_id']);
            $result['wards'] = $this->pdo->fetch_one_fields('locations', 'Name', 'id='.$result['wards_id']);
            $result['number_mem_show'] = @$this->number_mem[$result['number_mem']];
            $result['nation'] = $this->pdo->fetch_one_fields('nations', 'Name','Id='.$result['nation_id']);
            $result['revenue'] = @$this->revenue[$result['revenue']];
            $result['yearexp'] = $this->get_yearexp($result['date_start']);
            $result['type_name'] = @$this->type[$result['type']];
            $result['url'] = $this->get_pageurl($result['pid'], $result['page_name']);
            $result['pagelink'] = $this->get_all_pagelink($result['pid'], @$result['page_name']);
            $result['page_contact'] = DOMAIN."?mod=page&site=contact&page_id=".$result['page_id'];
            $result['a_image'] = $this->get_images($result['images'], $page_id);
        }
        return $result;
    }
    function info_page_location($page_id,$location,$lid=0){
        $sql="SELECT a.id,a.page_id,a.name,a.address,a.phone,a.email,a.province_id,b.page_name FROM pageaddress a
                LEFT JOIN pages b ON a.page_id=b.id
				WHERE a.province_id=$location AND (b.id='$page_id' OR b.page_name='$page_id' OR b.page_website='$page_id')";
        if($lid!=0) " AND a.id=$lid";
        $result = $this->pdo->fetch_one($sql);
        if($result){
            $result['province'] = $this->pdo->fetch_one_fields('locations', 'Name', 'id='.$result['province_id']);
            $result['url_page'] = $this->get_pageurl_location($page_id, $result['page_name'],$result['name'],$result['id']);
        }
            return $result;
    }
    function get_pages($where=null, $limit=10){
        $where = $where!=null?" AND $where":null;
        $pages = $this->pdo->fetch_all("SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.page_website,a.phone,
                a.address,a.number_mem,a.date_start,l.name AS province,p.metas,p.revenue,a.package_id,a.is_verification,a.is_oem
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id LEFT JOIN locations l ON l.id=a.province_id
                WHERE 1=1 $where ORDER BY a.level DESC,a.score DESC,a.id ASC LIMIT $limit");
        foreach ($pages AS $k=>$item){
            $pages[$k]['logo'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo']);
            $pages[$k]['logo_custom'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo_custom']);
            $pages[$k]['url'] = $this->get_pageurl($item['id'], $item['page_name']);
            $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
            $pages[$k]['number_mem'] = @$this->number_mem[$item['number_mem']];
            $pages[$k]['yearexp'] = $this->get_yearexp($item['date_start']);
            $pages[$k]['pagelink'] = $this->get_all_pagelink($item['id'], @$item['page_name']);
            $pages[$k]['revenue'] = @$this->revenue[$item['revenue']];
            $pages[$k]['metas'] = json_decode($item['metas'], true);
        }
        return $pages;
    }
    function get_pages_bycate($id=0, $where=null, $limit=10){
        $where = $where!=null?" AND $where":null;
        if($id!=0){
            $where .= " AND a.id IN (SELECT p.page_id FROM products p WHERE p.status=1 AND p.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id))
                ORDER BY lft))";
        }
        $pages = $this->pdo->fetch_all("SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.page_website,a.phone,
                a.address,a.number_mem,a.date_start,
                CASE WHEN a.package_end>'".date('Y-m-d')."' THEN a.package_id ELSE 0 END AS package_id
				FROM pages a
                WHERE a.status=1 $where ORDER BY a.package_id DESC,a.level DESC,a.score DESC,a.id ASC LIMIT $limit");
        foreach ($pages AS $k=>$item){
            $pages[$k]['logo'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo']);
            $pages[$k]['logo_custom'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo_custom']);
            $pages[$k]['url'] = $this->get_pageurl($item['id'], $item['page_name']);
            $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
            $pages[$k]['number_mem'] = @$this->number_mem[$item['number_mem']];
            $pages[$k]['yearexp'] = $this->get_yearexp($item['date_start']);
            $pages[$k]['pagelink'] = $this->get_all_pagelink($item['id'], @$item['page_name']);
            
        }
        return $pages;
    }
    function get_page_oems($where=null, $limit=10){
        $where = $where!=null?" AND $where":null;
        $pages = $this->pdo->fetch_all("SELECT a.id,a.name,a.logo,a.phone,a.address,a.number_mem,p.images,a.page_name,
                l.name AS province,a.is_oem,a.package_id,a.is_verification,p.metas,a.date_start
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id LEFT JOIN locations l ON l.id=a.province_id
                WHERE a.status=1 AND a.is_oem=1 $where ORDER BY a.level DESC,a.score DESC,a.id ASC LIMIT $limit");
        foreach ($pages AS $k=>$item){
            $pages[$k]['logo'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo']);
            $pages[$k]['url'] = $this->get_pageurl($item['id'], $item['page_name']);
            $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
            $pages[$k]['number_mem'] = @$this->number_mem_sm[$item['number_mem']];
            $pages[$k]['yearexp'] = $this->get_yearexp($item['date_start']);
            $pages[$k]['pagelink'] = $this->get_all_pagelink($item['id'], @$item['page_name']);
            $pages[$k]['metas'] = json_decode($item['metas'], true);
//             $a_images = explode(";", $item['images']);
//             $pages[$k]['a_img'] = [];
//             foreach ($a_images AS $v){
//                 $pages[$k]['a_img'][] = $this->img->get_image($this->get_folder_img($item['id']), $v);
//             }
            
        }
        return $pages;
    }
    function get_one_page($where=null, $limit=10){
        $where = $where!=null?" AND $where":null;
        $pages = $this->pdo->fetch_all("SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.page_website,
                a.address,a.number_mem,a.date_start
				FROM pages a
                WHERE 1=1 $where ORDER BY a.level DESC,a.score DESC,a.id ASC LIMIT $limit");
        foreach ($pages AS $k=>$item){
            $pages[$k]['logo'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo']);
            $pages[$k]['logo_custom'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo_custom']);
            $pages[$k]['url'] = $this->get_pageurl($item['id'], $item['page_name']);
            $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
            $pages[$k]['number_mem'] = @$this->number_mem[$item['number_mem']];
            $pages[$k]['yearexp'] = $this->get_yearexp($item['date_start']);
            $pages[$k]['pagelink'] = $this->get_all_pagelink($item['id'], @$item['page_name']);
        }
        return $pages;
    }
  /*  function get_pages($where=null, $limit=10){
        $where = $where!=null?" AND $where":null;
        $pages = $this->pdo->fetch_all("SELECT a.id,a.logo,a.logo_custom,a.name,a.page_name,a.page_website,a.number_mem,a.date_start,
                ad.id AS lid,ad.name AS subname,ad.address
				FROM pages a LEFT JOIN pageaddress ad ON a.id=ad.page_id
                WHERE 1=1 $where ORDER BY a.level DESC,a.score DESC,a.id ASC LIMIT $limit");
        foreach ($pages AS $k=>$item){
            $pages[$k]['logo'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo']);
            $pages[$k]['logo_custom'] = $this->img->get_image($this->get_folder_img($item['id']), $item['logo_custom']);
            $pages[$k]['url'] = $this->get_pageurl_location($item['id'], $item['page_name'],$item['name'],$item['lid']);
            $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
            $pages[$k]['number_mem'] = @$this->number_mem[$item['number_mem']];
            $pages[$k]['yearexp'] = $this->get_yearexp($item['date_start']);
            $pages[$k]['pagelink'] = $this->get_all_pagelink($item['id'], @$item['page_name']);
        }
        return $pages;
    }*/
    function getvideo($id){
        $sql = "SELECT url_youtube FROM pageprofiles WHERE page_id=$id";
        $value = $this->pdo->fetch_one($sql);
        $Url = explode ( 'v=', $value ['url_youtube'] );
        $value['img'] = "https://i.ytimg.com/vi/" . @$Url[1] . "/mqdefault.jpg";
        $value ['Url'] = "https://www.youtube.com/embed/" . @$Url [1] . "?rel=0&autoplay=0";
        return $value;
    }
    
    
    function create($data){
        $rt = [];
        $rt['code'] = 0;
        $rt['msg'] = 'Đăng ký thất bại, vui lòng thử lại sau.';
        $data['name'] = trim($_POST['Name']);
        $data['code'] = trim($_POST['Code']);
        $data['province_id'] = intval($_POST['ProvinceId']);
        $data['district_id'] = intval($_POST['DistrictId']);
        $data['wards_id'] = intval($_POST ['WardsId']);
        $data['address'] = trim($_POST['Address']);
        $data['created'] = time();
//         $data['user_id'] = $login;
        $data['status'] = 2;
        if($this->pdo->check_exist("SELECT 1 FROM pages WHERE name='" . $data ['name'] . "'")){
            $rt['msg'] = 'Tên trang đã tồn tại, vui lòng chọn lại';
        }elseif($pageId = $this->pdo->insert('pages', $data)){
            $rt['code'] = 1;
            $rt['msg'] = 'Đăng ký gian hàng thành công.';
            
            $data['page_name'] = "pid".$pageId.time();
            $this->pdo->update('pages', $data, "id=".$pageId);
            unset($data);
            
            $data['page_id'] = $pageId;
//             $data['user_id'] = $login;
            $data['created'] = time();
            $data['status'] = 1;
            $this->pdo->insert('pageusers', $data);
            
            unset($data);
            $data['page_id'] = $pageId;
            $this->pdo->insert('pageprofiles', $data);
        }
        return $rt;
    }
    
    
    function update_page_score($page_id){
        $result = $this->pdo->fetch_one("SELECT a.id AS pid,a.*,p.*
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
				WHERE a.id='$page_id' OR a.page_name='$page_id' OR a.page_website='$page_id'");
        $score = 0;
        if($result['name']!=null) $score += 5;
        if($result['code']!=null) $score += 5;
        if($result['name_short']!=null) $score += 5;
        if($result['name_global']!=null) $score += 5;
        if($result['code']!=null) $score += 5;
        if($result['wards_id']!=0) $score += 10;
        if($result['address']!=null) $score += 5;
        if($result['date_start']!='1970-01-01'&&$result['date_start']!='0000-00-00') $score += 5;
        if($result['logo']!=null) $score += 5;
        if($result['logo_custom']!=null) $score += 5;
        
        if($result['phone']!=null) $score += 2;
        if($result['email']!=null) $score +=2;
        if($result['website']!=null) $score += 2;
        if($result['page_name']!=null) $score += 2;
        if($result['number_mem']!=0) $score += 2;
        
        if($result['images']!=null) $score += 2;
        if($result['description']!=null) $score += 2;
        if($result['time_open']!=null) $score += 2;
        if($result['revenue']!=null) $score += 2;
        if($result['meta_title']!=null) $score += 2;
        if($result['meta_keyword']!=null) $score += 1;
        if($result['meta_description']!=null) $score += 1;
        if($result['url_facebook']!=null) $score += 1;
        if($result['url_google']!=null) $score += 1;
        if($result['url_youtube']!=null) $score += 1;
        
        $supports = $this->pdo->count_item('pagesupporters', "page_id=$page_id");
        $score += $supports>3?10:$supports*2;
        $partners = $this->pdo->count_item('pagepartners', "page_id=$page_id");
        $score += $partners>3?10:$partners*2;
        
        $data = [];
        $data['score'] = $score;
        $this->pdo->update("pages", $data, "id=$page_id");
        return $score;
    }
    
    function get_images($str, $page_id, $thumb=1){
        $folder = 'pages/'.$page_id.'/';
        if($thumb==1) $folder .= '270x270/';
        else $folder .= '600x600/';
        $a_images = explode(";", $str);
        $a_img = [];
        foreach ($a_images AS $v){
            if($v!='') $a_img[] = URL_IMAGE_S3.$folder.$v;
        }
        return $a_img;
    }
    
    function get_pageurl($id, $pagename=null){
        $url = DOMAIN.'shop/'.$id."/";
        if($pagename!=null) $url = DOMAIN.'shop/'.$pagename.'/';
        return $url;
    }
    function get_pageurl_location($id, $pagename=null,$subname=null,$lid){
        $url = URL_PAGE."?pageId=$id";
        if(!is_localhost() && $pagename!=null) $url = URL_PAGE.$pagename."?subname=".str_replace('&','',$this->str->str_convert($subname))."&lid=$lid";
        return $url;
    }
    function get_idcode($id){
        $len = 6 - strlen($id);
        $code = "GH";
        for ($i=1; $i<=$len; $i++) $code .= "0";
        return $code.$id;
    }
    
    
    function get_all_pagelink($id, $pagename=null){
        $page_url = $this->get_pageurl($id, $pagename);
        $sour = substr_count($page_url, '?')>0?'&':'?';
        $a_pagelink = [];
        foreach ($this->all_pages AS $k=>$item){
            $a_pagelink[$k] = $page_url.$sour."site=$k&pn=".$this->str->str_convert($item);
        }
        return $a_pagelink;
        
    }
    
    
    function remove_folder($page_id){
        $folder = $this->get_folder_img_upload($page_id);
        if(is_dir($folder)){
            chmod($folder, 0777);
            foreach (scandir($folder) as $item) {
                @chmod($folder.$item, 0777);
                @unlink($folder.$item);
            }
            @rmdir($folder);
        }
    }
    
    
    function get_yearexp($date){
        if($date==null || $date=='1970-01-01') $date = date("Y-m-d");
        $year = date("Y", strtotime($date));
        return date("Y") - $year + 1;
    }

    function get_scoreads($id){
        $value = $this->pdo->fetch_one("SELECT score_ads FROM pages WHERE id=$id");
        return $value['score_ads'];
    }

    function get_folder_img($page_id){
        return $this->dir_img.$page_id."/";
    }
    
    
    function get_folder_img_upload($page_id){
        $folder = DIR_UPLOAD.$this->get_folder_img($page_id);
        if(!is_dir($folder)){
            @mkdir($folder, 0775);
            @chmod($folder, 0775);
        }
        return $folder;
    }
    
    private function set_all_pages(){
        $all_pages = array(
            'home' => 'Trang chủ',
            'company_information' => 'Thông tin tổng quan',
            'company_profile' => 'Hồ sơ công ty',
            'company_capacity' => 'Khả năng của công ty',
            'company_partners' => 'Các đối tác chiến lược',
            'service_list' => 'Danh sách dịch vụ',
            'product_list' => 'Danh mục sản phẩm',
            'jobpost' => 'Tin tuyển dụng',
            'blogs' => 'Blog',
            'contact' => 'Liên hệ',
            'search' => 'Tìm kiếm'
        );
        return $this->all_pages = $all_pages;
    }

    
    
    function number_product($id)
    {
        return $this->pdo->count_item('products', 'page_id=' . $id);
    }

    function detail($id)
    {
        $db = $this->pdo->fetch_one("SELECT * FROM pages WHERE id=" . $id);
        $db['metas'] = [];
        if (@$db['prefix_auto'] != '') {
            $a_obj = explode('&&', $db['prefix_auto']);
            foreach ($a_obj as $v) {
                $a_pre = explode('=', $v);
                if (count($a_pre) == 2)
                    $db['metas'][trim($a_pre[0])] = trim($a_pre[1]);
            }
        }
        return $db;
    }

    function create_domain($domain)
    {
        $check = "://" . parse_url($domain, PHP_URL_HOST);
        if (! $this->pdo->check_exist("SELECT 1 FROM pages WHERE website LIKE '%$check%'")) {
            $data = [];
            $data['name'] = parse_url($domain, PHP_URL_HOST);
            $data['website'] = $domain;
            $data['created'] = time();
            $this->pdo->insert('pages', $data);
        }
    }
    
    function get_new_id_for_autorun($id, $limit){
        $sql = "SELECT a.id FROM pages a 
            WHERE a.status>0 AND a.website IS NOT NULL AND a.id>".$id."
            AND (SELECT COUNT(1) FROM products p WHERE p.page_id=a.id)<".$limit."
            ORDER BY a.id ASC LIMIT 1";
        $db = $this->pdo->fetch_one($sql);
        return $db['id'];
    }
}