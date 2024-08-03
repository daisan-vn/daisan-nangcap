<div class="main-content-wrap bg-white">
    <div class="container-fluid">
        <div class="row row-nm">
            <div class="col-xl-2">
                <div class="card filter border-0">
                    <div class="card-body">
                        <div class="left-filters__filter-wrapper">
                            <h3>Categories</h3>
                            <ul class="nav flex-column collapse" id="collapseFilter" aria-expanded="false">
                                {foreach from=$a_main_category key=k item=v}
                                <li><a href="?mod=page&site=index&cat={$v.id}">{$v.name}</a></li>
                                {/foreach}
                            </ul>
                            <a role="button" class="collapsed" data-toggle="collapse" href="#collapseFilter" aria-expanded="false" aria-controls="collapseExample"></a>
                        </div>
                        <div class="ads-google">
                            <!-- Ads Page Supplier Left Daisanvn -->
                            <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-7751440498976455" data-ad-slot="4944644611" data-ad-format="auto" data-full-width-responsive="true"></ins>
                            <script>
                                (adsbygoogle = window.adsbygoogle || []).push({});
                            </script>
                        </div>
                        <!-- <div class="revenue left-filters__filter-wrapper">
							<h3>Doanh thu</h3>
							{$out.checkbox_revenue}
						</div>
						<div class="memnumber left-filters__filter-wrapper my-3">
							<h3>Nhân sự</h3>
							{$out.checkbox_memnumber}
						</div> -->
                    </div>
                </div>
            </div>
            <div class="col-xl-8">
                <div class="search-result__content">
                    <div class="">
                        <nav aria-label="breadcrumb" style="line-height: 25px;padding-top:20px">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="./supplier">Nhà cung cấp</a></li>
                                <li class="breadcrumb-item">
                                    <div class="input-group mb-3">
                                        <input type="text" class="form-control form-control-sm" id="filter_key" placeholder="Từ khóa" value="{$filter.key|default:''}" onchange="filter()">
                                        <div class="input-group-append">
                                            <span class="input-group-text"><i class="fa fa-search"></i></span>
                                        </div>
                                    </div>
                                </li>
                                <li class="breadcrumb-item">{$out.number|default:0} nhà được tìm thấy</li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <ul class="nav nav-tabs">
                            <li class="nav-item">
                                <a class="nav-link text-nm-1 text-b active" href="javascript:void(0)">Bộ Lọc Nhà Cung
									Cấp</a>
                            </li>
                        </ul>
                        <div class="border border-top-0">
                            <div class="d-flex flex-row bd-highlight py-3 px-2">
                                <div class="p-2 bd-highlight">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="gold" {if $filter.gold}checked{/if} onchange="filter()">
                                        <label class="form-check-label" for="gold">Gold Supplier</label>
                                    </div>
                                </div>
                                <div class="p-2 bd-highlight">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="verify" {if $filter.verify}checked{/if} onchange="filter()">
                                        <label class="form-check-label" for="verify">Đã xác minh bởi Daisan</label>
                                    </div>
                                </div>
                                <div class="p-2 bd-highlight">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="oem" {if $filter.oem}checked{/if} onchange="filter()">
                                        <label class="form-check-label" for="oem">Đơn vị gia công (OEM)</label>
                                    </div>
                                </div>
                                <!-- <div class="p-2 bd-highlight">
									<div class="form-check form-check-inline">
										<label class="form-check-label" for="inlineCheckbox1">Sort By</label>
										<div class="nav-item dropdown">
											<a class="px-2 dropdown-toggle" data-toggle="dropdown" href="#"
												role="button" aria-haspopup="true" aria-expanded="false">Dropdown</a>
											<div class="dropdown-menu">
												<a class="dropdown-item" href="#">Best Match</a>
												<a class="dropdown-item" href="#">Response Rate</a>
											</div>
										</div>
									</div>
								</div> -->
                                <div class="p-2 bd-highlight ml-auto">
                                    <a data-toggle="collapse" href="#Province">
										Tỉnh/thành phố<i class="fa fa-angle-down fa-fw" aria-hidden="true"></i>
									</a>
                                </div>

                            </div>
                            <div class="collapse" id="Province">
                                <div class="p-3 pl-5">
                                    <ul class="nav row row-sm">
                                        {foreach from=$tax.province key=k item=v}
                                        <li class="col-xl-2 col-6">
                                            <input class="form-check-input" type="checkbox" value="{$v.Id}" {if in_array($v.Id,$filter.a_province)}checked{/if}> {$v.Name}
                                        </li>
                                        {/foreach}
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="ads-google">
                            <!-- Ads Page Supplier Daisan.vn Ngang -->
                            <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-7751440498976455" data-ad-slot="3054824354" data-ad-format="auto" data-full-width-responsive="true"></ins>
                            <script>
                                (adsbygoogle = window.adsbygoogle || []).push({});
                            </script>
                        </div>
                        {foreach from=$result item=data}
                        <div class="supplier-item-info">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <h3 class="text-lg m-0"><a href="{$data.url}">{$data.name}</a></h3>
                                    <nav class="nav ml-auto">
                                        <a class="nav-link text-dark" href="javascript:void(0)" onclick="SetPageFavorite({$data.id});"><i class="fa fa-star-o fa-fw"
												aria-hidden="true"></i>Yêu thích</a>
                                    </nav>
                                </div>
                                <div class="tag-list py-2">
                                    <i class="fa fa-clock-o col-yearexp"></i>
                                    <span class="join-year">
										<b class="value">{$data.yearexp}</b> Năm hoạt động</span> {if $data.package_id ne 0}
                                    <i class="fa fa-gg-circle col-gold ml-3"></i>
                                    <span>Gold Supplier</span> {/if} {if $data.is_verification ne 0}
                                    <i class="fa fa-check col-verify-1 ml-3"></i>
                                    <span class="col-verify">Đã xác minh</span> {/if} {if $data.is_oem ne 0}
                                    <i class="fa fa-share-alt col-gold ml-3"></i>
                                    <span>OEM</span> {/if}
                                </div>
                                <div class="row row-sm">
                                    <div class="col-xl-4">
                                        <div class="row row-nm">
                                            {foreach from=$data.metas key=k item=v} {if $k lt 3}
                                            <div class="col-xl-4 col-4">
                                                <a href="{$v.url}" class="border d-block"><img src="{$v.avatar}" class="img-fluid"></a>
                                                <p class="line-3 mt-2"><a href="{$v.url}" class="text-dark">{$v.name}</a></p>
                                            </div>
                                            {/if} {/foreach}
                                        </div>
                                    </div>
                                    <div class="col-xl-8">
                                        <div class="attrs">
                                            <div class="attr">
                                                <span class="name">Chỉ số đánh giá:</span>
                                                <div class="value">
                                                    <img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png">
                                                    <img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png"> {if $data.yearexp gt 3}
                                                    <img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png"> {/if} {if $data.package_id ne 0}
                                                    <img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png"> {/if} {if $data.is_verification ne 0}
                                                    <img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png"> {/if}
                                                </div>
                                            </div>

                                            <div class="attr">
                                                <span class="name">Sản phẩm chính:</span>
                                                <div class="value ellipsis ph">
                                                    <span class="d-block line-1">
														{if count($data.metas)}
														{foreach from=$data.metas key=k item=v}{$v.name}, {/foreach}
														{else}
														Đang cập nhật
														{/if}
													</span>
                                                </div>
                                            </div>
                                            <div class="attr">
                                                <span class="name">Địa điểm:</span>
                                                <div class="value">
                                                    <span class="ellipsis search" data-coun="CN">{$data.address}</span>
                                                </div>
                                            </div>
                                            <div class="attr">
                                                <span class="name">Doanh thu:</span>
                                                <div class="value" title="">
                                                    <span class="ellipsis search" data-reve="AR2">{$data.revenue|default:'Đang cập nhật'}</span>
                                                </div>
                                            </div>
                                            <div class="attr">
                                                <span class="name">Top 3 thị trường:</span>
                                                <div class="value" title="">
                                                    <span class="ellipsis search" data-mark="TR2">South America
														50%</span> ,&nbsp;
                                                    <span class="ellipsis search" data-mark="TR32">Southeast
														Asia
														15%</span> ,&nbsp;
                                                    <span class="ellipsis search" data-mark="TR4">Western
														Europe
														15%</span>
                                                </div>
                                            </div>
                                            <div class="attr mt-3">
                                                <div class="name">&nbsp;</div>
                                                <div class="value" title="">
                                                    <a href="{$data.url_contact}" class="btn btn-contact"><i
															class="fa fa-envelope-o fa-fw"></i>Liên hệ nhà cung cấp</a>
                                                    <a href="{$data.url}" class="btn ml-2 btn-chat">Vào gian hàng</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                        <!--supplier-item-info-->
                    </div>
                </div>
                <!--end media-->
            </div>
            <div class="col-xl-2 pt-5">
                <h3 class="text-lg text-b">Gợi ý cho bạn</h3>
                <div class="card">
                    <div class="card-body" id="page_product_justforyou"></div>
                </div>
            </div>
        </div>
        <div class="filter__search-pagination mb-3">
            <div class="card card-body border-0">
                {$paging}
            </div>
        </div>
    </div>
