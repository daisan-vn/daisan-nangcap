<div id="sw_info_contact" class="info-contact-button" href="#">
    <div class="Footer_btnZalo"><a href="https://zalo.me/2902158116251416363"><i id="center-bar" class="ic-zalo"></i></a>
        <div class="showQRzalo">
            <!--<a href="https://zalo.me/0986258282">-->
            <a href="https://zalo.me/2902158116251416363">
                <img src="{$arg.stylesheet}images/QRzalo_daisan.png" alt="qrzalo" width="100%"></a>
            <div class="arrowDown"></div>
        </div>
    </div>
    <div class="Footer_btnCall">
        <a href="tel:{$page.phone|default:{$option.contact.phone}}"><i id="center-bar" class="ic-phone"></i></a>
    </div>
</div>

<style>
    .swiper-container {
        z-index: 0
    }
    
    .owl-carousel {
        z-index: 0
    }
    
    .info-contact-button {
        position: fixed;
        left: 15px;
        width: 45px;
        height: 45px;
        bottom: 30px;
        z-index: 9999;
    }
    
    @media(max-width:768px) {
        .info-contact-button {
            bottom: 100px;
        }
    }
    
    .info-contact-button i.ic-zalo {
        display: block;
        width: 40px;
        height: 40px;
        background: url('{$arg.stylesheet}images/ic-zalo.png') no-repeat;
        background-size: 40px 40px;
        position: absolute;
        left: 2px;
        top: -50px;
        z-index: 9999;
    }
    
    .info-contact-button i.ic-zalo:hover {
        background: url('{$arg.stylesheet}images/ic-zalo-hover.png') no-repeat transparent;
        background-size: contain;
    }
    
    .info-contact-button .Footer_btnZalo:hover .showQRzalo {
        display: block;
    }
    
    .info-contact-button i.ic-phone {
        display: block;
        width: 40px;
        height: 40px;
        background: url('{$arg.stylesheet}images/ic-phone.png') no-repeat;
        background-size: 40px 40px;
        position: absolute;
        left: 2px;
        top: 2px;
        z-index: 9999;
        -webkit-animation: phonering_icon-transform 1.2s ease-in-out infinite;
        animation: phonering_icon-transform 1.2s ease-in-out infinite;
    }
    
    .info-contact-button i.ic-phone:hover {
        background: url('{$arg.stylesheet}images/ic-phone-hover.png') no-repeat transparent;
        background-size: contain;
    }
    
    @keyframes phonering_icon-transform {
        0% {
            -webkit-transform: rotate(0) scale(1) skew(1deg);
            -moz-transform: rotate(0) scale(1) skew(1deg);
            transform: rotate(0) scale(1) skew(1deg);
        }
        10% {
            -webkit-transform: rotate(-25deg) scale(1) skew(1deg);
            -moz-transform: rotate(-25deg) scale(1) skew(1deg);
            transform: rotate(-25deg) scale(1) skew(1deg);
        }
        20% {
            -webkit-transform: rotate(25deg) scale(1) skew(1deg);
            -moz-transform: rotate(25deg) scale(1) skew(1deg);
            transform: rotate(25deg) scale(1) skew(1deg);
        }
        30% {
            -webkit-transform: rotate(-25deg) scale(1) skew(1deg);
            -moz-transform: rotate(-25deg) scale(1) skew(1deg);
            transform: rotate(-25deg) scale(1) skew(1deg);
        }
        40% {
            -webkit-transform: rotate(25deg) scale(1) skew(1deg);
            -moz-transform: rotate(25deg) scale(1) skew(1deg);
            transform: rotate(25deg) scale(1) skew(1deg);
        }
        50% {
            -webkit-transform: rotate(0) scale(1) skew(1deg);
            -moz-transform: rotate(0) scale(1) skew(1deg);
            transform: rotate(0) scale(1) skew(1deg);
        }
        100% {
            -webkit-transform: rotate(0) scale(1) skew(1deg);
            -moz-transform: rotate(0) scale(1) skew(1deg);
            transform: rotate(0) scale(1) skew(1deg);
        }
    }
    
    .showQRzalo {
        width: 250px;
        display: none;
        position: absolute;
        bottom: 110px;
        left: 0;
        background-color: #e7ba01;
        padding: 10px;
        border-radius: 20px;
        -webkit-transform-origin: 10% 110%;
        -moz-transform-origin: 10% 110%;
        transform-origin: 10% 110%;
        -webkit-animation: Footer_ShowZalo .4s ease-in;
        animation: Footer_ShowZalo .4s ease-in;
        z-index: 999999;
    }
    
    .showQRzalo .arrowDown {
        width: 0;
        height: 0;
        border-left: 6px solid transparent;
        border-right: 6px solid transparent;
        border-top: 11px solid #e7ba01;
        position: absolute;
        left: 20px;
        bottom: -11px;
    }
    
    @keyframes Footer_ShowZalo {
        0% {
            opacity: 0;
            -webkit-transform: scale(.3);
            -moz-transform: scale(.3);
            transform: scale(.3);
        }
        100% {
            opacity: 1;
            -webkit-transform: scale(1);
            -moz-transform: scale(1);
            transform: scale(1);
        }
    }
