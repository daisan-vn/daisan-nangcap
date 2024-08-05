<?php

namespace Lib\Dbo;

class Service {

    use \Lib\Singleton;

    private $pdo, $str, $img;
	private $number_img_in_folder = 500;
	public $dir_img;
	
	protected function __construct(){
		$this->pdo = \Lib\DB::instance();
		$this->str = \Lib\Core\Text::instance();
		$this->img = \Lib\Core\Image::instance();

		$this->dir_img = "services/";
	}
	
	
	function get_pageservices($page_id, $where=null, $limit=6, $page_url=null){
		if($page_url==null) $page_url = URL_PAGE."?pageId=".$page_id;
		$sour = substr_count($page_url, '?')>0?'&':'?';
		
		$where = $where!=null?" AND $where":null;
		$services = $this->pdo->fetch_all("SELECT s.id,s.name,s.avatar,a.timework,a.description,
				(SELECT p.price FROM pageserviceprices p
					WHERE p.page_id=a.page_id AND p.service_id=a.service_id ORDER BY p.price ASC LIMIT 1) AS price
				FROM pageservices a LEFT JOIN services s ON s.id=a.service_id
				WHERE a.status=1 $where AND a.page_id=$page_id LIMIT $limit");
		foreach ($services AS $k=>$item){
			$services[$k]['avatar'] = $this->img->get_image($this->get_folder_img($item['id']), $item['avatar']);
			$services[$k]['url'] = $page_url.$sour."site=service_detail&service_id=".$item['id']."&pn=".$this->str->str_convert($item['name']);
		}
		return $services;
	}
	
	function get_folder_img($service_id){
		$number = intval($service_id/$this->number_img_in_folder);
		$folder = ($number+1)*$this->number_img_in_folder;
		return $this->dir_img.$folder."/";
	}
	
	
	function get_folder_img_upload($service_id){
		return DIR_UPLOAD.$this->get_folder_img($service_id);
	}
}