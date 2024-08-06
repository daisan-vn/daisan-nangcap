<?php

/* * ********    **************************** */

/* Help for load ajax and something */
/* 18/05/2016 - LucTV */

/* * ********    **************************** */

class Help extends Admin {

    function __construct() {
        parent::__construct();
    }

    function ajax_sort() {
        if (isset($_POST['id'])) {
            $sql = "SHOW COLUMNS FROM ".$_POST['table'];
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            $table_info = $stmt->fetch(PDO::FETCH_COLUMN);
            // $table_prefix = substr($table_info, 0, strpos($table_info, '_'));
            $data['sort'] = intval($_POST['sort']);
            $this->pdo->update($_POST['table'], $data, "id=".$_POST['id']);
            echo 1;
            exit();
        }
        echo 0;
        exit();
    }

    function ajax_active_item() {
        // kiếm tra nếu là bảng product thì cần xử lý thêm nghiệp vụ
        // cái này áp dùng mô hình bắn event mới đúng

        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $table = isset($_POST['table']) ? trim($_POST['table']) : '';
        
        if ($id && $table) {
            $value = $this->pdo->fetch_one("SELECT status FROM ".$table." WHERE Id=".$id.' LIMIT 1');

            if ($value) {
                if ($value['status'] == 0 || $value['status'] == 2) {
                    $status = 1;
                }
                elseif($value['status'] == 1) {
                    $status = 2;
                }
            }
            else {
                $status = 0;
            }

            $this->pdo->query("UPDATE ".$table." SET status=$status WHERE Id=".$id);
            echo $this->help_get_status($status, $table, $id);
            exit();
        }
        echo 0;
    }

    function __ajax_active_item() {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $table = isset($_POST['table']) ? trim($_POST['table']) : '';
        
        if ($id && $table) {
            $value = $this->pdo->fetch_one("SELECT status FROM ".$table." WHERE Id=".$id.' LIMIT 1');
            $curl_get_product = $this->curl_search_get_product($id);
            if (@$value['status'] == 0 || @$value['status'] == 2) {
                $status = 1;
                // add index api
                $curl_get_product = $this->curl_search_get_product($id);
                $data = $this->pdo->fetch_one("SELECT * FROM ".$table." WHERE Id=".$id.' LIMIT 1');

                $taxonomy_id = isset($data['taxonomy_id']) ? $data['taxonomy_id'] : 0;
                $e_category = $this->pdo->fetch_one("SELECT name FROM taxonomy WHERE id=$taxonomy_id");

                $page_id = isset($data['page_id']) ? $data['page_id'] : 0;
                $e_package = $this->pdo->fetch_one("SELECT package_id, endtime FROM pagepackage WHERE page_id=$page_id LIMIT 1");
                $e_package['endtime'] = gmdate("Y-m-d", strtotime(@$e_package['endtime'])+7*3600);

                $e_date = new DateTime();
                $e_date->setTimestamp($data['created']);
                $fields = $curl_get_product['fields'];
//
//                $e_unit_name = trim(@$_POST['unit_name']);
                $fields['attribute_contents']   = $data['attribute_contents'];
                $fields['category']   = $e_category['name'];
                $fields['date_start']   = $e_date->format('Y-m-d\TH:i:s\Z');
                $fields['groupattributes_id']   = $data['groupattributes_id'];
                $fields['images']               = $data['images'];
                $fields['keyword']              = $data['keyword'];
                $fields['location']             = '123';
                $fields['max_price']            = '216000';
                $fields['min_price']            = '216000';
                $fields['minorder']             = !empty($data['minorder']) ? $data['minorder'] : '';
                $fields['name']                 = !empty($data['name']) ? $data['name'] : '';
                $fields['ordertime']            = !empty($data['ordertime']) ? $data['ordertime'] : '';
                $fields['package_end']          = !empty($e_package['endtime']) ? $e_package['endtime'] : '';
                $fields['package_id']           = !empty($e_package['package_id']) ? $e_package['package_id'] : 0;
                $fields['page_id']              = !empty($data['page_id']) ? $data['page_id'] : 0;
                $fields['page_name']            = '123';
                $fields['pageaddress']          = 'Hà nội';
                $fields['pagename']             = 'Công ty TNHH Vật liệu xây dựng Phật Sơn Ousheng';
                $fields['phone']                = 'Foshan Ousheng Building Materi';
                $fields['status']               = $status = 1;
                $fields['taxonomy_id']          = $data['taxonomy_id'];
                $fields['unit']                 = 'm2';

                $dataCURL_str = json_encode($fields);
                $this->curl_search_update_index($id, $dataCURL_str);
            }

            elseif(@$value['status'] == 1) {
                $status = 2;
                //remove index api
                $this->curl_search_delete_product($id);
            }

            $this->pdo->query("UPDATE ".$table." SET status=$status WHERE Id=".$id);

            echo $this->help_get_status($status, $table, $id);
            exit();
        }
        echo 0;
    }

