<?php

namespace Lib\Core;

class Image extends \Lib\Core\Zebra {

    use \Lib\Singleton;

    public $img_type;
	public $_dir;
	
	protected function __construct(){
		$this->img_type = array("image/gif", "image/jpg", "image/jpeg", "image/png");
		$this->_dir = "../upload/";
		$this->folder = "images/";
		$this->thumbnail = "thumb/";
		
	}
	
	public function get_image($folder, $imgname){
        if ($imgname) {
            $folder = URL_IMAGE.$folder;
            return $folder.$imgname;
        }
	    return NO_IMG;
	}
	
	public function get_image_post($image, $type=0, $return_null=0){
	    $result = NO_IMG;
	    
	    $dir = $this->thumbnail;
	    if($type==1) $dir = $this->folder;
	    $dir = $this->_dir . $dir;
	    
	    $convert_arr_dir = explode("/", $dir);
	    if($convert_arr_dir[0]==".."){
	        $dir_get = implode("/", $convert_arr_dir);
	        unset($convert_arr_dir[0]);
	        unset($convert_arr_dir[1]);
	        $dir_show = implode("/", $convert_arr_dir);
	    }
	    else {
	        $dir_get = "../" . implode("/", $convert_arr_dir);
	        unset($convert_arr_dir[1]);
	        $dir_show = implode("/", $convert_arr_dir);
	    }
	    
	    if(is_file($dir_get . $image)){
	        $result = URL_UPLOAD . $dir_show . $image;
	    }else {
	        if($return_null==1)
	            return false;
	    }
	    
	    return $result;
	}
	
	
    function check_image($img, $w=200, $h=200, $size=5) {
        list($width, $height) = getimagesize($img['tmp_name']);
        if ($img["error"] > 0) {
            lib_alert("Image correct !");
            return false;
        } elseif (!in_array($img["type"], $this->img_type)) {
            lib_alert("Image correct !");
            return false;
        } elseif (($img["size"] / 1024) > ($size*1024)) {
            lib_alert("Invalid: Size of image > 5Mb !");
            return false;
        } elseif ($height < $h || $width < $w) {
            lib_alert("Invalid: Size of image is so small !");
            return false;
        } else {
            return true;
        }
    }

    
    function img_convert($folder, $imgname){
        $img = $folder.$imgname;
        $a_name = explode('.', $imgname);
        array_pop($a_name);
        $only_name = implode('.',$a_name);
        chmod($img, 0755);
        $imgsize = getimagesize($img);
        list(, $mimetype)	= explode("/", $imgsize['mime']);
        
        if(@$imgsize[0]<30||!in_array($mimetype, ['jpg','jpeg','png','gif','webp']||strpos(@file_get_contents($img), '<?php')!==false)){
            unlink($img);
            $rt = false;
        }else{
            $im = false;
            if($mimetype=='jpeg'||$mimetype=='jpg') $im = imagecreatefromjpeg($img);
            elseif($mimetype=='png') $im = imagecreatefrompng($img);
            elseif($mimetype=='gif') $im = imagecreatefromgif($img);
            elseif($mimetype=='webp') $im = imagecreatefromwebp($img);
            else unlink($img);
            
            if($im){
                imagepalettetotruecolor($im);
                imagealphablending($im, true);
                imagesavealpha($im, true);
                
                @unlink($img);
                if($mimetype=='jpeg'||$mimetype=='jpg'){
                    $rt = $only_name.'.jpeg';
                    imagejpeg($im, $folder.$only_name.'.jpeg', 90);
                }elseif($mimetype=='png'||$mimetype=='webp'){
                    $rt = $only_name.'.png';
                    imagepng($im, $folder.$only_name.'.png', 6);
                }elseif($mimetype=='gif'){
                    $rt = $only_name.'.gif';
                    imagegif($im, $folder.$only_name.'.gif');
                }
                
                imagedestroy($im);
                chmod($folder.$rt, 0755);
            }else $rt = false;
        }
        return $rt;
    }
    
    function upload($folder, $img, $max_width=null, $resize=-1) {
    	$folder = DIR_UPLOAD.$folder;
        $imgname = $this->get_imgname_upload($img);
        if (!is_dir($folder)) {
            @mkdir($folder, 0775, true);
            // @chmod($folder, 0775);
        }
        
        list($width, $height) = getimagesize($img['tmp_name']);
        if (move_uploaded_file($img['tmp_name'], $folder.$imgname)) {
            @chmod($folder.$imgname, 0755);
            if($max_width!=null && intval($max_width)>10){
            	if($resize>0) $new_height = $max_width/$resize;
            	else $new_height = $height * ($max_width/$width);
            	$this->resize_image($folder.$imgname, $max_width, $new_height);
            	@chmod($folder.$imgname, 0755);
            }
            return $imgname;
        }
        return false;
    }

