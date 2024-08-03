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
    <link rel="stylesheet" href="{$arg.stylesheet}css/animate.min.css">
    <link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
    <link rel="stylesheet" rel="stylesheet" href="{$arg.stylesheet}css/custom.css">
    <link rel="stylesheet" href="{$arg.stylesheet}css/main.css">
    <link rel="stylesheet" href="{$arg.stylesheet}css/mobile.css">

    <!-- Option 1: jQuery and Bootstrap Bundle (includes Popper) -->

    <script src="{$arg.stylesheet}js/jquery-1.12.4.min.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/bootstrap.bundle.min.js"></script>
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
        <div class="container">
            <div class="row ">
                <div class="col-lg-8 col-md-12">
                    {include file = $content}
                </div>
                <div class="col-lg-4 col-md-12">
                    {include file = "../includes/sidebar.tpl"}
                </div>
            </div>
        </div>
        {include file = "../includes/footer.tpl"} {include file='../includes/hmenu.tpl'}
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
            breakpoints: {
                // when window width is >= 320px
                320: {
                    slidesPerView: 1,
                    spaceBetween: 10
                },
                // when window width is >= 480px
                480: {
                    slidesPerView: 1,
                    spaceBetween: 20
                },
                // when window width is >= 900px
                900: {
                    slidesPerView: 2,
                    spaceBetween: 20
                }
            }
        });
    </script>
    <script>
        $('a.hmenu-item').click(function() {
            var data_id = $(this).attr('data-id');
            if (data_id && data_id != 0) {
                $('ul.hmenu[data-id=1]').addClass('hmenu-translateX-left');
                $('ul.hmenu[data-id=1]').removeClass('hmenu-visible');
                $('ul.hmenu[data-id=1]').removeClass('hmenu-translateX');

                $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-visible');
                $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-translateX');
                $('ul.hmenu[data-id=' + data_id + ']').removeClass('hmenu-translateX-right');
            }
        });

        $('a.hmenu-back').click(function() {
            var data_id = $(this).parent().parent().attr('data-id');

            if (data_id && data_id != 0) {
                $('ul.hmenu[data-id=1]').addClass('hmenu-visible');
                $('ul.hmenu[data-id=1]').addClass('hmenu-translateX');
                $('ul.hmenu[data-id=1]').removeClass('hmenu-translateX-left');

                $('ul.hmenu[data-id=' + data_id + ']').removeClass('hmenu-visible');
                $('ul.hmenu[data-id=' + data_id + ']').removeClass('hmenu-translateX');
                $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-translateX-right');
            }
        });
        $('#hmenu .hmenu-close').click(function() {
            $('ul.hmenu').addClass('hmenu-translateX-left');
            $('ul.hmenu').removeClass('hmenu-visible');
            $('ul.hmenu').removeClass('hmenu-translateX');

            $('#hmenu').removeClass('hmenu-visible');
            $('#hmenu-bg').removeClass('hmenu-opaque');
            $('body').removeClass('lock-position');
        });
        $('.hmenu-open').click(function() {
            $('ul.hmenu[data-id=1]').removeClass('hmenu-translateX-left');
            $('ul.hmenu[data-id=1]').addClass('hmenu-visible');
            $('ul.hmenu[data-id=1]').addClass('hmenu-translateX');

            $('#hmenu').addClass('hmenu-visible');
            $('#hmenu-bg').addClass('hmenu-opaque');
            $('body').addClass('lock-position');
        });
        $('.hmenu-more').click(function() {
            var t = $(this).attr('aria-expanded');
            if (!t || t == 'false') {
                $(this).html('Thu gọn <i class="fa fa-chevron-up"></i>');
            } else {
                $(this).html('Xem tất cả <i class="fa fa-chevron-down"></i>');
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