<?php

class System{
    
    function SetSessionLogin(){
    	if(isset($_POST['Action']) && $_POST['Action']=='set_session_login'){
    		$_SESSION[SESSION_LOGIN_DEFAULT] = $_POST['UserId'];
    		setcookie(COOKIE_LOGIN_ID, $_POST["UserId"], time()+(86400 * 30));
    		echo $_SESSION[SESSION_LOGIN_DEFAULT];
    		exit();
    	}
    }

    
    function ajax_setMobileConfig(){
    	setcookie("mobile_config_show_page", $_POST['value'], time()+(86400 * 30));
    }
}
