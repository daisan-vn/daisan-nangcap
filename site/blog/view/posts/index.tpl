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
    {foreach from=$result key=k item=v} {if $k gt 6}
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
<input type="hidden" value="{$out.id}" name="taxonomy_id"> {if $out.number gt 20}
<a href="javascript:; " onclick=LoadMore(this) class="viewmore ">Xem thêm <b></b></a> {/if}
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
        var taxonomy_id = $("input[name=taxonomy_id]").val();
        if (!page || page <= 1) page = 2;
        if (stop == 1) {
            return false;
        }
        number = (page - 1) * 20 + 20;
        data = {};
        data.page = page;
        data.taxonomy_id = taxonomy_id;
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