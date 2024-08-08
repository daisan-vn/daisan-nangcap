<link href="{$arg.stylesheet}css/cloud-zoom.css" rel="stylesheet">
<div class="main-content-wrap">
    <div class="product__detail">
        <div class="product-image d-block d-sm-none">
            <div class="owl-carousel owl-theme detail-slider">
                {foreach from=$info.a_img key=k item=v}
                <div class="item">
                    <img data-src="{$v}" alt="" class="w-100" loading="lazy">
                </div>
                {/foreach}
            </div>
        </div>
        <div class="card card-body border-0 mb-4">
            <div class="container">
                {if $info.taxonomy_id}
                <nav class="d-none d-sm-block">
                    <ol class="breadcrumb">
                        {$breadcrumb}
                        <li>({$a_cate_number[$info.taxonomy_id]|default:0})</li>
                    </ol>
                </nav>
                {/if}
                <div class="row row-nm">
                    <div class="col-xl-4 d-none d-sm-block">
                        <div class="zoom-section">
                            <div class="zoom-small-image">
                                <div id="wrap" style="top: 0px; position: relative;">
                                    <a href="{$info.avatar}" class="cloud-zoom" id="zoom1" rel="adjustX:10, adjustY:-4" style="position: relative; display: block;">
                                        <img src="{$arg.stylesheet}images/loading.gif" data-src="{$info.avatar}" width="100%" style="display: block;" loading="lazy">
                                    </a>
                                </div>
                            </div>
                            <p class="zoom">
                                <i class="fa fa-arrows-alt"></i> Click to enlarge
                            </p>
                            <div class="zoom-desc slide_option img_tiny">
                                {foreach from=$info.a_img key=k item=v}
                                <a href="{$v}" class="cloud-zoom-gallery" rel="useZoom: 'zoom1', smallImage: '{$v}'">
                                    <img class="zoom-tiny-image thumbnail" data-src="{$v}" width="100%" loading="lazy">
                                </a>
                                {/foreach}
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-5">
                        <div class="product__detail-info">
                            {if $info.number gt 0}
                            <div class="ready-to-ship">
                                <div class="d-flex flex-row bd-highlight">
                                    <div class="bd-highlight pre-icon">Sản phẩm có sẵn</div>
                                    <div class="bd-highlight icon-ins"><i class="fa fa-angle-down fa-fw"></i>Trong kho
                                    </div>
                                    <div class="bd-highlight icon-ins"><i class="fa fa-angle-down fa-fw"></i>Giao hàng nhanh
                                    </div>
                                </div>
                            </div>
                            {/if}
                            <div class="product__detail-info2">
                                <h3>{$info.name}</h3>
                                <div class="d-none d-md-block">
                                    <span class="hot-sale-tag">Đánh giá sản phẩm</span>
                                    <div class="d-flex flex-row bd-highlight mb-3">
                                        <div class="py-2 bd-highlight">
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star-half-o"></i> 4.5/5
                                        </div>
                                        <div class="p-2 bd-highlight">{$info.views} Lượt xem</div>
                                    </div>
                                </div>
                                <div class="dropdown-divider"></div>
                                {if count($info.prices) gt 0}
                                <div class="d-flex flex-row bd-highlight mb-3">
                                    {foreach from=$info.prices key=k item=v}
                                    <div class="bd-highlight price-item">
                                        <p class="quantity">{$v.version}<span class="ml-1">({$info.unit})</span></p>
                                        {if isset($v.promo)}
                                        <p class="price-sale">{$v.promo|number_format} đ</p>
                                        <p class="price-promotion">{$v.price|number_format} ₫</p>
                                        {else}
                                        <p class="price-sale">{$v.price|number_format} đ</p>
                                        {/if}
                                    </div>
                                    {/foreach}
                                </div>
                                {else}
                                <div>
                                    <span>Giá bán:</span>
                                    <b style="font-size: 120%">Liên Hệ</b>
                                </div>
                                {/if}
                                <div class="dropdown-divider"></div>
                                {if $info.price_promo gt 0}
                                <div class="countdown mb-2">
                                    <b class="text-success">{$info.promo|default:0}% OFF</b> Thời gian còn <i class="fa fa-clock-o fa-fw"></i>
                                    <b class="countdown d-inline-block text-info" data-countdown="{$arg.end_countdown}"></b>
                                </div>
                                <div class="detail-coupon">
                                    <div class="coupon-entry">
                                        <span class="coupon-entry-dis">Giảm giá lên tới
                                            <b>{$info.price_promo|number_format}đ+/{$info.unit}</b></span>
                                        <span class="coupon-entry-action">Mua ngay để nhận chiết khấu</span>
                                        <i class="ui2-icon ui2-icon-arrow-down"></i>
                                    </div>
                                </div>
                                {/if} {if count($info.prices) gt 0}
                                <div class="row row-sm my-4">
                                    <div class="col-4">
                                        <p class="mt-2">Số lượng đặt mua:</p>
                                    </div>
                                    <div class="col-6 product-quantity">
                                        <input type="hidden" id="addcart_minorder" value="{$info.minorder|default:1}">
                                        <input type="hidden" id="addcart_price" value="{$info.pricemin|default:0}">
                                        <div class="input-group input-group--style-2" style="width: 130px;">
                                            <span class="input-group-btn">
                                                <button class="btn btn-number" type="button"
                                                    onclick="ChangeNumber(-1, 'add');">
                                                    <i class="fa fa-minus"></i>
                                                </button>
                                            </span>
                                            <input type="text" class="form-control input-number" id="addcart_number" value="{$info.minorder|default:1}" height="100%" min="1" onchange="ChangeNumber(this.value);">
                                            <span class="input-group-btn">
                                                <button class="btn btn-number" type="button"
                                                    onclick="ChangeNumber(1, 'add');">
                                                    <i class="fa fa-plus"></i>
                                                </button>
                                            </span>
                                        </div>

                                    </div>

                                </div>
                                {/if} {if !$is_mobile}
                                <button title="Nhấn vào để xem" type="button" class="btn btn-contact show_phone rounded-pill call-now-detail" data-phone="{$page.phone|default:''}" data-id="{$info.id}" onclick="ShowPhone(event);">
                                    <i class="fa fa-volume-control-phone fa-fw"></i>
                                    <span>{$page.phone_hide|default:'Đang cập nhật'}</span>
                                </button>
                                <a href="javascript:void(0)" data-toggle="modal" data-target="#exampleModal" class="btn btn-info rounded-pill"><i class="fa fa-envelope-open-o fa-fw"
                                        aria-hidden="true"></i>Yêu cầu báo giá tốt hơn
                                </a> {/if}
                                <div class="showroom p-3 text-nm mt-3">
                                    <p>Số lượng đặt hàng tối thiểu (MOD) <b>{$info.minorder} {$info.unit}</b></p>
                                    <p>Thời gian giao hàng dự kiến {$info.ordertime|default:'Tương tác trực tiếp nhà cung cấp'}
                                    </p>
                                    {if $info.isimport eq 1}
                                    <p><b>Giá tại xưởng chưa bao gồm thuế và vận chuyển</b></p>
                                    {/if}
                                </div>
                                <div class="dropdown-divider"></div>
                                <div class="contact-supplier pt-2 pt-sm-0 d-block d-sm-none">
                                    <div class="row row-sm">
                                        <div class="col-6">
                                            <a href="?mod=page&site=contact&page_id={$page.id}&product_id={$info.id}" class="chat-on-app button">LẤY GIÁ
                                                MỚI</a>
                                        </div>
                                        <div class="col-6">
                                            <a href="tel:{$page.phone}" class="button btn-callnow call-now-detail" onclick="SaveInfoCall({$info.id},1)">GỌI NGAY</a>
                                        </div>
                                    </div>
                                </div>
                                {if $address}
                                <div class="showroom">
                                    <span class="showroom_title">Hệ thống kho và cửa hàng</span>
                                    <ul>
                                        {foreach from=$address item=data}
                                        <li><i class="fa fa-map-marker fa-fw" aria-hidden="true"></i>{$data.address}
                                        </li>
                                        {/foreach}
                                    </ul>
                                    <a href="{$page.url}?site=showrooms" class="d-block text-center pb-2">Xem thêm<i
                                            class="fa fa-angle-double-down fa-fw" aria-hidden="true"></i></a>
                                </div>
                                {/if} {literal}
                                <style>
                                    .showroom {
                                        border: solid 1px #f68d91;
                                        border-radius: 5px;
                                        margin-bottom: 10px;
                                    }
                                    
                                    .showroom_title {
                                        position: absolute;
                                        z-index: 1;
                                        width: 260px;
                                        margin-left: 85px;
                                        line-height: 30px;
                                        margin-top: -15px;
                                        background-color: #fff;
                                        text-transform: uppercase;
                                        font-size: 14px;
                                        font-weight: 700;
                                        text-align: center;
                                    }
                                    
                                    .showroom ul {
                                        padding: 20px 10px 10px 10px;
                                    }
                                    
                                    .showroom ul li i {
                                        color: #f00
                                    }
                                </style>
                                {/literal}
                                <!--
								<div class="d-none d-md-block">
									<div class="row mx-0">
										<div class="col-sm-4 col-6 px-0">
											<div class="item text-nm mb-1">
												<span><i class="fa fa-comments-o pr-2 fa-fw text-dark"></i>Hỗ trợ người
													bán: </span>
											</div>
										</div>
										<div class="col-sm-8">
											<div class="item text-nm mb-1">
												<span>✔ Giao dịch an toàn</span>
											</div>
										</div>
										<div class="col-sm-4 col-6 px-0">
											<div class="item text-nm mb-1">
												<span><i class="fa fa-cc-discover fa-fw pr-2 text-dark"></i>Thanh
													toán:</span>
											</div>
										</div>
										<div class="col-sm-8">
											<span class="payment-item visa"></span> <span
												class="payment-item mastercard"></span> <span
												class="payment-item tt"></span> <span
												class="payment-item e-checking"></span>
										</div>
										<div class="col-sm-4 col-6 px-0">
											<div class="item text-nm mb-1">
												<span><i class="fa fa-truck fa-fw pr-2 text-dark"></i>Đổi
													trả và bảo hành:</span>
											</div>
										</div>
										<div class="col-sm-8">
											<ul class="nav flex-column">
												<li class="nav-item"><i
														class="fa fa-circle fz-4 pr-2 fa-fw text-dark"></i>14 ngày
													đổi trả dễ dàng</li>
												<li class="nav-item"><i
														class="fa fa-circle fz-4 pr-2 fa-fw text-dark"></i>Hàng chính
													hãng</li>
												<li class="nav-item"><i
														class="fa fa-circle fz-4 pr-2 fa-fw text-dark"></i>Nhà cung
													cấp giao hàng</li>
											</ul>
										</div>
									</div>
								</div>-->

                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3">
                        <div class="product__detail-seller">
                            <div class="seller_action mb-4">
                                {if count($info.prices) gt 0}
                                <div class="mb-3 mx-1">
                                    <div class="row row-sm">
                                        <div class="col-7">Số lượng <span id="addcart_txt_number">{$info.minorder|default:1}</span> {$info.unit}
                                        </div>
                                        <div class="col-5 text-right"><b id="addcart_txt_total">{($info.minorder*$info.pricemin)|number_format}
                                                đ</b>
                                        </div>
                                    </div>
                                    <p class="mt-2">
                                        <span>Thời gian xử lý:</span>
                                        <span>{$info.ordertime|default:'tương tác trực tiếp nhà cung cấp'}</span>
                                    </p>
                                    <p class="d-flex w-100 justify-content-between">
                                        <span>Thời gian ship hàng:</span>
                                        <b>2-5 ngày</b>
                                    </p>
                                </div>
                                    {if $info.internal_sale}
                                    <button type="button" onclick="add_cart({$info.id},1);" class="btn btn-contact rounded-pill btn-block">
                                        Đặt Hàng Ngay
                                    </button>
                                    {/if}
                                    {if (!$info.internal_sale && $info.source)} 
                                    <a target="_blank" href="{$info.source}" class="btn btn-contact rounded-pill btn-block">
                                        Mua Hàng
                                    </a>
                                    {/if}
                                {/if}
                                
                                {if $is_mobile}
                                <a href="tel:1800 6464 98" class="btn btn-contact btn-block rounded-pill show_phone call-now-detail-180" onclick="SaveInfoCall({$info.id},1)"><i
                                        class="fa fa-volume-control-phone fa-fw"></i>
                                    Tổng đài miễn phí: 1800 6464 98
                                </a>
                                {/if}
                                {if $info.internal_sale} 
                                    {if !$is_mobile}
                                    <a href="?mod=page&site=contact&page_id={$page.id}&product_id={$info.id}" class="btn btn-block btn-contact-o rounded-pill">Liên hệ nhà cung
                                        cấp</a>
                                    {/if}
                                    <button type="button" class="btn btn-block btn-outline-secondary rounded-pill" onclick="add_cart({$info.id});">
                                        <i class="fa fa-opencart fa-fw" aria-hidden="true"></i>Thêm vào giỏ hàng
                                    </button>
                                {/if}
                            </div>
                            <div class="card seller_info">
                                <div class="card-header text-center">
                                    <span><img src="{$arg.stylesheet}images/TB1z2BEFND1gK0jSZFsXXbldVXa-42-10.svg"
                                            width="50"></span>
                                </div>
                                <div class="card-body pt-3 pt-sm-5">
                                    <h3 class="mt-0 text-b mb-0 seller-intro-title">
                                        <a href="{$page.url}" class="d-block col-black">{$page.name}</a>
                                    </h3>
                                    <p class="business-type">{$page.type_name}</p>
                                    <div>
                                        <span class="yrs"><span class="number">{$page.yearexp}</span> YRS</span>
                                        {if $page.package_id gt 0}
                                        <i class="fa fa-gg-circle col-gold"></i> {/if} {if $page.is_verification}
                                        <i class="fa fa-check col-verify-1"></i>
                                        <span class="col-verify">Đã xác minh</span> {/if}
                                    </div>
                                    <!--
									<div class="seller_info-phone py-3 d-none d-sm-block">
										<a href="javascript:void(0)"
											class="btn btn-outline-info btn-block rounded-pill show_phone"
											onclick="SaveInfoCall({$info.id},0)"><i class="fa fa-fw fa-phone"></i>Xem số
											điện thoại</a>
									</div>
									-->
                                    <input type="hidden" class="phonenumber" value="{$page.phone}">
                                    <input type="hidden" class="url" value="{$arg.thislink}">
                                    <p>Địa chỉ: <b>{$page.address}</b></p>
                                    <div class="d-flex justify-content-center mt-3 d-sm-none">
                                        <a href="?mod=page&site=contact&page_id={$page.id}&product_id={$info.id}" class="btn btn-contact-o rounded-pill mx-2">Liên hệ nhà cung
                                            cấp</a>
                                        <a href="{$page.url}" class="btn btn-contact rounded-pill mx-2">Đến gian
                                            hàng</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="details__info">
        <div class="container">
            <div class="row">
                <div class="col-xl-9">
                    <div class="detail__info-pRecommend">
                        <h2>Gợi ý cho bạn</h2>
                        <div class="owl-carousel owl-theme owl-detailRecommendProducts">
                        
                            {foreach from=$out.a_other  item=v}
                                                 
                                
                            <div class="item card border-0 rounded-8">
                                <div class="product-list-recommend">
                                    <div class="list-item-img">
                                                   
                                        <a href="{$v.url}"><img data-src="{$v.avatar}" class="img-fluid" loading="lazy"></a>
                                        
                                      
  


                                    </div>
                                    <div class="list-item-info">
                                        <h3 class="text-nm-1"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a></h3>
                                        <div class="product-item-price text-oneline">
                                            {$v.price_show} {if $v.price_show ne 'Liên hệ'}
                                            <span class="unit">/ {$v.unit}</span> {/if}
                                        </div>
                                        <p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
                                    </div>
                                </div>
                            </div>
                            {/foreach}
                       
                            
                        </div>
                    </div>
                    <div class="detail__info-pRecommend mt-3">
                        <h2>Có thể bạn quan tâm</h2>
                        <div class="owl-carousel owl-theme owl-detailRecommendProducts">
                            {foreach from=$out.a_for_you item=v}
                            <div class="item card border-0 rounded-8">
                                <div class="product-list-recommend">
                                    <div class="list-item-img">
                                        <a href="{$v.url}"><img data-src="{$v.avatar}" class="img-fluid" loading="lazy"></a>
                                    </div>
                                    <div class="list-item-info">
                                        <h3 class="text-nm-1"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a></h3>
                                        <div class="product-item-price text-oneline">
                                            {$v.price_show} {if $v.price_show ne 'Liên hệ'}
                                            <span class="unit">/ {$v.unit}</span> {/if}
                                        </div>
                                        <p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
                                    </div>
                                </div>
                            </div>
                            {/foreach}
                        </div>
                    </div>
                    <div class="ads-google mt-2">
                        <div class="row">
                            <div class="col-md-6">
                                <!-- Detail Product Daisanvn 728x90 -->
                                <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-7751440498976455" data-ad-slot="2800244305" data-ad-format="auto" data-full-width-responsive="true"></ins>
                                <script>
                                    (adsbygoogle = window.adsbygoogle || []).push({});
                                </script>
                            </div>
                            <div class="col-md-6 d-none d-sm-block">
                                <!-- Detail Product Daisanvn 728x90 -->
                                <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-7751440498976455" data-ad-slot="2800244305" data-ad-format="auto" data-full-width-responsive="true"></ins>
                                <script>
                                    (adsbygoogle = window.adsbygoogle || []).push({});
                                </script>
                            </div>
                        </div>
                    </div>
                    <div class="mt-4 detail__info-detailTab">
                        <div id="tab-fixed"></div>
                        <div class="tab-main">
                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link active" id="home-tab" data-toggle="tab" href="#home" role="tab" aria-controls="home" aria-selected="true">Chi tiết sản phẩm</a>

                                </li>
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link" id="profile-tab" data-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="false">Hồ sơ nhà cung
                                        cấp</a>
                                </li>
                                <!-- <li class="nav-item" role="presentation">
									<a class="nav-link" id="contact-tab" data-toggle="tab" href="#contact" role="tab"
										aria-controls="contact" aria-selected="false">Người mua đánh giá</a>
								</li> -->
                            </ul>
                        </div>
                        <div class="tab-content" id="myTabContent">
                            <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                                <div class="widget-detail-overview">
                                    <div class="card-body px-3">
                                        <div id="one">
                                            <h2 class="d-none d-sm-block">Thông tin tổng quan</h2>
                                            <div class="do-entry pb-3">
                                                <h3 class="text-nm-1 text-b">Thông số sản phẩm</h3>
                                                <div class="row">
                                                    <div class="col-xl-6 d-flex">
                                                        <div class="do-entry-item">Thương hiệu:</div>
                                                        <div class="do-entry-item-val">{$info.trademark}</div>
                                                    </div>
                                                    <div class="col-xl-6 d-flex">
                                                        <div class="do-entry-item text-oneline">Model Number:</div>
                                                        <div class="do-entry-item-val text-oneline">{$info.code}
                                                        </div>
                                                    </div>
                                                    {foreach from=$info.metas item=v}
                                                    <div class="col-xl-6 d-flex">
                                                        <div class="do-entry-item text-oneline">{$v.meta_key}:</div>
                                                        <div class="do-entry-item-val text-oneline">{$v.meta_value}
                                                        </div>
                                                    </div>
                                                    {/foreach}
                                                </div>
                                            </div>
                                        </div>
                                        <!--end do-entry-->
                                        {if $info.ability ne null}
                                        <div class="do-entry pb-3">
                                            <h3 class="text-nm-1 text-b">Khả năng cung cấp</h3>
                                            <div class="row">
                                                <div class="col-xl-6 d-flex">
                                                    <div class="do-entry-item">Supply Ability:
                                                    </div>
                                                    <div class="do-entry-item-val">{$info.ability}</div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--end do-entry-->
                                        {/if} {if $info.package ne null}
                                        <div class="do-entry pb-3">
                                            <h3 class="text-nm-1 text-b">Đóng gói và giao hàng</h3>
                                            <div class="">{$info.package}</div>
                                        </div>
                                        <!--end do-entry-->
                                        {/if}
                                        <div class="do-entry pb-3">
                                            <div class="do-entry clearfix">
                                                <h3 class="text-nm-1 text-b ">Mô tả chi tiết</h3>
                                                <div class="table-responsive">{$info.description}</div>
                                            </div>
                                        </div>
                                        <!--end do-entry-->
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                                <div class="widget-detail-overview">
                                    <div class="card-body p-3">
                                        <h3 class="title-has-line text-nm-1">HỒ SƠ CÔNG TY</h3>
                                        <table class="company-basicInfo w-100">
                                            <tbody>
                                                <tr>
                                                    <td width="30%">Tên công ty:</td>
                                                    <td>{$page.name}</td>
                                                </tr>
                                                <tr>
                                                    <td>Mã số thuế:</td>
                                                    <td>{$page.code}</td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày bắt đầu hoạt động:</td>
                                                    <td>{$page.date_start|date_format:'%d-%m-%Y'}</td>
                                                </tr>
                                                <tr>
                                                    <td>Địa chỉ đăng ký kinh doanh:</td>
                                                    <td>{$page.address}</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--end detail__info-detailTab-->

                    <section class="section-require mt-4">
                        <div class="container-fluid">
                            <div class="require-block w-100 bg-white">
                                <div class="row justify-content-around">
                                    <div class="col-md-6 d-none d-sm-block" id="connect-buyer1">
                                        <div class="card-body">
                                            <div class="p-15">
                                                <h2>Nhận <b>miễn phí</b> báo giá từ nhiều nhà bán hàng</h2>
                                                <ul>
                                                    <li><i class="hm-icn9"></i>
                                                        <p>Cho chúng tôi biết<br> <b>Bạn cần gì</b></p>
                                                    </li>
                                                    <li><i class="hm-icn10"></i>
                                                        <p>Nhận báo giá <br>từ <b>người bán hàng</b></p>
                                                    </li>
                                                    <li><i class="hm-icn11"></i>
                                                        <p>Thỏa thuận <br>để <b> chốt giao dịch</b></p>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6" id="quote-form">
                                        <div class="card-body">
                                            <div class="p-15">
                                                <h4>Để Lại Yêu Cầu Của Bạn</h4>
                                                <form id="SendRFQ" class="general-form menu-item-right">
                                                    <input type="hidden" class="form-control" name="product_id" value="{$info.id}">
                                                    <div class="form-group">
                                                        <input type="text" class="form-control" name="title" value="{$info.name}" disabled>
                                                    </div>
                                                    <div class="input-group mb-3">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text"><i
                                                                    class="fa fa-phone fa-fw"></i></span>
                                                        </div>
                                                        <input type="text" class="form-control" name="phone" placeholder="Nhập số điện thoại của bạn">
                                                    </div>
                                                    <div class="input-group mb-3">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">Số lượng cần</span>
                                                        </div>
                                                        <input type="text" class="form-control" name="number" value="{$info.minorder|default:1}">
                                                    </div>
                                                    <div class="d-flex justify-content-start">
                                                        <button type="button" onclick="SendRFQ();" class="btn btn-requirement">Gửi yêu cầu của bạn</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <!--end section requied-->

                    <div class="detail__info-pRecommend py-4">
                        <h2>Sản phẩm cùng nhà cung cấp</h2>
                        <div class="owl-carousel owl-theme owl-detailRecommendProducts">
                            {foreach from=$out.a_same_page item=v}
                            <div class="item card border-0 rounded-8">
                                <div class="product-list-recommend">
                                    <div class="list-item-img">
                                        <a href="{$v.url}"><img data-src="{$v.avatar}" class="img-fluid" loading="lazy"></a>
                                    </div>
                                    <div class="list-item-info">
                                        <h3 class="text-nm-1"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a></h3>
                                        <div class="product-item-price text-oneline">
                                            {$v.price_show} {if $v.price_show ne 'Liên hệ'}
                                            <span class="unit">/ {$v.unit}</span> {/if}
                                        </div>
                                        <p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
                                    </div>
                                </div>
                            </div>
                            {/foreach}
                        </div>
                    </div>
                    <!--end detail_info product-->
                    <!-- <div class="detail__info-pRecommend py-4">
						<h2>You may also like</h2>
						<div class="owl-carousel owl-theme owl-detailRecommendProducts">
							{foreach from=$out.a_other item=v}
							<div class="item card border-0 rounded-8">
								<div class="product-list-recommend">
									<div class="list-item-img">
										<a href="{$v.url}"><img src="{$v.avatar}" class="img-fluid"></a>
									</div>
									<div class="list-item-info">
										<h3 class="text-nm-1"><a href="{$v.url}"
												class="text-twoline text-dark">{$v.name}</a></h3>
										<div class="product-item-price text-oneline">
											{$v.price_show}
											{if $v.price_show ne 'Liên hệ'}
											<span class="unit">/ {$v.unit}</span>
											{/if}
										</div>
										<p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
									</div>
								</div>
							</div>
							{/foreach}
						</div>
					</div> -->
                </div>
            </div>
            <div class="breadcrumb-mobile mb-3 d-block d-sm-none">
                <div class="card border-0">
                    <p class="pb-3">Danh mục sản phẩm:</p>
                    <nav class="d-block d-sm-none">
                        <ol class="breadcrumb">
                            {$breadcrumb}
                        </ol>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="rfq_product_id" value="{$info.id|default:0}">
