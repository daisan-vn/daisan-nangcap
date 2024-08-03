<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Administrator</title>
    <base href="{$arg.admin}">
    <link href="{$arg.domain}favicon.ico" rel="shortcut icon">

    <!-- Bootstrap core CSS -->

    <link href="{$arg.stylesheet}bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}bootstrap/css/font-awesome.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}custom/css/pnotify.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}custom/css/animate.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}custom/css/style.css" rel="stylesheet">
    <link href="{$arg.stylesheet}custom/css/dashboard.css" rel="stylesheet">
    <link href="{$arg.stylesheet}custom/css/custom.css" rel="stylesheet">

    <script src="{$arg.stylesheet}bootstrap/js/jquery-1.12.4.min.js"></script>
    <script src="{$arg.stylesheet}bootstrap/js/bootstrap.min.js"></script>
    <script src="{$arg.stylesheet}custom/js/pnotify.min.js"></script>
    <script src="{$arg.stylesheet}custom/js/main.js"></script>

    <!--[if lt IE 9]>
    <script src="../assets/js/ie8-responsive-file-warning.js"></script>
    <![endif]-->

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>
<body>

{include file="includes/header.tpl"}

{literal}
<script>
$('#toggle_sidebar').remove();
</script>
{/literal}

<div class="container-fluid">

    <div class="home-item">
        <h1 style="margin-top: 10px; font-size: 30px;">Chào mừng bạn truy cập vào trang quản trị nội dung website !</h1>
        <h5>Vietsmart Tech Co,Ltd &copy; 2016, truy cập trang chủ của chúng tôi  <a href="http://vietsmart.net" target="_blank">vietsmart.net</a></h5>
        <hr>
        <div class="row">
        	<div class="col-md-4">
		        <h4><i class="fa fa-link fa-fw"></i> Một số nội dung quản lý</h4>
		        <hr>
		        <br>
		        <div class="row placeholders">
		            <div class="col-xs-6 col-sm-4 placeholder">
		                <a href="?mod=posts&site=index">
		                	<i class="fa fa-list-alt fa-3x"></i>
		                    <span class="text-muted">Bài viết</span></a>
		            </div>
		            <div class="col-xs-6 col-sm-4 placeholder">
		                <a href="?mod=media&site=index">
		                	<i class="fa fa-recycle fa-3x"></i>
		                    <span class="text-muted">Thư viện media</span></a>
		            </div>
		            <div class="col-xs-6 col-sm-4 placeholder">
		                <a href="?mod=menu&site=index">
		                	<i class="fa fa-tasks fa-3x"></i>
		                    <span class="text-muted">Quản lý menu</span></a>
		            </div>
		            <div class="col-xs-6 col-sm-4 placeholder">
		                <a href="?mod=user&site=index">
		                	<i class="fa fa-users fa-3x"></i>
		                    <span class="text-muted">Tài khoản</span></a>
		            </div>
		            <div class="col-xs-6 col-sm-4 placeholder">
		                <a href="?mod=posts&site=images">
		                	<i class="fa fa-image fa-3x"></i>
		                    <span class="text-muted">Hình ảnh</span></a>
		            </div>
		            <div class="col-xs-6 col-sm-4 placeholder">
		                <a href="?mod=option&site=index">
		                	<i class="fa fa-cogs fa-3x"></i>
		                    <span class="text-muted">cấu hình</span></a>
		            </div>
		        
		        </div>
        	
        	</div>
        	
        	<div class="col-md-8">
        		<h4>Thống kê truy cập</h4>
				<table class="highchart table hidden-lg hidden-md hidden-sm" data-graph-container-before="1" data-graph-type="column">
				  <thead>
				      <tr>
				          <th>Date</th>
				          <th class="text-right">Member onlines</th>
				      </tr>
				   </thead>
				   <tbody>
				   	{foreach from=$chart item=data}
				      <tr>
				          <td width="70%">{$data.date_log|date_format:"%d/%m/%Y"}</td>
				          <td class="text-right">{$data.number}</td>
				      </tr>
				    {/foreach}
				  </tbody>
				</table>        	
        	</div>
        </div>
    </div>
	<br>
	<p class="text-center">Administrator website &copy; 2016 | Design by <a href="">vietsmart.net</a></p>

</div>
<script src="{$arg.stylesheet}custom/js/highcharts.js"></script>
<script src="{$arg.stylesheet}custom/js/highchartTable.js"></script>
<script>
$(document).ready(function() {
	  $('table.highchart').highchartTable();
});
</script>
</body>
</html>
