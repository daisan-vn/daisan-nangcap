<header id="mheader" class="oem d-block d-sm-none">
    <div class="mtophead">
        <div class="d-flex justify-content-between bd-highlight p-2">
            <div class="bd-highlight">
                <a href=""><img src="{$arg.stylesheet}images/arrow-l.png"></a>
            </div>
            <div class="bd-highlight text-lg">Sản Xuất Theo Yêu Cầu</div>
            <div class="bd-highlight">&nbsp;</div>
        </div>
    </div>

    <div class="head_menu">
        <div class="head_menu_scoll">
            <ul class="nav" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link active tab-item" data-toggle="pill" href="#tax-0">Tất cả nhà cung cấp</a>
                </li>
                {foreach from=$a_main_category key=k item=data}
                <li class="nav-item" role="presentation">
                    <a class="nav-link tab-item" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
                </li>
                {/foreach}
            </ul>
        </div>
    </div>
</header>
<div class="main-content-wrap">
    <div class="pmod-oem-supplier-product d-none d-sm-block">
        <div class="video-container">
            <div class="filter"></div>
            <video autoplay="" loop="" src="{$arg.url_img}banner/OEM.mp4" class="fillWidth"></video>
        </div>
        <div class="recommend-layout">
            <div class="container-cate">
                <h3>Nhà Máy Gia Công (OEM)</h3>
                <p>Các nhà sản xuất được đánh giá bởi các bên thứ ba độc lập</p>
                <ul class="nav flex-column mt-3">
                    <li class="nav-item">
                        <span><img src="{$arg.stylesheet}images/oem-i1.svg"></span>Năng lực sản xuất hiệu suất cao
                    </li>
                    <li class="nav-item">
                        <span><img src="{$arg.stylesheet}images/oem-i2.svg"></span>Khả năng R&D để tùy chỉnh
                    </li>
                    <li class="nav-item">
                        <span><img src="{$arg.stylesheet}images/oem-i3.svg"></span>Chứng nhận và phê duyệt chuyên nghiệp
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="tab-category">
        <div class="container-cate">
            <ul class="nav nav-pills mb-3 " id="pills-tab-oem" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link active tab-item" data-toggle="pill" href="#tax-0">Tất cả nhà cung cấp</a>
                </li>
                {foreach from=$a_main_category key=k item=data}
                <li class="nav-item" role="presentation">
                    <a class="nav-link tab-item" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
                </li>
                {/foreach}
            </ul>
            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="tax-0">
                    <h3 class="tab-content-title">Tất cả nhà cung cấp gia công sản phẩm</h3>
                    <div id="Loaddb-0">
                        {foreach from=$result item=data}
                        <div class="card oem-recommend">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-xl-2 d-none d-sm-block factory-cover">
                                        <a href="{$data.url}"><img src="{$data.logo}" class="mr-3 w-100 shadow" alt="{$data.name}"></a>
                                    </div>
                                    <div class="col-xl-10">
                                        <div class="factory-content">
                                            <div class="media mb-2">
                                                <div class="media-body">
                                                    <h3 class="mt-0 text-oneline factory-intro-title">
                                                        <a href="{$data.url}">{$data.name}</a>
                                                    </h3>
                                                    <i class="fa fa-clock-o col-yearexp"></i>
                                                    <b class="number">6</b> năm kinh nghiệm {if $data.package_id ne 0}
                                                    <i class="fa fa-gg-circle col-gold ml-3"></i>
                                                    <span>Gold Supplier</span> {/if} {if $data.is_verification ne 0}
                                                    <i class="fa fa-check col-verify-1 ml-3"></i>
                                                    <span class="col-verify">Đã xác minh</span> {/if}
                                                    <i class="fa fa-map-marker ml-3"></i>
                                                    <span>{$data.province|default:'Đang cập nhật'}</span>
                                                </div>
                                                <a href="{$data.url_contact}" class="btn rounded-pill btn-contact">Liên Hệ Nhà Cung Cấp</a>
                                            </div>
                                            <div class="factory-contact">
                                                <div class="row row-nm">
                                                    <div class="col-xl-4">
                                                        <div class="content-message">
                                                            <div class="message-bar">Triển khai kinh doanh</div>
                                                            <div class="content-tag">
                                                                <ul class="nav">
                                                                    <li class="nav-item">
                                                                        <a class="nav-link" href="{$data.url}">Kinh doanh Toàn quốc</a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a class="nav-link" href="{$data.url}">Kinh doanh Quốc tế</a>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>

                                                    </div>
                                                    <div class="col-xl-8">
                                                        <div class="row row-nm">
                                                            {foreach from=$data.metas.products item=product}
                                                            <div class="col-xl-3 col-3">
                                                                <a href="{$product.url}"><img src="{$product.avatar}" class="img-fluid"></a>
                                                            </div>
                                                            {/foreach}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                        <!--end card oem-recommed-->
                    </div>
                </div>
                {foreach from=$a_main_category key=k item=data}
                <div class="tab-pane fade" id="tax-{$data.id}">
                    <h3 class="tab-content-title">Nhà cung cấp gia công {$data.name}</h3>
                    <div id="Loaddb-{$data.id}"></div>
                </div>
                {/foreach}
            </div>
        </div>
    </div>
</div>
<input type="hidden" value="{$out.url}" id="filter_url">
<script>
    $('.nav-pills').scrollingTabs({
        scrollToTabEdge: true,
        cssClassLeftArrow: 'fa fa-angle-left',
        cssClassRightArrow: 'fa fa-angle-right',
        disableScrollArrowsOnFullyScrolled: true,
        handleDelayedScrollbar: true,
        forceActiveTab: true
    });

    var a_tab = {};
    a_tab.page = 1;
    a_tab.id = 0;
    $('.tab-item').click(function() {
        var h = $(this).attr('href');
        var a_h = h.split('-');
        var data = {};
        data.id = a_h[1];
        console.log(data.id);
        $('#Loaddb-' + a_h[1]).load('?mod=page&site=load_more_oem', data);
        a_tab.id = a_h[1];
        $(window).scrollTop(0);
        a_tab.page = 1;
    });

    $(window).scroll(function() {
        var h = $(document).height() - $(window).height() - $('footer').height();
        if ($(window).scrollTop() >= h) {
            a_tab.page = a_tab.page + 1;
            if (a_tab.page < 11) {
                $.post('?mod=page&site=load_more_oem', a_tab, function(data) {
                    $('#Loaddb-' + a_tab.id).append(data);
                    //console.log(a_tab);
                });
            }
        }
    });
</script>