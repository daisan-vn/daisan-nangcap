<section class="mainsearch px-5 " >
    <div class="row justify-content-center ">
        <div class="col-md-7   mt-5 pt-5    "  >
            <ul class="mainsearch__tab  nav justify-content-center " >
                <li class="nav-item ">
                    <a class="nav-link active px-0 pb-0" href="# ">Sản phẩm</a>
                </li>
                <li class="nav-item ">
                    <a class="nav-link pb-0" href="./supplier ">Nhà cung cấp</a>
                </li>
            </ul>
            <div class="mainsearch__form  input-group my-2 my-lg-0 " >
                <input value="0" id="Type" type="hidden">
                <input type="hidden" id="filter_cate_id" value="{$main_filter.t|default:0}">
                
                <input class="form-control" type="text" id="key_search"  value="{$main_filter.key|default:''}" placeholder="Nhập từ khóa tìm kiếm">
                <button class="btn mainsearch__button "   onclick="search(); "><i
                        class="fa fa-search fa-fw "></i>{if !$is_mobile}Tìm kiếm{/if}</button> {include file="../includes/suggest.tpl"}
            </div>
        </div>
    </div>
</section>

{* Banner cũ của anh kiên *}
{* <div class="container py-4">
    <div class="swiper-container event-top">
        <div class="swiper-wrapper bg-white">
            <div class="swiper-slide">
            {foreach from=$home_slider item=data}
                <a href="{$data.alias}"><img src="{$data.image}" style="width:100%;" ></a> 
            </a>
            {/foreach}
            </div>
            <div class="swiper-slide">
                <a target="_blank" href="https://blog.daisan.vn/chao-he-sang-ron-rang-qua-tang.htm">
                    <img src="/site/upload/felico.jpg" style="width:100%"/>    
                </a> 
            </div>
        </div>
        <div class="swiper-pagination"></div>
    </div>
</div> *}
 
<div class="container    event-top  py-4 "   >
    <div class="owl-carousel owl-category "    >
        {foreach from=$home_slider item=data}
        <div class="item" >
            <a href="{$data.alias}"><img src="{$data.image}"  style="height:100%"       ></a>
        </div> 
        {/foreach}
    </div>
</div>
 
                

{if !$is_mobile}
<section class="section-main-menu">
    <div class="container-fluid">
        <div class="cate-banner-wrap">
            <div class="nav-main-menu">
                <ul class="main-menu">
                    {foreach from=$a_main_category key=k item=v} {if $k lt 6}
                    <li class="nav-item dropdown megamenu">
                        <a class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" href="#"><img src="{$v.image}" height="36"><span class="line-2">{$v.name}</span></a>
                        <div class="dropdown-menu sub-menu">
                            <div class="row">
                                {foreach from=$v.sub key=k1 item=sub1} {if $k1 lt 6}
                                <div class="col-2">
                                    <a href="{$sub1.url}" cla ss="dropdown-item text-b">{$sub1.name}</a> {foreach from=$sub1.sub key=k2 item=sub2} {if $k2 lt 10}
                                    <a class="dropdown-item" href="{$sub2.url}">{$sub2.name}</a> {/if} {/foreach}
                                    <a href="{$sub1.url}" class="dropdown-item" style="text-decoration: revert;">Xem thêm</a>
                                </div>
                                {/if} {/foreach}
                            </div>
                            <p class="text-center"><a href="{$v.url}">Xem tất cả sản phẩm trong {$v.name}</a></p>
                        </div>
                    </li>
                    {/if}{/foreach}
                    <li class="nav-item">
                        <a class="nav-link" href="./product/allcategory"><span class="line-2">Xem tất cả <br>danh mục<i class="fa fa-chevron-right "></i></span></a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</section>
{/if}

