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
<link href="{$arg.stylesheet}custom/css/jquery-ui.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}cropper/cropper.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}custom/css/style.css" rel="stylesheet">
<link href="{$arg.stylesheet}custom/css/dashboard.css" rel="stylesheet">
<link href="{$arg.stylesheet}custom/css/custom.css" rel="stylesheet">

<script src="{$arg.stylesheet}bootstrap/js/jquery-1.12.4.min.js"></script>
<script src="{$arg.stylesheet}custom/js/jquery-ui.min.js"></script>
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

    {include file=$content}

</body>
</html>