<script src="{$arg.stylesheet}js/cloud-zoom.1.0.3.js"></script>
{literal}
<script>
    $(window).scroll(function() {
        if ($(this).scrollTop() > 1000 && $(this).scrollTop() < $(document).height() - $('.product__detail-seller').height() - 800)
            $(".product__detail-seller").addClass('fixed');
        else
            $(".product__detail-seller").removeClass('fixed');
    });

    $(".open-mega-menu").click(function() {
        $('body').addClass('no-scroll-active')
        $('.mega-menu').addClass('active');
        $('.overlay').fadeIn();
    });
    $(".close-mega").click(function() {
        $('body').removeClass('no-scroll-active')
        $('.mega-menu').removeClass('active');
        $('.overlay').fadeOut();
    });
    $('#collapse_filter').on('click', function() {
        $(".filter").addClass("active");
        $('.overlay').fadeIn();
    });
    $('.close_filter').on('click', function() {
        $(".filter").removeClass("active");
        $('.overlay').fadeOut();
    });
    $('.overlay').on('click', function() {
        $('.filter').removeClass('active');
        $('.overlay').fadeOut();
    });

    function goback() {
        $(".mega-menu-dropdown-header").removeClass("show");
    }

    function showUlCategory() {
        $(".mega-menu-dropdown-header").toggleClass(
            'hmenu-translateX');
    }

    $('.owl-detailRecommendProducts').owlCarousel({
        loop: true,
        margin: 10,
        nav: true,
        dots: false,
        thumbs: true,
        navText: ["<i class='fa fa-chevron-left'></i>",
            "<i class='fa fa-chevron-right'></i>"
        ],
        responsive: {
            0: {
                items: 2,
            },
            600: {
                items: 3,
            },
            1000: {
                items: 5,
            }
        }
    });
    $(function() {
        $('.detail-slider').owlCarousel({
            'items': 1,
            'loop': true,
            'nav': true,
            'dots': true,
            'autoplay': true,
            'smartSpeed': 500,
            responsive: {
                0: {
                    'items': 1,
                    'nav': false,
                },
                416: {
                    'items': 1,
                    'nav': false,
                },
                700: {
                    'items': 1,
                    'nav': false,
                },
                992: {
                    'items': 1,
                    'nav': true,
                }
            }
        });
    });