<div class="main-content-wrap py-3 ">
    <div class="main-content-wrap pb-3">
        <section class="section-line-cate d-block d-sm-none">
            <div class="block-body">
                <div class="mz-grid mz-grid-cols-5 mz-gap-8 m-slider-grid-row">
                    <div class="item-col">
                        <a href="javascript:void(0)" id="collapse_all_category" rel="nofollow " class="search-trending-item nav-link" target="_blank" style="background-color:#f60">
                            <div class="info-col">
                                <div class="keyword-label">
                                    Danh mục
                                </div>
                            </div>
                            <div class="img-col">
                                <div class="img-item-outer"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$arg.url_img}icons/m-ic-cate.png" height="36" loading="lazy">
                                </div>
                            </div>
                        </a>
                    </div>
                    <!--end item-col-->
                    <div class="item-col">
                        <a href="./event/" rel="nofollow " class="search-trending-item nav-link" target="_blank" style="background-color: #5675f8">
                            <div class="info-col">
                                <div class="keyword-label">
                                    Khuyến mãi
                                </div>
                            </div>
                            <div class="img-col">
                                <div class="img-item-outer"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$arg.url_img}icons/m-ic-event.png" height="36" loading="lazy">
                                </div>
                            </div>
                        </a>
                    </div>
                    <!--end item-col-->
                    <div class="item-col">
                        <a href="{$arg.url_sourcing}" rel="nofollow " class="search-trending-item nav-link" target="_blank" style="background-color: #a02878">
                            <div class="info-col">
                                <div class="keyword-label">
                                    Yêu cầu giá
                                </div>
                            </div>
                            <div class="img-col">
                                <div class="img-item-outer"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$arg.url_img}icons/m-ic-rfq.png" height="36" loading="lazy">
                                </div>
                            </div>
                        </a>
                    </div>
                    <!--end item-col-->
                    <div class="item-col ">
                        <a href="./sitemap " rel="nofollow " class="search-trending-item nav-link " target="_blank " style="background-color: #5c47b5">
                            <div class="info-col ">
                                <div class="keyword-label ">
                                    Xem thêm
                                </div>
                            </div>
                            <div class="img-col ">
                                <div class="img-item-outer "><img src="{$arg.stylesheet}images/loading.gif" data-src="{$arg.url_img}icons/m-ic-other.png" height="36 " loading="lazy ">
                                </div>
                            </div>
                        </a>
                    </div>
                    <!--end item-col-->
                </div>
            </div>
        </section>
        <section class="home-feature-department-section mb-3">
            <div class="container-fluid ">
                <div class="cate-banner-wrap p-sm-3 bg-white">
                    <div class="home-feature-department-block p-sm-0 p-2">
                        <div class="block-head ">
                            <div class="head-title">
                  52              Khám phá các lĩnh vực trên hệ thống Daisan
                            </div>
                        </div>
                        <div class="block-body">
                            <!-- Swiper -->
                            <div class="swiper-container swiper-department">
                                <div class="swiper-wrapper bg-white">
                                    {foreach from=$tax.menu_top_suggest item=v}
                                    <div class="swiper-slide">
                                        <div class="department-item is-slider">
                                            <a class="d-block department-item-img-field overflow-hidden" href="{$v.url}" target="_blank">
                                                <span class="department-item-img-field-inner">
                                                    <img class="department-item-img img-fluid" src="{$v.image}"
                                                        data-srcset="{$v.image} 50w" alt="{$v.name}" >
                                                </span>
                                            </a>
                                            <p class="text-center w-75 mx-auto pt-2 text-twoline">{$v.title}</p>
                                        </div>
                                    </div>
                                    {/foreach}
                                </div>
                                <!-- If we need pagination  -->
                                <div class="swiper-pagination"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="home-page-section mb-3 ">
            <div class="container-fluid ">
                <div class="cate-banner-wrap p-sm-3 bg-white">
                    <div class="home-page-block p-sm-0 p-2">
                        <div class="block-head ">
                            <div class="head-title">
                                Nhà cung cấp nổi bật
                            </div>
                        </div>
                        <div class="block-body ">
                            <div class="m-slider-grid-row mz-grid mz-grid-cols-8 mz-gap-8 m-slider-grid-row py-2">
                                {foreach from=$a_page_featured item=v}
                                <div class="item-col m-slider-grid-col">
                                    <a href="{$v.url}" class="page-item nav-link text-dark">
                                        <div class="img-item-outer "><img src="{$v.logo_custom}" data-src="{$v.logo} " data-srcset="{$v.logo} 50w " alt="{$v.name} " class="img-fluid img-item lazy " loading="lazy ">
                                        </div>
                                    </a>
                                </div>
                                <!--end item-col-->
                                {/foreach}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!--end nhà cung cấp nổi bật-->
        <section class="home-cate-section mb-3 ">
            <div class="container-fluid ">
                <div class="cate-banner-wrap p-sm-3 bg-white ">
                    <div class="home-cate-block p-sm-0 p-2">
                        <div class="block-head ">
                            <div class="head-title">
                                Sản phẩm thịnh hành được chọn lọc
                            </div>
                        </div>
                        <div class="block-body ">
                            <div class="m-slider-grid-row mz-grid mz-grid-cols-8 mz-gap-8 m-slider-grid-row">
                                {foreach from=$tax.category_hot item=v}
                                <div class="item-col m-slider-grid-col">
                                    <a href="{$v.url}" class="cate-item nav-link text-dark">
                                        <div class="img-item-outer overflow-hidden"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.logo} 50w " alt="{$v.name} " class="img-fluid img-item lazy zoom-in-1" loading="lazy">
                                        </div>
                                        <p class="text-center">{$v.name}</p>
                                    </a>
                                </div>
                                <!--end item-col-->
                                {/foreach}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!--end nhà cung cấp nổi bật-->
        <section class="section-product-recommend">
            <div class="container-fluid ">
                <div class="cate-banner-wrap p-sm-3">
                    <div class="home-cate-block p-sm-0 p-2">
                        <div class="block-head ">
                            <div class="head-title">
                                Sản phẩm gợi ý cho bạn
                            </div>
                        </div>
                        <div class="block-body">
                            <div id="product_justforyou" class="row row-nm"></div>
                        </div>
                        <div class="text-center">
                            <div id="load-more-button"><img src="{$arg.stylesheet}images/loading.gif" width="32"></div>
                            <p id="alert-more-product" class="text-nm-1 text-muted"></p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <div class="filter fcategory d-block d-sm-none ">
        <div class="d-flex justify-content-start bd-highlight p-3 border-bottom ">
            <div class="bd-highlight ">
                <a href="{$arg.domain} "><img src="{$arg.stylesheet}images/arrow-l.png "></a>
            </div>
            <div class="bd-highlight text-lg text-b pl-3 ">Tất cả danh mục</div>
            <div class="bd-highlight ">&nbsp;</div>
        </div>
        <ul>
            {foreach from=$a_main_category item=v}
            <li class="nav-item ">
                <a href="{$v.url} " class="nav-link d-flex align-items-center text-nm-1 col-black "><img src="{$v.image} " height="50 "><span class="pl-2 ">{$v.name}</span><span class="pull-right cate-banner-chevron "><i
                        class="fa fa-chevron-right "></i></span> </a>
            </li>
            {/foreach}
        </ul>
    </div>

    <!--BEGIN::POPUP-->
    {if isset($out['popup']) and ($out.popup.image neq $arg.noimg)}
    <div class="modal fade" id="PopupHome" role="dialog">
        <div class="modal-dialog">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <div class="content-popuphome1">
                <a href="{$out.popup.alias}" target="_blank" class=""><img src="{$out.popup.image}" class="img-fluid"></a>
            </div>
        </div>
    </div>
    {/if}


    <script>
        $(document).ready(function() {
            var isLoading = false;
            var currentPage = 2;
            var totalPages = 5; // Tổng số trang

            // Xử lý sự kiện scroll
            $(window).on('scroll', function() {
                if (!isLoading && currentPage <= totalPages) {
                    if ($(window).scrollTop() + $(window).height() >= $(document).height() - 800) {
                        isLoading = true;
                        loadMoreContent();
                    }
                }
            });

            // Hàm tải nội dung thêm
            function loadMoreContent() {
                // Simulate loading data from the server
                setTimeout(function() {
                    // Gọi hàm để tải nội dung từ trang currentPage
                    loadPageContent(currentPage);
                    currentPage++;

                    isLoading = false;

                    if (currentPage > totalPages) {
                        $('#load-more-button').hide();
                        $('#alert-more-product').html("Bạn đã tải hết sản phẩm");
                    }
                }, 1000); // Giả lập thời gian tải dữ liệu
            }

            function loadPageContent(page) {
                console.log(page);
                data = {};
                data.page = page;
                $.post("?mod=product&site=load_more_just_for_you", data).done(function(e) {
                    $('#product_justforyou').append(e);
                });
                // Thực hiện mã để tải nội dung từ trang page
                // Ví dụ: Sử dụng AJAX để gửi yêu cầu lên máy chủ và nhận lại dữ liệu
                // Sau đó, bạn có thể thêm dữ liệu vào phần tử hiển thị nội dung
                // Ví dụ: $('#content').append(data);
            }
        });
    </script>

    <script>
        new Swiper('.event-top', {
            loop: false,
            autoplay: {
                delay: 4000,
            },
            slidesPerView: 1,
        });

        new Swiper('.swiper-department', {
            loop: false,
            autoplay: {
                delay: 3000,
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            breakpoints: {
                // when window width is >= 320px
                320: {
                    slidesPerView: 3,
                    spaceBetween: 10
                },
                // when window width is >= 480px
                480: {
                    slidesPerView: 3,
                    spaceBetween: 20
                },
                // when window width is >= 640px
                640: {
                    slidesPerView: 8,
                    spaceBetween: 15
                }
            }
        });
    </script>
    {literal}

    <script>
        $('.owl-1').owlCarousel({
            loop: true,
            thumbsPrerendered: true,
            items: 1,
            nav: true,
            thumbs: true,
            autoplay: true,
            autoplayTimeout: 5000,
            navText: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"],
        });

        function SendRFQ() {
            var data = {};
            data['title'] = $('#SendRFQ input[name=title]').val();
            data['phone'] = $('#SendRFQ input[name=phone]').val(); //data['number'] = $('#SendRFQ input[name=number]').val();
            if (data.title == '' || data.title.length <
                6) {
                noticeMsg('System Message', 'Vui lòng nhập yêu cầu của bạn', 'error');
                $("#SendRFQ input[name=title]").focus();
                return false;
            }
            /*else if(data.phone=='' ){ noticeMsg( 'System Message', 'Vui lòng nhập vào số điện thoại của bạn', 'error'); $(
                   "#SendRFQ input[name=phone]").focus(); return false; }*/
            setTimeout(function() {
                location.href = arg.url_sourcing + '?site=createRfq&title=' + data.title;
            }, 1000);
        }
    </script>
    <script type="text/javascript">
        $('#collapse_all_category').on('click', function() {
            $(".filter").addClass("active");
            $('.overlay').fadeIn();
        });
    </script>
    {/literal}