    function ajax_active_multi() {
        $type = isset($_POST['type']) ? intval($_POST['type']) : 0;
        $table = isset($_POST['table']) ? trim($_POST['table']) : '';
        
        $ids = isset($_POST['id']) ? trim($_POST['id']) : '';
        if (is_string($ids)) {
            $ids = explode(',', $ids);
        }
        $ids = array_filter(array_map('intval', $ids));
        $ids = implode(',', $ids);

        if (in_array($type, [0, 1, 2]) && $table) {
            $sql = "SHOW COLUMNS FROM ".$table;
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            $table_id = $stmt->fetch(PDO::FETCH_COLUMN);

            $this->pdo->query("UPDATE ".$table." SET status=".$type." WHERE $table_id IN ($ids)");
            echo 1;
            exit();
        }
        echo 0;
    }

    function ajax_set_featured_item() {
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $table = isset($_POST['table']) ? trim($_POST['table']) : '';
        if ($id && $table) {
            $value = $this->pdo->fetch_one("SELECT featured FROM ".$table." WHERE id=".$id. ' LIMIT 1');
            $featured = 0;
            if ($value['featured'] == 0) $featured = 1;

            $this->pdo->query("UPDATE ".$table." SET featured=$featured WHERE id=".$id);
            echo $this->help_get_featured($featured, $table, $id);
            exit();
        }
        echo 0;
    }

    function ajax_delete(){
        $id = isset($_POST['id']) ? intval($_POST['id']) : 0;
        $table = isset($_POST['table']) ? trim($_POST['table']) : '';
        if($table && $id) {
            if ($this->pdo->query("DELETE FROM $table WHERE id=$id")) {
                echo "Xóa thông tin thành công.";
                exit();
            }    
        }
        echo "Xóa thông tin thất bại, vui lòng kiểm tra lại hệ thống.";
    }


    function ajax_delete_multi() {
        $id = isset($_POST ['id']) ? $_POST ['id'] : 0;
        if ($id == 0) {
            lib_redirect_back();
            exit();
        }

        $input_arr = explode(',', $id);
        $deleted_arr = [];
        $notdeleted_arr = [];
        $deleted_id = [];

        foreach ($input_arr as $k => $item) {
            $value = $this->pdo->fetch_one("SELECT Id,Title FROM posts WHERE Id=$item");
            if ($value) {
                array_push($deleted_arr, $value['Title']);
                array_push($deleted_id, $value['Id']);
                $this->pdo->query("DELETE FROM posts WHERE Id=$item");
                $this->pdo->query("DELETE FROM keywordrls WHERE PostId=$item");
            }else {
                array_push($notdeleted_arr, $value['Title']);
            }
        }

        $data['deleted'] = implode('<br>', $deleted_arr);
        $data['notdeleted'] = implode('<br>', $notdeleted_arr);
        $data['deleted_id'] = implode('-', $deleted_id);

        echo json_encode($data);
    }

    function ajax_load_location(){
        $Type = isset($_POST['Type']) ? trim($_POST['Type']) : null;
        $Value = isset($_POST['Value']) ? intval($_POST['Value']) : 0;
        $prefix = "Chọn quận huyện";
        if($Type=='wards') $prefix = "Chọn phường xã";
        $str = $this->help->get_select_location(0, $Value, $prefix);
        echo $str; exit();
    }

}
