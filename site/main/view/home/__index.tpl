<section class="mainsearch py-5">
    <div class="row justify-content-center ">
        <div class="col-md-6 ">
            <ul class="mainsearch__tab nav justify-content-center ">
                <li class="nav-item ">
                    <a class="nav-link active px-0 pb-0 " href="# ">Sản phẩm</a>
                </li>
                <li class="nav-item ">
                    <a class="nav-link pb-0" href="./supplier ">Nhà cung cấp</a>
                </li>
            </ul>
            <div class="mainsearch__form input-group my-2 my-lg-0 ">
                <input value="0" id="Type" type="hidden">
                <input class="form-control" type="text" id="key_search" value="{$main_filter.key|default:''}" placeholder="Nhập từ khóa tìm kiếm">
                <button class="btn mainsearch__button" type="button " onclick="search(); "><i
                        class="fa fa-search fa-fw "></i>{if !$is_mobile}Tìm kiếm{/if}</button> {include file="../includes/suggest.tpl"}
            </div>
        </div>
    </div>
</section>
<div class="">
    <h1 class="d-none">{$metadata.title}</h1>
    <div class="container-fluid">
        <section class="d-flex cate-banner-wrap cate-banner-wrap-inner bg-white mt-sm-3">
            <div class="cate-banner-menu-vertical d-none d-sm-block">
                <h5 class="cate-banner-menu-vertical-title">MY MARKETS</h5>
                <ul class="cate-banner-menu-vertical-title-ul">
                    {foreach from=$a_main_category key=k item=v} {if $k lt 7}
                    <li class="mega-menu-has-child">
                        <a href="{$v.url}"> <span class="icon-cate-banner"> <img
                                    src="{$arg.stylesheet}images/loading.gif" data-src="{$v.image}" alt="{$v.name}"
                                    loading="lazy">
                            </span> <span class="cate-banner-text text-oneline">{$v.name}</span> <span class="pull-right cate-banner-chevron"><i class="fa fa-chevron-right"></i></span>
                        </a>
                        <div class="mega-menu-dropdown mega-menu-lg mega-menu-dropdown-header">
                            <div class="row">
                                {foreach from=$v.sub key=k1 item=sub1}
                                <div class="col-xl-4 col-md-4 col-sm-4 col-mega-vertical col-cus-padding">
                                    <h3 class="mega-menu-heading line-1">
                                        <a href="{$sub1.url}">{$sub1.name}</a>
                                    </h3>
                                    <ul>
                                        {foreach from=$sub1.sub key=k2 item=sub2} {if $k2 lt 6}
                                        <li><a href="{$sub2.url}" class="line-1">{$sub2.name}</a></li>
                                        {/if} {/foreach}
                                    </ul>
                                </div>
                                {/foreach}
                            </div>
                        </div>
                    </li> {/if} {/foreach}
                    <li class="mega-menu-has-child">
                        <a href="./product/allcategory"> <span class="icon-cate-banner" style="padding: 6px;"> <img
                                    src="{$arg.stylesheet}images/loading.gif" data-src="{$arg.url_img}all-36-36.png"
                                    style="width: 20px;" loading="lazy">
                            </span> <span class="cate-banner-text text-oneline">Tất Cả Danh
                                Mục Sản Phẩm</span>
                        </a>
                        <ul class="mega-menu-dropdown mega-menu-dropdown-header">
                            {foreach from=$a_main_category key=k item=v} {if $k gt 6}
                            <li><a href="{$v.url}" class="line-1">{$v.name}</a></li> {/if} {/foreach}
                        </ul>
                    </li>
                </ul>
            </div>
            <!-- end cate-banner-menu-vertical-->
            <div class="cate-banner-slide">
                <div class="owl-carousel owl-1">
                    {foreach from=$a_slider key=k item=v}
                    <div class="item">
                        <a href="{$v.alias}" target="_blank"><img src="{$v.image}" alt="" class="w-100"></a>
                    </div>
                    {/foreach}
                </div>
            </div>
            <!--end cate-banner-slide-->
            <div class="cate-banner-select d-none d-sm-block">
                <h5 class="title-bg-blue">
                    <a href="./event/" class="col-white">Trưng Bày Sản Phẩm</a>
                </h5>
                <div class="promotion-list">
                    {foreach from=$event item=v}
                    <div class="promotion-list-line">
                        <a href="{$v.url}" class="overlay-link"></a>
                        <div class="title">{$v.name}</div>
                        <div class="view-more">
                            <a href="{$v.url}">Xem ngay</a>
                        </div>
                        <div class="item-banner">
                            <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" class="zoom-in" loading="lazy">
                        </div>
                    </div>
                    {/foreach}
                </div>
            </div>
            <!--end cate-banner-select-->
        </section>
    </div>
