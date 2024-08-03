<?php
class Home extends Blog {
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
		$where = "a.status=1 AND a.type='post'";
		$sql = "SELECT a.id,a.title,a.alias,a.description,a.created,a.media_id
                FROM posts a WHERE $where ORDER BY a.id DESC LIMIT 20";
		$result = $this->pdo->fetch_all($sql);
		foreach ($result AS $k=>$item){
		   // $result[$k]['url'] = "?site=post_detail&id=".$item['id'];
			//$result[$k]['url'] = DOMAIN . ROUTER_BLOG . $item['alias'] . ".htm";
			$result[$k]['url'] = URL_BLOG . $item['alias'] . ".htm";
		    $result[$k]['avatar'] = $this->media->get_image_byid($item['media_id'],1);
		}
		$this->smarty->assign('result', $result);
		$out['number'] = $this->pdo->count_custom("SELECT COUNT(1) number FROM posts a WHERE $where");
		$post_views = $this->post->get_posts(null,null,4,null,"a.views DESC");
		$this->smarty->assign('out',$out);
		$this->smarty->assign('post_views', $post_views);

		$this->smarty->display(LAYOUT_HOME);
	}
	function load_more() {
		$page = isset($_POST['page']) ? intval($_POST['page']) : 1;
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
	
	function post_detail(){
	    
	    $id = isset($_GET['id'])?intval($_GET['id']):0;
	    $info = $this->pdo->fetch_one("SELECT * FROM posts WHERE id=$id");
	    $info['avatar'] = $this->media->get_image_byid($info['media_id'],1);
	    $info['content'] = str_replace('http://imgs.beta.daisan.vn','http://imgs.daisan.vn',$info['content']);
	    $this->smarty->assign('info', $info);
	   
	   // $this->get_breadcrumb($info['taxonomy_id']);
	    $a_category = $this->get_taxonomy_rls_array($info['id']);
	    foreach ($a_category AS $k=>$item){
	        $a_category_id[] = $item['id'];
	    }
	    @$a_other = $this->post->get_posts(implode(",", @$a_category_id), 0, 8,' a.id<>'.$info['id'], NULL, $info['type']);
	    $category_min_id = $this->get_min_of_category($a_category);
	    $this->get_breadcrumb($category_min_id);
	    $this->smarty->assign('a_other', $a_other);
	    $this->get_seo_metadata(@$info['title'], @$out['meta_key'], @$info['description'], @$info['avatar']);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	

}
