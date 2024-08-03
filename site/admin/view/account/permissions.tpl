<div class="content d-flex flex-column flex-column-fluid" id="kt_content">
    <!--begin::Subheader-->
    <div class="subheader py-2 py-lg-6 subheader-solid" id="kt_subheader">
        <div class="container-fluid d-flex align-items-center justify-content-between flex-wrap flex-sm-nowrap">
            <!--begin::Info-->
            <div class="d-flex align-items-center flex-wrap mr-1">
                <!--begin::Page Heading-->
                <div class="d-flex align-items-baseline flex-wrap mr-5">
                    <!--begin::Page Title-->
                    <h5 class="text-dark font-weight-bold my-1 mr-5">Quản Lý Danh Sách Quyền Quản Trị</h5>
                    <!--end::Page Title-->
                </div>
                <!--end::Page Heading-->
            </div>
            <!--end::Info-->
            <!--begin::Toolbar-->
            <div class="col-md-4 text-right">
                <button type="button" class="btn btn-primary btn-sm" onclick="LoadForm(0);">
                    <i class="fa fa-plus fa-sm"></i> Thêm mới
                </button>
            </div>
            <!--end::Toolbar-->
        </div>
    </div>
    <!--end::Subheader-->
    <!--begin::Entry-->
    <div class="d-flex flex-column-fluid">
        <!--begin::Container-->
        <div class="container">
            <!--begin::Card-->
            <div class="card card-custom gutter-b p-5">

            <div class="row">
            <div class="col-md-8">
                
            </div>
            <div class="col-md-4">
                <div class="form-group form-inline justify-content-end">
                    <select class="left form-control" name="bulk1">
                        <option value="">Chọn tác vụ</option>
                        <option value="1">Kích hoạt</option>
                        <option value="2">Hủy kích hoạt</option>
                    </select> &nbsp;
                    <button id="search_btn" type="button" class="btn btn-primary" onclick="BulkAction(1);">Áp
                        dụng</button>
                </div>
            </div>
        </div>


                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped hls_list_table">
                        <thead>
                            <tr>
                                <th style="width: 1%"><input type="checkbox" class="SelectAllRows"></th>
                                <th>Tên phân quyền</th>
                                <th>URL phân quyền</th>
                                <th>Level</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-right" width="120"></th>
                            </tr>
                        </thead>
                        <tbody>
                            {if $result neq NULL}
                                {foreach from=$result item=data}
                                    <tr id="field{$data.permission_id}">
                                        <td class="text-center"><input type="checkbox" class="item_checked"
                                                value="{$data.permission_id}"></td>
                                        <td class="field_name">{$data.permission_name}</td>
                                        <td>{$data.permission_mod} | {$data.permission_site}</td>
                                        <td>{$data.level}</td>
                                        <td class="text-center" id="stt{$data.permission_id}">
                                            {$data.status}
                                        </td>
                                        <td class="text-right">
                                            <button type="button" class="btn btn-default btn-icon btn-sm"
                                                onclick="LoadDataForForm({$data.permission_id});"><i
                                                    class="flaticon-edit"></i></button>
                                            <button type="button" class="btn btn-default btn-icon btn-sm" title="Xóa"
                                                onclick="LoadDeleteItem('user', {$data.permission_id}, 'ajax_permission_delete');"><i
                                                    class="flaticon2-trash"></i></button>
                                        </td>
                                    </tr>
                                {/foreach}
                            {else}
                                <tr>
                                    <td colspan="10">Không tìm thấy tài khoản nào</td>
                                </tr>
                            {/if}
                        </tbody>
                    </table>
                </div>
                <div class="paging">{$paging}</div>
                <!--end::Card-->
            </div>
            <!--end::Container-->
        </div>
        <!--end::Entry-->
    </div>


    <!-- Modal UpdateFrom -->
    <div class="modal fade" tabindex="-1" id="UpdateFrom">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    <h4 class="modal-title" id="title"></h4>
                </div>
                <form data-parsley-validate class="form-horizontal form-label-left" method="post" action="">
                    <div class="modal-body">
                        <input type="hidden" name="permission_id">
                        <div class="form-group">
                            <label class="control-label col-md-2 col-sm-2 col-xs-12">Name</label>
                            <div class="col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="permission_name" required="required" class="form-control"
                                    placeholder="Name...">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-2 col-sm-2 col-xs-12">URL</label>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <input type="text" name="permission_mod" required="required" class="form-control"
                                    placeholder="module...">
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <input type="text" name="permission_site" required="required" class="form-control"
                                    placeholder="function...">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-2 col-sm-2 col-xs-12">Level</label>
                            <div class="col-md-4 col-sm-6 col-xs-12">
                                <select class="form-control" name="level"></select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-2 col-sm-2 col-xs-12"></label>
                            <div class="col-md-9 col-sm-9 col-xs-12">
                                <div class="checkbox">
                                    <label> <input type="checkbox" name="status" value="1"> Kích hoạt / khóa phân quyền
                                        này</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary" name="submit">Lưu thông tin</button>
                    </div>
                </form>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->

    {literal}
        <script>
            function LoadDataForForm(id) {
                $("#UpdateFrom input[type=text]").val('');
                $.post("?mod=account&site=ajax_load_permission_item", {'id' : id}).done(function(data) {
                var data = JSON.parse(data);
                console.log(data);
                if (data.permission_id == undefined) {
                    $("#UpdateFrom input[name=permission_id]").val(0);
                    $("#UpdateFrom input[name=status]").prop('checked', true);
                    $("#title").html('Thêm quyền người dùng mới');
                } else {
                    $("#UpdateFrom input[name=permission_id]").val(data.permission_id);
                    $("#UpdateFrom input[name=permission_name]").val(data.permission_name);
                    $("#UpdateFrom input[name=permission_mod]").val(data.permission_mod);
                    $("#UpdateFrom input[name=permission_site]").val(data.permission_site);
                    $("#title").html('Sửa thông tin phân quyền');
                    if (data.status == '1') {
                        $("#UpdateFrom input[name=status]").prop('checked', true);
                    } else {
                        $("#UpdateFrom input[name=status]").prop('checked', false);
                    }
                }
                $("#UpdateFrom select[name=level]").html(data.select_level);
                $("#UpdateFrom").modal('show');
            });
            }

            function BulkAction(pos) {
                PNotify.removeAll();
                var bulk = $('select[name=bulk' + pos + ']').val();
                if (bulk == '') {
                    var notice = new PNotify({
                        title: 'Chọn tác vụ',
                        text: 'Vui lòng chọn 1 tác vụ',
                        type: 'info',
                        mouse_reset: false,
                        buttons: {
                            sticker: false
                        },
                        animate: {
                            animate: true,
                            in_class: 'fadeInDown',
                            out_class: 'fadeOutRight'
                        }
                    });
                    notice.get().click(function() {
                        notice.remove();
                    });
                } else if (bulk == 1) {
                    BulkActive('hls_permissions', 1);
                } else if (bulk == 2) {
                    BulkActive('hls_permissions', 0);
                }
            }
        </script>
    {/literal}