</div>
{if !$is_mobile}
<div class="text-center my-3">
    <a href="{$a_ad.adhome.p1.alias}"><img src="{$a_ad.adhome.p1.image}" width="970" style="border: 1px solid;
        border-radius: 5px;"></a>
</div>
{/if}
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
    <!--
    <section class="home-search-trending-section mb-3">
        <div class="container-fluid">
            <div class="cate-banner-wrap p-sm-3 bg-white">
                <div class="home-search-trending-block">
                    <div class="block-head">
                        <div class="head-title">
                            Xu hướng tìm kiếm
                        </div>
                    </div>
                    <div class="block-body">
                        <div class="m-slider-grid-row mz-grid mz-grid-cols-5 mz-gap-8">
                            {foreach from=$key_trend item=v}
                            <div class="item-col">
                                <a href="./product?k={$v.name}" class="search-trending-item nav-link text-dark">
                                    <div class="img-col">
                                        <div class="img-item-outer"><img src="{$arg.stylesheet}images/loading.gif"
                                                data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" alt="{$v.name}"
                                                width="68" class="img-item lazy" loading="lazy">
                                        </div>
                                    </div>
                                    <div class="info-col">
                                        <div class="keyword-label">
                                            {$v.name}
                                        </div>
                                        <div class="total-search">
                                            {$v.score|number_format} lượt tìm
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <!--end item-col
                            {/foreach}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>-->
    <!--end xu huong tim kiem-->
    <!-- <section class="moreChannel d-block d-sm-none">
        <div class="container-fluid">
            <div class="cate-banner-wrap">
                <div class="row row-sm m-slider-grid-row">
                    {foreach from=$a_home_category key=k item=v}
                    <div class="col-4">
                        <div class="item p-1 p-sm-2">
                            <p class="line-2">
                                <a href="{$v.url}">{$v.name}</a>
                            </p>
                            <div class="img-item-chanel">
                                <img class="img-fluid" data-src="{$v.image}" class="lazy" loading="lazy">
                            </div>
                        </div>
                    </div>
                    {/foreach}
                    <div class="col-4">
                        <div class="item p-1 p-sm-2 text-center">
                            <p class="line-2">
                                <a href="./supplier/toprank">Nhà cung cấp hàng đầu</a>
                            </p>
                            <div class="img-item-chanel">
                                {foreach from=$a_product_page_toprank key=k item=v} {if $k eq 0}
                                <img class="img-fluid" data-src="{$v.avatar}" class="lazy" loading="lazy">{/if} {/foreach}
                            </div>
                        </div>
                    </div>
                </div>
                <!-- end row 
            </div>
        </div>
    </section> -->
    <section class="home-category-section pb-3">
        <div class="container-fluid">
            <div class="cate-banner-wrap pt-3">
                <div class="row row-nm">
                    <div class="col-lg-3 col-md-4">
                        <div class="category-card card card-body">
                            <h2 class="category-card__title">
                                Sản phẩm sẵn sàng giao hàng
                            </h2>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$a_product_readytoship key=k item=v} {if $k lt 4}
                                    <div class="col-md-6 col-6">
                                        <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="img-fluid lazy" loading="lazy">
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more"><a href="./product/readytoship">Xem thêm</a></div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-4">
                        <div class="category-card card card-body">
                            <h2 class="category-card__title">
                                Top bán chạy
                            </h2>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$a_product_toprank key=k item=v} {if $k lt 4}
                                    <div class="col-md-6 col-6">
                                        <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="img-fluid lazy" loading="lazy">
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more"><a href="./product/toprank">Xem thêm</a></div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-4">
                        <div class="category-card card card-body">
                            <h3 class="category-card__title">
                                Nhà cung cấp hàng đầu
                            </h3>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$a_product_page_toprank key=k item=v} {if $k lt 4}
                                    <div class="col-md-6 col-6">
                                        <a href="./supplier/toprank"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="img-fluid lazy" loading="lazy">
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more"><a href="./supplier/toprank">Xem thêm</a></div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-4">
                        <div class="category-card category-card--singin card card-body">
                            <h3 class="category-card__title">
                                Đăng nhập để có trải nghiệm tốt nhất
                            </h3>
                            <div class="category-card__see-more"><a href="./login" class="btn btn-warning btn-block">Đăng nhập ngay</a></div>
                        </div>
                        <div class="category-card__image mt-3">
                            <a href="https://daisan.vn/products/gach-the-trang-tri" class="px-4"><img src="{$arg.stylesheet}images/gach-the.jpg" class="w-100"></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="home-productcate">
        <div class="container-fluid">
            <div class="cate-banner-wrap p-sm-3 mt-sm-3 mb-sm-3 bg-white">
                <div class="block-head d-flex justify-content-between align-items-center p-3 pt-sm-0">
                    <h2 class="block-head__title">Sản phẩm có sẵn kho</h2>
                    <a href="./product/readytoship">Xem tất cả</a>
                </div>
                {if !$is_mobile}
                <div class="swiper-container swiper-productcate d-none d-sm-block">
                    <div class="swiper-wrapper ">
                        {foreach from=$a_product_readytoship item=v}
                        <div class="swiper-slide ">
                            <a href="{$v.url}" target="_blank " class="product-item__img-field">
                                <div class="product-item__img-field-inner"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="lazy" loading="lazy"></div>
                            </a>
                        </div>
                        {/foreach}
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
                {/if} {if $is_mobile}
                <div class="category-card card card-body">
                    {foreach from=$a_product_readytoship key=k item=v} {if $k lt 3}
                    <div class="media mb-3">
                        <a href="{$v.url}" class="mr-3">
                            <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" style="max-width: 135px; height:85px; object-fit: contain;" alt="{$v.name}" loading="lazy">
                        </a>
                        <div class="media-body">
                            <a href="{$v.url}" class="product-card__title">
                                {$v.name}
                            </a>
                            <div class="product-card__info-row">
                                <div class="product-card__price-col">
                                    <div class="product-item-price text-oneline">
                                        {$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}
                                        <span class="unit">/ {$v.unit}</span>{/if}
                                    </div>
                                    <p class="product-item-order mb-0">{$v.minorder} {$v.unit} (Tối thiểu)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if} {/foreach}
                </div>
                {/if}
            </div>
        </div>
    </section>
    <!--end home-productcate-->
    <section>
        <div class="container-fluid">
            <div class="cate-banner-wrap">
                <div class="row row-nm">
                    {foreach from=$tax.menu_top_right key=k item=v} {if $k lt 4}
                    <div class="col-lg-3 col-md-4 col-6">
                        <div class="category-card card card-body">
                            <h3 class="category-card__title">
                                {$v.name}
                            </h3>
                            <div class="category-card__image big">
                                <a href="{$v.url}"><img src="{$v.image}"></a>
                            </div>
                            <div class="category-card__see-more"><a href="{$v.url}">Xem thêm</a></div>
                        </div>
                    </div>
                    {/if} {/foreach}
                </div>
            </div>
        </div>
    </section>
    <section class="home-productcate">
        <div class="container-fluid">
            <div class="cate-banner-wrap p-sm-3 mt-sm-3 mb-sm-3 bg-white">
                <div class="block-head d-flex justify-content-between align-items-center p-3 pt-sm-0">
                    <h2 class="block-head__title">Sản phẩm mới cập nhật</h2>
                    <a href="./product/new">Xem tất cả</a>
                </div>
                {if !$is_mobile}
                <div class="swiper-container swiper-productcate d-none d-sm-block">
                    <div class="swiper-wrapper ">
                        {foreach from=$a_product_new item=v}
                        <div class="swiper-slide ">
                            <a href="{$v.url}" target="_blank " class="product-item__img-field">
                                <div class="product-item__img-field-inner"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="lazy" loading="lazy"></div>
                            </a>
                        </div>
                        {/foreach}
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
                {/if} {if $is_mobile}
                <div class="category-card card card-body">
                    {foreach from=$a_product_new key=k item=v} {if $k lt 3}
                    <div class="media mb-3">
                        <a href="{$v.url}" class="mr-3">
                            <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" style="max-width: 135px; height:85px; object-fit: contain;" alt="{$v.name}" loading="lazy">
                        </a>
                        <div class="media-body">
                            <a href="{$v.url}" class="product-card__title">
                                {$v.name}
                            </a>
                            <div class="product-card__info-row">
                                <div class="product-card__price-col">
                                    <div class="product-item-price text-oneline">
                                        {$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}<span class="unit">/ {$v.unit}</span>{/if}
                                    </div>
                                    <p class="product-item-order mb-0">{$v.minorder} {$v.unit} (Tối thiểu)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if} {/foreach}
                </div>
                {/if}
            </div>
        </div>
    </section>
    <!--end home-productcate-->
    <section class="home-productcate">
        <div class="container-fluid">
            <div class="cate-banner-wrap p-sm-3 mt-sm-3 mb-sm-3 bg-white">
                <div class="block-head d-flex justify-content-between align-items-center p-3 pt-sm-0">
                    <h2 class="block-head__title">Sản phẩm giảm giá trong tuần</h2>
                    <a href="./product/promotions">Xem tất cả</a>
                </div>
                {if !$is_mobile}
                <div class="swiper-container swiper-productcate d-none d-sm-block">
                    <div class="swiper-wrapper ">
                        {foreach from=$a_product_promo item=v}
                        <div class="swiper-slide ">
                            <a href="{$v.url}" target="_blank " class="product-item__img-field">
                                <div class="product-item__img-field-inner"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="lazy" loading="lazy"></div>
                            </a>
                        </div>
                        {/foreach}
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
                {/if} {if $is_mobile}
                <div class="category-card card card-body">
                    {foreach from=$a_product_promo key=k item=v} {if $k lt 3}
                    <div class="media mb-3">
                        <a href="{$v.url}" class="mr-3">
                            <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" style="max-width: 135px; height:85px; object-fit: contain;" alt="{$v.name}" loading="lazy">
                        </a>
                        <div class="media-body">
                            <a href="{$v.url}" class="product-card__title">
                                {$v.name}
                            </a>
                            <div class="product-card__info-row">
                                <div class="product-card__price-col">
                                    <div class="product-item-price text-oneline">
                                        {$v.price|number_format}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}<span class="unit">/ {$v.unit}</span>{/if}
                                    </div>
                                    <p class="product-item-order mb-0">{$v.minorder} {$v.unit} (Tối thiểu)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if} {/foreach}
                </div>
                {/if}
            </div>
        </div>
    </section>
    <!--end home-productcate-->
    <section>
        <div class="container-fluid">
            <div class="cate-banner-wrap">
                <div class="row row-nm">
                    {foreach from=$a_home_category key=k item=v} {if $k lt 4}
                    <div class="col-lg-3 col-md-4 ">
                        <div class="category-card card card-body">
                            <h2 class="category-card__title">
                                {$v.name}
                            </h2>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$v.sub key=k item=sub} {if $k lt 4}
                                    <div class="col-md-6 col-6">
                                        <a href="{$sub.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$sub.image}" data-srcset="{$sub.image} 50w" class="img-fluid lazy" loading="lazy">
                                            <span class="text-oneline">{$sub.name}</span>
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more text-oneline"><a href="{$v.url}">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                    {/if} {/foreach}
                </div>
            </div>
        </div>
    </section>
    <section class="home-productcate">
        <div class="container-fluid">
            <div class="cate-banner-wrap p-sm-3 mt-sm-3 mb-sm-3 bg-white">
                <div class="block-head d-flex justify-content-between align-items-center p-3 pt-sm-0">
                    <h2 class="block-head__title">Top sản phẩm bán chạy</h2>
                    <a href="./product/toprank">Xem tất cả</a>
                </div>
                {if !$is_mobile}
                <div class="swiper-container swiper-productcate d-none d-sm-block">
                    <div class="swiper-wrapper ">
                        {foreach from=$a_product_toprank item=v}
                        <div class="swiper-slide ">
                            <a href="{$v.url}" target="_blank " class="product-item__img-field">
                                <div class="product-item__img-field-inner"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="lazy" loading="lazy"></div>
                            </a>
                        </div>
                        {/foreach}
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
                {/if} {if $is_mobile}
                <div class="category-card card card-body">
                    {foreach from=$a_product_toprank key=k item=v} {if $k lt 3}
                    <div class="media mb-3">
                        <a href="{$v.url}" class="mr-3">
                            <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" style="max-width: 135px; height:85px; object-fit: contain;" alt="{$v.name}" loading="lazy">
                        </a>
                        <div class="media-body">
                            <a href="{$v.url}" class="product-card__title">
                                {$v.name}
                            </a>
                            <div class="product-card__info-row">
                                <div class="product-card__price-col">
                                    <div class="product-item-price text-oneline">
                                        {$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}
                                        <span class="unit">/ {$v.unit}</span>{/if}
                                    </div>
                                    <p class="product-item-order mb-0">{$v.minorder} {$v.unit} (Tối thiểu)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if} {/foreach}
                    <div class="category-card__see-more text-oneline"><a href="./product/imports">Xem tất cả</a>
                    </div>
                </div>
                {/if}
            </div>
        </div>
    </section>
    <!--end home-productcate-->
    <section class="mb-3">
        <div class="container-fluid">
            <div class="cate-banner-wrap">
                <div class="row row-nm">
                    {foreach from=$a_home_category key=k item=v} {if $k ge 4 && $k lt 8}
                    <div class="col-lg-3 col-md-4 ">
                        <div class="category-card card card-body">
                            <h2 class="category-card__title">
                                {$v.name}
                            </h2>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$v.sub key=k item=sub} {if $k lt 4}
                                    <div class="col-md-6 col-6">
                                        <a href="{$sub.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$sub.image}" data-srcset="{$sub.image} 50w" class="img-fluid lazy" loading="lazy">
                                            <span class="text-oneline">{$sub.name}</span>
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more text-oneline"><a href="{$v.url}">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                    {/if} {/foreach}
                    <div class="col-lg-3 col-md-4 ">
                        <div class="category-card card card-body">
                            <h2 class="category-card__title">
                                Sản phẩm nhập khẩu
                            </h2>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$a_product_import key=k item=v}
                                    <div class="col-md-6 col-6">
                                        <a href="./product/imports"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="img-fluid lazy" loading="lazy">
                                            <span class="text-oneline">{$v.name}</span>
                                        </a>
                                    </div>
                                    {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more text-oneline"><a href="./product/imports">Xem tất cả</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-4 ">
                        <div class="category-card card card-body">
                            <h2 class="category-card__title">
                                Dành cho đại lý, cửa hàng
                            </h2>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$a_product_wholesaler key=k item=v} {if $k lt 4}
                                    <div class="col-md-6 col-6">
                                        <a href="./product/imports"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="img-fluid lazy" loading="lazy">
                                            <span class="text-oneline">{$v.name}</span>
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more text-oneline"><a href="./product/wholesaler">Xem tất
                                    cả</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-4 d-flex align-items-center">
                        <a href="https://daisan.vn/products/gach-gia-xi-mang"><img src="{$arg.stylesheet}images/gach-van-xi-mang.jpg" class="img-fluid"></a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section>
        <div class="container-fluid">
            <div class="cate-banner-wrap">
                <div class="row row-nm">
                    {foreach from=$tax.menu_top_right key=k item=v} {if $k ge 4 && $k lt 8}
                    <div class="col-lg-3 col-md-4 col-6 mb-3">
                        <div class="category-card card card-body">
                            <h3 class="category-card__title">
                                {$v.name}
                            </h3>
                            <div class="category-card__image big">
                                <a href="{$v.url}"><img src="{$v.image}"></a>
                            </div>
                            <div class="category-card__see-more"><a href="{$v.url}">Xem thêm</a></div>
                        </div>
                    </div>
                    {/if} {/foreach}
                </div>
            </div>
        </div>
    </section>

    <section>
        <div class="container-fluid">
            <div class="cate-banner-wrap">
                <div class="row row-nm">
                    {foreach from=$a_main_category key=k item=v} {foreach from=$v.sub key=k1 item=sub} {if $sub.position eq 2}
                    <div class="col-lg-3 col-md-4 mb-3">
                        <div class="category-card card card-body">
                            <h2 class="category-card__title">
                                {$sub.name}
                            </h2>
                            <div class="category-card__image">
                                <div class="row row-nm">
                                    {foreach from=$sub.sub key=k item=sub1} {if $k lt 4}
                                    <div class="col-md-6 col-6">
                                        <a href="{$sub1.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$sub1.image}" data-srcset="{$sub1.image} 50w" class="img-fluid lazy" loading="lazy">
                                            <span class="text-oneline">{$sub1.name}</span>
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                            <div class="category-card__see-more text-oneline"><a href="{$sub.url}">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                    {/if}{/foreach} {/foreach}
                </div>
            </div>
        </div>
    </section>


    <section class="home-productcate">
        <div class="container-fluid">
            <div class="cate-banner-wrap p-sm-3 mt-sm-3 mb-sm-3 bg-white">
                <div class="d-flex justify-content-between">
                    <h2 class="block-head__title">Dành cho đại lý, cửa hàng</h2>
                    <a href="./product/wholesaler">Xem tất cả</a>
                </div>
                {if !$is_mobile}
                <div class="swiper-container swiper-productcate d-none d-sm-block">
                    <div class="swiper-wrapper ">
                        {foreach from=$a_product_wholesaler item=v}
                        <div class="swiper-slide ">
                            <a href="{$v.url}" target="_blank " class="product-item__img-field">
                                <div class="product-item__img-field-inner"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="lazy" loading="lazy"></div>
                            </a>
                        </div>
                        {/foreach}
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
                {/if} {if $is_mobile}
                <div class="category-card card card-body">
                    {foreach from=$a_product_wholesaler key=k item=v} {if $k lt 3}
                    <div class="media mb-3">
                        <a href="{$v.url}" class="mr-3">
                            <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" style="max-width: 135px; height:85px; object-fit: contain;" alt="{$v.name}" loading="lazy">
                        </a>
                        <div class="media-body">
                            <a href="{$v.url}" class="product-card__title">
                                {$v.name}
                            </a>
                            <div class="product-card__info-row">
                                <div class="product-card__price-col">
                                    <div class="product-item-price text-oneline">
                                        {$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}
                                        <span class="unit">/ {$v.unit}</span>{/if}
                                    </div>
                                    <p class="product-item-order mb-0">{$v.minorder} {$v.unit} (Tối thiểu)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if} {/foreach}
                    <div class="category-card__see-more text-oneline"><a href="./product/imports">Xem tất cả</a>
                    </div>
                </div>
                {/if}
            </div>
        </div>
    </section>
    <!--end home-productcate-->

    <section class="home-product bg-white">
        <div class="container-fluid">
            <div class="cate-banner-wrap p-sm-3 mt-sm-3 pb-sm-3 ">
                <div class="block-head d-flex justify-content-between align-items-center p-3 pt-sm-0">
                    <h2 class="block-head__title">Gợi ý cho bạn</h2>
                </div>
                <div id="product_justforyou"></div>
            </div>
        </div>
    </section>
