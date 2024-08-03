<div class="body-head">
    <div class="row">
        <div class="col-md-8">
            <h1>
                <i class="fa fa-bars fa-fw"></i> Quản lý hình ảnh banner trên các trang
            </h1>
        </div>
    </div>
</div>

<div class="">
    <div class="box"  style="margin-bottom: 20px;">
        <div class="row row-sm">
            <div class="col-md-7">
                <input type="file" id="UploadAds"> <small class="form-text text-muted"> Kích thước file ảnh tối đa
                    3MB, hỗ trợ định dạng jpg, png.</small>
            </div>
            <div class="col-md-5">
                <h6>Lựa chọn kích thước ảnh quảng cáo</h6>
                <div>
                    {foreach from=$out.a_ads_size key=k item=data}
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="ads_size" id="check{$data}" value="{$k}"
                            onclick="ChangerAdsSize({$k});" {if $out.img_ads_size eq $k}checked{/if}>
                        <label class="form-check-label" for="check{$data}">{$data}</label>
                      
                    </div>
                    {/foreach}
                </div>
            </div>
        </div>
    </div>
   


    <div id="ShowAds">
        {foreach from=$a_ads_show key=k item=size}
        <div class="row row-sm">
            {foreach from=$size key=k item=img}
            <div class="col-md-12 col-12" style="margin-bottom: 30px;">
                <div class="row">
                    <div class="col-md-8">
                        <div class="card mb-2" id="Img{$k}">
                       
                            <div class="card-body align-middle p-0">
                                <img alt="{$k}" src="{$img.slide}" width="100%">
                            </div>
                            <div class="card-footer p-2">
          
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="box">
                            <h3 style="font-size: 15px;margin-top:10px;font-weight: bold;">Thông tin ảnh</h3>
                            <p><i class="fa fa-image fa-fw"></i>{$img.image}</p>
                            <p><i class="fa fa-folder-o fa-fw"></i>{$img.showpage}</p>
                            <p><span><a href="javascript:void(0)" onclick="ChangeAdsInfo({$k},{$img.size})"><i
                                            class="fa fa-pencil fa-fw"></i>Cập
                                        nhật</a></span> <span class="pull-right"><a href="javascript:void(0);"
                                        onclick="RemoveImgAds({$k},{$img.size});"><i
                                            class="fa fa-trash fa-fw"></i>Remove
                                        image</a></span></p>
                        </div>
                    </div>
                </div>
            </div>
            
         
            
            {/foreach}
        </div>
        {/foreach}
    </div>
</div>
<div class="modal fade" id="ConfirmChangeSize" tabindex="-1">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Đổi kích thước
                    Slider</h5>
            </div>
            <div class="modal-body">Khi thay đổi kích thước slider toàn bộ
                ảnh slider kích thước cũ sẽ bị xóa để cập nhật lại. Bạn có chắc chắn
                rằng muốn thực hiện điều này chứ ?</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="Btn">Đồng
                    ý</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy
                    bỏ</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="ChangeAdsInfo" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">

                <h5 class="modal-title" id="exampleModalLabel">Cập nhật thông
                    tin</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <input type="hidden" id="number" value="">
                    <div class="form-group">
                        <label for="recipient-name" class="col-form-label">Tên</label> <input type="text"
                            class="form-control" id="title" name="title">
                    </div>
                    <div class="form-group">
                        <label for="recipient-link" class="col-form-label">Đường
                            link</label> <input type="text" class="form-control" id="link" name="link">
                    </div>
                    <div class="form-group">
                        <label for="recipient-link" class="col-form-label">Vị trí</label>
                        <select class="left form-control" id="position" title="Vị trí">
                            {$out.position}
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="message-text" class="col-form-label">Mô tả:</label>
                        <textarea class="form-control" id="description"></textarea>
                    </div>
                    <div class="form-group">
                        <input type="hidden" class="form-control" id="size" name="size">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="SaveAdsInfo()">Cập nhật</button>
            </div>
        </div>
    </div>
</div>

