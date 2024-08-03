{if isset($result)}
{if $result neq NULL}
<div class="row row-media" style="margin-top: 15px; background: #f2f2f2;">
    {foreach from=$result item=data}
    <div class="col-media">
        <a onclick="{$data.action}">
            <span class="img_helper"></span><img id="media{$data.id}" src="{$data.post_avatar}">
        </a>
    </div>
    {/foreach}
    <div class="clearfix"></div>
</div>
<div class="paging">{$out_paging}</div>
<div class="clearfix"></div>
{else}
<div class="text-center media_empty">
    <h4 class="text-primary">Chưa có file nào trong thư mục này</h4>
    <a id="UploadTab" href="#profile" class="btn btn-default btn-primary"><i class="fa fa-cloud-upload"></i> Upload file</a>
</div>
{/if}
{literal}
<script>
$('#UploadTab').click(function (e) {
    e.preventDefault();
    $('.nav-tabs a:last').tab('show');
});
var wimg = $('.col-media').width();
$('.col-media').css('height', wimg+'px');
window.onresize = function () {
    var wimg = $('.col-md-110').width();
    $('.col-media').css('height', wimg+'px');
};
</script>
{/literal}
{/if}