</style>

<div class="toolbar-side">
    <div class="back-to-top">
        <i class="fa fa-arrow-up"></i>
    </div>
</div>

<footer id="footer">
    <div class="back-top back-to-top text-center" id="totop">Back to top</div>
    <div class="container-fluid">
        <div class="cate-banner-wrap">
            <div class="row wrap-footer-col">
                {foreach from=$tax.menu_foot item=data}
                <div class="col-xl-3 col-6">
                    <h4 class="footer-title">{$data.name}</h4>
                    <ul>
                        {foreach from=$data.submenu item=sub1}
                        <li><a href="{$sub1.url}">{$sub1.name}</a></li>
                        {/foreach}
                    </ul>
                </div>
                {/foreach}
            </div>
        </div>
    </div>
    <div class="footer-choose">
        <div class="container-fluid">
            <div class="footer-info p-3 p-md-0">
                <div class="row row-sm justify-content-center">

                    <div class="col-xl-4">
                        <p class="text-b mt-3 mt-md-0">© 2009 DAISAN.,JSC</p>
                        <p class="mb-2">Công Ty Cổ phần Đại Sàn. GPĐKKD: 0103884103 do sở KH &amp; ĐT TP Hà Nội cấp lần đầu ngày 29/06/2009.</p>
                        <p class="mb-3">Trụ sở chính: 88 Láng Hạ, P. Láng Hạ, Q. Đống Đa, TP Hà Nội.</p>
                        <p>
                            <a href="http://online.gov.vn/Home/WebDetails/54203">
                                <img src="{$arg.img_gen}tb-bct.png" height="50">
                            </a>
                            <a href="http://online.gov.vn/Home/WebDetails/54203">
                                <img src="{$arg.img_gen}dk-bct.png" height="50">
                            </a>
                        </p>
                    </div>
                    <div class="col-xl-4">
                        <p class="text-b">MIỀN BẮC</p>
                        <p>Showroom: D11-47 KĐT Geleximco Lê Trọng Tấn, Hà Đông, Hà Nội</p>
                        <p>VPGD: D11-47 KĐT Geleximco Lê Trọng Tấn, Hà Đông, Hà Nội</p>
                        <p>Email: <a href="mailto:info@daisan.vn">info@daisan.vn</a></p>
                        <p class="text-b mt-3">MIỀN NAM</p>
                        <p>VPGD: 57/1c, Khu phố 1, P. An Phú Đông, Q.12</p>
                        <a class="hide">Điện thoại: 1900 98 98 36</a> Email: <a href="mailto:info@daisan.vn">info@daisan.vn</a>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <div class="footer-choose d-none">
        <div class="container-fluid">
            <div class="footer-choose-wrap d-flex justify-content-center">
                <div class="logo-footer">
                    <img src="{$arg.url_img}logo-white.png" height="30">
                </div>
                <div class="footer-choose-option-wrap">
                    <div class="fake-select select-lang">
                        <span class="icon-lang"></span> <span class="text-lang">Tiếng Việt - VI</span> <span class="up-down-arr"></span>

                    </div>
                    <div class="fake-select">
                        <span class="icon-money"></span> <span class="text-lang">đ
                            - Việt Nam đồng</span> <span class="up-down-arr"></span>
                    </div>
                    <div class="fake-select">
                        <span class="icon-co"></span> <span class="text-lang">Việt Nam</span> <span class="up-down-arr"></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-link">
        <div class="container-fluid">
            <div class="cate-banner-wrap">
                <div class="wrap-footer-col">
                    <div class="card-columns d-none d-sm-block">
                        {if count($tax.menu_foot_link) gt 0} {foreach from=$tax.menu_foot_link item=data}
                        <div class="card text-white bg-transparent">
                            <a href="{$data.url}">
                                {$data.name}
                                <br>
                                <span>{$data.title|default:''}</span>
                            </a>
                        </div>
                        {/foreach} {/if}
                    </div>

                    <!--end card-columns-->
                    <div class="pt-2 text-center">
                        <ul class="list-inline">
                            {if isset($tax.menu_foot_other) AND count($tax.menu_foot_other) gt 0} {foreach from=$tax.menu_foot_other item=v}
                            <li class="list-inline-item"><a href="{$v.url}"> {$v.name} </a></li>
                            {/foreach} {/if}
                            <li class="list-inline-item li_last">© 2009-2021, Daisan., JSC. or its affiliates</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="bottomNavbar bg-white d-block d-sm-none">
        <div class="row row-sm">
            <div class="col text-center">
                <a href="./" class="active"><span class="icon"><i class="fa fa-home" aria-hidden="true"></i></span>
                    <p>Home</p>
                </a>
            </div>
            <div class="col text-center">
                <a href="{$arg.url_helpcenter}"><span class="icon"><i class="fa fa-users" aria-hidden="true"></i></span>
                    <p>Hỗ trợ</p>
                </a>
            </div>
            <div class="col text-center">
                <a href="javascript:void(0)" data-toggle="modal" data-target="#exampleModal">
                    <span class="icon"><i class="fa fa-commenting" aria-hidden="true"></i></span>
                    <p>Liên hệ</p>
                </a>
            </div>
            <div class="col text-center">
                <a href="?mod=product&site=cart"><span class="icon"><i class="fa fa-shopping-cart"
                            aria-hidden="true"></i></span>
                    <p>Giỏ hàng</p>
                </a>
            </div>
            <div class="col text-center">
                <a href="?mod=account&site=index"><span class="icon"><i class="fa fa-user"
                            aria-hidden="true"></i></span>
                    <p>Tài khoản</p>
                </a>
            </div>
        </div>
    </div>
