<?php

class Account extends Customerbase {
	
    private $out;
    
	function __construct() {
		parent::__construct ();
		
		$this->out = [];
	}
	
	
	function set_out_value(){
	    $this->smarty->assign('out', $this->out);
	}
	
	
	function index(){
	    global $login;
	    
	    $this->out['page_list'] = $this->pdo->fetch_all("SELECT a.id,a.name,a.page_name,a.logo,b.position
				FROM pageusers b LEFT JOIN pages a ON a.id=b.page_id
				WHERE b.user_id=$login ORDER BY a.id DESC LIMIT 3");
	    foreach ($this->out['page_list'] AS $k=>$item){
	        $this->out['page_list'][$k]['url'] = $this->page->get_pageurl($item['id'], $item['page_name']);
	        $this->out['page_list'][$k]['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
	    }
	    
	    $this->set_out_value();
	    $this->smarty->display(LAYOUT_DEFAULT);
	}
	
	
	function login() {
	    global $login;
	    
	    $out = [];
	    $token = isset($_GET['token'])?trim($_GET['token']):null;
	    $out['url'] = $token==null?URL_CUSTOMER:base64_decode($token);
	    
	    if (isset($_POST['action']) && $_POST['action']=='ajax_login') {
	        $Username = trim($_POST['Username']);
	        $Password = trim($_POST['Password']);
	        $Rt = [];
	        $Rt['Code'] = 0;
	        $Rt['Msg'] = null;
	        if (!preg_match("/^[a-zA-Z0-9_]{4,20}$/",$Username)) {
	            $Rt['Msg'] = "Tài khoản không hợp lệ, vui lòng nhập tài khoản tối thiểu 4 ký tự chữ và số.";
	        } elseif(!preg_match( "/^[a-zA-Z0-9_*#@]{6,20}$/", $Password )){
	            $Rt['Msg'] = "Mật khẩu không hợp lệ, vui lòng nhập mật khẩu tối thiểu 6 ký tự chữ và số.";
	        }else{
	            $user = $this->pdo->fetch_one("SELECT id,name,status,type FROM useradmin WHERE username='$Username' AND password='".md5($Password)."'" );
	            if (!$user)
	                $Rt['Msg'] = "Sai tên đăng nhập hoặc mật khẩu, vui lòng kiểm tra lại.";
                else if($user && $user['status'] != 1)
                    $Rt['Msg'] = "Tài khoản của bạn đang bị khóa hoặc chưa được kích hoạt, vui lòng liên hệ với quản trị để biết thêm thông tin.";
                else {
                    $Rt['Code'] = 1;
                    $Rt['Msg'] = "Đăng nhập thành công.";
                    $Rt['UserId'] = $user ['id'];
                    $_SESSION ['daisan_customer_login'] = $user['id'];
                    $_SESSION ['daisan_customer_login_role'] = $user['type']==''?'admin':$user['type'];
                }
	        }
	        echo json_encode($Rt);
	        exit();
	    }
	    if($login != 0) lib_redirect(URL_CUSTOMER);
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_ACCOUNT);
	}
	
	
	function autologin(){
	    $cookie_hodine = isset($_COOKIE['COOKIE_USER_HODINE'])?json_decode($_COOKIE['COOKIE_USER_HODINE']):[];
	    if(intval(@$cookie_hodine->remember)===1){
    	    $Username = trim(@$cookie_hodine->username);
    	    $Password = trim(@$cookie_hodine->password);
            $user = $this->pdo->fetch_one("SELECT id FROM users WHERE username='$Username' AND password='$Password'");
            if ($user){
                $_SESSION [SESSION_LOGIN_DEFAULT] = $user['id'];
                setcookie('COOKIE_USER_HODINE', json_encode($cookie_hodine), time()+(86400*3), '/');
            }
	    }
	    $_SESSION['__hodine_autologin'] = 1;
	    $urlback = isset($_GET['urlback'])?base64_decode($_GET['urlback']):DOMAIN;
        lib_redirect($urlback);
	}
	
	
	function register() {
	    if (isset($_POST['action']) && $_POST['action'] == 'ajax_register') {
	        $Name = trim($_POST['Name']);
	        $Username = trim($_POST['Username']);
	        $Password = trim($_POST['Password']);
	        $RePass = trim($_POST['RePass']);
	        $Rt = [];
	        $Rt['Code'] = 0;
	        $Rt['Msg'] = null;
	        if($Name == ''){
	            $Rt['Msg'] = "Không được bỏ trống thông tin họ tên.";
	        }elseif(! preg_match ( "/^[a-zA-Z0-9_]{6,20}$/", $Username )) {
	            $Rt['Msg'] = "Tài khoản không hợp lệ, vui lòng nhập tài khoản tối thiểu 6 ký tự chữ và số.";
	        }elseif(! preg_match ( "/^[a-zA-Z0-9_*#@]{6,20}$/", $Password )) {
	            $Rt['Msg'] = "Mật khẩu không hợp lệ, vui lòng nhập mật khẩu tối thiểu 6 ký tự chữ và số.";
	        }elseif($RePass != $Password) {
	            $Rt['Msg'] = "Mật khẩu xác nhận không chính xác, vui lòng nhập lại.";
	        }elseif($this->pdo->check_exist ( "SELECT 1 FROM users WHERE Username='$Username'" )) {
	            $Rt['Msg'] = "Tài khoản đã tồn tại trên hệ thống, vui lòng chọn tài khoản khác.";
	        }else{
	            $data = [];
	            $data['name'] = $Name;
	            $data['username'] = $Username;
	            $data['password'] = md5($Password);
	            $data['phone'] = trim($_POST['Phone']);
	            $data['email'] = trim($_POST['Email']);
	            $data['created'] = time();
	            $data['status'] = 1;
	            $UserId = $this->pdo->insert('users', $data);
	            setcookie(COOKIE_LOGIN_ID, $UserId, time() + (86400 * 30));
	            $Rt['Code'] = 1;
	            $Rt['Msg'] = "Đăng ký tài khoản thành công.";
	        }
	        echo json_encode($Rt);
	        exit();
	    }
	    $this->smarty->display(LAYOUT_CUSTOM);
	}
	
	
	function forgetpass(){
	    
	    if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='forget_password'){
	        $email = trim(@$_POST['email']);
	        $rt = [];
	        $rt['code'] = 0;
	        if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
	            $rt['msg'] = "Không đúng định dạng email.";
	        }elseif(!$this->pdo->check_exist("SELECT 1 FROM users WHERE email='$email'")){
	            $rt['msg'] = "Email không tồn tại trên hệ thống.";
	        }elseif($this->pdo->check_exist("SELECT 1 FROM users WHERE email='$email' AND status<>1")){
	            $rt['msg'] = "Tài khoản này đã bị khóa.";
	        }else{
	            $user = $this->pdo->fetch_one("SELECT id,name FROM users WHERE email='$email' AND status=1");
	            if(!$user){
	                $rt['msg'] = "Tài khoản không chính xác.";
	            }else{
	                $data = [];
	                $data['token'] = md5($email.time());
	                $data['tokentime'] = time()+2*60*60;
	                $this->pdo->update('users', $data, "id=".$user['id']);
	                
	                $url = DOMAIN."?mod=account&site=resetpass&user_id=".$user['id']."&token=".$data['token'];
	                $mail_content = null;
	                $mail_content .= "<h3>Chức năng quên mật khẩu đăng nhập</h3>";
	                $mail_content .= "<p>Vui lòng click vào đường dẫn bên dưới để thực hiện chức năng lấy lại mật khẩu.</p>";
	                $mail_content .= "<p>$url</p>";
	                $mail_content .= "<p>Thời hạn xử lý trong vòng 2 giờ, sẽ hết hạn vào ".date("H:i d-m-Y", strtotime("+2 hour")).".</p>";
	                $mail_content .= "<p>Rất hân hạnh được phục vụ.</p>";
	                $mail_content .= "<p>Trân trọng !</p>";
	                
	                $mail_to = array('TO'=>'info@daisan.vn');
	                send_mail($mail_to, 'Hodine Report', 'Hodine Forget Password', $mail_content);
	                $rt['code'] = 1;
	                $rt['msg'] = "Email đã được gửi tới hòm thư của bạn. Vui lòng kiểm tra và làm theo hướng dẫn.";
	            }
	        }
	        echo json_encode($rt);
	        exit();
	    }
	    