</div>
{if !$is_mobile}
<div class="text-center my-3">
    <!-- Daisan Ads - Ad Display Code -->
    <div id="adm-container-7"></div>
    <script data-cfasync="false" async type="text/javascript" src="//daisanads.com/display/items.php?7&2&970&90&0&0&0"></script>
    <!-- Daisan Ads - Ad Display Code -->
</div>
{/if}

</div>
<div class="filter fcategory d-block d-sm-none">
    <div class="d-flex justify-content-start bd-highlight p-3 border-bottom">
        <div class="bd-highlight">
        
            <a href="{$arg.domain}"><img src="{$arg.stylesheet}images/arrow-l.png"></a>
        </div>
        <div class="bd-highlight text-lg text-b pl-3">Tất cả danh mục</div>
        <div class="bd-highlight">&nbsp;</div>
    </div>
    <ul>
    {vardump($a_main_category)};
        {foreach from=$a_main_category item=v}
        <li class="nav-item">
            <a href="{$v.url}" class="nav-link d-flex align-items-center text-nm-1 col-black"><img src="{$v.image}" height="50"><span class="pl-2">{$v.name}</span><span class="pull-right cate-banner-chevron"><i
                        class="fa fa-chevron-right"></i></span> </a>
        </li>
        {/foreach}
    </ul>