<input type="hidden" name="img_ads" class="form-control" value="{$profile.img_ads|default:''}">
<input type="hidden" name="folder" class="form-control" value="{$arg.url_upload}{$out.folder|default:''}">
{literal}
<script>
    var Folder = $("input[name=folder]").val();
    var img_ads = $("input[name=img_ads]").val();
    var ArrImgAds = [];
    if (img_ads != '') ArrImgAds = img_ads.split(';');

    $(window).ready(function () {
        // LoadImgForm();
        LoadAdsForm();
        $('#UploadAds').change(function () {
            var Number = ArrImgAds.length;
            if (Number > 8) {
                noticeMsg('Thông báo', 'Đã vượt quá số lượng ảnh được phép đăng.', 'error');
            } else if (this.files && this.files[0]) {
                var fileType = this.files[0]["type"];
                var fileName = this.files[0]["name"];
                var ValidImageTypes = ["image/jpeg", "image/png"];

                if ($.inArray(fileType, ValidImageTypes) >= 0) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var Data = {};
                        Data['imgname'] = fileName;
                        Data['img'] = e.target.result;
                        Data['ajax_action'] = 'upload_ads';
                        loading();
                        $.post('?mod=slider&site=banners', Data).done(function (e) {
                            location.reload();
                            ArrImgAds.push(e);
                            LoadAdsForm();
                            endloading();
                        });
                    }
                    reader.readAsDataURL(this.files[0]);
                } else {
                    noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng.', 'error');
                }
            }
            $("#UploadAds").val('');
        });
    });

    function LoadAdsForm() {

        $('#ShowAds img').attr('src', arg.noimg);

        $("#ShowAds small").html('No image');

        $('#ShowAds .card').hide();

        $.each(ArrImgAds, function (k, item) {
            var key = k + 1;
            $('#ShowAds #Img' + key).show();

            $('#ShowAds #Img' + key + ' img').attr('src', Folder + item);

            $("#ShowAds #Img" + key + " small").html('<a href="javascript:void(0)" onclick="RemoveImg(' + key + ', \'ads\');">Remove</a>');

        });

    }

    function RemoveImg(Key, type) {
        var Data = {};
        Data['imgname'] = ArrImg[Key];
        if (type == 'slider_mobile') Data['imgname'] = Arrsliders_mobile[Key];
        if (type == 'ads') Data['imgname'] = ArrImgAds[Key];
        Data['ajax_action'] = 'remove_' + type;
        loading();
        $.post('?mod=slider&site=banners', Data).done(function (e) {
            if (type == 'slider_mobile') {
                Arrsliders_mobile.splice(Key, 1);
                LoadSliderMobile();
                endloading();
            } else if (type == 'ads') {
                ArrImgAds.splice(Key, 1);
                LoadAdsForm();
                endloading();
            }
            else {
                ArrImg.splice(Key, 1);
                LoadImgForm();
                endloading();
            }
        });
    }

    function UploadImg(fileImg, type, width) {
        var fileType = fileImg["type"];
        var fileName = fileImg["name"];
        var ValidImageTypes = ["image/jpeg", "image/png"];
        if ($.inArray(fileType, ValidImageTypes) >= 0) {
            var reader = new FileReader();
            reader.onload = function (e) {
                var Data = {};
                Data['imgname'] = fileName;
                Data['img'] = e.target.result;
                Data['type'] = type;
                Data['width'] = width;
                Data['ajax_action'] = 'upload_banner';
                loading();
                $.post('?mod=slider&site=banners', Data).done(function (e) {
                    if (e == 0) noticeMsg('Xảy ra lỗi', 'Không thể lưu được ảnh, vui lòng thử lại sau.', 'error');
                    else {
                        $("#" + type + " img").attr('src', e);
                        noticeMsg('Thông báo', 'Thay đổi ảnh mới thành công.', 'success');
                    }
                    endloading();
                });
            }
            reader.readAsDataURL(fileImg);
        } else {
            noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
        }
        $("#" + type + " input").val('');
    }

    function RemoveBanner(key) {
        var Data = {};
        Data['key'] = key;
        Data['ajax_action'] = 'remove_banner';
        loading();
        $.post('?mod=slider&site=banners', Data).done(function (e) {
            $("#" + key + " img").attr('src', '');
            endloading();
        });
    }
    function RemoveImgAds(key, size) {
        var Data = {};
        Data['key'] = key;
        Data['size'] = size;
        Data['ajax_action'] = 'remove_ads';
        loading();
        $.post('?mod=slider&site=banners', Data).done(function (e) {
            $("#" + key + " img").attr('src', '');
            location.reload();
            endloading();
        });
    }
    function ChangerSliderSize(size, type) {
        if (type === 'ok') {
            var data = {};
            data.size = size;
            data.ajax_action = 'change_slider_size';
            loading();
            $.post('?mod=slider&site=banners', data).done(function (e) {
                noticeMsg('Thông báo', 'Thay đổi kích thước ảnh slider thành công.', 'success');
                setTimeout(function () {
                    location.reload();
                }, 1200);
            });
        } else {
            $('#ConfirmChangeSize #Btn').attr('onclick', "ChangerSliderSize(" + size + ", 'ok');")
            $('#ConfirmChangeSize').modal('show');
        }
    }
    function ChangerAdsSize(size, type) {
        if (type === 'ok') {
            var data = {};
            data.size = size;
            data.ajax_action = 'change_ads_size';
            loading();
            $.post('?mod=slider&site=banners', data).done(function (e) {
                noticeMsg('Thông báo', 'Thay đổi kích thước ảnh slider thành công.', 'success');
                setTimeout(function () {
                    location.reload();
                }, 1200);
            });
        } else {
            $('#ConfirmChangeSize #Btn').attr('onclick', "ChangerAdsSize(" + size + ", 'ok');")
            $('#ConfirmChangeSize').modal('show');
        }
    }
    function ChangerSliderInfo(id) {
        $("#ChangeSliderInfo input#number").val(id);
        data = {};
        data.number = id;
        data.ajax_action = 'get_slider_info';
        $.post("?mod=slider&site=banners", data).done(function (e) {
            var rt = JSON.parse(e);
            $("#ChangeSliderInfo input#title").val(rt.title);
            $("#ChangeSliderInfo input#link").val(rt.link);
            $("#ChangeSliderInfo textarea#description").val(rt.description);
        });
        $("#ChangeSliderInfo").modal('show');
    }
    function SaveSliderInfo() {
        data = {};
        data.number = $("#number").val();
        data.title = $("#title").val();
        data.link = $("#link").val();
        data.description = $("#description").val();
        data.ajax_action = 'change_slider_info';
        $.post("?mod=slider&site=banners", data).done(function (e) {
            noticeMsg('Thông báo', 'Thành công', 'success');
            setTimeout(function () {
                location.reload();
            }, 1200);
        });
    }
    function ChangerSliderMobileInfo(id) {
        $("#ChangeSliderMobileInfo input#number").val(id);
        data = {};
        data.number = id;
        data.ajax_action = 'get_slider_mobile_info';
        $.post("?mod=slider&site=banners", data).done(function (e) {
            var rt = JSON.parse(e);
            $("#ChangeSliderMobileInfo input#title").val(rt.title);
            $("#ChangeSliderMobileInfo input#link").val(rt.link);
            $("#ChangeSliderMobileInfo textarea#description").val(rt.description);
        });
        $("#ChangeSliderMobileInfo").modal('show');
    }
    function SaveSliderMobileInfo() {
        data = {};
        data.number = $("#ChangeSliderMobileInfo input#number").val();
        data.title = $("#ChangeSliderMobileInfo input#title").val();
        data.link = $("#ChangeSliderMobileInfo input#link").val();
        data.description = $("#ChangeSliderMobileInfo #description").val();
        data.ajax_action = 'change_slider_mobile_info';
        $.post("?mod=slider&site=banners", data).done(function (e) {
            noticeMsg('Thông báo', 'Thành công', 'success');
            setTimeout(function () {
                location.reload();
            }, 1200);
        });
    }
    function ChangeAdsInfo(id, size) {
        $("#ChangeAdsInfo input#number").val(id);
        data = {};
        data.number = id;
        data.size = size;
        data.ajax_action = 'get_ads_info';
        $.post("?mod=slider&site=banners", data).done(function (e) {
            var rt = JSON.parse(e);
            $("#ChangeAdsInfo #title").val(rt.title);
            $("#ChangeAdsInfo #link").val(rt.link);
            $("#ChangeAdsInfo #position").val(rt.position);
            $("#ChangeAdsInfo #description").val(rt.description);
            $("#ChangeAdsInfo #size").val(rt.size);
        });
        $("#ChangeAdsInfo").modal('show');
    }
    function SaveAdsInfo() {
        data = {};
        data.size = $("#ChangeAdsInfo #size").val();
        data.number = $("#ChangeAdsInfo #number").val();
        data.title = $("#ChangeAdsInfo #title").val();
        data.link = $("#ChangeAdsInfo #link").val();
        data.position = $("#ChangeAdsInfo #position").val();
        data.description = $("#ChangeAdsInfo #description").val();
        data.ajax_action = 'change_ads_info';
        $.post("?mod=slider&site=banners", data).done(function (e) {
            noticeMsg('Thông báo', 'Thành công', 'success');
            setTimeout(function () {
                location.reload();
            }, 1200);
        });
    }
</script>
{/literal}