</footer>
<div class="modal fade show" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog  modal-lg" role="document">
        <div class="modal-content rounded-0">
            <div class="modal-header">
                <h5>Để lại số điện thoại, chúng tôi sẽ gọi lại tư vấn ngay</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body mt-0">
                <div class="row" id="FormSendContact">
                    <div class="col-md-5 col-12 text-center bg-col-left d-none d-sm-block">

                        <div class="pt-4">
                            <img src="https://daisan.vn/site/main/webroot/images/Img_From_Rfq.jpg">
                        </div>
                        <div>
                            <h4>Liên hệ tới chúng tôi</h4>
                            <ul class="timeline">
                                <li class="text-left">
                                    <p>Cho chúng tôi biết những gì bạn cần bằng cách điền vào biểu mẫu</p>
                                </li>
                                <li class="text-left">
                                    <p>Nhận chi tiết nhà cung cấp đã được xác minh</p>
                                </li>
                                <li class="text-left">
                                    <p>So sánh Báo giá và niêm phong thỏa thuận</p>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-7 col-12">
                        <div class="pb-4">
                            <select class="custom-select mb-3 rounded-0" name="location_id">
                                <option value="0">Toàn Quốc</option>
                                {foreach from=$tax.province item=v}
                                <option value="{$v.Id}">{$v.Name}</option>
                                {/foreach}
                            </select>
                            <textarea class="form-control rounded-0 mb-3" name="description" placeholder="Nội dung yêu cầu"></textarea>
                            <input type="number" class="form-control rounded-0" name="phone" placeholder="Nhập số điện thoại">
                        </div>
                        <button type="button" class="btn btn-primary btn-block btn-sendcontact" onclick="SendPhoneContact()">Gửi thông tin yêu cầu</button> {literal}
                        <script type="text/javascript" data-cfasync="false">
                        </script>
                        {/literal}
                        <div class="pt-3">
                            <h4 class="d-none d-sm-block">Tổng đài hỗ trợ trực tuyến</h4>
                            <ul class="timeline d-none d-sm-block">
                                <li class="text-left">
                                    <p>
                                        Tư vấn mua hàng (Miễn phí): 1900 98 98 36<br> <small>(Tư
                                            vấn, báo giá sản phẩm 8-21h kể cả T7, CN)</small>
                                    </p>
                                </li>
                                <li class="text-left">
                                    <p>
                                        Phòng IT: 0964.36.8282<br> <small>(Hỗ trợ 24/7.
                                            Đăng ký mở gian hàng trên hê thống)</small>
                                    </p>
                                </li>
                            </ul>
                            <hr>
                            <div class="row row-nm">
                                <div class="col-12">
                                    <a class="btn btn-block btn-danger rounded-pill mb-3 btn-lg call-now-detail-180" href="tel:1800646498">
                                        <i class="fa fa-phone"></i> Tư vấn mua hàng: 1900 98 98 36
                                    </a>
                                </div>
                                <div class="col-6">
                                    <a class="btn btn-block btn-outline-info rounded-pill" href="https://zalo.me/0986258282">
                                        <i class="fa fa-commenting-o"></i> Nhắn tin qua Zalo
                                    </a>
                                </div>
                                <div class="col-6">
                                    <a class="btn btn-block btn-outline-info rounded-pill" href="https://m.me/daisanvn">
                                        <i class="fa fa-commenting-o"></i> Nhắn tin Facebook
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
