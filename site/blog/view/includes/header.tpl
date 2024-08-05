<header>
    {if !$is_mobile}
    <div id="head_top" class="d-none d-sm-block">
        <div class="container-fluid">
            <nav class="navbar navbar-expand-lg">
                <button class="btn btn-menu hmenu-open" type="button">
                    <img src="/site/main/webroot/images/nav-menu-black.png" height="18">
                </button>
                <a class="navbar-brand logo" href="./"><img src="{$arg.logo|default:$arg.noimg}"></a>
                <div class="d-flex align-items-center ml-auto d-block d-sm-none">
                    <div class="p-2 bd-highlight">
                        {if $arg.login eq 0}
                        <a href="./login" class="">Đăng nhập </a> {else} Chào, <b><a
                                href="?mod=account&site=index">{$hcache.user.name|truncate:10}</a></b> {/if}
                    </div>
                    <div class="p-2 bd-highlight shoping-cart">
                        <a href="?mod=product&site=cart">
                            <span class="icon-menu"><img src="{$arg.url_img}cart-black.png" height="27">
                            </span> <span class="badge" id="cart-number-mb">0</span>
                        </a>
                    </div>
                </div>

                <div class="navbar-collapse" id="navbarSupportedContent">
                    <div class="form-search input-group my-2 my-lg-0">
                        <input type="hidden" id="filter_cate_id" value="{$main_filter.t|default:0}">
                        <button class="open-cate" id="open-cate">{$main_filter.t_txt|default:'Tất cả'} <i
                                class="fa fa-caret-down"></i></button>
                        <input class="form-control" type="text" id="search_key" value="{$smarty.get.key|default:''}" placeholder="Nhập từ khóa tìm kiếm" oninput="onChangeSeach(this.value)" ;>
                        <span class="search-clear"><img src="{$arg.stylesheet}images/remove-key.svg" width="15"></span>
                        <button class="btn search-btn" type="button" onclick="search();"><i
                                class="fa fa-search fa-fw"></i></button> {include file="../includes/suggest.tpl"}
                    </div>
                    <ul class="head_top--right navbar-nav ml-auto nav-right">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <p class="mb-0"><span>Chào, {$hcache.user.name|default:'Đăng nhập'}</span></p>
                                Tài khoản của tôi
                            </a>
                            <div class="dropdown-menu dropdown-menu-hover dropdown-menu-right" aria-labelledby="bd-versions">
                                {if $arg.login eq 0}
                                <a class="btn btn-warning btn-block mt-3" href="https://daisan.vn/login">Đăng nhập tài
                                    khoản</a>
                                <a class="btn btn-secondary btn-block mb-3" href="https://daisan.vn/?mod=account&site=register">Đăng ký
                                    tài khoản</a>
                                <a href="{$btn_fb_login}" class="btn btn-secondary btn-block btn-login-facebook"><i
                                        class="fa fa-facebook-square cl-blue fz32"></i> Đăng nhập facebook</a>
                                <a href="javascript:void(0)" id="customBtn" class="btn btn-secondary btn-block mb-3 btn-login-google"><i
                                        class="fa fa-google"></i> Đăng nhập Google</a> {else}
                                <a class="dropdown-item" href="?mod=account&site=orders">Quản lý mua hàng
                                    <!-- <span class="pull-right">3</span> -->
                                </a>
                                <a class="dropdown-item" href="{$arg.url_helpcenter}">Chính sách vận chuyển</a>
                                <a class="dropdown-item" href="{$arg.url_helpcenter}">Dịch vụ khách hàng</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="?mod=account&site=pages">Gian hàng bán</a>
                                <a class="dropdown-item" href="./newshop">Khởi tạo gian hàng mới</a>
                                <a class="dropdown-item" href="?mod=account&site=rfq">Yêu cầu báo giá</a>
                                <a class="dropdown-item" href="?mod=account&site=index">Tài khoản của tôi</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="?mod=account&site=logout">Đăng xuất</a> {/if}
                            </div>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="https://daisan.vn/?mod=account&site=orders">
                                <p class="mb-0"><span>Quản lý</span></p>
                                Đơn hàng
                            </a>
                        </li>
                        <li class="nav-item nav-cart">
                            <a class="nav-link" href="https://daisan.vn/cart">
                                <img src="https://daisan.vn/site/upload/images/cart-black.png" height="30">
                                <span class="cart-number" id="cart-number">0</span> Cart
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
    {/if}

    <div class="container">
        <div class="menu">
            <ul class="nav">
                <li class="nav-item active"><a href="{$arg.url_blog}">Mới nhất</a></li>
                {foreach from=$a_main_category key=k item=v}
                <li class="nav-item"><a class="nav-link " href="{$v.url}">{$v.name}</a></li>
                {/foreach}
            </ul>
        </div>
    </div>
    {if $is_mobile}
    <div class="mmenu">
        <ul class="nav">
            <li class="nav-item ">
                <a class="nav-link " href="./"><img src="{$arg.stylesheet}images/logo-daisan.png" width="28"></a>
            </li>
            <li class="nav-item active "><a class="nav-link " href="./blog">Mới nhất</a></li>
        </ul>
        <ul class="nav">
            <li class="nav-item">
                <a class="nav-link clicksearch " href="# "><i class="fa fa-search" aria-hidden="true"></i></a>
            </li>
            <li class="nav-item">
                <a class="nav-link showmmenu" href="javascript:void(0)"><i class="fa fa-bars"
                        aria-hidden="true"></i></a>
            </li>
        </ul>
        <div class="sub-mmenu hide">
            <form class="form-inline mt-2 mt-md-0">
                {foreach from=$a_main_category key=k item=v}
                <li class="col-6">
                    <a href="{$v.url}">{$v.name}</a>
                </li>
                {/foreach}
            </form>
        </div>
        <div class="mainsearch hide">
            <form class="form-inline mt-2 mt-md-0">
                <input class="form-control mr-2 w-75" type="text" placeholder="Nhập từ khóa tìm kiếm" id="search_key" value="{$smarty.get.key|default:''}">
                <button class="btn bg-warning my-2 my-sm-0" type="button" onclick="search();">Find</button>
            </form>
        </div>
    </div>
    {/if}
