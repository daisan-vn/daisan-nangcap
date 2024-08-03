<div class="body-head">
    <div class="row">
        <div class="col-md-8">
            <h1><i class="fa fa-bars fa-fw"></i> Thêm từ khóa cho danh mục</h1>
        </div>
        <div class="col-md-4 text-right">
        </div>
    </div>
</div>
<form method="post">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <div class="row">
                <div class="col-md-4">
                    <a href="?mod=keyword&site=category" class="btn btn-primary btn-sm">
                        <i class="fa fa-list fa-fw"></i>
                        Danh mục từ khóa
                    </a>
                </div>
                <div class="col-md-8 text-right">
                    <a href="?mod=keyword&site=keyword_category_img&id={$smarty.get.id}" class="btn btn-success btn-sm">
                        <i class="fa fa-plus fa-fw"></i>
                        Thêm hình cho từ khóa
                    </a>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <!-- dataAttribute -->
            <div class="class" id="contentsAttribute">
                <div class="form-group row">
                    <div class="col-sm-12">
                        <textarea class="form-control" name="contents_{$smarty.get.id}" rows="8" placeholder="lựa chọn 1 <enter>
                            lựa chọn 2 <enter>">{$result.show_content}</textarea>
                    </div>
                </div>
            </div>

        </div>
        <div class="panel-body">
            <div class="form-group row">
                <div class="col-sm-10">
                    <input type="hidden" name="lenght_attribute" value="{count($result)}">
                    <button type="submit" name="submit" class="btn btn-primary btn-lg">Lưu thông tin</button>
                </div>
            </div>
        </div>
    </div>
</form>

<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>
