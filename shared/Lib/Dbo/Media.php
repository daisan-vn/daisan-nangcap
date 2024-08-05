<?php

namespace Lib\Dbo;

class Media {

    use \Lib\Singleton;

    private $pdo, $img;
	public $path_image, $path_thumb;
	public $a_category;
	public $thumbsize, $thumbratio, $thumbposition, $imagewidth;

	protected function __construct(){
		$this->pdo = \Lib\DB::instance();
		$this->img = \Lib\Core\Image::instance();

		$this->path_image = "media/images/";
		$this->path_thumb = "media/thumbnails/";
		
	    $this->a_category = array( 1 => "Logo", 2 => "Slider", 3 =>'Adhome', 4=>'AdmHome', 5=>'Background',6=>"Popup", 7 => "Home Banner");
		 
		$this->thumbsize = array (
		    '160' => 'Nhỏ (160px)',                                                                                                                                                                            
		    '240' => 'Vừa (240px)',
		    '320' => 'Lớn (320px)',
		    '480' => 'Lớn (480px)'
		);
		
		$this->thumbratio = array (
		    '0' => 'Tỉ lệ gốc',
		    '3' => '3:1 (Ảnh ngang)',
		    '2' => '2:1 (Ảnh ngang)',
		    '1.7777777777777778' => '16:9 (Ảnh ngang)',
		    '1.5' => '3:2 (Ảnh ngang)',
		    '1.3333333333333333' => '4:3 (Ảnh ngang)',
		    '1' => '1:1 (Ảnh vuông)',
		    '0.75' => '3:4 (Ảnh đứng)',
		    '0.6666666666666667' => '2:3 (Ảnh đứng)',
		);
		
		$this->thumbposition = array (
		    '2' => 'Trên trái',
		    '3' => 'Trên giữa',
		    '4' => 'Trên phải',
		    '5' => 'Giữa trái',
		    '6' => 'Chính giữa',
		    '7' => 'Giữa phải',
		    '8' => 'Dưới trái',
		    '9' => 'Dưới giữa',
		    '10' => 'Dưới phải'
		);
		
		$this->imagewidth = array(
		    1900 => '1900 pixel',
		    1500 => '1500 pixel',
		    1200 => '1200 pixel',
		    1000 => '1000 pixel',
		    800 => '800 pixel',
		    600 => '600 pixel',
		    300 => '300 pixel',
		    0 => 'Giữ nguyên ảnh gốc'
		);
		
	}


	
	function remove_media($id){
		$media = $this->pdo->fetch_one("SELECT a.*,t.alias FROM media a LEFT JOIN taxonomy t ON t.id=a.taxonomy_id WHERE a.id=$id");
		@unlink($this->get_path_upload($media['alias']).$media['name']);
		@unlink($this->get_path_upload($media['alias'], 1).$media['name']);
		$this->pdo->query("DELETE FROM media WHERE id=$id");
	}

	
	function get_media_image($id, $thumb=0){
		$media = $this->pdo->fetch_one("SELECT a.id,a.name,t.alias 
				FROM media a LEFT JOIN taxonomy t ON t.id=a.taxonomy_id WHERE a.id=$id LIMIT 1");
		$folder = $this->get_path($media['alias'], $thumb);
		return $folder.$media['name'];
	}
	
	
	function get_image_byid($id, $thumb=0){
		$media = $this->pdo->fetch_one("SELECT a.id,a.name,t.alias
				FROM media a LEFT JOIN taxonomy t ON t.id=a.taxonomy_id WHERE a.id=$id LIMIT 1");
		
		$rt = NO_IMG;
		if($media){
		    $folder = $this->get_path($media['alias'], $thumb);
		    $rt = $this->img->get_image($folder, $media['name']);
		}
		
		return $rt;
	}
	
	function get_images($category, $position=0, $limit=1, $location=0, $type='image'){
	    $sql = "SELECT id,title,alias,description,media_id FROM posts WHERE taxonomy_id=$category AND status=1";
	    if($position!=0) $sql .= " AND position=$position";
	    if($this->pdo->check_exist("SELECT 1 FROM posts WHERE province_id=$location")) $sql .=" AND province_id=$location";
	    else $sql .=" AND province_id=0";
		if($type != "") $sql .= " AND type='$type'";
	    $sql .= " ORDER BY sort";
	    if($limit==1){
	        $media = $this->pdo->fetch_one($sql." LIMIT 1");
	        $media['image'] = $this->get_image_byid(@$media['media_id']);
	    }else{
	        $media = $this->pdo->fetch_all($sql." LIMIT $limit");
	        foreach ($media AS $k=>$item){
	            $media[$k]['image'] = $this->get_image_byid($item['media_id']);
	        }
	    }
	    return $media;
	}
	function get_slides($category, $limit=1){
	    $sql = "SELECT id,title,alias,description,media_id FROM posts WHERE type='slider' AND taxonomy_id=$category AND status=1 ORDER BY sort";
	    if($limit==1){
	        $media = $this->pdo->fetch_one($sql." LIMIT 1");
	        $media['image'] = $this->get_image_byid($media['media_id']);
	    }else{
	        $media = $this->pdo->fetch_all($sql." LIMIT $limit");
	        foreach ($media AS $k=>$item){
	            $media[$k]['image'] = $this->get_image_byid($item['media_id']);
	        }
	    }
	    return $media;
	}
	
	function get_media_value($id){
		$media = $this->pdo->fetch_one("SELECT a.id,a.name,t.alias,a.created
				FROM media a LEFT JOIN taxonomy t ON t.id=a.taxonomy_id WHERE a.id=$id");
		$media['image'] = $this->img->get_image($this->get_path($media['alias']), $media['name']);
		$media['thumb'] = $this->img->get_image($this->get_path($media['alias'], 1), $media['name']);
		return $media;
	}
	
	function get_path($folder, $thumb=0) {
		$path = $thumb==0?$this->path_image:$this->path_thumb;
		return $path.$folder."/";
	}
 
	function get_path_upload($folder, $thumb=0){
		return DIR_UPLOAD.$this->get_path($folder, $thumb);
	}
}