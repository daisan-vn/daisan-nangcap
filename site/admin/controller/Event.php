<?php

class Event extends Admin {
    
    private $folder;
    
    function __construct() {
        parent::__construct();
        
        $this->folder = 'images/events/';
    }
    
    function index(){
        global $login;
        $status = isset($_GET['status']) ? $_GET['status'] : -1;
        $event_id = isset($_GET['event_id'])?intval($_GET['event_id']):-1;
        $out['filter_status']= $this->help->get_select_from_array($this->help->a_status, $status, 'Trạng thái');
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";
        $out['filter_category'] = $this->taxonomy->get_select_taxonomy_tree('event', $event_id, 0, null, 'Không có danh mục');
        if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_event'){
            $id = intval(@$_POST['id']);
            $result = $this->pdo->fetch_one("SELECT * FROM events WHERE id=$id");
            $result['date_start'] = (!isset($result['date_start'])||$result['date_start']=='0000-00-00')?date('Y-m-d'):date('Y-m-d', strtotime($result['date_start']));
            $result['date_finish'] = (!isset($result['date_finish'])||$result['date_finish']=='0000-00-00')?date('Y-m-d', strtotime('+10 day')):date('Y-m-d', strtotime($result['date_finish']));
            $result['avatar'] = $this->img->get_image($this->folder, @$result['image']);
            $result['banner'] = $this->img->get_image($this->folder, @$result['banner']);
            echo json_encode($result);
            exit();
        }if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_event'){
            $id = intval(@$_POST['id']);
            $data = [];
            $data['name'] = trim(@$_POST['name']);
            $data['description'] = trim(@$_POST['description']);
            $data['date_start'] = date('Y-m-d', strtotime(trim(@$_POST['date_start'])));
            $data['date_finish'] = date('Y-m-d', strtotime(trim(@$_POST['date_finish'])));
            $data['admin_id'] = $login;
            $data['url'] = $_POST['url'];
            if($id==0){
                $data['created'] = time();
                $data['status'] = 1;
                $this->pdo->insert('events', $data);
            }else $this->pdo->update('events', $data, "id=$id");
            
            if(isset($_POST['image']) && $_POST['image']!=''){
                $imgname = $this->img->upload_image_base64($this->folder, $_POST['image']);
                $data = [];
                $data['image'] = $imgname;
                $this->pdo->update('events', $data, 'id='.$id);
            }
            if(isset($_POST['banner']) && $_POST['banner']!=''){
                $imgname = $this->img->upload_image_base64($this->folder, $_POST['banner']);
                $data = [];
                $data['banner'] = $imgname;
                $this->pdo->update('events', $data, 'id='.$id);
            }
            echo 1; exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='load_category'){
            $event = $this->pdo->fetch_one('SELECT taxonomy_id FROM events WHERE id='.intval($_POST['event_id']));
            echo $this->taxonomy->get_select_taxonomy_tree('event', @$event['taxonomy_id'], 0, 'a.level<2', 'Chọn danh mục');
            exit();
        }elseif(isset($_POST['ajax_action']) && $_POST['ajax_action']=='save_category'){
            $data = [];
            $data['taxonomy_id'] = intval($_POST['taxonomy_id']);
            $data['created'] = time();
            $data['admin_id'] = $login;
            $this->pdo->update('events', $data, 'id='.intval($_POST['event_id']));
            exit();
        }
        $where = "1=1";
        if($status!=-1) $where.=" AND a.status = $status";
        if(isset($_GET['key']) && $_GET['key'] != "") $where .= " AND (a.name LIKE '%".$_GET['key']."%' OR a.code LIKE '%".$_GET['key']."%')";
        if(isset($_GET['event_id']) && intval($_GET['event_id']) != 0) $where .= " AND a.taxonomy_id=".intval($_GET['event_id']);
        $result = $this->pdo->fetch_all("SELECT a.*,t.name AS category FROM events a LEFT JOIN taxonomy t ON t.id=a.taxonomy_id  WHERE $where");
        foreach ($result AS $k=>$item){
            $result[$k]['status'] = $this->help_get_status($item['status'], 'events', $item['id']);
            $result[$k]['avatar'] = $this->img->get_image($this->folder, @$item['image']);
        }
        
        $this->smarty->assign("result", $result);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }
    
    /** =========================================================================== */
    
    function ajax_delete() {
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        $rt = [];
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if($this->pdo->check_exist("SELECT 1 FROM pages WHERE id=$id")){
            $this->page->remove_folder($id);
            
            $this->pdo->query("DELETE FROM pageaddress WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagemessages WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagepartners WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageprofiles WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagesupporters WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pagethemes WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageusers WHERE page_id=$id");
            
            $this->pdo->query("DELETE FROM pageservices WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageservicemetas WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageserviceorders WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageserviceprices WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageservicepromos WHERE page_id=$id");
            $this->pdo->query("DELETE FROM pageservicesteps WHERE page_id=$id");
            
            $this->pdo->query("DELETE FROM pages WHERE id=$id");
            $rt['code'] = 1;
            $rt['msg'] = "Xóa page thành công.";
        }
        
        echo json_encode($rt);
    }
    
    
    function ajax_delete_package() {
        $id = isset($_POST ['Id']) ? intval($_POST ['Id']) : 0;
        $rt = [];
        $rt['code'] = 0;
        $rt['msg'] = "Không xóa được nội dung";
        if($this->pdo->check_exist("SELECT 1 FROM packages WHERE id=$id")){
            $this->pdo->query("DELETE FROM packages WHERE id=$id");
            $rt['code'] = 1;
            $rt['msg'] = "Xóa thông tin thành công.";
        }
        echo json_encode($rt);
    }
    
    
    function ajax_add_admin(){
        $page_id = intval($_POST['page_id']);
        $user_id = intval($_POST['user_id']);
        
        $rt = [];
        $rt['code'] = 0;
        if(!$this->pdo->check_exist("SELECT 1 FROM users WHERE id=$user_id")) $rt['msg'] = "Tài khoản không tồn tại";
        else if($this->pdo->check_exist("SELECT 1 FROM pageusers WHERE page_id=$page_id AND user_id=$user_id"))
            $rt['msg'] = "Tài khoản đã được set quản trị cho gian hàng này.";
            else{
                $data = [];
                $data['user_id'] = $user_id;
                $data['page_id'] = intval($_POST['page_id']);
                $data['created'] = time();
                $data['status'] = 1;
                $this->pdo->insert('pageusers', $data);
                $rt['code'] = 1;
                $rt['msg'] = "Tạo quản trị cho gian hàng thành công";
            }
            
            echo json_encode($rt); exit();
    }
    function ajax_sort() {
        if (isset($_POST['id'])) {
            $sql = "SHOW COLUMNS FROM ".$_POST['table'];
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            $data['sort'] = intval($_POST['sort']);
            $this->pdo->update($_POST['table'], $data,"id=".$_POST['id']);
            echo 1;
            exit();
        }
        echo 0;
        exit();
    }
    
}
?>