<?php

class Home extends Admin {

    function index() {

        global $smarty, $location;
        $out = ['money'=>0];
        $today = date("Y-m-d");

        $type = 'info';

        $values = $this->get_conf_values($type);

        $this->smarty->assign('values', @$values);

        $this->pdo->query("DELETE FROM accesslogs WHERE date_log<'".date('Y-m-d', strtotime('-15 day'))."'");

        $chart = $this->pdo->fetch_all("SELECT date_log, COUNT(1) AS number FROM accesslogs
        		GROUP BY date_log ORDER BY date_log DESC LIMIT 15");

        krsort($chart);

        $smarty->assign('chart', $chart);


        $count_page = $this->pdo->fetch_all("SELECT package_id,COUNT(1) AS number FROM pages WHERE package_end >='$today' GROUP BY package_id");
        $a_page = [];
	    foreach ($count_page AS $item){
	        $a_page[$item['package_id']] = $item['number'];
	    }

        $sql="SELECT id,name,price FROM packages WHERE status=1";
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();

        $package = [];

	    while ($item = $stmt->fetch()){
            $item['number'] = intval(@$a_page[$item['id']]);
            $item['money'] = $item['number']*$item['price'];
            $package[] = $item;
            
            $out['money'] += $item['money'];
        }
        $this->smarty->assign('package',$package);


        $count_product = $this->pdo->count_rows("SELECT 1 FROM adsproducts ap LEFT JOIN adscampaign ac ON ap.campaign_id=ac.id WHERE ap.status=1 AND ac.status=1 AND ac.date_start<='$today' AND ac.date_finish >='$today'");
        $this->smarty->assign('count_product',$count_product);
        
        // $sql="SELECT *,COUNT(b.page_id) AS number FROM pages a
        // LEFT JOIN useronlines b ON a.id=b.page_id
        // WHERE DATE_FORMAT(b.date_log, '%Y')='".date("Y")."' 
        // AND DATE_FORMAT(b.date_log,'%m')='".date("m")."' GROUP BY a.id ORDER BY number DESC LIMIT 10";

        // kien mod

        $this_month = date('Y-m').'-01';
        $next_month = date('Y-m', strtotime('+1 month')).'-01';

        $sql = "SELECT a.*, b.number FROM pages a
            INNER JOIN (SELECT page_id, count(page_id) as number FROM useronlines
            WHERE date_log>='".$this_month."' 
            AND date_log < '".$next_month."'
            GROUP BY page_id
            ) b ON b.page_id = a.id
            ORDER BY b.number DESC
            LIMIT 10;
        ";

        // end kien mod

        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();

        $pages=[];

        while ($item = $stmt->fetch()){
            $item['url_page'] = $this->page->get_pageurl($item['id'], $item['page_name']);
            //$item['access_month'] = intval(@$a_page[$item['id']]);
            $pages[]=$item;

        }

        $this->smarty->assign('pages',$pages);

        
        $products = $this->pdo->fetch_all("SELECT id,name,views FROM products WHERE status=1 ORDER BY views DESC LIMIT 10");

        foreach ($products as $k => $item) {
            $products[$k]['url']=DOMAIN."?mod=product&site=detail&pid=".$item['id'];
        }

        $this->smarty->assign('products',$products);

        $out['location']=$location;

        $this->smarty->assign('out', $out);
        $smarty->display(LAYOUT_DEFAULT);
    }

    function accesslogusers_phone(){

        $out = [];

        $out['from'] = isset($_GET['from'])?$_GET['from']:'';
        $out['to'] = isset($_GET['to'])?$_GET['to']:'';

        

        $where = "user_ip<>'' AND url<>''";

        if($out['from']!=='') $where .= ' AND updated>='.strtotime($out['from']);
        if($out['to']!=='') $where .= ' AND updated<='.strtotime('23:23:59 '.$out['to']);


        $sql = "SELECT phone,COUNT(1) AS number FROM accesslogusers WHERE $where GROUP BY phone ORDER BY number DESC";

        $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);

        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        $this->smarty->assign("result", $result);


        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);

    }

    function accesslogusers(){
        $out = [];

        $out['phone']=isset($_GET['phone'])?$_GET['phone']:'';
        $out['from'] = isset($_GET['from'])?$_GET['from']:'';
        $out['to'] = isset($_GET['to'])?$_GET['to']:'';


        $where = "user_ip<>'' AND url<>''";

        if($out['from']!=='') $where .= ' AND updated>='.strtotime($out['from']);
        if($out['to']!=='') $where .= ' AND updated<='.strtotime('23:23:59 '.$out['to']);
        if($out['phone']!=='') $where .= " AND phone='".$out['phone']."'";

        

        $sql = "SELECT user_ip,email,phone,url,ismobile,updated,location FROM accesslogusers WHERE $where ORDER BY id DESC";

        $paging = new \Lib\Core\Pagination($this->pdo->count_item('accesslogusers', $where), 50);

        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        foreach ($result AS $k=>$item){
            $result[$k]['ismobile'] = $item['ismobile']==1?'mobile':'desktop';
        }

        $this->smarty->assign("result", $result);


        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }


    function accesslog_ip(){
        $out = [];

        $out['ip'] = isset($_GET['ip'])?$_GET['ip']:'';
        $out['from'] = isset($_GET['from'])?$_GET['from']:'';
        $out['to'] = isset($_GET['to'])?$_GET['to']:'';

        $where = "WHERE user_ip<>'' AND url<>''";

        if($out['ip']!=='') $where .= " AND user_ip LIKE '%".$out['ip']."%'";
        if($out['from']!=='') $where .= ' AND updated>='.strtotime($out['from']);
        if($out['to']!=='') $where .= ' AND updated<='.strtotime('23:23:59 '.$out['to']);


        $sql = "SELECT user_ip,location,COUNT(1) AS number FROM accesslogs $where GROUP BY user_ip ORDER BY number DESC";

        $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);

        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        $this->smarty->assign("result", $result);
        

        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function accesslog_location(){

        $out = [];

        $out['from'] = isset($_GET['from'])?$_GET['from']:'';
        $out['to'] = isset($_GET['to'])?$_GET['to']:'';

        $where = "WHERE user_ip<>'' AND url<>''";

        if($out['from']!=='') $where .= ' AND updated>='.strtotime($out['from']);
        if($out['to']!=='') $where .= ' AND updated<='.strtotime('23:23:59 '.$out['to']);

        $sql = "SELECT location,COUNT(1) AS number FROM accesslogs $where GROUP BY location ORDER BY number DESC";

        $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);

        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        $this->smarty->assign("result", $result);


        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function accesslogs(){

        $out = [];

        $out['from'] = isset($_GET['from'])?$_GET['from']:'';
        $out['to'] = isset($_GET['to'])?$_GET['to']:'';

        $where = "user_ip<>'' AND url<>''";

        if($out['from']!=='') $where .= ' AND updated>='.strtotime($out['from']);
        if($out['to']!=='') $where .= ' AND updated<='.strtotime('23:23:59 '.$out['to']);

        $sql = "SELECT user_ip,url,ismobile,updated FROM accesslogs WHERE $where ORDER BY id DESC";

        $paging = new \Lib\Core\Pagination($this->pdo->count_item('accesslogs', $where), 50);

        $sql = $paging->get_sql_limit($sql);
        $result = $this->pdo->fetch_all($sql);

        foreach ($result AS $k=>$item){
            $result[$k]['ismobile'] = $item['ismobile']==1?'mobile':'desktop';
        }

        $this->smarty->assign("result", $result);

        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);
    }

    function content(){

    	$users = $this->pdo->fetch_all("SELECT a.user_id,a.name,a.user_login,
    			(SELECT COUNT(post_id) FROM vsc_posts WHERE a.user_id=user_id) AS number_post
    			FROM vsc_users a WHERE a.type='admin'");

    	$this->smarty->assign('users', $users);
    	$this->smarty->display(LAYOUT_DEFAULT);

    }


    function rfq(){

        $out = [];
        $out['filter_keyword'] = isset($_GET['key']) ? $_GET['key'] : "";

        $where ="1=1";

        if(isset($_GET['key']) && $_GET['key'] != "") $where = "a.title LIKE '%".$_GET['key']."%'";

        $sql = "SELECT a.id,a.title,a.image,a.price,a.number,a.created,a.status,t.name AS unit,
                (SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS taxonomy,
                (SELECT t.name FROM locations t WHERE t.id=a.location_id) AS location,
                (SELECT u.name FROM users u WHERE u.id=a.user_id) AS user_name,
                (SELECT COUNT(1) FROM rfqquotations q WHERE a.id=q.rfq_id) AS number_quotation
                FROM rfq a LEFT JOIN taxonomy t ON a.unit_id=t.id WHERE $where ORDER BY a.id DESC";

        $out['number'] = $this->pdo->count_item('rfq', $where);

        $paging = new \Lib\Core\Pagination($out['number'], 20, 0);

        $sql = $paging->get_sql_limit($sql);
        $rfq = $this->pdo->fetch_all($sql);

        foreach ($rfq AS $k=>$item){
            $rfq[$k]['url'] = URL_SOURCING."?site=rfq_detail&id=".$item['id'];
            $rfq[$k]['url_edit'] = URL_SOURCING."?site=createRfq&id=".$item['id'];
            $rfq[$k]['url_quote'] = "?mod=account&site=rfq_quote&id=".$item['id'];
            $rfq[$k]['avatar'] = $this->img->get_image("rfq/", $item['image']);
            $rfq[$k]['status'] = $this->help_get_status($item['status'], 'rfq', $item['id']);
        }

        $this->smarty->assign('result', $rfq);
        $this->smarty->assign('out', $out);
        $this->smarty->display(LAYOUT_DEFAULT);

    }

	function contact() {
		global $smarty;

		$contact = [];
		$sql = "SELECT id,name,phone,email,created,description FROM vsc_contact ORDER BY id DESC";
		$paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
		$sql = $paging->get_sql_limit($sql);
		$stmt = $this->pdo->getPDO()->prepare($sql);
		$stmt->execute();

		while ($item = $stmt->fetch()){
			$item['created'] = gmdate("d/m/Y H:i", $item['created']+7*3600);
			$contact[] = $item;
		}

		$smarty->assign("result", $contact);
		$smarty->display(LAYOUT_DEFAULT);
	}

	function tablechangelogs(){

	    $out = [];
	    $out['from'] = isset($_GET['from'])?$_GET['from']:'';
	    $out['to'] = isset($_GET['to'])?$_GET['to']:'';

	    $where = "WHERE a.obj<>''";
	    if($out['from']!=='') $where .= ' AND a.created>='.strtotime($out['from']);
	    if($out['to']!=='') $where .= ' AND a.created<='.strtotime('23:23:59 '.$out['to']);

	    $sql = "SELECT a.id,a.obj,a.type,a.content,a.created,u.username 
                FROM tablechangelogs a LEFT JOIN useradmin u ON u.id=a.user_id $where ORDER BY a.id DESC";

	    $paging = new \Lib\Core\Pagination($this->pdo->count_rows($sql), 20);
	    $sql = $paging->get_sql_limit($sql);
	    $result = $this->pdo->fetch_all($sql);

	    foreach ($result AS $k=>$item){
	        $result[$k]['content'] = json_decode($item['content'], true);
	    }

	    $this->smarty->assign("result", $result);
	    $this->smarty->assign('out', $out);
	    $this->smarty->display(LAYOUT_DEFAULT);

	}

	function ajax_set_location_used(){
	    if(isset($_POST['location1'])){
	        $_SESSION[SESSION_LOCATION_ID] = $_POST['location1'];
	        exit();
	    }
	}

	

	function ajax_get_contact() {
		if (isset($_POST['id'])) {
			$id = $_POST['id'];
			$value = $this->pdo->fetch_one("SELECT contact_name,contact_phone,contact_email,description,created FROM vsc_contacts WHERE contact_id=$id");
			$result = '<dt>Họ tên</dt><dd>'.$value['contact_name'].'</dd>';
			$result .= '<dt>Email</dt><dd><a href="mailto:'.$value['contact_email'].'" title="Gửi Email">'.$value['contact_email'].'</a></dd>';
			$result .= '<dt>SĐT</dt><dd><a href="tel:'.$value['contact_phone'].'" title="Gọi: '.$value['contact_phone'].'">'.$value['contact_phone'].'</a></dd>';
			$result .= '<dt>Ngày gửi</dt><dd>'.gmdate("d/m/Y H:i:s", $value['created']+7*3600).'</dd>';
			$result .= '<dt>Nội dung</dt><dd>'.$value['description'].'</dd>';
			echo json_encode($result);
		}
	}

	function ajax_delete_contact(){
		$data['ok'] = 0;

		if(isset($_POST['id'])){
			$this->pdo->query("DELETE FROM vsc_contacts WHERE id=".$_POST['id']);
			$data['ok'] = 1;
			echo json_encode($data);
			exit();
		}
	}



    function get_conf_values($type) {
        $sql = "SELECT option_name , option_value FROM vsc_options WHERE option_type='$type'";
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();

        $values = [];

        while ($item = $stmt->fetch()) {
            $values[$item['option_name']] = $item['option_value'];
        }

        return $values;
    }

	function denied() {
		global $smarty;
		$smarty->display('error.tpl');
	}
}