</header>
<input type="hidden" value="{$out.url}" id="url_redirect">
<input type="hidden" value="{$arg.client_id}" id="google_login_id">
<script src="https://apis.google.com/js/api:client.js"></script>
{literal}
<script>
    var googleUser = {};
    var google_login_id = $("#google_login_id").val();
    var startApp = function() {
        gapi.load('auth2', function() {
            auth2 = gapi.auth2.init({
                client_id: google_login_id,
                cookiepolicy: 'single_host_origin',
            });
            onSignInGoogle(document.getElementById('customBtn'));
            onSignInGoogle(document.getElementById('customBtn1'));
        });
    };

    function onSignInGoogle(element) {
        auth2.attachClickHandler(element, {},
            function(googleUser) {
                var datalogin = {};
                console.log(googleUser);
                datalogin.id = googleUser.getBasicProfile().getId();
                datalogin.name = googleUser.getBasicProfile().getName();
                datalogin.avatar = googleUser.getBasicProfile().getImageUrl();
                datalogin.email = googleUser.getBasicProfile().getEmail();
                datalogin.action = 'ajax_login_google';
                $.post("?mod=account&site=login", datalogin).done(function(e) {
                    var rt = JSON.parse(e);
                    if (rt.code == 0) {
                        noticeMsg('Thông báo', rt.msg, 'error');
                        endloading();
                        return false;
                    } else {
                        noticeMsg('Thông báo', 'Đăng nhập thành công.', 'success');
                        endloading();
                        var url_redirect = $("#url_redirect").val();
                        var url_fr = $("#url_fr").val();
                        if (rt.Token && rt.Token != '' && url_fr != '') url_redirect += '&token=' + rt.Token;
                        location.href = url_redirect;
                        location.reload();
                    }
                });
            });
    }
    startApp();
</script>
{/literal}