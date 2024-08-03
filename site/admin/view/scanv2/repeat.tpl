<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Quét sản phẩm tự động
			</h1>
		</div>
	</div>
</div>

<div class="card shadow border">
	<div class="card-body py-4">
		<p>Tự động quét tất cả các link sản phẩm mới cho gian hàng theo chuyên mục.</p>
        <hr/>
	</div>
</div>

<div class="card">
    <div class="card-body">
        <div class="form-group row">
            <label class="col-sm-2 col-form-label">Danh mục</label>
            <div class="col-sm-4">
                <select class="form-control" onchange="SelectCategory(this.value);">
                    {{$categories}}
                </select>
            </div>
        </div>

        <div class="form-group row">
            <div class="col-sm-2"></div>
            <div class="col-sm-10">
                <button type="button" onclick="StartScan();" class="btn btn-primary">Bắt đầu quét</button>
            </div>
        </div>
    </div>
</div>

<script>

    let cat_id = 0;

    function SelectCategory(id) {
        cat_id = id;
        console.log(cat_id);
    }

    function StartScan() {

    }

</script>