<div class="main-content-wrap">
    <div class="category-slide">
        <div class="owl-carousel owl-category">
            {foreach from=$a_banner item=data}
            <div class="item">
                <img src="{$data.image}" alt="" height="240">
            </div>
            {/foreach}
        </div>
        <div class="category-content">
            <h1>{$category.name}</h1>
            <p>{$category.description}</p>
        </div>
    </div>
    <div class="container container-cate position-100">
        {if !$is_mobile}
        <section class="cate-section">
            <div class="card border-0">
                <div class="card-body">
                    <div class="section-title">
                        <h2 class="title-not-line">Sản phẩm theo danh mục</h2>
                    </div>
                    <div class="swiper-container swiper-cate">
                        <div class="swiper-wrapper">
                            {foreach from=$a_category_all item=v}
                            <div class="swiper-slide">
                                <div class="cate-item is-slider text-center" data-id="{$v.id}">
                                    <a class="cate-item-img-field" href="{$v.url}">
                                        <span class="cate-item-img-field-inner">
                                                    <img class="cate-item-img" src="{$v.image}"
                                                     alt="{$v.name}" height="60">
                                                </span>
                                    </a>
                                    <div class="cate-item-body">
                                        <a href="{$v.url}" class="cate-item-title text-dark text-twoline">
                                                    {$v.name}</a>
                                    </div>
                                </div>
                            </div>
                            {/foreach}
                        </div>
                        <!-- If we need navigation buttons -->
                        <div class="swiper-button swiper-button-prev"></div>
                        <div class="swiper-button swiper-button-next"></div>
                    </div>
                </div>
            </div>
            <div class="sub-cate" id="sub-cate">
                <nav class="nav">
                </nav>
            </div>
        </section>
        {/if}
        <!--end cate-banner-slide-->
        {if $is_mobile}
        <div class="card border-0 rounded-8 categoty-bottom-slider">
            <div class="card-body">
                <ul class="nav row row-sm">
                    {foreach from=$a_category_all key=k item=data}
                    <li class="col-xl-2 col-3 nav-item text-center {if $k ge 7}d-none d-sm-block{/if}">
                        <a class="nav-link" href="{$data.url}">
                            <img src="{$data.image}" class="img-fluid" alt="{$data.name}">
                            <span></span>
                        </a>
                        <p>{$data.name}</p>
                    </li>
                    {/foreach}
                    <li class="col-xl-2 col-3 nav-item text-center d-block d-sm-none">
                        <a class="nav-link" href="javascript:void(0)" id="collapse_all_category">
                            <img src="{$arg.stylesheet}images/H0e9c53982dc7407f9abc86bb5b2145bf4.webp" class="img-fluid">
                        </a>
                        <p>Tất cả</p>
                    </li>
                </ul>
            </div>
        </div>
        {/if}
        <section class="section-product-rated">
            <div class="section-title">
                <h2 class="title-not-line">Top Sản Phẩm</h2>
            </div>
            <div class="rounded-8 product-rated">
                <div class="row row-nm m-slider-grid-row">
                    {foreach from=$db.product_hot key=k item=v}
                    <div class="col-xl-2 mb-2 m-slider-grid-col">
                        <div class="p-0 p-sm-3 bg-white">
                            <div class="rank-index offericon">{$k+1}</div>
                            <a href="{$v.url}" class="texr-dark"><img src="{$v.avatar}" class="rounded-8 img-fluid">
                                <h3 class="text-twoline title-h3 text-center">{$v.name}</h3>
                            </a>
                        </div>
                    </div>
                    {/foreach}
                </div>
            </div>
        </section>

        <section class="supplier-section">
            <div class="section-title">
                <h2 class="title-not-line">Top nhà cung cấp hàng đầu</h2>
            </div>
            <div class="swiper-container swiper-supplier">
                <div class="swiper-wrapper">
                    {foreach from=$db.page_top item=v}
                    <div class="swiper-slide">
                        <div class="supplier-item is-slider text-center">
                            <a class="supplier-item__img-field" href="{$v.url}">
                                {if $v.metas.images[0]}
                                <span class="supplier-item__img-field--inner" style="background: linear-gradient(to right, rgb(0, 0, 0), rgb(0, 0, 0), transparent 240px), url({$v.metas.images[0]}) center bottom / 100% no-repeat;">
                                                 
                                                </span>
                                {else}
                                <span class="supplier-item__img-field--inner">
                                    <img class="supplier-item__img img-fluid" src=" https://s.alicdn.com/@img/imgextra/i1/O1CN01I3L7cd1nab9bjvjEo_!!6000000005106-2-tps-784-440.png"
                                     alt="{$v.name}">
                                </span>
                                {/if}
                            </a>

                            <div class="supplier-item__description">
                                <span><i class="fa fa-check col-verify-1 fa-fw"></i>Đã xác minh</span>
                                <p class="supplier-item__name">{$v.name}</p>
                            </div>
                            <div class="supplier-item__product">
                                {foreach from=$v.products key=kp item=p}
                                <a href="{$p.url}" class="product__img-field"><img src="{$p.avatar}" class="img-fluid"></a>
                                {/foreach}
                            </div>

                        </div>
                    </div>
                    {/foreach}
                </div>
                <!-- If we need navigation buttons -->
                <div class="swiper-button swiper-button-prev"></div>
                <div class="swiper-button swiper-button-next"></div>
            </div>
        </section>

        {if count($db.product_promo) gt 2}
        <section class="section-weeklydeals d-none d-sm-block">
            <div class="section-title">
                <h2 class="title-not-line">Sản phẩm khuyến mại trong tuần</h2>
            </div>
            <div class="row row-no weeklydeals-wrapper">
                <div class="col-xl-4 left">
                    <img src="{$arg.stylesheet}images/TB1nvKOvxD1gK0jSZFyXXciOVXa-400-260.webp" class="img-fluid">
                    <div class="text-wrapper">
                        <h3>Khuyến mãi trong tuần</h3>
                        <p class="mb-3">Ưu đãi hàng tuần giảm giá từ 10%</p>
                        <a href="./product/promotions?categoryId={$out.id}" class="btn btn-primary rounded-pill">Xem
							thêm</a>
                    </div>
                </div>
                <div class="col-xl-8">
                    <div class="card-group">
                        {foreach from=$db.product_promo key=k item=v}
                        <div class="card card-product-item">
                            <div class="card-body">
                                <a href="{$v.url}"><img data-src="{$v.avatar}" class="card-img-top" alt="{$v.name}" loading="lazy"></a>
                                <div class="list-item-info">
                                    <h3 class="text-nm-1">
                                        <a href="{$v.url}" class="text-oneline text-dark">{$v.name}</a>
                                    </h3>
                                    <div class="product-item-price text-oneline">
                                        {$v.price} {$v.pricemax}{if $v.pricemax ne null}<span class="unit"> /
											{$v.unit}</span>{/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        </section>
        <!--end section-weeklydeals-->
        {/if}
        <section class="section-category-new d-none d-sm-block">
            <div class="section-title">
                <h2 class="title-not-line">Sản phẩm mới đăng</h2>
            </div>
            <div class="row row-no weeklydeals-wrapper">
                <div class="col-xl-4 left">
                    <img src="{$arg.stylesheet}images/TB1HOiIvuT2gK0jSZFvXXXnFXXa-400-260.png_400x400.webp" class="img-fluid">
                    <div class="text-wrapper">
                        <h3>Sản phẩm mới</h3>
                        <p class="mb-3">Tổng hợp sản phẩm mới cập nhật</p>
                        <a href="./product/new?categoryId={$out.id}" class="btn btn-primary rounded-pill">Xem thêm</a>
                    </div>
                </div>
                <div class="col-xl-8">
                    <div class="card-group">
                        {foreach from=$db.product_new key=k item=v}
                        <div class="card card-product-item">
                            <div class="card-body">
                                <a href="{$v.url}"><img src="{$v.avatar}" class="card-img-top" alt="{$v.name}"></a>
                                <div class="list-item-info pt-3">
                                    <h3 class="text-nm-1">
                                        <a href="{$v.url}" class="text-oneline text-dark">{$v.name}</a>
                                    </h3>
                                    <div class="product-item-price text-oneline">
                                        {$v.price} {$v.pricemax}{if $v.pricemax ne null}<span class="unit"> /
											{$v.unit}</span>{/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        </section>
        <!--end section-category-new-->
        <section class="">
            <div class="section-title">
                <h2 class="title-not-line">Nhà máy gia công theo yêu cầu</h2>
            </div>
            <div class="swiper-container swiper-supplier">
                <div class="swiper-wrapper">
                    {foreach from=$db.page_oem item=v}
                    <div class="swiper-slide">
                        <div class="supplier-item is-slider text-center">
                            <a class="supplier-item__img-field" href="{$v.url}">
                                {if $v.metas.images[0]}
                                <span class="supplier-item__img-field--inner" style="background: linear-gradient(to right, rgb(0, 0, 0), rgb(0, 0, 0), transparent 240px), url({$v.metas.images[0]}) center bottom / 100% no-repeat;">
                                                 
                                                </span>
                                {else}
                                <span class="supplier-item__img-field--inner">
                                    <img class="supplier-item__img img-fluid" src=" https://s.alicdn.com/@img/imgextra/i1/O1CN01I3L7cd1nab9bjvjEo_!!6000000005106-2-tps-784-440.png"
                                     alt="{$v.name}">
                                </span>
                                {/if}
                            </a>

                            <div class="supplier-item__description">
                                <span><i class="fa fa-check col-verify-1 fa-fw"></i>Đã xác minh</span>
                                <p class="supplier-item__name">{$v.name}</p>
                            </div>
                            <div class="supplier-item__product">
                                {foreach from=$v.products key=kp item=p}
                                <a href="{$p.url}" class="product__img-field"><img src="{$p.avatar}" class="img-fluid"></a>
                                {/foreach}
                            </div>

                        </div>
                    </div>
                    {/foreach}
                </div>
                <!-- If we need navigation buttons -->
                <div class="swiper-button swiper-button-prev"></div>
                <div class="swiper-button swiper-button-next"></div>
            </div>

        </section>
        <section class="section-product-recommend">
            <div class="section-title">
                <h2 class="title-not-line">Sản phẩm gợi ý cho bạn</h2>
            </div>
            <div class="ads-slide mb-3">
                <div class="owl-carousel owl-category">
                    {foreach from=$a_slider item=data}
                    <div class="item">
                        <a href="{$data.alias}"><img src="{$data.image}" alt="" class="rounded-8"></a>
                    </div>
                    {/foreach}
                </div>
            </div>
            <div class="product-grid grid-5 mgrid-2">
                {foreach from=$db.product_foryou key=k item=v}
                <div class="product-card card border-0">
                    <a href="{$v.url}" class="product-card__img-field">
                        <div class="product-card__img-field-inner">
                            <img src="{$v.avatar}" class="img-fluid ">
                        </div>
                    </a>
                    <div class="product-card__body">
                        <h3 class="text-nm-1">
                            <a href="{$v.url}" target="_blank" class="text-twoline text-dark"><img src="{$arg.stylesheet}images/icons/icon-super.png" height="16">{$v.name}</a>
                        </h3>
                        <div class="product-item-price text-oneline">
                            <b>{$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if}</b> {if $v.price neq 0}<span class="unit">/ {$v.unit}</span>{/if}
                        </div>
                        <p class="product-item-order">{$v.minorder} {$v.unit} (Tối thiểu)</p>
                    </div>
                </div>
                {/foreach}
            </div>
            <div class="text-center py-3">
                <div id="load-more-button">Đang tải thêm...</div>
                <p id="alert-more-product" class="text-nm-1 text-muted"></p>
            </div>
        </section>
    </div>
</div>
<div class="filter fcategory d-block d-sm-none">
    <div class="d-flex justify-content-start bd-highlight p-3 border-bottom">
        <div class="bd-highlight">
            <a href=""><img src="{$arg.stylesheet}images/arrow-l.png"></a>
        </div>
        <div class="bd-highlight text-nm-1 text-b pl-2">Xây dựng & bất động sản</div>
        <div class="bd-highlight">&nbsp;</div>
    </div>
    <div class="row row-no">
        <div class="col-4">
            <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                {foreach from=$a_category_all key=k item=data}
                <a class="nav-link {if $k eq 0}active{/if}" id="v-pills-home-tab" data-toggle="pill" href="#vtax{$data.id}" role="tab" aria-controls="v-pills-home" aria-selected="true">{$data.name}</a> {/foreach}
            </div>
        </div>
        <div class="col-8">
            <div class="tab-content" id="v-pills-tabContent">
                {foreach from=$a_category_all key=k item=data}
                <div class="tab-pane fade {if $k eq 0}show active{/if}" id="vtax{$data.id}" role="tabpanel" aria-labelledby="v-pills-home-tab">
                    <div class="d-flex justify-content-between bd-highlight px-3 pb-3">
                        <div class="bd-highlight text-nm text-b"><a href="{$data.url}" class="text-dark">{$data.name}</a></div>
                        <div class="bd-highlight">
                            <a href=""><img data-src="{$arg.stylesheet}images/TB11Qn9uGL7gK0jSZFBXXXZZpXa-16-24.webp" height="12" loading="lazy"></a>
                        </div>
                    </div>
                    <ul class="nav flex-column">
                        {foreach from=$data.sub item=sub}
                        <li class="nav-item">
                            <a href="{$sub.url}" class="nav-link text-dark">{$sub.name}</a>
                        </li>
                        {/foreach}
                    </ul>
                </div>
                {/foreach}
            </div>
        </div>
    </div>
</div>

<input type="hidden" value="{$out.id}" id="catId">
<script type="text/javascript">
    $('#collapse_all_category').on('click', function() {
        $(".filter").addClass("active");
        $('.overlay').fadeIn();
    });
</script>

<script>
    $(document).ready(function() {
        $('.cate-item').hover(function() {
            // Hiển thị submenu khi di chuột vào phần tử
            data = {};
            data.id = $(this).data('id');
            $.post("?mod=product&site=load_child_cate", data).done(function(e) {
                $('#sub-cate').html(e);
            });
            $('.sub-cate').addClass('visible');
            $('.overlay').addClass('show');
        }, function() {
            // Ẩn submenu khi di chuột ra khỏi phần tử
            // $('.sub-cate').removeClass('visible');
        });
        $('.overlay').hover(function() {
            $('.overlay').removeClass('show');
            $('.sub-cate').removeClass('visible');
        });
    });
    var Swipes = new Swiper('.swiper-cate', {
        loop: false,
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
                slidesPerView: 4,
                spaceBetween: 20
            },
            // when window width is >= 640px
            640: {
                slidesPerView: 8,
                spaceBetween: 15
            }
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });
    var Swipes = new Swiper('.swiper-supplier', {
        loop: false,
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        breakpoints: {
            // when window width is >= 320px
            320: {
                slidesPerView: 2,
                spaceBetween: 10
            },
            // when window width is >= 480px
            480: {
                slidesPerView: 3,
                spaceBetween: 20
            },
            // when window width is >= 640px
            640: {
                slidesPerView: 3,
                spaceBetween: 15
            }
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });
</script>
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
            data = {};
            data.id = $("#catId").val();
            data.page = page;
            console.log(data);
            $.post("?mod=product&site=load_more_product_foryou_bycate", data).done(function(e) {
                $('.product-grid').append(e);
            });
            // Thực hiện mã để tải nội dung từ trang page
            // Ví dụ: Sử dụng AJAX để gửi yêu cầu lên máy chủ và nhận lại dữ liệu
            // Sau đó, bạn có thể thêm dữ liệu vào phần tử hiển thị nội dung
            // Ví dụ: $('#content').append(data);
        }
    });
</script>