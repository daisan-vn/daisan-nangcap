<div class="row">
    <div class="col-md-9">
        <div class="form-group form-inline">
            <select class="form-control">
                <option value="0">-- Chọn danh mục --</option>
            </select>
            <select class="form-control">
                <option value="0">-- Chọn nhà bán --</option>
            </select>
            <button type="button" class="btn btn-primary" onclick="filter();">
                <i class="fa fa-search fa-fw"></i> Tìm kiếm
            </button>
        </div>
    </div>
    <div class="col-md-3">
        
    </div>
</div>

<div class="table-responsive">
    <table class="table table-bordered table-hover table-striped">
        <thead>
            <th>Tiêu đề</th>
            <th>Gian hàng</th>
            <th>Giá bán</th>
            <th>Lượt xem</th>
        </thead>
        <tbody>
        {foreach $product_list as $product}
            <tr>
                <td>{$product.name}</td>
                <td></td>
                <td></td>
                <td>{$product.views}</td>
            </tr>
        {/foreach}
        </tbody>
    </table>
</div>