    function upload_image_auto_resize_fromurl($folder, $url, $max_width=null, $resize=1){
        if(!is_dir($folder)) $folder = DIR_UPLOAD.$folder;
        $stream_opts = [
            "ssl" => [
                "verify_peer"=>false,
                "verify_peer_name"=>false,
            ]
        ];
        $img = @file_get_contents($url,false, stream_context_create($stream_opts));
        $a_type = explode('.', $url);
        $type = @end($a_type);
        list($type, ) = explode('?', $type);
        list($type, ) = explode('#', $type);
        $imgname = time()."_".md5($url).".".$type;
        
        if(!is_dir($folder)){
            mkdir($folder, 0777, true);
            // chmod($folder, 0777);
        }
        $rt = false;
        if(@file_put_contents($folder.$imgname, $img)){
            $rt = $imgname;
            if($max_width!=null && intval($max_width)>30){
                list($width, $height) = getimagesize($folder.$imgname);
                if($width>0){
                    $new_height = $height * ($max_width/$width);
                    $this->resize_image($folder.$imgname, $max_width, $new_height);
                }
            }
            chmod($folder.$imgname, 0755);
        }
        return $rt;
    }
    
    
    function upload_webp($page_id, $url_img, $name) {
        $folder = DIR_UPLOAD.'pages/'.$page_id."/";
        if (!is_dir($folder)){
            @mkdir($folder, 0777, true);
            // @chmod($folder, 0777);
        }
        
        $content = @file_get_contents($url_img,false,stream_context_create(["ssl"=>["verify_peer"=>false,"verify_peer_name"=>false]]));
        if($content===false){
            $context = stream_context_create([
                'http' => [
                    'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
                ],
            ]);
            $content = @file_get_contents($url_img, false, $context);
        }
        
        $rt = false;
        if(@file_put_contents($folder.$name, $content)){
            $rz = $this->resize_img_upload($folder.$name, 800, -1);
            if(!$rz){
                @unlink($folder.$name);
                return false;
            }
            $name = $this->convert_type_webp($folder, $name);
            $rt = $name;
        }
        return $rt;
    }
    
    
    function convert_type_webp($folder, $image){
        $imgsize = @getimagesize($folder.$image);
        if($imgsize) list(, $mimetype) = explode("/", $imgsize['mime']);
        else $mimetype = null;
        
        if($mimetype=='jpeg'||$mimetype=='jpg') $im = @imagecreatefromjpeg($folder.$image);
        elseif($mimetype=='png') $im = @imagecreatefrompng($folder.$image);
        elseif($mimetype=='gif') $im = @imagecreatefromgif($folder.$image);
        elseif($mimetype=='webp') $im = @imagecreatefromwebp($folder.$image);
        else{
            $im = false;
            unlink($folder.$image);
        }
        
        if($im){
            imagepalettetotruecolor($im);
            imagealphablending($im, true);
            imagesavealpha($im, true);
            list($newname,) = explode('.', $image);
            $rt = $newname.'.webp';
            imagewebp($im, $folder.$rt);
            imagedestroy($im);
            @unlink($folder.$image);
            chmod($folder.$rt, 0755);
        }else $rt = false;
        return $rt;
    }
    
    
    function resize_img_upload($image, $max_width=null, $resize=-1){
        $imgsize = getimagesize($image);
        $width = $imgsize[0];
        $height = $imgsize[1];
        if(intval(@$width)==0||intval($height)==0){
            return false;
        }
        $new_width = $max_width;
        if($max_width===null||$max_width<100) $new_width = $width;
        if($new_width>1600) $new_width = 1600;
        
        if($resize>0) $new_height = intval($new_width/$resize);
        else $new_height = intval($height * floatval($new_width/$width));
        
        if($width!=$new_width || $height!=$new_height){
            $this->source_path = $image;
            $this->preserve_aspect_ratio = true;
            $this->enlarge_smaller_images = true;
            $this->preserve_time = true;
            
            $this->target_path = $image;
            $this->jpeg_quality = 70;
            $this->png_compression = 6;
            
            $this->resize($new_width, $new_height, 6, -1);
        }
        chmod($image, 0755);
        return true;
    }
    
    
    function upload_image_base64_v1($folder, $img, $imgname=null, $max_width=null, $resize=1){
    	if(!is_dir($folder)) $folder = DIR_UPLOAD.$folder;

    	list(, $img) = explode(',', $img);

    	if(!is_dir($folder)){
            if (!mkdir($folder, 0777, true) && !is_dir($folder)) {
                throw new \RuntimeException(sprintf('Directory "%s" was not created', $folder));
            }
//    		mkdir($folder, 0777);
//    		chmod($folder, 0777);
    	}
    	$rt = false;
    	if(@file_put_contents($folder.$imgname, base64_decode($img))){
    		$rt = $imgname;
    		if($max_width!=null && intval($max_width)>30){
    		    list($width, $height) = getimagesize($folder.$imgname);
    		    if($resize>0) $new_height = $max_width/$resize;
    		    else $new_height = $height * ($max_width/$width);
    		    $this->resize_image($folder.$imgname, $max_width, $new_height);
    		}
    		chmod($folder.$imgname, 0755);
    	}
    	return $rt;
    }
    function upload_image_base64($folder, $img, $imgname=null, $max_width=null, $resize=1){
    	if(!is_dir($folder)) $folder = DIR_UPLOAD.$folder;
        // echo "<pre>";
        // print_r('$imgname -----'.$imgname);
        // echo "</pre>";
    	list($type, $img) = explode(';', $img);
    	list(, $img)      = explode(',', $img);
    	list(, $type)	= explode("/", $type);
    	$imgname = ($imgname==null||$imgname=='') ? 'hodine_img' : $imgname;
    	$imgname = time()."_".md5($imgname).".".$type;

    	if(!is_dir($folder)){
            if (!mkdir($folder, 0777, true) && !is_dir($folder)) {
                throw new \RuntimeException(sprintf('Directory "%s" was not created', $folder));
            }
//    		mkdir($folder, 0777);
//    		chmod($folder, 0777);
    	}
    	$rt = false;
    	if(@file_put_contents($folder.$imgname, base64_decode($img))){
    		$rt = $imgname;
    		if($max_width!=null && intval($max_width)>30){
    		    list($width, $height) = getimagesize($folder.$imgname);
    		    if($resize>0) $new_height = $max_width/$resize;
    		    else $new_height = $height * ($max_width/$width);
    		    $this->resize_image($folder.$imgname, $max_width, $new_height);
    		}
    		chmod($folder.$imgname, 0755);
    	}
    	return $rt;
    }