</script>
{/literal} {literal}
<script type="text/javascript">
    function SaveInfoCall(id, ismobile) {
        var data = {};
        data.phone = $('.phonenumber').val();
        data.url = $('.url').val();
        if (ismobile == 0)
            $(".show_phone").html('<i class="fa fa-fw fa-phone"></i>&nbsp;' + data.phone);
        $.post('?mod=product&site=get_info_call', data).done(function(e) {});
    }

    function GetPhoneNumber(id, ismobile) {
        $("#PopupCall input[name=ismobile]").val(ismobile);
        $("#PopupCall").modal({
            show: true,
            //backdrop: 'static',
            //keyboard: false  // to prevent closing with Esc button (if you want this too)
        });
    }

    function ShowPhoneNumber() {
        var IsMobile = $('.ismobile').val();
        var PhoneNumber = $('.setphonenumber').val();
        var data = {};
        data.email = $("#PopupCall input[name=email]").val();
        data.phone = $("#PopupCall input[name=callphone]").val();
        data.url = $("#PopupCall input[name=callurl]").val();
        if (data.email == '') {
            noticeMsg('Thông báo', 'Vui lòng nhập vào email của bạn.',
                'error');
            $("#PopupCall input[name=email]").focus();
            return false;
        }
        loading();
        $.post('?mod=product&site=get_info_call', data).done(function(e) {
            endloading();
            if (IsMobile == 0) $(".show_phone").html('<i class="fa fa-fw fa-phone"></i>&nbsp;' + PhoneNumber);
            else window.location.href = "tel://" + PhoneNumber;
            $("#PopupCall").modal('hide');
        });
    }
