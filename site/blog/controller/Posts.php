<?php
class Posts extends Blog {
    private $folder, $pament_method;
	function __construct() {
		parent::__construct ();
		
		$this->folder = "rfq/";
		$this->pament_method = array(
		    1 => 'Thanh toán tiền mặt khi giao hàng',
		    2 => 'Thanh toán chuyển khoản ATM',
		    3 => 'Thanh toán online tự động'
		);
	}
	
	function index() {
		$cid = intval(\App::getParam('id', 0));
		
		$taxonomy = $this->pdo->fetch_one("SELECT id,name,parent,keyword,description FROM taxonomy WHERE type='category' AND (id='$cid' OR alias='$cid')");
		$cid = @$taxonomy['id'];
		$where = "a.status=1 AND a.type='post'";
		if($cid != 0){
		    $taxs = $this->tax->get_all_category_id($cid);
		    if (count($taxs) > 0)
		        $where .= " AND a.id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id IN (".implode(",", $taxs)."))";
		}
		$sql = "SELECT a.id,a.title,a.alias,a.description,a.created,a.media_id
                FROM posts a WHERE $where ORDER BY a.id DESC";
		$out['number'] = $this->pdo->count_item('posts', $where);
		$paging = new \Lib\Core\Pagination($out['number'], 20, 1);
		$sql = $paging->get_sql_limit($sql);
		$result = $this->pdo->fetch_all($sql);
		foreach ($result AS $k=>$item){
		    //$result[$k]['url'] = "?site=post_detail&id=".$item['id'];
			//$result[$k]['url'] = DOMAIN . ROUTER_BLOG . $item['alias'] . ".htm";
			$result[$k]['url'] = URL_BLOG . $item['alias'] . ".htm";
		    $result[$k]['avatar'] = $this->media->get_image_byid($item['media_id'],1);
		}
		$this->smarty->assign('result', $result);

		$post_views = $this->post->get_posts(null,null,4,"a.taxonomy_id=$cid","a.views DESC");
		$this->smarty->assign('post_views', $post_views);
		
		$a_category_submenu = $this->tax->get_taxonomy("category", $cid, NULL, 6);
		$this->smarty->assign('a_category_submenu', $a_category_submenu);
		
		$out['taxonomy_name'] = $taxonomy['name'];
		$out['id'] = $cid;
		$this->smarty->assign('out', $out);
		$this->get_breadcrumb($cid);
		$this->smarty->display(LAYOUT_HOME);
	}
	function load_more() {
		$page = isset($_POST['page']) ? intval($_POST['page']) : 1;
		$id = isset($_POST['id']) ? intval($_POST['id']): 0;
        $limit = (($page-1)*20).',20';
		$where = "a.status=1 AND a.type='post'";
		$sql = "SELECT a.id,a.title,a.alias,a.description,a.created,a.media_id
                FROM posts a WHERE $where ORDER BY a.id DESC LIMIT $limit";
		$result = $this->pdo->fetch_all($sql);
		foreach ($result AS $k=>$item){
		   // $result[$k]['url'] = "?site=post_detail&id=".$item['id'];
			//$result[$k]['url'] = DOMAIN . ROUTER_BLOG . $item['alias'] . ".htm";
			$result[$k]['url'] = URL_BLOG . $item['alias'] . ".htm";
		    $result[$k]['avatar'] = $this->media->get_image_byid($item['media_id'],1);
		}
		$this->smarty->assign('result', $result);
		
		$this->smarty->assign('out',$out);
		$this->smarty->display(LAYOUT_NONE);
	}
	function search(){
		//exit();
	    $key = isset($_GET['key'])?trim($_GET['key']):'';
	    $where = "a.status=1 AND a.type='post'";
	    if($key!='') $where .= " AND a.title LIKE '%$key%'";
	    $sql = "SELECT a.id,a.title,a.alias,a.description,a.created,a.media_id
                FROM posts a WHERE $where ORDER BY a.id DESC LIMIT 10";
	    $out['number'] = $this->pdo->count_item('posts', $where);
	   
	    $result = $this->pdo->fetch_all($sql);
	    foreach ($result AS $k=>$item){
			//$result[$k]['url'] = DOMAIN . ROUTER_BLOG . $item['alias'] . ".htm";
			$result[$k]['url'] = URL_BLOG . $item['alias'] . ".htm";
	        $result[$k]['avatar'] = $this->media->get_image_byid($item['media_id'],1);
	    }
	    $this->smarty->assign('out', $out);
	    $this->smarty->assign('result', $result);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	function tag(){
		$id = isset($_GET['id']) ? $_GET['id'] : 0;
		$taxonomy = $this->pdo->fetch_one("SELECT id,name,parent,keyword,description FROM taxonomy WHERE type='tag' AND (id='$id' OR alias='$id')");
		$id = @$taxonomy['id'];
		$where = "a.status=1 AND a.type='post'";
		$sql = "SELECT a.id,a.title,a.alias,a.description,a.created,a.updated,a.media_id
    	FROM posts a
    	WHERE a.status=1 AND a.type='post'";
    	if($id != 0){
    		$taxs = $this->tax->get_all_category_id($id);
    		if (count($taxs) > 0)
    			$sql .= " AND a.id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id IN (".implode(",", $taxs)."))";
    	}
    	$sql .= " ORDER BY sort ASC, id DESC";
		$result = $this->pdo->fetch_all($sql);
	    foreach ($result AS $k=>$item){
			//$result[$k]['url'] = DOMAIN . ROUTER_BLOG . $item['alias'] . ".htm";
			$result[$k]['url'] = URL_BLOG . $item['alias'] . ".htm";
	        $result[$k]['avatar'] = $this->media->get_image_byid($item['media_id'],1);
	    }
		$this->smarty->assign('result', $result);
    	$this->smarty->display(LAYOUT_HOME);
	}
	function post_detail(){
		$id = intval(\App::getParam('id', 0));
	    
		$where = "1=1";
		if(is_numeric($id)) $where .= " AND id='$id'";
        else $where .= " AND alias='$id'";
	    $info = $this->pdo->fetch_one("SELECT * FROM posts WHERE $where");
	    $info['avatar'] = $this->media->get_image_byid($info['media_id'],1);
		$info['created'] = gmdate("d/m/Y", $info['created']);
	    $info['content'] = str_replace('http://imgs.beta.daisan.vn','http://imgs.daisan.vn',$info['content']);
	    $this->smarty->assign('info', $info);
	   
	   // $this->get_breadcrumb($info['taxonomy_id']);
	    $a_category = $this->get_taxonomy_rls_array($info['id']);
	    foreach ($a_category AS $k=>$item){
	        $a_category_id[] = $item['id'];
	    }
		$a_tag = $this->get_taxonomy_rls_array($info['id'],'tag');
		foreach ($a_tag AS $k=>$item){
	        $a_tag_id[] = $item['id'];
	    }
	    @$a_other = $this->post->get_posts(implode(",", @$a_tag_id), 0, 6, "a.id<>".$info['id'], NULL, $info['type']);
	    $category_min_id = $this->get_min_of_category($a_category);
	    $this->get_breadcrumb($category_min_id);
	    $this->smarty->assign('a_other', $a_other);
	    $this->get_seo_metadata(@$info['title'], @$out['meta_key'], @$info['description'], @$info['avatar']);
		$this->pdo->query("UPDATE posts SET views=views+1 WHERE alias = '$id'");
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	function ajax_loadmore(){
	    $where = "a.status=1 AND a.type='post'";
	    $limit = 10;
	    $page = isset($_POST['page'])?intval($_POST['page']):1;
	    $start = ($page - 1) * $limit;
	    $sql = "SELECT a.id,a.title,a.description,a.created,a.media_id
                FROM posts a WHERE $where ORDER BY a.id DESC LIMIT $start, $limit";
	    $result = $this->pdo->fetch_all($sql);
	    foreach ($result AS $k=>$item){
			//$result[$k]['url'] = DOMAIN . ROUTER_BLOG . $item['alias'] . ".htm";
			$result[$k]['url'] = URL_BLOG . $item['alias'] . ".htm";
	        $result[$k]['avatar'] = $this->media->get_image_byid($item['media_id'],1);
	    }
		
	    $this->smarty->assign('result', $result);
		
	    $this->smarty->display('none.tpl');
	}

}
