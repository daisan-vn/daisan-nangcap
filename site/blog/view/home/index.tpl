<ul class="newslist latest">
    {foreach from=$result key=k item=v} {if $k eq 0}
    <li class="newsitem">
        <a href="{$v.url}">
            <img width="100 " height="70 " src="{$v.avatar}"></a>
        <h3 class="newsitem__title ">
            <a href="{$v.url}">{$v.title}</a>
        </h3>
        <figure class="d-none d-sm-block ">
            {$v.description}
        </figure>
        <div class="newsitem__timepost ">
            <span>{$v.created|date_format:'%d-%m-%Y
				%H:%M'}</span>
        </div>
        </a>
    </li>
    {/if} {if $k eq 1}
    <li class="newsitem d-none d-sm-block">
        <a href="{$v.url}">
            <img width="100 " height="70 " src="{$v.avatar}"></a>
        <h3 class="newsitem__title ">
            <a href="{$v.url}">{$v.title}</a>
        </h3>
        <div class="newsitem__timepost ">
            <span>{$v.created|date_format:'%d-%m-%Y
				%H:%M'}</span>
        </div>
        </a>
    </li>
    <li class="newsitem d-block d-sm-none">
        <a href="{$v.url}" class="newsitem__img">
            <img width="100 " height="70 " src="{$v.avatar}">
        </a>
        <h3 class="newsitem__title ">
            <a href="{$v.url}">
				{$v.title}
			</a>
        </h3>
    </li>
    {/if} {if $k gt 1 && $k lt 5}
    <li class="newsitem">
        <a href="{$v.url}" class="newsitem__img d-block d-sm-none">
            <img width="100 " height="70 " src="{$v.avatar}">
        </a>
        <h3 class="newsitem__title ">
            <a href="{$v.url}">
				{$v.title}
			</a>
        </h3>
    </li>
    {/if} {/foreach}
</ul>
<ul class="newslist" id="mainlist">
    {foreach from=$result key=k item=v} {if $k ge 5 && $k lt 12}
    <li class="newsitem">
        <a href="{$v.url}">
            <div class="newsitem__img">
                <img width="100 " height="70 " src="{$v.avatar}">
            </div>

            <h3 class="newsitem__title ">
                {$v.title}
            </h3>
            <div class="newsitem__timepost">
                <span>{$v.created|date_format:'%d-%m-%Y
					%H:%M'}</span>
            </div>
        </a>
    </li>
    {/if} {/foreach}
    <li>
        <div class="swiper-container newsvideo ">
            <div class="block-head p1 d-flex justify-content-between ">
                <h2>{$taxs.p1.name}</h2>
            </div>
            <div class="swiper-wrapper ">
                {foreach from=$taxs.p1.posts item=v}
                <div class="swiper-slide ">
                    <a href="{$v.url}" rel="nofollow " target="_blank "><img src="{$v.avatar}"></a>
                    <div class="newsvideo__item ">
                        <h3><a href="{$v.url}" class="text-white ">
								{$v.title}</a></h3>
                    </div>
                </div>
                {/foreach}
            </div>
            <!-- If we need pagination -->
            <div class="swiper-pagination "></div>
        </div>
    </li>
    {foreach from=$result key=k item=v} {if $k ge 12}
    <li class="newsitem">
        <a href="{$v.url}">
            <div class="newsitem__img">
                <img width="100 " height="70 " src="{$v.avatar}">
            </div>

            <h3 class="newsitem__title ">
                {$v.title}
            </h3>
            <div class="newsitem__timepost">
                <span>{$v.created|date_format:'%d-%m-%Y
					%H:%M'}</span>
            </div>
        </a>
    </li>
    {/if} {/foreach}
</ul>
<div id="Loaddb"></div>
<input type="hidden" value="{$out.number}" name="number_all">
<a href="javascript:; " onclick=LoadMore(this) class="viewmore ">Xem thêm <b></b></a>
<script>
    var page = 2;
    var stop = 0;


    $(window).scroll(function() {
        var h = parseInt($(document).height() - $(window).height());
        if (parseInt($(window).scrollTop()) == h) {
            LoadMore();
        }
    });

    function LoadMore() {
        var number_all = $("input[name=number_all]").val();
        if (!page || page <= 1) page = 2;
        if (stop == 1) {
            return false;
        }
        number = (page - 1) * 20 + 20;
        data = {};
        data.page = page;

        loading();
        $.post("?mod=home&site=load_more", data).done(function(e) {
            if (e) {
                $('#Loaddb').append(e);
                if (number > number_all) $('.viewmore').addClass('d-none');
            } else stop = 1;

            page = page + 1;
            endloading();
        });
    }
</script>