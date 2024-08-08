<div id="search_buttom">
    <a href="javascript:void(0);">
        <i class="fa fa-search"></i>
    </a>
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
                                <img src="https://daisan.vn/site/upload/generals/tb-bct.png" height="50">
                            </a>
                            <a href="http://online.gov.vn/Home/WebDetails/54203">
                                <img src="https://daisan.vn/site/upload/generals/dk-bct.png" height="50">
                            </a>
                        </p>
                    </div>
                    <div class="col-xl-4">
                        <p class="text-b">MIỀN BẮC</p>
                        <p>Showroom: Số 40 Tố Hữu, Nhân Chính, Thanh Xuân, Hà Nội</p>
                        <p>VPGD: Tầng 2, VOCARIMEX, Số 8, Cát Linh, Đống Đa, Hà Nội</p>
                        <p>Email: <a href="mailto:info@daisan.vn">info@daisan.vn</a></p>
                        <p class="text-b mt-3">MIỀN NAM</p>
                        <p>VPGD: 278/1 Phạm Văn Chiêu, P.9, Q. Gò Vấp, Hồ Chí Minh</p>
                        <a class="hide">Điện thoại: 1800 6464 98 (028)
							226.58.999</a> Email: <a href="mailto:info@daisan.vn">info@daisan.vn</a>
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
                            <img src="https://daisan.vn/site/themes/webroot/images/Img_From_Rfq.jpg">
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
                        <button type="button" class="btn btn-primary btn-block btn-sendcontact" onclick="SendPhoneContact()">Gửi thông tin yêu cầu</button>

                        <div class="pt-3">
                            <h4 class="d-none d-sm-block">Tổng đài hỗ trợ trực tuyến</h4>
                            <ul class="timeline d-none d-sm-block">
                                <li class="text-left">
                                    <p>
                                        Tư vấn mua hàng (Miễn phí): 1800 6464 98<br> <small>(Tư
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
                                    <a class="btn btn-block btn-danger rounded-pill mb-3 btn-lg" href="tel:1800646498">
                                        <i class="fa fa-phone"></i> Tư vấn mua hàng: 1800 6464 98
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
