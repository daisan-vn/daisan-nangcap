<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<meta http-equiv="Content-Type" content="application/xhtml+xml">
<base href="{$arg.domain}">
<title>{$metadata.title|default:'Hodine'}</title>
<meta name="keywords" content="{$metadata.keyword|default:'hodine'}" />
<meta name="description"
	content="{$metadata.description|default:'Hodine'}" />
<link href="{$arg.stylesheet}images/favicon.ico" rel="shortcut icon"
	type="image/x-icon">

<!-- Bootstrap -->

<link href="{$arg.stylesheet}css/bootstrap.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/jquery-ui.min.css" rel="stylesheet">
<link href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
	rel="stylesheet">
<link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}slick/slick.css" rel="stylesheet">
<link href="{$arg.stylesheet}slick/slick-theme.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/style.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/aboutus.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/mobile.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/loadingpage.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/custom.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
	type="text/javascript"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"
	type="text/javascript"></script>
<script src="{$arg.stylesheet}js/popper.min.js" type="text/javascript"></script>
<script src="{$arg.stylesheet}js/bootstrap.min.js"
	type="text/javascript"></script>
<script src="{$arg.stylesheet}js/pnotify.min.js" type="text/javascript"></script>
<script src="{$arg.stylesheet}js/jquery-ui.min.js"
	type="text/javascript"></script>
<script src="{$arg.stylesheet}slick/slick.min.js" type="text/javascript"></script>
<script>
	var str_arg = '{$js_arg}';
</script>
<script src="{$arg.stylesheet}js/custom.js"></script>

</head>
<body id="aboutus">
	{include file='../includes/header_aboutus.tpl'}
	{include file=$content}
	{include file='../includes/footer_aboutus.tpl'}
	<script type="text/javascript">
		$('.sliderAbout').slick({
			infinite : true,
			slidesToShow : 1,
			slidesToScroll : 1,
			dots : false,
			autoplay : true,
			autoplaySpeed : 3000,
			nextArrow : '.next-slider',
			prevArrow : '.prev-slider',
			responsive : [ {
				breakpoint : 1024,
				settings : {
					slidesToShow : 1,
					slidesToScroll : 1,
					infinite : true,
					dots : true
				}
			}, {
				breakpoint : 600,
				settings : {
					slidesToShow : 1,
					slidesToScroll : 1,
					dots : false
				}
			}, {
				breakpoint : 480,
				settings : {
					slidesToShow : 1,
					slidesToScroll : 1,
					dots : false
				}
			} ]
		});
	</script>
</body>
</html>