	    $this->smarty->display(LAYOUT_CUSTOM);
	}
	
	
	function resetpass(){
	    global $login;
	    
	    if(isset($_POST['ajax_action']) && $_POST['ajax_action']=='change_password'){
	        $newpass = trim($_POST['pass']);
	        $renewpass = trim($_POST['repass']);
	        $rt = [];
	        $rt['code'] = 0;
	        if(strlen($newpass)<6 || strlen($renewpass)<6){
	            $rt['msg'] = "Vui lòng nhập tối thiểu 6 ký tự không chứa khoảng trắng.";
	        }elseif($newpass!=$renewpass){
	            $rt['msg'] = "Mật khẩu xác nhận không chính xác.";
	        }elseif(!preg_match( "/^[a-zA-Z0-9_*#@]{6,20}$/", $newpass )){
	            $rt['msg'] = "Mật khẩu chứa các ký tự không phù hợp.";
	        }else{
	            $data = [];
	            $data['password'] = md5($newpass);
	            $this->pdo->update('users', $data, "id=$login");
	            $rt['code'] = 1;
	            $rt['msg'] = "Thay đổi mật khẩu thành công.";
	        }
	        echo json_encode($rt);
	        exit();
	    }
	    
	    $token = @$_GET['token'];
	    $user_id = @$_GET['user_id'];
	    $user = $this->pdo->fetch_one("SELECT tokentime FROM users WHERE id=$user_id AND token='$token'");
	    $status = 1;
	    $message = null;
	    if(!$user){
	        $status = 0;
	        $message = "Token không có hiệu lực, vui lòng thực hiện lại chức năng quên mật khẩu.";
	    }elseif ($user['tokentime']<time()){
	        $status = 2;
	        $message = "Thời gian hiệu lực cho token này đã hết, vui lòng thực hiện lại chức năng để tạo token mới.";
	    }
	    
	    $out = [];
	    $out['status'] = $status;
	    $out['message'] = $message;
	    
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_CUSTOM);
	}
	
	
	function logout() {
	    unset($_SESSION['daisan_customer_login']);
	    lib_redirect(URL_CUSTOMER);
	}
	
}
