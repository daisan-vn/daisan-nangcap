<div id="hmenu" class="">
    <div id="hmenu-bg">
        <span class="hmenu-close"><i class="fa fa-remove"></i></span>
    </div>
    <div id="hmenu-canvas">
        <div id="hmenu-header">
            {if $arg.login eq 0}
            <a href="{$arg.url_account}login/?token={$arg.login_token}">
                <i class="fa fa-user-circle-o"></i>
                <span>Hi, Vui lòng đăng nhập</span>
            </a>
            {else}
            <a href="{$arg.url_account}">
                <i class="fa fa-user-circle-o"></i>
                <span>Hi, {$hcache.user.name}</span>
            </a>
            {/if}
        </div>
        <div id="hmenu-content">
            {if $is_mobile}
            <ul class="hmenu hmenu-translateX-left" data-id="1">
                <li>
                    <a class="hmenu-item" data-id="2">
                       <i class="fa fa-bars fa-fw" aria-hidden="true"></i>Tất cả danh mục
                        <span class="pull-right"><i class="fa fa-chevron-right"></i></span>
                    </a>
                </li>
                <li>
                    <a class="hmenu-item" href="./event/">
                        <i class="fa fa-bolt fa-fw" aria-hidden="true"></i>Daily deals
                    </a>
                </li>
                <li>
                    <a class="hmenu-item" href="./product/toprank">
                        <i class="fa fa-bookmark-o fa-fw" aria-hidden="true"></i>Xu hướng
                    </a>
                </li>
                <li>
                    <a class="hmenu-item" href="{$arg.url_blog}">
                        <i class="fa fa-newspaper-o fa-fw" aria-hidden="true"></i>&nbsp;Blog
                    </a>
                </li>
                <li>
                    <a class="hmenu-item" href="{$arg.url_account}create/">
                        <i class="fa fa-users fa-fw" aria-hidden="true"></i>Tham gia bán trên Daisan
                    </a>
                </li>
                <li>
                    <div class="hmenu-item hmenu-title">Tài khoản</div>
                </li>
                <li><a class="hmenu-item" href="{$arg.url_account}login"><i class="fa fa-user-o fa-fw" aria-hidden="true"></i>Tài khoản của tôi</a></li>
                <li><a class="hmenu-item" href="{$arg.url_account}orders/"><i class="fa fa-shopping-cart fa-fw" aria-hidden="true"></i>Đơn mua hàng</a></li>
                <li><a class="hmenu-item" href="{$arg.url_account}rfq/"><i class="fa fa-podcast fa-fw" aria-hidden="true"></i>Yêu cầu báo giá</a></li>
                <li><a class="hmenu-item" href="{$arg.url_helpcenter}"><i class="fa fa-question-circle fa-fw" aria-hidden="true"></i>Trung tâm trợ giúp</a></li>
                {if $arg.login neq 0}
                <li><a class="hmenu-item" href="{$arg.url_account}logout/?token={$arg.login_token}"><i class="fa fa-sign-out fa-fw" aria-hidden="true"></i>Đăng xuất</a></li>
                {/if}
            </ul>
            <ul class="hmenu hmenu-translateX-left" data-id="2">
                <li><a class="hmenu-item hmenu-back"><i class="fa fa-arrow-left"></i> MAIN MEMU</a></li>
                {foreach from=$a_main_category item=v}
                <li>
                    <a class="hmenu-item" data-id="{$v.id}">
                        {$v.name}
                        <span class="pull-right"><i class="fa fa-chevron-right"></i></span>
                    </a>
                </li>
                {/foreach}
            </ul>
            {foreach from=$a_main_category item=v} 
            <ul class="hmenu hmenu-translateX-left" data-id="{$v.id}">
                <li><a class="hmenu-item" data-id="2"><i class="fa fa-arrow-left"></i> <b>TẤT CẢ DANH MỤC</b></a></li>
                <li>
                    <div class="hmenu-item hmenu-title"><a href="{$v.url}" class="text-dark">{$v.name}</a></div>
                </li> {foreach from=$v.sub item=s2} <li><a class="hmenu-item" data-id="{$s2.id}">{$s2.name}<span
                            class="pull-right"><i class="fa fa-chevron-right"></i></span></a></li> {/foreach}
            </ul> 
            {/foreach}
            {/if} {if !$is_mobile}
            <ul class="hmenu hmenu-translateX-left" data-id="1">
                {foreach from=$a_main_category item=v}
                <li>
                    <div class="hmenu-item hmenu-title"><a href="{$v.url}" class="text-dark">{$v.name}</a></div>
                </li>
                {foreach from=$v.sub key=k1 item=s1} {if $k1 lt 3}
                <li>
                    <a class="hmenu-item" data-id="{$s1.id}">
                        {$s1.name}
                        <span class="pull-right"><i class="fa fa-chevron-right"></i></span>
                    </a>
                </li>
                {/if} {/foreach} {if count($v.sub) gt 3}
                <div class="collapse" id="more{$v.id}">
                    {foreach from=$v.sub key=k1 item=s1} {if $k1 gte 3}
                    <li>
                        <a class="hmenu-item" data-id="{$s1.id}">
                            {$s1.name}
                            <span class="pull-right"><i class="fa fa-chevron-right"></i></span>
                        </a>
                    </li>
                    {/if} {/foreach}
                </div>
                <li><a type="button" class="hmenu-item hmenu-more" data-toggle="collapse" href="#more{$v.id}" role="button" aria-expanded="false">
                        Xem tất cả <i class="fa fa-chevron-down"></i>
                    </a>
                </li>
                {/if}
                <li class="hmenu-separator"></li>
                {/foreach}
                <li>
                    <div class="hmenu-item hmenu-title">Tài khoản</div>
                </li>
                <li><a class="hmenu-item" href="{$arg.url_account}login">Tài khoản của tôi</a></li>
                <li><a class="hmenu-item" href="{$arg.url_account}orders/">Đơn mua hàng</a></li>
                <li><a class="hmenu-item" href="{$arg.url_account}shops/">Gian hàng bán</a></li>
                <li><a class="hmenu-item" href="{$arg.url_account}create/">Tạo gian hàng</a></li>
                <li><a class="hmenu-item" href="{$arg.url_account}rfq/">Yêu cầu báo giá</a></li>
                <li><a class="hmenu-item" href="{$arg.url_helpcenter}">Trung tâm trợ giúp</a></li>
                {if $arg.login neq 0}
                <li><a class="hmenu-item" href="{$arg.url_account}logout/?token={$arg.login_token}">Đăng xuất</a></li>
                {/if}
            </ul>
            {/if} {foreach from=$a_main_category item=v} {foreach from=$v.sub item=s1}
            <ul class="hmenu hmenu-translateX-right" data-id="{$s1.id}">
                <li><a class="hmenu-item hmenu-back"><i class="fa fa-arrow-left"></i> MAIN MEMU</a></li>
                <li>
                    <div class="hmenu-item hmenu-title"><a href="{$v.url}" class="text-dark">{$s1.name}</a></div>
                </li>
                {foreach from=$s1.sub item=s2}
                <li><a class="hmenu-item" href="{$s2.url}">{$s2.name}</a></li>
                {/foreach}
            </ul>
            {/foreach} {/foreach}
        </div>
    </div>
