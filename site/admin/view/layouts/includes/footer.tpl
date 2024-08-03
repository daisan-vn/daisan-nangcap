<div class="modal fade" tabindex="-1" id="ShowDetail">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
				<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body"></div>
		</div>
	</div>
</div>

<!-- Confirm Delete Modal -->
<div class="modal fade" id="ConfirmDelete">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Xác nhận xóa</h4>
            </div>
            <div class="modal-body">Bạn có chắc chắn rằng muốn xóa <b class="del_name"></b> chứ ?</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" onclick="DeleteItem();" id="DeleteItem">Đồng ý xóa</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
            </div>
        </div>
    </div>
</div>

<!-- Confirm Bulk Delete Modal -->
<div class="modal fade" id="ConfirmBulkDelete">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Xác nhận xóa</h4>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa vĩnh viễn các mục sau chứ ?</p>
                <div id="DeleteList"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" id="DeleteBulk">Đồng ý xóa</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
            </div>
        </div>
    </div>
</div>

<div id="loading">
	<i class="fa fa-spinner fa-pulse fa-5x fa-fw"></i>
</div>
