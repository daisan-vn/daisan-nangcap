<?php

class Jobpost extends Pageadmin{
	
	private $taxonomy, $job;
	
	function __construct() {
		parent::__construct ();
		$this->taxonomy = \Lib\Dbo\Taxonomy::instance();
		$this->job = \Lib\Dbo\Job::instance();
		
		$a_menu = array(
				'index' => "Tất cả tin tuyển dụng",
				'create' => "Đăng tin tuyển dụng",
		);
		$this->get_pagemenu($a_menu);
	}
	
	
	function index(){
		global $login, $lang;
		$out = array ();
		
		$sql = "SELECT a.id,a.title,a.salary,a.date_finish,
				(SELECT GROUP_CONCAT(l.Name separator ', ') FROM locations l WHERE FIND_IN_SET(l.Id, a.place)) AS places,
				(SELECT GROUP_CONCAT(t.name separator ', ') FROM taxonomy t WHERE FIND_IN_SET(t.id, a.category)) AS category
				FROM jobposts a
				WHERE a.page_id=".$this->page_id;
		$paging = new \Lib\Core\Pagination($this->pdo->count_item('jobposts', "page_id=".$this->page_id), 20);
		$sql = $paging->get_sql_limit($sql);
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();
		$result = [];
		while ($item = $stmt->fetch()) {
			$item['salary'] = $this->job->a_salary[$item['salary']];
			$item['url_edit'] = "?mod=jobpost&site=create&id=".$item['id'];
			$result[] = $item;
		}
		$this->smarty->assign("result", $result);
		
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function create(){
		global $login, $lang;
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='create_jobpost'){
			
			$data['title'] = trim($_POST['title']);
			$data['position'] = intval($_POST['position']);
			$data['category'] = implode(",", is_array($_POST['category'])?$_POST['category']:[]);
			$data['place'] = implode(",", is_array($_POST['place'])?$_POST['place']:[]);
			$data['worktype'] = intval($_POST['worktype']);
			$data['salary'] = intval($_POST['salary']);
			$data['timetry'] = intval($_POST['timetry']);
			$data['number'] = intval($_POST['number']);
			
			$data['exp'] = intval($_POST['exp']);
			$data['degree'] = intval($_POST['degree']);
			$data['gender'] = intval($_POST['gender']);
			$data['age'] = intval($_POST['age']);
			
			$data['description'] = trim($_POST['description']);
			$data['content'] = trim($_POST['content']);
			$data['requirement'] = trim($_POST['requirement']);
			$data['date_finish'] = date("Y-m-d", strtotime($_POST['date_finish']));
			
			$jobpost_id = isset($_POST['id']) ? intval($_POST['id']) : 0;
			if($jobpost_id==0){
				$data['user_id'] = $login;
				$data['created'] = time();
				$data['page_id'] = $this->page_id;
				$data['status'] = 1;
				$jobpost_id = $this->pdo->insert('jobposts', $data);
			}else{
				$this->pdo->update('jobposts', $data, "id=$jobpost_id");
			}
			
			echo $jobpost_id;
			exit();
		}
		
		$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
		$post = $this->pdo->fetch_one("SELECT * FROM jobposts WHERE id=$id AND page_id=".$this->page_id);
		
		$out['select_category'] = $this->taxonomy->get_select_taxonomy('jobpost', @$post['category'], 0, null, 0);
		$out['select_salary'] = $this->help->get_select_from_array($this->job->a_salary, @$post['salary'], 'Thỏa thuận');
		$out['select_position'] = $this->help->get_select_from_array($this->job->a_position, @$post['position'], 'Chọn cấp bậc');
		$out['select_worktype'] = $this->help->get_select_from_array($this->job->a_worktype, @$post['worktype'], 0);
		$out['select_timetry'] = $this->help->get_select_from_array($this->job->a_timetry, @$post['timetry'], 'Không thử việc');
		$out['select_exp'] = $this->help->get_select_from_array($this->job->a_exp, @$post['exp'], 'Không yêu cầu');
		$out['select_degree'] = $this->help->get_select_from_array($this->job->a_degree, @$post['degree'], 'Không yêu cầu');
		$out['select_age'] = $this->help->get_select_from_array($this->job->a_age, @$post['age'], 'Không yêu cầu');
		$out['select_gender'] = $this->help->get_select_from_array($this->job->a_gender, @$post['gender'], 'Không yêu cầu');
		$out['select_place'] = $this->help->get_select_location_multi(@$post['place'], 0, 0);
		
		$this->smarty->assign('out', $out);
		$this->smarty->assign('post', $post);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	
	function ajax_handle(){
		
		
	}
	
	
	function ajax_delete(){
		if(isset($_POST['action']) && $_POST['action']=='delete_item'){
			$id = intval(@$_POST['id']);
			$check_order = $this->pdo->check_exist("SELECT 1 FROM pageserviceorders WHERE service_id=$id AND page_id=".$this->page_id);
			if(!$this->pdo->check_exist("SELECT 1 FROM pageservices WHERE service_id=$id AND page_id=".$this->page_id)){
				$rt['code'] = 0;
				$rt['msg'] = 'Dịch vụ không đúng';
			}
			if(!$this->pdo->check_exist("SELECT 1 FROM pageservices WHERE service_id=$id AND page_id=".$this->page_id)){
				$rt['code'] = 0;
				$rt['msg'] = "Không xóa được dịch vụ vì đang tồn tại đơn hàng cho dịch vụ này.";
			}else{
				$rt['code'] = 1;
				$this->pdo->query("DELETE FROM pageservices WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageservicemetas WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageserviceprices WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageservicepromos WHERE service_id=$id AND page_id=".$this->page_id);
				$this->pdo->query("DELETE FROM pageservicesteps WHERE service_id=$id AND page_id=".$this->page_id);
			}
			echo json_encode($rt);
			exit();
		}
	}
	
}