</div>

<!--BEGIN::POPUP-->
{if $out.popup.image neq $arg.noimg}
<div class="modal fade" id="PopupHome" role="dialog">
    <div class="modal-dialog">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <div class="content-popuphome1">
            <a href="{$out.popup.alias}" target="_blank" class=""><img src="{$out.popup.image}" class="img-fluid"></a>
        </div>
    </div>
</div>
{/if} {literal}
<!--
<script> 
	$(document).ready(function() {
		setTimeout(function() {
			$("#exampleModal").modal({
				show : true
			});
		}, 5000);
		/*setTimeout(function() {
		$("#PopupLocation").modal({
			show : true,
			//backdrop: 'static',
			//keyboard: false  // to prevent closing with Esc button (if you want this too)
		});
		},10000);*/
	});
</script>-->
<script>
    $('.owl-1').owlCarousel({
        loop: true,
        thumbsPrerendered: true,
        items: 1,
        nav: true,
        thumbs: true,
        autoplay: true,
        autoplayTimeout: 5000,
        navText: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"]
    });

    function SendRFQ() {
        var data = {};
        data['title'] = $('#SendRFQ input[name=title]').val();
        //data['phone'] = $('#SendRFQ input[name=phone]').val();
        //data['number'] = $('#SendRFQ input[name=number]').val();
        if (data.title == '' || data.title.length < 6) {
            noticeMsg('System Message', 'Vui lòng nhập yêu cầu của bạn', 'error');
            $("#SendRFQ input[name=title]").focus();
            return false;
        }
        /*else if(data.phone ==''){
            noticeMsg('System Message', 'Vui lòng nhập vào số điện thoại của bạn', 'error');
            $("#SendRFQ input[name=phone]").focus();
        return false;
        }*/
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