</script>
<script type="text/javascript">
    function loadPrice(id) {
        loading();
        $('#FrmPrice .modal-body').load('?mod=product&site=load_prices&id=' + id, function() {
            $('#FrmPrice').modal('show');
            endloading();
        });
    }

    function AddPrice() {
        loading();
        $.post('?mod=product&site=ajax_handle_price', {
            'ajax_action': 'add_price'
        }).done(function(e) {
            var data = JSON.parse(e);
            if (data.code == 1) {
                $("#FrmPrice .modal-body").load('?mod=product&site=load_prices');
            } else {
                noticeMsg('Thông báo', data.msg, 'error');
            }
            endloading();
        });
    }

    function SetPrice(type, id, value) {
        var Data = {};
        Data['type'] = type;
        Data['id'] = id;
        Data['value'] = value;
        Data['ajax_action'] = 'set_price';
        $.post('?mod=product&site=ajax_handle_price', Data).done(function() {
            noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
        });
    }

    function DeletePrice(id) {
        loading();
        $.post('?mod=product&site=ajax_handle_price', {
            'ajax_action': 'delete_price',
            'id': id
        }).done(function() {
            $("#FrmPrice .modal-body").load('?mod=product&site=load_prices');
            endloading();
        });
    }

    function SortPrice(id, type) {
        loading();
        $.post('?mod=product&site=ajax_handle_price', {
            'ajax_action': 'sort_price',
            'id': id,
            'type': type
        }).done(function() {
            $("#FrmPrice .modal-body").load('?mod=product&site=load_prices');
            endloading();
        });
    }

    function SavePrice(id) {
        var Data = {};
        Data.id = id;
        Data.ajax_action = 'save_price';
        loading();
        $.post('?mod=product&site=ajax_handle_price', Data).done(function() {
            noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
            setTimeout(function() {
                location.reload();
            }, 1000);
        });
    }

    function SetFavorites(product_id) {
        //if(arg.login==0){
        //	noticeMsg('System Message', 'Vui lòng đăng nhập trước khi thực hiện chức năng.');
        //	return false;
        //}
        var data = {};
        data['id'] = product_id;
        data['ajax_action'] = 'set_product_favorite';
        loading();
        $.post('?mod=product&site=ajax_handle', data).done(function(e) {
            data = JSON.parse(e);
            if (data.code == 1) {
                noticeMsg('System Message', data.msg, 'success');
            } else noticeMsg('System Message', data.msg, 'error');

            endloading();
        });
    }

    function SendComment() {
        var data = {};
        data['page_id'] = $(".sendcomment input[name=page_id]").val();
        data['product_id'] = $(".sendcomment input[name=product_id]").val();
        data['message'] = $(".sendcomment textarea").val();
        data['ajax_action'] = 'send_comment';
        console.log(data);
        if (data.message.length < 2 || data.message.length > 500) {
            noticeMsg('System Message', 'Nội dung phải chứa 2 đến 500 ký tự', 'error');
            $(".sendcomment textarea").focus();
            return false;
        }
        loading();
        $.post('?mod=product&site=detail', data).done(function(e) {
            location.reload();
        });
    }

    function SendContact(type) {
        var data = {};
        data['page_id'] = $("input[name=page_id]").val();
        data['product_id'] = $("input[name=product_id]").val();
        if (type == 1) data['message'] = $("textarea[name=message]#Message1").val();
        else data['message'] = $("textarea[name=message]#Message2").val();
        data['number'] = $("input[name=number]").val();
        data['unit_id'] = $("select[name=unit_id]").val();
        data['ajax_action'] = 'send_contact';


        if (arg.login == 0) {
            //noticeMsg('Thông báo', 'Vui lòng đăng nhập trước khi gửi liên hệ tới nhà cung cấp', 'error');
            window.location.href = arg.domain + "?mod=account&site=login";

        } else if (data.message.length < 5 || data.message.length > 1000) {
            noticeMsg('Thông báo', 'Vui lòng nhập nội dung ít nhất 5 ký tự.', 'error');
            if (type == 1)
                $("textarea[name=message]#Message1").focus();
            else
                $("textarea[name=message]#Message2").focus();
            return false;
        }
        loading();
        $.post('?mod=page&site=contact', data).done(function(e) {
            var data = JSON.parse(e);
            if (data.code == 1) {
                noticeMsg('System Message', data.msg, 'success');
                $("textarea[name=message]").val('');
                endloading();
            } else {
                noticeMsg('System Message', data.msg, 'error');
                endloading();
            }
        });
    }

    var height = $("header").height() + $("#P-3").height() + $("#productimg").height() + $("#myTab").height() + $(".nav-con").height();
    $(window).scroll(function() {
        if ($(window).scrollTop() > height) {
            $("#myTab").addClass('fixed-top1');
            $(".nav-con").addClass('fixed-top2');
            $("header").removeClass('fixed');
        } else {
            $("#myTab").removeClass('fixed-top1');
            $(".nav-con").removeClass('fixed-top2');
        }
        $("#home .nav-link").click(function() {
            $("#home .nav-link").removeClass("active");
            $(this).addClass("active");
            $(".widget-item").removeClass("fixed");
            $(".widget-item").addClass("fixed");
        });
    });


    if ($(window).width() < 700) {
        $('#DropUpShare').on('click', function() {
            $('#NetworkShare').addClass('active');
            $('.overlay').fadeIn();
        });
        $('.overlay').on('click', function() {
            $('#NetworkShare').removeClass('active');
            $('.overlay').fadeOut();
        });
        $('.close').on('click', function() {
            $('#NetworkShare').removeClass('active');
            $('.overlay').fadeOut();
        });

    } else {
        $('#DropUpShare').on('click', function() {
            $("#NetworkShare").toggleClass('active');
        });
    }

    function SendRFQ() {
        var product_id = $('#SendRFQ input[name=product_id]').val();
        var title = $('#SendRFQ input[name=title]').val();
        var phone = $('#SendRFQ input[name=phone]').val();
        var number = $('#SendRFQ input[name=number]').val();
        setTimeout(function() {
            location.href = './sourcing/?site=createRfq&title=' + title + '&product_id=' + product_id + '&number=' + number + '&phone=' + phone;
        }, 1000);
    }

    function ChangeNumber(number, type) {
        var minorder = $('#addcart_minorder').val();
        var addcart_price = $('#addcart_price').val();
        var addcart_number = $('#addcart_number').val();
        if (type == 'add') addcart_number = parseInt(addcart_number) + number;
        if (parseInt(minorder) > addcart_number) addcart_number = minorder;
        $('#addcart_number').val(addcart_number);
        $('#addcart_txt_number').html(addcart_number);
        $('#addcart_txt_total').html(new Intl.NumberFormat().format(addcart_number * addcart_price) + 'đ');
    }

    function ShowPhone(event) {
        event.preventDefault();
        let $element = $(event.currentTarget);
        if ($element.data('clicked')) {
            location.href = 'tel:' + $element.data('phone');
        }
        else {
            $element.data('clicked', 1);
            $element.find('span').html($element.data('phone'));
            // tracking click
            SaveInfoCall($element.data('id'), 0);
        }
    }
</script>
{/literal}