</div>

<script>
    $('a.hmenu-item').click(function() {
     var data_id = $(this).attr('data-id');
     if (data_id && data_id != 0) {
         if (data_id == 2) {
             $('ul.hmenu[data-id]').addClass('hmenu-translateX-left');
             $('ul.hmenu[data-id]').removeClass('hmenu-visible');
             $('ul.hmenu[data-id]').removeClass('hmenu-translateX');
             $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-visible');
             $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-translateX');
             $('ul.hmenu[data-id=' + data_id + ']').removeClass('hmenu-translateX-right');
         } else {
             $('ul.hmenu[data-id]').addClass('hmenu-translateX-left');
             $('ul.hmenu[data-id]').removeClass('hmenu-visible');
             $('ul.hmenu[data-id]').removeClass('hmenu-translateX');
             $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-visible');
             $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-translateX');
             $('ul.hmenu[data-id=' + data_id + ']').removeClass('hmenu-translateX-right');
         }
     }
 });
 
     $('a.hmenu-back').click(function() {
         var data_id = $(this).parent().parent().attr('data-id');
 
         if (data_id && data_id != 0) {
             $('ul.hmenu[data-id=1]').addClass('hmenu-visible');
             $('ul.hmenu[data-id=1]').addClass('hmenu-translateX');
             $('ul.hmenu[data-id=1]').removeClass('hmenu-translateX-left');
 
             $('ul.hmenu[data-id=' + data_id + ']').removeClass('hmenu-visible');
             $('ul.hmenu[data-id=' + data_id + ']').removeClass('hmenu-translateX');
             $('ul.hmenu[data-id=' + data_id + ']').addClass('hmenu-translateX-right');
         }
     });
     $('#hmenu .hmenu-close').click(function() {
         $('ul.hmenu').addClass('hmenu-translateX-left');
         $('ul.hmenu').removeClass('hmenu-visible');
         $('ul.hmenu').removeClass('hmenu-translateX');
 
         $('#hmenu').removeClass('hmenu-visible');
         $('#hmenu-bg').removeClass('hmenu-opaque');
         $('body').removeClass('lock-position');
     });
     $('.hmenu-open').click(function() {
         $('ul.hmenu[data-id=1]').removeClass('hmenu-translateX-left');
         $('ul.hmenu[data-id=1]').addClass('hmenu-visible');
         $('ul.hmenu[data-id=1]').addClass('hmenu-translateX');
 
         $('#hmenu').addClass('hmenu-visible');
         $('#hmenu-bg').addClass('hmenu-opaque');
         $('body').addClass('lock-position');
     });
     $('.hmenu-more').click(function() {
         var t = $(this).attr('aria-expanded');
         if (!t || t == 'false') {
             $(this).html('Thu gọn <i class="fa fa-chevron-up"></i>');
         } else {
             $(this).html('Xem tất cả <i class="fa fa-chevron-down"></i>');
         }
     });
 </script>
 