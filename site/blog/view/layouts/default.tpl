<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <meta http-equiv="Content-Type" content="application/xhtml+xml">
    <base href="{$arg.url_blog}">
    <title>{$metadata.title|default:'Blog - Tin tức vật liệu xây dựng'}</title>
    <meta name="keywords" content="{$metadata.keyword|default:'daisan'}" />
    <meta name="description" content="{$metadata.description|default:'Thông tin chính xác, cập nhật giá cả thị trường vật liệu xây dựng. Cung cấp kiến thức, kinh nghiệm mua và lựa chọn vật liệu xây dựng.'}" />
    <link href="{$arg.stylesheet}images/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <meta property="og:title" content="{$metadata.title|default:''}" />
    <meta property="og:image" content="{$metadata.image|default:''}" />
    <meta property="og:image:width" content="600" />
    <meta property="og:site_name" content="daisan.vn" />
    <meta property="og:description" content="{$metadata.description|default:''}" />

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="{$arg.stylesheet}css/bootstrap.min.css">
    <link rel="stylesheet" href="{$arg.stylesheet}css/font-awesome.min.css">
    <link rel="stylesheet" href="{$arg.stylesheet}swiper/swiper-bundle.min.css" />
    <link rel="stylesheet" href="{$arg.stylesheet}css/custom.css">
    <link rel="stylesheet" href="{$arg.stylesheet}css/main.css">
    <link rel="stylesheet" href="{$arg.stylesheet}css/mobile.css">
    <!-- Option 1: jQuery and Bootstrap Bundle (includes Popper) -->
    <!-- Option 1: jQuery and Bootstrap Bundle (includes Popper) -->
    <script src="{$arg.stylesheet}js/jquery-1.12.4.min.js" type="text/javascript"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js " integrity="sha384-Piv4xVNRyMGpqkS2by6br4gNJ7DXjqk09RmUpJ8jgGtD7zP9yug3goQfGII0yAns " crossorigin="anonymous "></script>
    <script src="{$arg.stylesheet}swiper/swiper-bundle.min.js "></script>
    <script src="{$arg.stylesheet}js/pnotify.min.js" type="text/javascript"></script>
    <script>
        var str_arg = '{$js_arg}';
    </script>
    <script src="{$arg.stylesheet}js/custom.js " type="text/javaScript "></script>
</head>

<body>
    {include file="../includes/header.tpl"}

    <div class="home-content">
        {include file = $content} {include file = "../includes/footer.tpl"}
    </div>


    <script>
        var Swipes = new Swiper('.slidenews', {
            loop: false,
            slidesPerView: 1,
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            autoplay: {
                delay: 3000,
            }
        });
        var Swipes = new Swiper('.newsvideo', {
            loop: false,
            slidesPerView: 2,
            spaceBetween: 20,
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            autoplay: {
                delay: 3000,
            }
        });
    </script>
    <!-- Option 2: Separate Popper and Bootstrap JS -->
    <!--
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js " integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj " crossorigin="anonymous "></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js " integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN " crossorigin="anonymous "></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js " integrity="sha384-+YQ4JLhjyBLPDQt//I+STsc9iw4uQqACwlvpslubQzn4u2UU2UFM80nGisd026JF " crossorigin="anonymous "></script>
    -->
</body>

</html>