<ul class="newslist">
    {foreach from=$result key=k item=v}
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
    {/foreach}
</ul>