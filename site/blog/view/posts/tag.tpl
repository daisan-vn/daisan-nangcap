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
    <li class="newsitem">
        <a href="#">
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
    {foreach from=$result key=k item=v} {if $k gt 6 && $k lt 20}
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
{if $out.number gt 20}
<a href="javascript:; " onclick="More(this) " class="viewmore ">Xem thêm <b></b></a> {/if}