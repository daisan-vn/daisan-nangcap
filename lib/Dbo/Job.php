<?php

namespace Lib\Dbo;

class Job {

    use \Lib\Singleton;

    private $pdo, $str, $img;
	public $a_salary, $a_exp, $a_position, $a_degree, $a_worktype, $a_timetry, $a_age, $a_gender;
	
	protected function __construct(){
		$this->pdo = \Lib\DB::instance();
		$this->str = \Lib\Core\Text::instance();
		$this->img = \Lib\Core\Image::instance();

		$this->set_salary();
		$this->set_exp();
		$this->set_degree();
		$this->set_position();
		$this->set_worktype();
		$this->set_timetry();
		$this->set_age();
		$this->set_gender();
	}
	
	
	function get_pagejobposts($page_id=0, $where=null, $limit=null, $page_url=null){
		if($page_url==null) $page_url = URL_PAGE."?pageId=".$page_id;
		$sour = substr_count($page_url, '?')>0?'&':'?';
		
		$sql = "SELECT a.id,a.title,a.salary,a.date_finish,
				(SELECT GROUP_CONCAT(l.Name separator ', ') FROM locations l WHERE FIND_IN_SET(l.Id, a.place)) AS places,
				(SELECT GROUP_CONCAT(t.name separator ', ') FROM taxonomy t WHERE FIND_IN_SET(t.id, a.category)) AS category
				FROM jobposts a WHERE a.status=1";
		if($page_id!=0) $sql .= " AND a.page_id=$page_id";
		$sql .= " ORDER BY a.created DESC";
		if($limit!=null && $limit!=0) $sql .= " LIMIT $limit";
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		$result = [];
		while ($item = $stmt->fetch()) {
			$item['salary'] = $this->a_salary[$item['salary']];
			$item['url'] = $page_url.$sour."site=jobpost_detail&post_id=".$item['id']."&pn=".$this->str->str_convert($item['title']);
			$result[] = $item;
		}
		return $result;
	}
	
	
	private function set_salary(){
		$a_salary = array(
				1 => '1 đến 3 triệu',
				3 => '3 đến 5 triệu',
				5 => '5 đến 10 triệu',
				10 => '10 đến 15 triệu',
				15 => '15 đến 25 triệu',
				25 => '25 đến 50 triệu',
				50 => 'trên 50 triệu'
		);
		$this->a_salary = $a_salary;
	}
	
	private function set_position(){
		$a_position = array(
				1 => 'Cộng tác viên, thực tập',
				2 => 'Chuyên viên - nhân viên',
				3 => 'Chuyên gia',
				4 => 'Quản lý, giám sát',
				5 => 'Quản lý cấp trung',
				6 => 'Quản lý cấp cao'
		);
		$this->a_position = $a_position;
	}
	
	private function set_degree(){
		$a_degree = array(
				1 => 'Chứng chỉ nghề',
				2 => 'Trung học',
				3 => 'Trung cấp',
				4 => 'Cao đẳng',
				5 => 'Đại học',
				6 => 'Trên đại học'
		);
		$this->a_degree = $a_degree;
	}
	
	private function set_exp(){
		$a_exp = array(
				1 => 'Chưa có kinh nghiệm',
				2 => 'Dưới 1 năm kinh nghiệm',
				3 => '1 năm kinh nghiệm',
				4 => '2 năm kinh nghiệm',
				5 => '3 năm kinh nghiệm',
				6 => '4 năm kinh nghiệm',
				7 => '5 năm kinh nghiệm',
				8 => 'Trên 5 năm kinh nghiệm'
		);
		$this->a_exp = $a_exp;
	}
	
	private function set_age(){
		$a_age = array(
				1 => 'Dưới 18 tuổi',
				2 => '18 đến 25 tuổi',
				3 => '25 đến 30 tuổi',
				4 => '30 đến 40 tuổi',
				5 => '40 đến 50 tuổi',
				6 => 'Trên 50 tuổi'
		);
		$this->a_age = $a_age;
	}
	
	private function set_worktype(){
		$a_worktype = array(
				1 => 'Toàn thời gian',
				2 => 'Bán thời gian',
				3 => 'Theo hợp đồng tư vấn',
				4 => 'Thực tập',
				5 => 'Khác'
		);
		$this->a_worktype = $a_worktype;
	}
	
	private function set_timetry(){
		$a_timetry = array(
				1 => 'Dưới 7 ngày',
				2 => '1 tháng',
				3 => '2 tháng',
				4 => '3 tháng',
				5 => 'Thỏa thuận'
		);
		$this->a_timetry = $a_timetry;
	}
	
	private function set_gender(){
		$a_gender = array(1=>'Nam', 2=>'Nữ', 3=>'Khác');
		$this->a_gender = $a_gender;
	}

}