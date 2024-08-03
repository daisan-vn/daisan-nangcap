<div class="body-head">

	<div class="row">

		<div class="col-md-8">

			<h1><i class="fa fa-bars fa-fw"></i> Quản lý danh sách sản phẩm quảng cáo</h1>

		</div>

		<div class="col-md-4 text-right">

		</div>

	</div>

</div>



<div class="row">

	<div class="col-md-8">

	    <div class="form-group form-inline">

	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">

	        <select class="left form-control" id="status">{$out.filter_status}</select>

	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>

	    </div>

	</div>

	<div class="col-md-4">

	    <div class="form-group form-inline text-right">

	        <select class="left form-control" name="bulk1">

	            <option value="">Chọn tác vụ</option>

	            <option value="1">Kích hoạt</option>

	            <option value="2">Hủy kích hoạt</option>

	        </select>

	        <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>

        </div>

	</div>

</div>



<div class="table-responsive">

    <table class="table table-bordered table-hover table-striped">

        <thead>

        <tr>

            <th class="text-center"><input type="checkbox" class="SelectAllRows"></th>

            <th>Sản phẩm</th>

            <th>Chiến dịch</th>

            <th>Gian hàng</th>

            <th class="text-right">Click</th>

            <th>Khởi tạo</th>

            <th class="text-center">TT</th>

        </tr>

        </thead>

        <tbody>

        {if $result neq NULL}

            {foreach from=$result item=data}

                <tr id="field{$data.id}">

                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>

                    <td width="35%">

                    	<div class="row row-small">

                    		<div class="col-md-2">

                    			<img class="img" id="img{$data.id}" src="{$data.avatar}">

                    		</div>

                    		<div class="col-md-10"><a href="{$data.url}" target="_blank">{$data.name}</a></div>

                    	</div>

                    </td>

                    <td><a href="{$out.url}&campaign_id={$data.campaign_id}">{$data.campaign_name}</a></td>

                    <td><a href="{$out.url}&page_id={$data.page_id}">{$data.page_name}</a></td>

                    <td class="text-right">{$data.number_click}</td>

                    <td>{$data.created|date_format:'%H:%M:%S %d-%m-%Y'}</td>

                    <td class="text-center" id="stt{$data.id}">{$data.status}</td>

                </tr>

            {/foreach}

        {else}

            <tr><td class="text-center" colspan="10"><br>Không có nội dung nào được tìm thấy<br><br></td></tr>

        {/if}

        </tbody>

    </table>

</div>



<div class="paging">{$paging}</div>



{literal}

<script>

$('#keyword,#category').keypress(function( event ){

    if ( event.which == 13 ) filter();

});



function filter(){

    var key = $.trim($("#keyword").val());

    var status=$("#status").val();

    var url = "?mod=product&site=ads";

    if(status!=-1) url = url+"&status="+status;

    if(key!='') url = url+"&key="+key;

    window.location.href = url;

}



function BulkAction(pos) {

    PNotify.removeAll();

    var bulk = $('select[name=bulk'+pos+']').val();

    if (bulk == '') {

        var notice = new PNotify({

            title: 'Chọn tác vụ',

            text: 'Vui lòng chọn 1 tác vụ',

            type: 'info',

            mouse_reset: false,

            buttons: { sticker: false },

            animate: { animate: true, in_class: 'fadeInDown', out_class: 'fadeOutRight' }

        });

        notice.get().click(function () { notice.remove(); });

    } 

    else if (bulk == 0) BulkDelete('product', 'ajax_bulk_delete');

    else if (bulk == 1) BulkActive('products', 1);

    else if (bulk == 2) BulkActive('products', 2);

}

</script>

{/literal}