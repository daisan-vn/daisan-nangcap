{foreach from=$result item=data}
<div class="row row-no post_item mb-3">
    <div class="col-md-2">
        <p class="card-text">
            <span class="text-secondary">{$data.created|date_format:"%A,
				%B %e, %Y"}</span>
        </p>
    </div>
    <div class="col-md-7 col-7">
        <h3 class="post_title text-lg text-mbig text-b">
            <a href="{$data.url}" class="text-dark">{$data.title}</a>
        </h3>
    </div>
    <div class="col-md-3 col-5">
        <a href="{$data.url}"><img src="{$data.avatar}" class="img-fluid pl-2"></a>
    </div>
</div>
{/foreach}