<div class="main-content-wrap">
    <div class="container container-cate">
        <br/>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="{$arg.domain}" class="text-primary">Trang chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page">Toàn bộ danh mục</li>
            </ol>
        </nav>
        <div class="all-category-wrap py-4 gry-bg">
            <div class="sticky-top">
                <div class="row">
                    <div class="col">
                        <div class="bg-white all-category-menu navbar-fixed-top">
                            <ul class="clearfix no-scrollbar">
                                {foreach from=$a_category_all item=cate key=k}
                                <li class="{if $k eq 0}active{/if}">
                                    <a href="#{$k}" class="row no-gutters align-items-center">
                                        <div class="col-md-3">
                                            <i class="fa {$cate.icon} fa-2x"></i>
                                        </div>
                                        <div class="col-md-9">
                                            <div class="cat-name line-3">
                                                {$cate.name}
                                            </div>
                                        </div>
                                    </a>
                                </li>
                                {/foreach}
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mt-4">
                <div class="row row-nm">
                    <div class="col-xl-9">
                        {foreach from=$a_category_all item=cate key=k}
                        <div class="mb-3 bg-white">
                            <div class="sub-category-menu active" id="{$k}">
                                <h3> <i class="fa {$cate.icon} fa-fw"></i>{$cate.name}
                                    </a> ({$a_cate_number[$cate.id]|default:0})</h3>
                                <div class="row">
                                    {foreach from=$cate.sub item=sub}
                                    <div class="col-lg-6 col-6">
                                        <h4 class="mb-3"><a href="{$sub.url}">{$sub.name}</a><span
                                                class="number pl-1">({$a_cate_number[$sub.id]|default:0})</span>
                                        </h4>
                                        <ul class="mb-3">
                                            {foreach from=$sub.sub item=data}
                                            <li><a href="{$data.url}">
                                                    {$data.name}
                                                </a></li>
                                            {/foreach}
                                        </ul>
                                    </div>
                                    {/foreach}

                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                    <div class="col-xl-3">
                        <div class="p-3 bg-white">
                            <h3 class="text-lg">
                                <span class="align-self-center font-weight-bold">Mua hàng trên Daisan</span>
                            </h3>
                            <div id="page_product_justforyou"></div>
                            <!-- <div class="border mt-3 p-3">
                                <div class="text-muted">
                                    Tại Daisan, chúng tôi có rất nhiều công cụ và dịch vụ miễn phí dành cho người mua để
                                    giúp
                                    tìm nguồn cung ứng sản phẩm phù hợp dễ dàng cho bạn!
                                </div>
                                <ul class="list-unstyled mt-3 pl-3">
                                    <li class="d-block">
                                        <a href="" class="text-info"><i class="fa fa-circle pr-2"></i>Dịch vụ người
                                            mua</a>
                                    </li>
                                    <li class="d-block">
                                        <a href="" class="text-info"><i class="fa fa-circle pr-2"></i>Trung tâm giao
                                            dịch an
                                            toàn</a>
                                    </li>
                                    <li class="d-block">
                                        <a href="" class="text-info"><i class="fa fa-circle pr-2"></i>Câu chuyện thành
                                            công
                                            của
                                            người mua</a>
                                    </li>
                                    <li class="d-block">
                                        <a href="" class="text-info"><i class="fa fa-circle pr-2"></i>Cộng đồng người
                                            mua</a>
                                    </li>
                                </ul>
                            </div>
                            <h3 class="text-lg pt-3">
                                <span class="align-self-center font-weight-bold">Trung tâm an ninh</span>
                            </h3>
                            <div class="border mt-3 p-3 pl-3">
                                <div class="text-muted">
                                    Tại Daisan, chúng tôi có rất nhiều công cụ và dịch vụ miễn phí dành cho người mua để
                                    giúp
                                    tìm nguồn cung ứng sản phẩm phù hợp dễ dàng cho bạn!
                                </div>
                                <ul class="mt-3">
                                    <li class="d-block pb-2">
                                        <a href=""><i class="fa fa-circle pr-2"></i>Xem các thành viên trả tiền bị cấm
                                            mới
                                            nhất
                                            trên Alibaba.com</a>
                                    </li>
                                    <li class="d-block pb-2">
                                        <a href=""><i class="fa fa-circle pr-2"></i>Mẹo mới để mua an toàn trên
                                            Alibaba.com</a>
                                    </li>
                                    <li class="d-block pb-2">
                                        <a href=""><i class="fa fa-circle pr-2"></i>Học hỏi từ những người khác. Xem
                                            nghiên
                                            cứu
                                            điển hình của chúng tôi về gian lận</a>
                                    </li>
                                </ul>
                            </div>
                            <h3 class="text-lg pt-3">
                                <span class="align-self-center font-weight-bold">Công cụ mua</span>
                            </h3>
                            <div class="border mt-3 p-3">
                                <ul class="list-3">
                                    <li class="d-block ic-1">
                                        <a href="" class="font-weight-bold">Trung tâm thông báo</a>
                                        <p class="text-muted">Quản lý yêu cầu từ người mua</p>
                                    </li>
                                    <li class="d-block ic-2">
                                        <a href="" class="font-weight-bold">Quản lí thương mại
                                        </a>
                                        <p class="text-muted">Trò chuyện với người mua trong thời gian thực</p>
                                    </li>
                                    <li class="d-block ic-3">
                                        <a href="" class="font-weight-bold">Thông báo thương mại</a>
                                        <p class="text-muted">Luôn cập nhật về các cập nhật thương mại</p>
                                    </li>
                                    <li class="d-block ic-4">
                                        <a href="" class="font-weight-bold">Yêu cầu mua</a>
                                        <p class="text-muted">Cho các nhà cung cấp biết nhu cầu tìm nguồn cung ứng của
                                            bạn
                                        </p>
                                    </li>
                                    <li class="d-block ic-5">
                                        <a href="" class="font-weight-bold">Yêu thích</a>
                                        <p class="text-muted">Đánh dấu sản phẩm và nhà cung cấp</p>
                                    </li>
                                </ul>
                            </div> -->
                            <!-- <h3 class="text-lg pt-3">
                                <span class="align-self-center font-weight-bold">Hướng dẫn mua an toàn</span>
                            </h3>
                            <div class="border mt-3 p-3">
                                <div class="text-muted">Làm thế nào để kiểm tra nhà cung cấp của bạn trước khi đặt hàng?
                                </div>
                                <ul class="list-cus mt-3 pl-3">
                                    <li class="d-block pb-1">
                                        <a href=""><i class="fa fa-circle pr-1"></i>Tôi là nhà giao dịch mới, tôi nên
                                            làm
                                            gì?</a>
                                    </li>
                                    <li class="d-block pb-1">
                                        <a href=""><i class="fa fa-circle pr-1"></i>Lợi ích của việc kiểm tra đối với
                                            người
                                            mua
                                            ở nước ngoài.</a>
                                    </li>
                                    <li class="d-block pb-1">
                                        <a href=""><i class="fa fa-circle pr-1"></i>Xóa email spam của Nigeria.</a>
                                    </li>
                                    <li class="d-block pb-1">
                                        <a href=""><i class="fa fa-circle pr-1"></i>Làm thế nào để tìm một nhà cung cấp
                                            tốt?</a>
                                    </li>
                                    <li class="d-block pb-1">
                                        <a href=""><i class="fa fa-circle pr-1"></i>Cách tự kiểm tra các nhà cung cấp
                                            Trung
                                            Quốc
                                            của bạn.</a>
                                    </li>
                                </ul>
                            </div> -->
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
    	setTimeout(function () {
    		$('#page_product_justforyou').load('?mod=product&site=load_just_for_you&limit=10&action=for_page&location=' + arg.id_location);
    	}, 600);
        $('body').scrollspy({ target: '#Cate-S-1' })
        $("#Cate-S-1 .item").click(function () {
            $(".item").removeClass("active");
            $(this).addClass("active");
        });
    });
    var height = $("header").height() + $(".all-category-menu").height();
    console.log($(window).height());
    $(window).scroll(function () {
        if ($(window).scrollTop() > height) {
            $(".all-category-menu").addClass('fixed-top');
            $("#Cate-S-2 .row").css('padding-top', '180px');
        }
        else {
            $(".all-category-menu").removeClass('fixed-top');
        }
    });
</script>