</div>

<input type="hidden" value="{$out.url}" id="filter_url">

<script type="text/javascript">
    $(window).ready(function() {
        setTimeout(function() {
            $('#page_product_justforyou').load('?mod=product&site=load_just_for_you&limit=10&action=for_page&location=' + arg.id_location);
        }, 600);
        $(".memnumber input[type=checkbox]").click(function() {
            var arr = [];
            $(".memnumber input[type=checkbox]").each(function() {
                if ($(this).is(':checked')) {
                    var value = $(this).val();
                    arr.push(value);
                }
            });

            var filter_checkbox = arr.toString();
            var url = set_filter();
            url = (filter_checkbox != '') ? url + "&memnumber=" + filter_checkbox : url;
            location.href = url;
        });

        $(".revenue input[type=checkbox]").click(function() {
            var arr = [];
            $(".revenue input[type=checkbox]").each(function() {
                if ($(this).is(':checked')) {
                    var value = $(this).val();
                    arr.push(value);
                }
            });

            var filter_checkbox = arr.toString();
            var url = set_filter();
            url = (filter_checkbox != '') ? url + "&revenue=" + filter_checkbox : url;
            location.href = url;
        });

        $("#Province input[type=checkbox]").click(function() {
            var arr = [];
            $("#Province input[type=checkbox]").each(function() {
                if ($(this).is(':checked')) {
                    var value = $(this).val();
                    arr.push(value);
                }
            });

            var filter_checkbox = arr.toString();
            var url = set_filter();
            url = (filter_checkbox != '') ? url + "&location=" + filter_checkbox : url;
            location.href = url;
        });
    });

    function filter() {
        var url = set_filter();
        location.href = url;
    }

    function set_filter() {
        var url = $("#filter_url").val();
        var gold = ($('#gold').is(':checked')) ? 1 : 0;
        var verify = ($('#verify').is(':checked')) ? 1 : 0;
        var oem = ($('#oem').is(':checked')) ? 1 : 0;
        var k = $("#filter_key").val();

        url = url + "?type=search";
        if (gold == 1) url += '&gold=1';
        if (verify == 1) url += '&verify=1';
        if (oem == 1) url += '&oem=1';
        url = (k != '') ? url + "&k=" + k : url;
        return url;
    }

    function SetPageFavorite(id) {
        if (arg.login == 0) {
            noticeMsg('System Message', 'Vui lòng đăng nhập trước khi thực hiện chức năng này.', 'warning');
            return false;
        }
        var data = {};
        data['id'] = id;
        data['ajax_action'] = 'set_page_favorite';
        loading();
        $.post('?mod=page&site=ajax_handle', data).done(function(e) {
            data = JSON.parse(e);
            if (data.code == 1) {
                $("#BtnFavorite" + id).remove();
                noticeMsg('System Message', data.msg, 'success');
            } else noticeMsg('System Message', data.msg, 'error');

            endloading();
        });
    }
</script>