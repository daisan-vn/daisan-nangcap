<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<meta http-equiv="Content-Type" content="application/xhtml+xml">
<base href="{$arg.url_pageadmin}">
<title>{$metadata.title|default:'Seller Center - Đại Sàn'}</title>
<meta name="keywords" content="{$metadata.keyword|default:'seller center, daisan'}" />
<meta name="description" content="{$metadata.description|default:'Seller Center - Đại Sàn'}" />

<!-- Bootstrap -->
<link href="{$arg.stylesheet}css/bootstrap.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/jquery-ui.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/font-awesome.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/custom.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/style.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">

<link href="{$arg.dirimg}favicon.ico" rel="shortcut icon" type="image/x-icon">
<script src="{$arg.stylesheet}js/jquery-3.2.1.slim.min.js" type="text/javascript"></script>
<script src="{$arg.stylesheet}js/jquery-1.12.4.min.js" type="text/javascript"></script>
<script src="{$arg.stylesheet}js/jquery-ui.min.js" type="text/javascript"></script>
<script src="{$arg.stylesheet}js/popper.min.js" type="text/javascript"></script>
<script src="{$arg.stylesheet}js/bootstrap.min.js" type="text/javascript"></script>
<script src="{$arg.stylesheet}js/pnotify.min.js" type="text/javascript"></script>
<script>
var arg = '{$js_arg}';
var router = "{$out.router|default:'search'}";
</script>
<script src="{$arg.stylesheet}js/custom.js"></script>

</head>
<body>

	{include file='../includes/header.tpl'}

	<section id="main">

		<div class="card-group">
			<div class="card rounded-0" id="sidebar" style="flex-grow: 0.25">
				{include file='../includes/sidebar.tpl'}
			</div>
			<div class="card rounded-0">
				{include file=$content}
			</div>
		</div>


	</section>

	{include file='../includes/footer.tpl'}

</body>
</html>
