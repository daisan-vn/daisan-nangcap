<?php

namespace Lib\Dbo;

class Post {

    use \Lib\Singleton;

    private $pdo, $img, $str;
	public $type, $status, $position;
	
	protected function __construct(){
		$this->pdo = \Lib\DB::instance();
		$this->str = \Lib\Core\Text::instance();
		$this->media = \Lib\Dbo\Media::instance();

		$this->type = array(
				'post' => 'Tin tức, Bài viết',
				'product' => 'Sản phẩm',
				'album' => 'Album ảnh',
				'video' => 'Videos',
				'image' => "Hình ảnh",
				'question' => 'Hỏi đáp',
				'project' => 'Dịch vụ',
				'help' => 'Hỗ trợ',
				'support' => 'Bài viết hỗ trợ',
		);
		
		$this->position = array(
				1 => "Position 1",
				2 => "Position 2",
				3 => "Position 3",
				4 => "Position 4",
		);
		
        $this->status = array( 0 => "Chưa kích hoạt", 1 => "Hoạt động", 2 => "Khóa");
	}
	
	
	function get_posts($category=NULL, $position=null, $limit=NULL, $where=NULL, $orderby=NULL, $type='post', $fields=null){
	    global $lang;
	    $sql = "SELECT a.id,a.title,a.alias,a.media_id,a.description,a.content,a.featured,a.position,a.updated";
	    if($fields!=null) $sql .= ",$fields";
	    $sql .= " FROM posts a WHERE a.type='$type' AND a.status=1 AND a.lang='$lang'";
		
	    if($position!==0 && $position!==null) $sql .= " AND a.position='$position'";
	    if($category != NULL && $category != '' && $type=='post') $sql .= " AND a.id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id IN ($category))";
	    if($category != NULL && $category != '' && $type!='post') $sql .= " AND a.taxonomy_id IN($category)";
	    if($where!=NULL && $where!='') $sql .= " AND $where";
	    if($orderby != NULL) $sql .= " ORDER BY $orderby";
		else $sql .= " ORDER BY a.sort, a.featured DESC, a.id DESC";
	    if($limit != 0 && $limit != NULL) $sql .= " LIMIT $limit";
	    $stmt = $this->pdo->getPDO()->prepare($sql);
	    $stmt->execute();
	    $posts = [];
	    while ($item = $stmt->fetch()){
	       // $item['url'] = $this->get_url($item['id'], $item['alias'], $type);
	        //$item['avatar'] = $this->img->get_image($item['image']);
			//$item['url'] = DOMAIN . ROUTER_BLOG . $item['alias'] . ".htm";
			$item['url'] = URL_BLOG . $item['alias'] . ".htm";
	        $item['avatar'] = $this->media->get_image_byid($item['media_id'],1);
	        $item['image'] = $this->media->get_image_byid($item['media_id'],1);
	        $posts[] = $item;
	    }
	    return $posts;
	}
	function get_array_posts_with_taxposition($position, $type='category', $limit=1, $limit_post=null){
	    global $lang;
	    $tax = [];
	    if($limit==1){
	        $tax = $this->pdo->fetch_one("SELECT id,name,alias,description FROM taxonomy
					WHERE status=1 AND type='$type' AND position='$position' AND lang='$lang'
					ORDER BY featured DESC,lft LIMIT 1");
	        if($tax){
	           // $tax['url'] = "?mod=$type&site=index&id=".$tax['id'];
				//$tax['url'] = DOMAIN . ROUTER_BLOG . $tax['alias'];
				$tax['url'] = DOMAIN . $tax['alias'];
	            $tax['posts'] = $this->get_posts($tax['id'], 0, $limit_post,null,null,'post');
	        }
	    }else if($limit > 1){
	        $sql = "SELECT id,name,alias,image FROM taxonomy
					WHERE status=1 AND type='$type' AND position='$position' AND lang='$lang'
					ORDER BY featured DESC,lft LIMIT $limit";
	        $stmt = $this->pdo->getPDO()->prepare($sql);
	        $stmt->execute();
	        while ($item = $stmt->fetch()){
	          //  $item['url'] = $this->taxonomy->get_url($type, $item['id'], $item['alias']);
	          //  $item['avatar'] = $this->img->get_image($item['image']);
			    // $item['url'] = DOMAIN . ROUTER_BLOG . $item['alias'];
				$item['url'] = URL_BLOG . $item['alias'] . ".htm";
	            $item['posts'] = $this->get_posts($item['id'], 0, $limit_post);
	            $tax[] = $item;
	        }
	    }
	    return $tax;
	}
	function get_select_posts($type="post",$active=0, $category=0, $not=null, $prefix="Select post"){
        $result = "";
        if ($prefix != null)
            $result = '<option value="0">' . $prefix . '</option>';

        $sql = "SELECT id,title FROM posts WHERE status=1 AND type='$type'";
        if($category!=0)
            $sql .= " AND id IN (SELECT post_id FROM taxonomyrls WHERE taxonomy_id=$category)";
        if($not != 0 && count(explode(",", $not))>0)
            $sql .= " AND post_id NOT IN ($not)";

        $sql .= " ORDER BY sort";
		
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        while ($item = $stmt->fetch()) {
            if ($item ['id'] == $active)
                $result .= '<option value="' . $item ['id'] . '" selected>';
            else
                $result .= '<option value="' . $item ['id'] . '">';
            $result .= $item ['title'];
            $result .= '</option>';
        }
        return $result;
    }
	
	function get_price($price=0, $promo=0){
		$str = null;
		if($promo==0){
			$str .= "<span class=\"price_sale\">".number_format($price)." đ</span>";
		}else{
			$str .= "<span class=\"price_sale\">".number_format($promo)." đ</span>";
			$str .= "<span class=\"price_old\">".number_format($price)." đ</span>";
		}
		return $str;
	}
	
	
	function check_alias($type, $value, $current=0) {
		if ($this->pdo->fetch_one("SELECT id FROM posts WHERE type='$type' AND alias='$value' AND alias<>'' AND id<>$current")){
			$value=$value."1";
			$value = $this->check_alias($type,$value,$current);
		}
		return $value;
	}

	function get_url($id, $alias=NULL){
		$url = DOMAIN . ROUTER_BLOG;
		if($alias==NULL || $alias=="")
			$url .= $id;
		else 
			$url .= $alias; 
		return $url;
	}
}