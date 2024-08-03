<?php
class Helpcenter extends Main {
    private $folder, $pament_method, $menu_help;
	function __construct() {
		parent::__construct ();
		
		$menu_help = $this->menu->get_menu_arr('help');
		$this->smarty->assign('menu_help', $menu_help);
	}
	
	
	function index() {
		$category = $this->tax->get_taxonomy('support',0,null,10);
		foreach ($category AS $k=>$v){
		    $category[$k]['posts'] = $this->pdo->fetch_all("SELECT id,title FROM posts WHERE status=1 AND type='support'
                AND id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id=".$v['id'].")
                ORDER BY featured DESC LIMIT 5");
		    unset($v);
		}
 		
		$this->smarty->assign('category', $category);
		$this->smarty->display(LAYOUT_HOME);
	}
	
	function detail(){
	    $id = isset($_GET['pId'])?intval($_GET['pId']):0;
	    $info = $this->pdo->fetch_one("SELECT * FROM posts WHERE id=$id");
	    $info['content'] = str_replace('http://imgs.beta.daisan.vn','http://imgs.daisan.vn',$info['content']);
	    $this->smarty->assign('info', $info);
	    
	    $sql = 'SELECT id,title FROM posts WHERE status=1 AND id<>'.$id.'
                AND id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id IN (SELECT taxonomy_id FROM taxonomyrls WHERE post_id='.$id.'))
                ORDER BY featured DESC LIMIT 10';
	    $other = $this->pdo->fetch_all($sql);
	    $this->smarty->assign('other', $other);
	    
	    $this->get_breadcrumb($info['taxonomy_id']);
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	

	function search() {
	    $cid = isset($_GET['cId'])?intval($_GET['cId']):0;
	    $key = isset($_GET['key'])?trim($_GET['key']):'';
	    
	    $where = "a.status=1 AND a.type='support'";
	    if($key!='') $where .= " AND a.title LIKE '%$key%'";
	    if($cid!=0){
	        $where .= " AND (a.id IN (SELECT r.post_id FROM taxonomyrls r WHERE r.taxonomy_id=$cid) OR a.taxonomy_id=$cid)";
	        $key = $this->pdo->fetch_one_fields('taxonomy', 'name', 'id='.$cid);
	    }
	    
	    $out = [];
	    
	    $sql = "SELECT a.id,a.title,a.description FROM posts a WHERE $where ORDER BY a.featured DESC";
	    $out['number']=$this->pdo->count_item("posts", $where);
	    $paging = new \Lib\Core\Pagination($out['number'], 10, 0);
	    $sql = $paging->get_sql_limit($sql);
	    $posts = $this->pdo->fetch_all($sql);
	    $this->smarty->assign('posts', $posts);
	    
// 	    lib_dump($posts);
	    
	    $category = $this->tax->get_taxonomy('support');
	    $this->smarty->assign('category', $category);
	    $out['key'] = trim($key);
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_HOME);
	}
	
}
