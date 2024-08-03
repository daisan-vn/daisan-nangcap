{if $result neq NULL}
{if $type eq 'image'}
<div id="media">
    <div class="row sml">
        {foreach from=$result item=data}
            <div class="item col-md-110" id="field{$data.id}">
                <div class="img_div" id="div_active{$data['id']}" >
                    <div class="check_active unactive" id="check_active{$data['id']}"><i class="fa fa-check fa-fw"></i></div>
                    <span class="img_helper"></span><img onclick="getinfoimg({$data['id']});" data-toggle="modal" data-target="#UpdateFrom" src="{$data.post_avatar}" id="active{$data['id']}" class="img_change">
                </div>
            </div>
        {/foreach}
    </div>
</div>
<div class="paging">
	{$out_paging}
</div>
{else}
<div class="paging">
	<h3 style="float: left;">Files trong thư mục</h3>
	{$out_paging}
</div>
<div class="clearfix"></div>
<div id="media">
    <div class="row sml">
        {foreach from=$result item=data}
            <div class="item col-md-4" id="field{$data.id}">
                <div class="img_div" id="div_active{$data['id']}" >
                    <div class="check_active unactive" id="check_active{$data['id']}"><i class="fa fa-check fa-fw"></i></div>
                    <span class="img_helper"></span>
                    <!-- <img onclick="getinfoimg({$data['id']});" data-toggle="modal" data-target="#UpdateFrom" src="{$data.post_avatar}" id="active{$data['id']}" class="img_change"> -->
                    <div onclick="getinfoimg({$data['id']});" data-toggle="modal" data-target="#UpdateFrom" id="active{$data['id']}" class="img_change">
	                    <i class="fa fa-file fa-fw fa-4x"></i>
	                    <p>{$data.media_title}</p>
	                    <p>{$data.media_name}</p>
                    </div>
                </div>
            </div>
        {/foreach}
    </div>
</div>
{/if}
{else}
<div id="media">
	<div class="text-center media_empty">
	    <h4 class="text-primary">Chưa có file nào trong thư mục này</h4>
	    {if $type eq 'image'}
	    <a href="?mod=media&site=upload" class="btn btn-default btn-primary"><i class="fa fa-cloud-upload"></i> Upload file</a>
	    {else}
	    <a href="?mod=media&site=uploadFiles" class="btn btn-default btn-primary"><i class="fa fa-cloud-upload"></i> Upload file</a>
	    {/if}
	    <br><br><br><br>
	</div>
</div>
{/if}
{literal}
<script>
var wimg = $('.col-md-110').width();
$('.img_div').css('height', wimg+'px');
window.onresize = function () {
    var wimg = $('.col-md-110').width();
    $('.img_div').css('height', wimg+'px');
};
</script>
{/literal}