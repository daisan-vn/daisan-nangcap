{foreach from=$result key=k item=v}
<div class="product-card card border-0">
    <a href="{$v.url}" class="product-card__img-field">
        <div class="product-card__img-field-inner">
            <img src="{$v.avatar}" class="img-fluid ">
        </div>
    </a>
    <div class="product-card__body">
        <h3 class="text-nm-1">
            <a href="{$v.url}" target="_blank" class="text-twoline text-dark"><img src="{$arg.stylesheet}images/icons/icon-super.png" height="16">{$v.name}</a>
        </h3>
        <div class="product-item-price text-oneline">
            <b>{$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if}</b> {if $v.price neq 0}<span class="unit">/ {$v.unit}</span>{/if}
        </div>
        <p class="product-item-order">{$v.minorder} {$v.unit} (Tối thiểu)</p>
    </div>
</div>
{/foreach}