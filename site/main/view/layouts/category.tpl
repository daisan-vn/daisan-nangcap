<!DOCTYPE html>
<html lang="vi">

<head>
    <meta http-equiv="Content-Type" charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <meta http-equiv="Content-Type" content="application/xhtml+xml">
    <base href="{$arg.domain}">
    <title>{$metadata.title|default:'Daisan.vn'}</title>
    <meta name="keywords" content="{$metadata.keyword|default:'daisan'}" />
    <meta name="description" content="{$metadata.description|default:'daisan'}" />
    <meta name="robots" content="INDEX,FOLLOW" />
    <meta name="revisit-after" content="1 days" />

    <meta property="og:title" content="{$metadata.title|default:'daisan'}">
    <meta property="og:description" content="{$metadata.description|default:'daisan'}">
    <meta property="og:image" content="{$metadata.image|default:''}" />
    <meta property="og:image:secure_url" content="{$metadata.image|default:''}">

    <link href="{$arg.img_gen}favicon.ico" rel="shortcut icon" type="image/x-icon">


    <!-- Bootstrap -->
    <link href="{$arg.stylesheet}css/bootstrap.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}css/jquery-ui.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}css/font-awesome.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}css/owl.carousel.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">
    <link href="{$arg.stylesheet}swiper/swiper-bundle.min.css" rel="stylesheet">

    <link href="{$arg.stylesheet}css/custom.css" rel="stylesheet">
    <link href="{$arg.stylesheet}css/style.css" rel="stylesheet">
    <link href="{$arg.stylesheet}css/mobile.css" rel="stylesheet">


    <script src="{$arg.stylesheet}js/jquery-3.2.1.slim.min.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/jquery-1.12.4.min.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/popper.min.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/bootstrap.min.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/pnotify.min.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/owl.carousel.min.js"></script>
    <script src="{$arg.stylesheet}js/jquery.lazy.min.js"></script>
    <!-- Swiper JS -->
    <script src="{$arg.stylesheet}swiper/swiper-bundle.min.js"></script>
    <script src="{$arg.stylesheet}js/jquery-ui.min.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/owl-jquery.js" type="text/javascript"></script>
    <script src="{$arg.stylesheet}js/jquery.countdown.min.js" type="text/javascript"></script>
    <script src="https://accounts.google.com/gsi/client" async defer></script>

    <script>
        var str_arg = '{$js_arg}';
    </script>
    <script src="{$arg.stylesheet}js/ddscrollspy.js"></script>
    <script src="{$arg.stylesheet}js/custom.js"></script>

</head>

<body>

    <div class="overlay"></div>
    {include file='../includes/header.tpl'}
    {include file=$content}
	{include file='../includes/footer.tpl'}
    {include file='../includes/hmenu.tpl'}

    <script>
        $(document).ready(function() {
            var lazyloadImages;
            if ("IntersectionObserver" in window) {
                lazyloadImages = document.querySelectorAll('img[loading="lazy"]');
                var imageObserver = new IntersectionObserver(function(entries, observer) {
                    console.log(observer);
                    entries.forEach(function(entry) {
                        if (entry.isIntersecting) {
                            var image = entry.target;
                            image.src = image.dataset.src;
                            image.classList.remove("lazy");
                            imageObserver.unobserve(image);
                        }
                    });
                }, {
                    root: document.querySelector("body"),
                    rootMargin: "0px 0px 500px 0px"
                });

                lazyloadImages.forEach(function(image) {
                    imageObserver.observe(image);
                });
            } else {
                var lazyloadThrottleTimeout;
                lazyloadImages = $('img[loading="lazy"]');

                function lazyload() {
                    if (lazyloadThrottleTimeout) {
                        clearTimeout(lazyloadThrottleTimeout);
                    }

                    lazyloadThrottleTimeout = setTimeout(function() {
                        var scrollTop = $(window).scrollTop();
                        lazyloadImages.each(function() {
                            var el = $(this);
                            if (el.offset().top < window.innerHeight + scrollTop + 500) {
                                var url = el.attr("data-src");
                                el.attr("src", url);
                                el.removeClass("lazy");
                                lazyloadImages = $('img[loading="lazy"]');
                            }
                        });
                        if (lazyloadImages.length == 0) {
                            $(document).off("scroll");
                            $(window).off("resize");
                        }
                    }, 20);
                }
                $(document).on("scroll", lazyload);
                $(window).on("resize", lazyload);
            }
        })
    </script>
</body>

</html>