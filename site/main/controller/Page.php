<?php

class Page extends Main {

	function dangkynhaban() {
		$this->smarty->display(LAYOUT_NONE);
	}

	function api_dangkynhaban() {
		// $name = 
	}

	function dangkydemo() {
		$this->smarty->display(LAYOUT_NONE);
	}
	
	function index() {
	    global $login;

		$cont = $this->get_afjson_file(FILE_CONT);
        
        $this->smarty->assign('a_home_category', $cont['a_home_category']);
        $this->smarty->assign('a_product_new', $cont['a_product_new']);
        $this->smarty->assign('a_product_toprank', $cont['a_product_toprank']);
        $this->smarty->assign('a_product_readytoship', $cont['a_product_readytoship']);
        $this->smarty->assign('a_product_promo', $cont['a_product_promo']);
        $this->smarty->assign('a_product_import', $cont['a_product_import']);
        $this->smarty->assign('a_product_wholesaler', $cont['a_product_wholesaler']);
        $this->smarty->assign('a_product_page_oem', $cont['a_product_page_oem']);
        $this->smarty->assign('a_product_page_toprank', $cont['a_product_page_toprank']);

		$favorites = $this->pdo->fetch_array_field('pagefavorites', 'page_id', 'user_id='.$login);
		$filter = [];
		$key = isset($_GET['k']) ? trim($_GET['k']) : null;
		$memnumber = isset($_GET['memnumber']) ? trim($_GET['memnumber']) : null;
		$cat = isset($_GET['cat']) ? intval($_GET['cat']) : 0;
		$revenue = isset($_GET['revenue']) ? trim($_GET['revenue']) : null;
		$filter['gold'] = isset($_GET['gold']) ? trim($_GET['gold']) : 0;
		$filter['verify'] = isset($_GET['verify']) ? trim($_GET['verify']) : 0;
		$filter['oem'] = isset($_GET['oem']) ? trim($_GET['oem']) : 0;
		$filter['province'] = isset($_GET['location']) ? trim($_GET['location']) : 0;
		$filter['a_province'] = explode(',', $filter['province']);
		$filter['key'] = $key;
		$out = [];
		$where = "a.status=1";
		if($cat!=0){
		    $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cat) AND (SELECT rgt FROM taxonomy WHERE id=$cat))
                ORDER BY lft)";
		}
		if($key!='') $where .= " AND (a.name LIKE '%$key%' OR a.phone LIKE '%$key%' OR a.email LIKE '%$key%')";
		if($filter['gold']==1) $where .= " AND a.package_id>0";
		if($filter['verify']==1) $where .= " AND a.is_verification=1";
		if($filter['oem']==1) $where .= " AND a.is_oem=1";
		if($filter['province']!=null) $where .= " AND a.province_id IN (".$filter['province'].")";
		if($memnumber!=null) $where .= " AND a.number_mem IN ($memnumber)";
		if($revenue!=null) $where .= " AND p.revenue IN ($revenue)";
		$out['number']=$this->pdo->count_custom("SELECT COUNT(1) AS number FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
        WHERE $where");
		$paging = new \Lib\Core\Pagination($out['number'], 20, 0);
		$sql = "SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.page_website,a.phone,a.type,
                a.address,a.number_mem,a.date_start,l.name AS province,p.metas,p.revenue,p.supply_ability,a.package_id,a.is_verification,a.is_oem,p.images,l.Name
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id LEFT JOIN locations l ON l.id=a.province_id
                WHERE $where ORDER BY a.featured DESC,a.package_id DESC,a.is_verification DESC,a.level DESC,a.score DESC";
		$sql = $paging->get_sql_limit($sql);
	
		$pages = $this->pdo->fetch_all($sql);
		foreach ($pages AS $k=>$item){
		    $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
		    $pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
		    $pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
		    $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
		    $pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
		    $pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		    $pages[$k]['metas'] = json_decode($item['metas'], true);
		    $pages[$k]['isfavorite'] = in_array($item['id'], $favorites)?1:0;
			$pages[$k]['type_name'] = @$this->page->type[$item['type']];
			$pages[$k]['number_mem_show'] = @$this->page->number_mem[$item['number_mem']];
			$pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
			
			// $a_image_profile = strlen(@$item['images'])>30 ? explode(";", @$item['images']) : [];
			// $image_profile = [];
			// foreach ($a_image_profile AS $item2){
			// 	if(is_file($this->page->get_folder_img_upload($item['id']).$item2))
			// 		$image_profile[] = $this->img->get_image($this->page->get_folder_img($item['id']), $item2);
			// }
			// $pages[$k]['image_profile'] = $image_profile;
		}
				
		$this->smarty->assign('result', $pages);

		if(isset($_COOKIE['HodineCache'])) $HodineCache = json_decode($_COOKIE['HodineCache'], true);
		else $HodineCache = [];
		if(!isset($HodineCache['product_view']) || !is_array($HodineCache['product_view'])) $HodineCache['product_view'] = [];
		$HodineCache['product_view'][] = 0;
		$a_product_views = $this->product->get_list_inarray($HodineCache['product_view']);
		$this->smarty->assign('a_product_views', $a_product_views);
		
		$out['url'] = "./supplier";
		$out['favorites'] = $favorites;
		$this->smarty->assign('out', $out);
		$this->smarty->assign('filter', $filter);
		$this->smarty->assign('headsearch', 1);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	function load_more_index()
    {
		global $login;
		$id = isset($_POST['id']) ? intval($_POST['id']) : 0;
		$oem = isset($_POST['oem']) ? intval($_POST['oem']) : 0;
		$verify = isset($_POST['verify']) ? intval($_POST['verify']) : 0;
        $page = isset($_POST['page'])?intval($_POST['page']):1;
        $limit = 20;
        $start = ($page-1)*$limit;
        $limit = "$start,$limit";
		$where = "a.status=1";
		if($id!=0) $where .= " AND a.taxonomy_id=".intval($id);
		if($oem!=0) $where .= " AND a.is_oem=".intval($oem);
		if($verify!=0) $where .= " AND a.is_verification=".intval($verify);

		$favorites = $this->pdo->fetch_array_field('pagefavorites', 'page_id', 'user_id='.$login);
		
		$sql = "SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.page_website,a.phone,a.type,
                a.address,a.number_mem,a.date_start,l.name AS province,p.metas,p.revenue,p.supply_ability,a.package_id,a.is_verification,a.is_oem,p.images,l.Name
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id LEFT JOIN locations l ON l.id=a.province_id
                WHERE $where ORDER BY a.featured DESC,a.package_id DESC,a.is_verification DESC,a.level DESC,a.score DESC";
		if($limit!=null) $sql .= " LIMIT $limit";
		$pages = $this->pdo->fetch_all($sql);
		foreach ($pages AS $k=>$item){
		    $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
		    $pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
		    $pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
		    $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
		    $pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
		    $pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		    $pages[$k]['metas'] = json_decode($item['metas'], true);
		    $pages[$k]['isfavorite'] = in_array($item['id'], $favorites)?1:0;
			$pages[$k]['type_name'] = @$this->page->type[$item['type']];
			$pages[$k]['number_mem_show'] = @$this->page->number_mem[$item['number_mem']];
			$pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		}
       
        $this->smarty->assign('result',$pages);
        $this->smarty->display( LAYOUT_NONE );
    }
	function category()
    {
		$id = intval(\App::getParam('id', 0));

        $taxonomy = $this->pdo->fetch_one("SELECT * FROM taxonomy WHERE type='product' AND alias='$id' OR id='$id'");
        $id = @$taxonomy['id'];
        $category = $this->tax->get_value($id);
        
        $a_category_all = $this->tax->get_taxonomy('product', $id, null, null, 1, 1,1);
        $this->smarty->assign('a_category_all', $a_category_all);

		$a_slider = $this->media->get_slides($id, 6);
        $this->smarty->assign('a_slider', $a_slider);

        $a_banner = $this->media->get_images($id,2,8,0,'banner');
        $this->smarty->assign('a_banner', $a_banner);

		$file = "../../constant/info/c_".$id.".json";
        $db = json_decode(@file_get_contents($file), true);
        if(!is_array($db)) $db = [];
        if(count($db)<2||(time()-@filemtime($file))>86400){
            $db = [];
            $db['product_hot'] = $this->product->get_list_group_bypage($id, 'a.ismain=1', 6);
            $db['product_promo'] = $this->product->get_list_bycate($id, "a.promo>0 AND a.promo_date>='".date('Y-m-d')."'", 4);
            $db['product_new'] = $this->product->get_list_bycate($id, null, 4, 'a.id DESC');
            $db['product_foryou'] = $this->product->get_list_bycate($id, Null, 30, 'a.ismain DESC,a.id DESC');
            $db['page_top'] = $this->page->get_pages_bycate($id, 'a.featured=1', 4);
            foreach ($db['page_top'] AS $k=>$v){
                $db['page_top'][$k]['products'] = $this->product->get_list_bypage($v['id'], null, 2);
            }
			
            $db['page_oem'] = $this->page->get_pages_bycate($id, 'a.is_oem=1', 3);
            foreach ($db['page_oem'] AS $k=>$v){
                $db['page_oem'][$k]['products'] = $this->product->get_list_bypage($v['id'], null, 3);
            }
            file_put_contents($file, json_encode($db));
        }
//         echo date('H:i:s d-m-Y', filemtime(FILE_TAX));
        $this->smarty->assign('db', $db);
		$where = "a.status=1";
		$out['number']=$this->pdo->count_custom("SELECT COUNT(1) AS number FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
        WHERE $where");
	
		$sql = "SELECT a.page_id,p.*,pr.metas,pr.revenue,pr.supply_ability FROM products a
				LEFT JOIN pages p ON a.page_id = p.id
				LEFT JOIN pageprofiles pr ON p.id=pr.page_id
				WHERE $where";
		if($id!=0){
			$sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
			AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id))
			ORDER BY lft)";
		}
		$sql .=" GROUP BY a.page_id";
		
		$paging = new \Lib\Core\Pagination($out['number'], 20, 0);
		$sql = $paging->get_sql_limit($sql);
		$pages = $this->pdo->fetch_all($sql);
		foreach ($pages AS $k=>$item){
			$pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
			$pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
			$pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
			$pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
			$pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
			$pages[$k]['metas'] = json_decode($item['metas'], true);
			$pages[$k]['type_name'] = @$this->page->type[$item['type']];
			$pages[$k]['number_mem_show'] = @$this->page->number_mem[$item['number_mem']];
			$pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
			//$pages[$k]['isfavorite'] = in_array($item['id'], $favorites)?1:0;
		}
		$this->smarty->assign('result', $pages);

        $out = [];
        $out['id'] = $id;
        $this->smarty->assign('out', $out);
        
        $this->get_seo_metadata(@$category['name'], @$category['keyword'], @$category['description'], @$category['image']);
        $this->smarty->assign('category', $category);
        $this->smarty->display(LAYOUT_HOME);
    }
	function load_child_cate(){
        $id = $_POST['id'];
        $child_all = $this->tax->get_taxonomy('product', $id, null, null, 1, 1,1);
        $this->smarty->assign('child_all', $child_all);
        $this->smarty->display(LAYOUT_NONE);
    }


	function __search() {
	    global $login;
	
		$favorites = $this->pdo->fetch_array_field('pagefavorites', 'page_id', 'user_id='.$login);
		$filter = [];
		$key = isset($_GET['k']) ? trim($_GET['k']) : null;
		$memnumber = isset($_GET['memnumber']) ? trim($_GET['memnumber']) : null;
		$cat = isset($_GET['cat']) ? intval($_GET['cat']) : 0;
		$revenue = isset($_GET['revenue']) ? trim($_GET['revenue']) : null;
		$filter['gold'] = isset($_GET['gold']) ? trim($_GET['gold']) : 0;
		$filter['verify'] = isset($_GET['verify']) ? trim($_GET['verify']) : 0;
		$filter['oem'] = isset($_GET['oem']) ? trim($_GET['oem']) : 0;
		$filter['province'] = isset($_GET['location']) ? trim($_GET['location']) : 0;
		$filter['a_province'] = explode(',', $filter['province']);
		$filter['key'] = $key;
		$out = [];
		$where = "a.status=1";
		if($cat!=0){
		    $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cat) AND (SELECT rgt FROM taxonomy WHERE id=$cat))
                ORDER BY lft)";
		}
		//if($key!='') $where .= " AND (a.name LIKE '%$key%' OR a.phone LIKE '%$key%' OR a.email LIKE '%$key%')";
		if($key!=''){
		    $where .= " AND (a.name LIKE '%$key%' OR p.name LIKE '%$key%' OR a.id IN (SELECT p.page_id FROM productsearch p WHERE p.name LIKE '$key%'))";
		}
		$category = $this->pdo->fetch_one("SELECT id FROM taxonomy WHERE name LIKE '$key'");
		if($category) $cat_id = $category['id'];
		
	
		if($filter['gold']==1) $where .= " AND a.package_id>0";
		if($filter['verify']==1) $where .= " AND a.is_verification=1";
		if($filter['oem']==1) $where .= " AND a.is_oem=1";
		if($filter['province']!=null) $where .= " AND a.province_id IN (".$filter['province'].")";
		if($memnumber!=null) $where .= " AND a.number_mem IN ($memnumber)";
		if($revenue!=null) $where .= " AND p.revenue IN ($revenue)";
		$out['number']=$this->pdo->count_custom("SELECT COUNT(1) AS number FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
        WHERE $where");
		$paging = new \Lib\Core\Pagination($out['number'], 20, 0);
		// $sql = "SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.page_website,a.phone,a.type,
        //         a.address,a.number_mem,a.date_start,l.name AS province,p.metas,p.revenue,p.supply_ability,a.package_id,a.is_verification,a.is_oem,p.images,l.Name
		// 		FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id LEFT JOIN locations l ON l.id=a.province_id
        //         WHERE $where ORDER BY a.featured DESC,a.package_id DESC,a.is_verification DESC,a.level DESC,a.score DESC";
		$sql = "SELECT a.page_id,p.*,pr.metas,pr.revenue,pr.supply_ability FROM products a
		LEFT JOIN pages p ON a.page_id = p.id
		LEFT JOIN pageprofiles pr ON p.id=pr.page_id
		WHERE $where";
		if($cat_id!==null){
			$sql .= " OR (a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
			AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cat_id) AND (SELECT rgt FROM taxonomy WHERE id=$cat_id))
			ORDER BY lft))";
		}
		$sql .=" GROUP BY a.page_id";
		
		$sql = $paging->get_sql_limit($sql);
		
		$pages = $this->pdo->fetch_all($sql);
		foreach ($pages AS $k=>$item){
		    $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
		    $pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
		    $pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
		    $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
		    $pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
		    $pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		    $pages[$k]['metas'] = json_decode($item['metas'], true);
		    $pages[$k]['isfavorite'] = in_array($item['id'], $favorites)?1:0;
			$pages[$k]['type_name'] = @$this->page->type[$item['type']];
			$pages[$k]['number_mem_show'] = @$this->page->number_mem[$item['number_mem']];
			$pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		}
				
		$this->smarty->assign('result', $pages);
		$out['checkbox_memnumber'] = $this->help->get_checkbox_from_array($this->page->number_mem, $memnumber, 'number_mem');
		$out['checkbox_revenue'] = $this->help->get_checkbox_from_array($this->page->revenue, $revenue, 'revenue');
		$out['url'] = "./supplier/search";
		$out['favorites'] = $favorites;
		$this->smarty->assign('out', $out);
		$this->smarty->assign('filter', $filter);
		$this->smarty->assign('headsearch', 1);
		$this->smarty->display(LAYOUT_DEFAULT);
	}

	function search() {
		$limit = 20;

	    global $login;
	
		$favorites = $this->pdo->fetch_array_field('pagefavorites', 'page_id', 'user_id='.$login);
		$filter = [];
		$key = isset($_GET['k']) ? trim($_GET['k']) : null;
		$memnumber = isset($_GET['memnumber']) ? trim($_GET['memnumber']) : null;
		$revenue = isset($_GET['revenue']) ? trim($_GET['revenue']) : null;
		$filter['cat'] = isset($_GET['cat']) ? intval($_GET['cat']) : 0;
		$filter['gold'] = isset($_GET['gold']) ? trim($_GET['gold']) : 0;
		$filter['verify'] = isset($_GET['verify']) ? trim($_GET['verify']) : 0;
		$filter['oem'] = isset($_GET['oem']) ? trim($_GET['oem']) : 0;
		$filter['province'] = isset($_GET['location']) ? trim($_GET['location']) : 0;
		$filter['a_province'] = explode(',', $filter['province']);
		$filter['key'] = $key;
		$out = [];

		if ($key) {
			$search_repo = \Repo\PageSearch::instance();
			$page_ids = $search_repo->getIdsFromSearch($key, $search_repo->getOptionByArray($filter));
			$out['number'] = count($page_ids);
			
			$page = isset($_GET['page'])? intval($_GET['page']): 1;
			if ($page < 1) $page = 1;
			$offset = ($page - 1) * $limit;
			$current_page_ids = array_slice($page_ids, $offset, $limit);
			$page_ids_txt = implode(',', $current_page_ids);

			$paging = new \Lib\Core\Pagination($out['number'], $limit, 0);

			$sql = "SELECT p.*,pr.metas,pr.revenue,pr.supply_ability
				FROM pages p
				LEFT JOIN pageprofiles pr ON p.id=pr.page_id
				WHERE p.id IN ({$page_ids_txt})
				ORDER BY FIELD(p.id, {$page_ids_txt})
			";

			$pages = $this->pdo->fetch_all($sql);
		}
		else {
			$where = " 1=1 ";

			$search_clause = "(
				SELECT s.id,
					(CASE WHEN s.is_verification=1 THEN 2 ELSE 0 END) AS X3,
					(CASE WHEN s.featured=1 THEN 2 ELSE 0 END) AS X5
					FROM pages s
				)";
			
			if($filter['gold']==1) $where .= " AND p.package_id>0";
			if($filter['verify']==1) $where .= " AND p.is_verification=1";
			if($filter['oem']==1) $where .= " AND p.is_oem=1";
			if($filter['province']!=null) $where .= " AND p.province_id IN (".$filter['province'].")";
			if($memnumber!=null) $where .= " AND p.number_mem IN ($memnumber)";
			if($revenue!=null) $where .= " AND pr.revenue IN ($revenue)";

			$out['number']=$this->pdo->count_custom("SELECT COUNT(1) AS number FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
        	WHERE $where");

			$paging = new \Lib\Core\Pagination($out['number'], $limit, 0);

			$sql = "SELECT DISTINCT p.*,pr.metas,pr.revenue,pr.supply_ability
				FROM pages p
				LEFT JOIN {$search_clause} t ON p.id=t.id
				LEFT JOIN pageprofiles pr ON p.id=pr.page_id
				WHERE $where
				ORDER BY (X3 + X5) DESC
			";

			$sql = $paging->get_sql_limit($sql);
			$pages = $this->pdo->fetch_all($sql);
		}

		foreach ($pages AS $k=>$item){
		    $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
		    $pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
		    $pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
		    $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
		    $pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
		    $pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		    $pages[$k]['metas'] = json_decode($item['metas'], true);
		    $pages[$k]['isfavorite'] = in_array($item['id'], $favorites)?1:0;
			$pages[$k]['type_name'] = @$this->page->type[$item['type']];
			$pages[$k]['number_mem_show'] = @$this->page->number_mem[$item['number_mem']];
			$pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		}
				
		$this->smarty->assign('result', $pages);
		$out['checkbox_memnumber'] = $this->help->get_checkbox_from_array($this->page->number_mem, $memnumber, 'number_mem');
		$out['checkbox_revenue'] = $this->help->get_checkbox_from_array($this->page->revenue, $revenue, 'revenue');
		$out['url'] = "./supplier/search";
		$out['favorites'] = $favorites;
		$this->smarty->assign('out', $out);
		$this->smarty->assign('filter', $filter);
		$this->smarty->assign('headsearch', 1);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	

	function search_20_6_2024() {
	    global $login;
	
		$favorites = $this->pdo->fetch_array_field('pagefavorites', 'page_id', 'user_id='.$login);
		$filter = [];
		$key = isset($_GET['k']) ? trim($_GET['k']) : null;
		$memnumber = isset($_GET['memnumber']) ? trim($_GET['memnumber']) : null;
		$cat = isset($_GET['cat']) ? intval($_GET['cat']) : 0;
		$revenue = isset($_GET['revenue']) ? trim($_GET['revenue']) : null;
		$filter['gold'] = isset($_GET['gold']) ? trim($_GET['gold']) : 0;
		$filter['verify'] = isset($_GET['verify']) ? trim($_GET['verify']) : 0;
		$filter['oem'] = isset($_GET['oem']) ? trim($_GET['oem']) : 0;
		$filter['province'] = isset($_GET['location']) ? trim($_GET['location']) : 0;
		$filter['a_province'] = explode(',', $filter['province']);
		$filter['key'] = $key;
		$out = [];

		// $where = "a.status=1";

		$where = " 1=1 ";

		// if($cat!=0){
		//     $where .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
        //         AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cat) AND (SELECT rgt FROM taxonomy WHERE id=$cat))
        //         ORDER BY lft)";
		// }

		// if($key!='') $where .= " AND (p.name LIKE '%$key%' OR p.phone LIKE '%$key%' OR p.email LIKE '%$key%')";
		
		if($key!=''){
		    $search_clause = "(
				(SELECT s.id,
					8 AS X1,
					4 AS X2,
					(CASE WHEN s.is_verification=1 THEN 2 ELSE 0 END) AS X3,
					(CASE WHEN s.featured=1 THEN 2 ELSE 0 END) AS X5
					FROM pages s INNER JOIN productsearch p ON p.page_id = s.id
					WHERE s.name LIKE '%{$key}%' AND p.name LIKE '%{$key}%'
					GROUP BY p.page_id)
				UNION
					(SELECT s.id,
					8 AS X1,
					0 AS X2,
					(CASE WHEN s.is_verification=1 THEN 2 ELSE 0 END) AS X3,
					(CASE WHEN s.featured=1 THEN 2 ELSE 0 END) AS X5
					FROM pages s INNER JOIN productsearch p ON p.page_id = s.id
					WHERE s.name LIKE '%{$key}%' AND p.name NOT LIKE '%{$key}%'
					GROUP BY p.page_id)
				UNION
					(SELECT s.id,
					0 AS X1,
					4 + SQRT(COUNT(p.product_id)) AS X2,
					(CASE WHEN s.is_verification=1 THEN 2 ELSE 0 END) AS X3,
					(CASE WHEN s.featured=1 THEN 2 ELSE 0 END) AS X5
					FROM pages s INNER JOIN productsearch p ON p.page_id = s.id
					WHERE s.name NOT LIKE '%{$key}%' AND MATCH(p.name) AGAINST('{$key}' IN BOOLEAN MODE)
					GROUP BY p.page_id)
				)
			";
			// $search_clause = "(
			// 	SELECT s.id,
			// 		8 AS X1,
			// 		0 AS X2,
			// 		(CASE WHEN s.is_verification=1 THEN 2 ELSE 0 END) AS X3,
			// 		(CASE WHEN s.featured=1 THEN 2 ELSE 0 END) AS X5
			// 		FROM pages s
			// 		WHERE s.name LIKE '%{$key}%'
			// 	)
			// ";
		}
		else {
			$search_clause = "(
				SELECT s.id,
					0 AS X1,
					0 AS X2,
					(CASE WHEN s.is_verification=1 THEN 2 ELSE 0 END) AS X3,
					(CASE WHEN s.featured=1 THEN 2 ELSE 0 END) AS X5
					FROM pages s
				)";
		}

		$category = $this->pdo->fetch_one("SELECT id FROM taxonomy WHERE name LIKE '$key'");
		if($category) $cat_id = $category['id'];
		
	
		if($filter['gold']==1) $where .= " AND p.package_id>0";
		if($filter['verify']==1) $where .= " AND p.is_verification=1";
		if($filter['oem']==1) $where .= " AND p.is_oem=1";
		if($filter['province']!=null) $where .= " AND p.province_id IN (".$filter['province'].")";
		if($memnumber!=null) $where .= " AND p.number_mem IN ($memnumber)";
		if($revenue!=null) $where .= " AND pr.revenue IN ($revenue)";

		$out['number']=$this->pdo->count_custom("SELECT COUNT(1) AS number FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id
        WHERE $where");

		$paging = new \Lib\Core\Pagination($out['number'], 20, 0);

		$sql = "SELECT DISTINCT p.*,pr.metas,pr.revenue,pr.supply_ability
			FROM pages p
			LEFT JOIN {$search_clause} t ON p.id=t.id
			LEFT JOIN pageprofiles pr ON p.id=pr.page_id
			WHERE $where
		";
		
		// if($cat_id!==null){
		// 	$sql .= " OR (a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
		// 	AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$cat_id) AND (SELECT rgt FROM taxonomy WHERE id=$cat_id))
		// 	ORDER BY lft))";
		// }
		
		$sql .= ' ORDER BY (X1 + X2 + X3 + X5) DESC ';
		$sql = $paging->get_sql_limit($sql);
		
		$pages = $this->pdo->fetch_all($sql);
		foreach ($pages AS $k=>$item){
		    $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
		    $pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
		    $pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
		    $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
		    $pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
		    $pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		    $pages[$k]['metas'] = json_decode($item['metas'], true);
		    $pages[$k]['isfavorite'] = in_array($item['id'], $favorites)?1:0;
			$pages[$k]['type_name'] = @$this->page->type[$item['type']];
			$pages[$k]['number_mem_show'] = @$this->page->number_mem[$item['number_mem']];
			$pages[$k]['revenue'] = @$this->page->revenue[$item['revenue']];
		}
				
		$this->smarty->assign('result', $pages);
		$out['checkbox_memnumber'] = $this->help->get_checkbox_from_array($this->page->number_mem, $memnumber, 'number_mem');
		$out['checkbox_revenue'] = $this->help->get_checkbox_from_array($this->page->revenue, $revenue, 'revenue');
		$out['url'] = "./supplier/search";
		$out['favorites'] = $favorites;
		$this->smarty->assign('out', $out);
		$this->smarty->assign('filter', $filter);
		$this->smarty->assign('headsearch', 1);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	function oem() {
	    $out = [];
	    
		$result = $this->page->get_page_oems("a.status=1 AND a.is_oem=1", 20);
	    $this->smarty->assign('result', $result);
	    
	    $out['url'] = "?mod=page&site=index";
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}

	function load_more_oem() {
		$page = isset($_POST['page']) ? intval($_POST['page']) : 1;
		$id = isset($_POST['id']) ? intval($_POST['id']) : 0;
	    if($page==1) $limit = 20;
		else $limit = (($page-1)*20).',20';
		$where = "a.status=1 AND a.is_oem=1";
	    if($id !=0) $where.=" AND a.taxonomy_id=$id";
	    $result = $this->page->get_page_oems($where, $limit);
	    $this->smarty->assign('result', $result);
	    
	    $this->smarty->display(LAYOUT_NONE);
	}
	
	function toprank() {
	    $out = [];
	    $pages = $this->pdo->fetch_all("SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.is_oem,a.package_id,
                a.address,a.number_mem,a.date_start,a.is_verification,l.name AS province,p.metas
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id LEFT JOIN locations l ON l.id=a.province_id
                WHERE a.status=1 AND a.featured=1 ORDER BY a.level DESC,a.score DESC,a.id ASC LIMIT 20");
	    foreach ($pages AS $k=>$item){
	        $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
	        $pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
	        $pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
	        $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
	        $pages[$k]['number_mem'] = @$this->page->number_mem[$item['number_mem']];
	        $pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
	        $pages[$k]['pagelink'] = $this->page->get_all_pagelink($item['id'], @$item['page_name']);
	        $pages[$k]['metas'] = json_decode($item['metas'], true);
	    }
	    $this->smarty->assign('result', $pages);
	    
	    $out['url'] = "?mod=page&site=index";
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	
	function load_more_toprank() {
	    $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
	    if($page==1) $limit = 20;
	    else $limit = (($page-1)*20).',20';
	    
	    $sql = "SELECT a.id,a.name,a.logo,a.logo_custom,a.page_name,a.is_oem,a.package_id,
                a.address,a.number_mem,a.date_start,a.is_verification,l.name AS province,p.metas
				FROM pages a LEFT JOIN pageprofiles p ON a.id=p.page_id LEFT JOIN locations l ON l.id=a.province_id
                WHERE a.status=1 AND a.featured=1";
	    if(isset($_POST['id'])&&$_POST['id']!=0) $sql .= " AND a.taxonomy_id=".intval($_POST['id']);
	    $sql .= " ORDER BY a.level DESC,a.score DESC,a.id ASC LIMIT $limit";
	    
	    $pages = $this->pdo->fetch_all($sql);
	    foreach ($pages AS $k=>$item){
	        $pages[$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
	        $pages[$k]['logo_custom'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo_custom']);
	        $pages[$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
	        $pages[$k]['url_contact'] = "?mod=page&site=contact&page_id=".$item['id'];
	        $pages[$k]['number_mem'] = @$this->page->number_mem[$item['number_mem']];
	        $pages[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
	        $pages[$k]['pagelink'] = $this->page->get_all_pagelink($item['id'], @$item['page_name']);
	        $pages[$k]['metas'] = json_decode($item['metas'], true);
	    }
	    $this->smarty->assign('result', $pages);
	    
	    $out = [];
	    $out['page'] = $page;
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_NONE);
	}
	
	function contact(){
		global $login;	
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='send_contact'){
			$page_id = isset($_POST['page_id']) ? intval($_POST['page_id']) : 0;
			$product_id = isset($_POST['product_id']) ? intval($_POST['product_id']) : 0;
			$number = isset($_POST['number']) ? intval($_POST['number']) : 0;
			$unit_id = isset($_POST['unit_id']) ? intval($_POST['unit_id']) : 0;
			$rt = [];
			$rt['code'] = 0;
			if($login==0) $rt['code'] = 2;
			elseif(!$this->pdo->check_exist("SELECT 1 FROM pages WHERE id=$page_id")){
				$rt['msg'] = "Không tồn tại gian hàng này.";
			}elseif($product_id!=0 && !$this->pdo->check_exist("SELECT 1 FROM products WHERE page_id=$page_id AND id=$product_id")){
				$rt['msg'] = "Sản phẩm không thuộc gian hàng.";
			}else{
			    $data = [];
				$data['page_id'] = $page_id;
				$data['product_id'] = $product_id;
				$data['message'] = trim(@$_POST['message']);
				$data['number'] = $number;
				$data['unit_id'] = $unit_id;
				$data['user_id'] = $login;
				$data['created'] = time();
				$this->pdo->insert('pagemessages', $data);
				$rt['code'] = 1;
				$rt['msg'] = "Gửi liên hệ tới gian hàng thành công.";
			}
			echo json_encode($rt);
			exit();
		}
		
		$page_id = isset($_GET['page_id']) ? intval($_GET['page_id']) : 0;
		$product_id = isset($_GET['product_id']) ? intval($_GET['product_id']) : 0;
		
		$product = $this->pdo->fetch_one("SELECT id,name,images,minorder,unit_id,page_id FROM products WHERE id=$product_id");
		if($product) $page_id = $product['page_id'];
		$page = $this->page->get_profile($page_id);
		$this->smarty->assign('page', $page);
		
		$product = $this->product->get_detail($product);
		
		$this->smarty->assign('product_unit',$this->tax->get_select_taxonomy('product_unit', @$product['unit_id'], 0, null, 0));
		$this->smarty->assign('product', $product);
		$this->smarty->display (LAYOUT_CUSTOM);
	}
	function contact_confirm(){
        // $oId = $_GET['oId'];
        // $id = json_decode($oId, true);
        // $this->smarty->assign("out", $id);
        $this->smarty->display(LAYOUT_HOME);
    }
	
	function ajax_handle(){
	    global $login;
	    if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='set_page_favorite'){
	        $id = intval(@$_POST['id']);
	        $rt = [];
	        if($this->pdo->check_exist("SELECT 1 FROM pagefavorites WHERE user_id=$login AND page_id=$id")){
	            $rt['code'] = 0;
	            $rt['msg'] = 'Bạn đã thêm vào danh sách trước đó.';
	        }else{
	            $data = [];
	            $data['user_id'] = $login;
	            $data['page_id'] = $id;
	            $data['created'] = time();
	            $data['status'] = 1;
	            $this->pdo->insert('pagefavorites', $data);
	            $rt['code'] = 1;
	            $rt['msg'] = 'Lưu vào danh sách theo dõi thành công.';
	        }
	        echo json_encode($rt); exit();
	    }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='remove_page_favorite'){
	        $id = intval(@$_POST['id']);
	        $data['created'] = time();
	        $data['status'] = 0;
	        $this->pdo->update('pagefavorites', $data, "page_id=$id AND user_id=$login");
	        exit();
	    }
	}
	
}