    function upload_image_fromurl($folder, $url, $max_width=null, $resize=1){
        if(!is_dir($folder)) $folder = DIR_UPLOAD.$folder;
        $stream_opts = [
            "ssl" => [
                "verify_peer"=>false,
                "verify_peer_name"=>false,
            ]
        ];
        $img = @file_get_contents($url,false, stream_context_create($stream_opts));
        $a_type = explode('.', $url);
        $type = @end($a_type);
        $imgname = time()."_".md5($url).".".$type;
        
        if(!is_dir($folder)){
            mkdir($folder, 0777, true);
            // chmod($folder, 0777);
        }
        
        $rt = false;
        if(@file_put_contents($folder.$imgname, $img)){
            $rt = $imgname;
            if($max_width!=null && intval($max_width)>30){
                list($width, $height) = getimagesize($folder.$imgname);
                if($resize>0) $new_height = $max_width/$resize;
                else $new_height = $height * ($max_width/$width);
                $this->resize_image($folder.$imgname, $max_width, $new_height);
            }
            chmod($folder.$imgname, 0755);
        }
        
        return $rt;
    }
    
    
    function make_image_thumb($path_img, $thumbsize=240, $thumbratio=1) {
    	if ($thumbratio == 0) {
    		$thumbheight = $thumbsize;
    		$thumbposition = 1;
    	}else {
    		$thumbheight = intval(intval($thumbsize) / floatval($thumbratio));
    		$thumbposition = 6;
    	}
    
    	$this->resize_image($path_img, $thumbsize, $thumbheight, $thumbposition);
    }
    
    
    function resize_image($image, $width, $height, $thumbposition=6){
    	$this->source_path = $image;
    	$this->preserve_aspect_ratio = true;
    	$this->enlarge_smaller_images = true;
    	$this->preserve_time = true;
    	
    	$this->target_path = $image;
    	$this->jpeg_quality = 70;
    	$this->png_compression = 8;
    	
    	$this->resize($width, $height, $thumbposition, -1);
    }
    
    
    /**
     * Remover images
     * @param string $dir
     * @param string $imgname
     */
    function remove($imgname=null){
    	$rt = true;
    	if($imgname != null || $imgname != ''){
    		if(is_file($this->_dir . $this->folder . $imgname)){
		    	@unlink($this->_dir . $this->folder . $imgname);
		    	@unlink($this->_dir . $this->thumbnail . $imgname);
    		}else $rt = false;
    	}else $rt = false;
    	return $rt;
    }
    
    
    function get_imgname_upload($img){
    	list(, $type)	= explode("/", $img['type']);
    	return time()."_".md5($img['name']).".".$type;
    }

}

