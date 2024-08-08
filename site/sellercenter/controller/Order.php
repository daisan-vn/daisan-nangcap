<?php

class Order extends Pageadmin{
    
    private $status;
    
	function __construct() {
		parent::__construct ();
		
	}
	
	
	function index(){
		global $login;
		$out = [];
		
		if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_status'){
		    $id = intval(@$_POST['id']);
		    $order = $this->pdo->fetch_one("SELECT status FROM productorders WHERE id=$id AND page_id=".$this->page_id);
		    $rt['code'] = 0;
		    if(!$order){
		        $rt['msg'] = 'Xảy ra lỗi, vui lòng thử lại';
		    }elseif($order['status']==4){
		        $rt['msg'] = 'Đơn hàng đã được xử lý từ phía người dùng';
		    }else{
		        $data['status'] = $_POST['status'];
		        $data['updated'] = time();
		        $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
		        $rt['msg'] = 'Cập nhật đơn hàng thành công';
		    }
		    echo json_encode($rt);
		    exit();
		    
		    $id = intval(@$_POST['id']);
		    $data['status'] = $_POST['status'];
		    $data['updated'] = time();
		    $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
		    exit();
		}elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_content'){
		    $id = intval(@$_POST['id']);
		    $order = $this->pdo->fetch_one("SELECT * FROM productorders WHERE id=$id");
		    echo json_encode($order);
		    exit();
		}elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_content'){
		    $id = intval(@$_POST['id']);
		    $data['customer'] = trim($_POST['customer']);
		    $data['phone'] = trim($_POST['phone']);
		    $data['email'] = trim($_POST['email']);
		    $data['address'] = trim($_POST['address']);
		    $data['description'] = trim($_POST['description']);
		    $this->pdo->update('productorders', $data, "id=$id AND page_id=".$this->page_id);
		    exit();
		}
		
		$key = isset($_GET['key'])?$_GET['key']:null;
		$status = isset($_GET['status'])?$_GET['status']:-1;
		
		$where = "a.page_id=".$this->page_id;
		if($key!=null) $where .= " AND a.customer LIKE '%$key%'";
		if($status!=-1) $where .= " AND a.status=$status";
		
		$sql = "SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a WHERE $where ORDER BY a.id DESC";
		$paging = new \Lib\Core\Pagination($this->pdo->count_item('productorders', $where), 20);
		$sql = $paging->get_sql_limit($sql);
		
		$result = $this->pdo->fetch_all($sql);
		foreach ($result AS $k=>$item){
		    $result[$k]['code'] = "#OID".$item['page_id'].$item['id'];
		    $result[$k]['status_btn'] = $this->get_status_btn($item['id'], $item['status']);
		}
		$this->smarty->assign('result', $result);
		
		$out['select_status'] = $this->help->get_select_from_array($this->product->order_status, $status, "Chọn trạng thái");
		$out['key'] = $key;
		$this->smarty->assign('out', $out);
		$this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function detail(){
	    $id = isset($_REQUEST['id']) ? intval($_REQUEST['id']) : 0;
	    
	    $order = $this->pdo->fetch_one("SELECT a.id,a.created,a.updated,a.customer,a.phone,a.email,a.address,a.description,a.status,a.page_id,
                (SELECT SUM(b.price*b.number) FROM productorderitems b WHERE a.id=b.order_id) AS totalmoney
                FROM productorders a WHERE a.id=$id AND a.page_id=".$this->page_id);
	    $this->smarty->assign('order', $order);
	    
	    $detail = $this->pdo->fetch_all("SELECT a.price,a.number,b.name AS productname
                FROM productorderitems a LEFT JOIN products b ON b.id=a.product_id
                WHERE a.order_id=$id AND a.page_id=".$this->page_id);
	    $this->smarty->assign('detail', $detail);
	    $this->smarty->display(LAYOUT_NONE);
	}
	
	
	function get_status_btn($id, $status){
	    $status_name = $this->product->order_status[$status];
	    $status_class = "btn-outline-primary dropdown-toggle";
	    if($status==1||$status==2) $status_class = "btn-outline-warning dropdown-toggle";
	    elseif($status==3) $status_class = "btn-outline-success";
	    elseif($status==4||$status==5) $status_class = "btn-outline-danger";
	    
	    $str = "<div class=\"btn-group\">";
	    $str .= "<button type=\"button\" class=\"btn btn-sm $status_class\" ";
	    if($status!=3&&$status!=4&&$status!=5)
	       $str .= "data-toggle=\"dropdown\"";
	    $str .= ">";
	    $str .= $this->product->order_status[$status];
	    if($status!=3&&$status!=4&&$status!=5){
	        $str .= "<div class=\"dropdown-menu\">";
	        if($status==0)
	           $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 1);\">Đang xử lý</a>";
	        if($status==0||$status==1)
	           $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 2);\">Giao hàng</a>";
	        if($status==2){
	            $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 3);\">Thành công</a>";
	            $str .= "<a class=\"dropdown-item\" href=\"#\" onclick=\"ChangeStatus($id, 5);\">Trả lại</a>";
	        }
	        $str .= "</div>";
	    }
	    $str .= "</button>";
	    $str .= "</div>";
	    return $str;
	}
}
