<script src="{$arg.stylesheet}cropper/cropper.min.js"></script>
<script src="{$arg.stylesheet}cropper/cropper-main.js"></script>

<h1 class="page-header">Sửa hình ảnh</h1>

<div class="row">
    <div class="col-md-9 col-sm-12 col-xs-12">
        <div id="crop_area">
            <img id="image" src="{$media.image}">
        </div>
    </div>

    <div class="col-md-3 col-sm-12 col-xs-12">
        {*<div class="item sml">
            <div class="box">
                <h4 class="item-header">Chọn tỉ lệ (new)</h4>
                <div class="row">
                    <div class="col-xs-12">
                        <div class="btn-group" data-toggle="buttons">
                            <label class="btn btn-primary active">
                                <input type="radio" name="ratio" onclick="ChangeRatio();" id="option1" autocomplete="off" checked value="0"> Tự do
                            </label>
                            <label class="btn btn-primary">
                                <input type="radio" name="ratio" onclick="ChangeRatio();" id="option2" autocomplete="off" value="1"> 1:1
                            </label>
                            <label class="btn btn-primary">
                                <input type="radio" name="ratio" onclick="ChangeRatio();" id="option3" autocomplete="off" value="1.3333333333333333"> 4:3
                            </label>
                            <label class="btn btn-primary">
                                <input type="radio" name="ratio" onclick="ChangeRatio();" id="option3" autocomplete="off" value="1.7777777777777777"> 16:9
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>*}

        <div class="item sml">
            <div class="box">
                <h4 class="item-header">Chọn tỉ lệ</h4>
                <div class="row docs-toggles">
                    <div class="col-xs-12">
                        <div class="btn-group" data-toggle="buttons">
                            <label class="btn btn-primary active">
                                <input class="sr-only" id="aspectRatio4" name="aspectRatio" value="NaN" type="radio" checked>
                                <span>
                                  Tự do
                                </span>
                            </label>
                            <label class="btn btn-primary">
                                <input class="sr-only" id="aspectRatio0" name="aspectRatio" value="1.7777777777777777" type="radio">
                                <span>
                                  16:9
                                </span>
                            </label>
                            <label class="btn btn-primary">
                                <input class="sr-only" id="aspectRatio1" name="aspectRatio" value="1.3333333333333333" type="radio">
                                <span>
                                  4:3
                                </span>
                            </label>
                            <label class="btn btn-primary">
                                <input class="sr-only" id="aspectRatio2" name="aspectRatio" value="1" type="radio">
                                <span>
                                  1:1
                                </span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="item sml">
            <div class="box">
                <h4 class="item-header">Công cụ</h4>
                <div class="row docs-buttons">
                    <div class="col-xs-12">
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary" data-method="setDragMode" data-option="move" title="Move">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;setDragMode&quot;, &quot;move&quot;)">
                              <i class="fa fa-arrows"></i>
                            </span>
                                </button>
                                <button type="button" class="btn btn-primary" data-method="setDragMode" data-option="crop" title="Crop">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;setDragMode&quot;, &quot;crop&quot;)">
                              <i class="fa fa-crop"></i>
                            </span>
                                </button>
                            </div>

                            <div class="btn-group">
                                <button type="button" class="btn btn-primary" data-method="zoom" data-option="0.1" title="Zoom In">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;zoom&quot;, 0.1)">
                              <i class="fa fa-search-plus"></i>
                            </span>
                                </button>
                                <button type="button" class="btn btn-primary" data-method="zoom" data-option="-0.1" title="Zoom Out">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;zoom&quot;, -0.1)">
                              <i class="fa fa-search-minus"></i>
                            </span>
                            </button>
                        </div>
                    </div>

                    <div class="col-xs-12">
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary" data-method="move" data-option="-10" data-second-option="0" title="Move Left">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;move&quot;, -10, 0)">
                              <span class="fa fa-arrow-left"></span>
                            </span>
                                    </button>
                                    <button type="button" class="btn btn-primary" data-method="move" data-option="10" data-second-option="0" title="Move Right">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;move&quot;, 10, 0)">
                              <span class="fa fa-arrow-right"></span>
                            </span>
                                    </button>
                                    <button type="button" class="btn btn-primary" data-method="move" data-option="0" data-second-option="-10" title="Move Up">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;move&quot;, 0, -10)">
                              <span class="fa fa-arrow-up"></span>
                            </span>
                                    </button>
                                    <button type="button" class="btn btn-primary" data-method="move" data-option="0" data-second-option="10" title="Move Down">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;move&quot;, 0, 10)">
                              <span class="fa fa-arrow-down"></span>
                            </span>
                            </button>
                        </div>
                    </div>

                    <div class="col-xs-12">
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary" data-method="rotate" data-option="-45" title="Rotate Left">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;rotate&quot;, -45)">
                              <span class="fa fa-rotate-left"></span>
                            </span>
                                    </button>
                                    <button type="button" class="btn btn-primary" data-method="rotate" data-option="45" title="Rotate Right">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;rotate&quot;, 45)">
                              <span class="fa fa-rotate-right"></span>
                            </span>
                                    </button>
                                </div>

                                <div class="btn-group">
                                    <button type="button" class="btn btn-primary" data-method="scaleX" data-option="-1" title="Flip Horizontal">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;scaleX&quot;, -1)">
                              <span class="fa fa-arrows-h"></span>
                            </span>
                                    </button>
                                    <button type="button" class="btn btn-primary" data-method="scaleY" data-option="-1" title="Flip Vertical">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;scaleY&quot;, -1)">
                              <span class="fa fa-arrows-v"></span>
                            </span>
                            </button>
                        </div>
                    </div>

                    <div class="col-xs-12">
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary" data-method="reset" title="Reset">
                            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;reset&quot;)">
                              <i class="fa fa-refresh fa-fw"></i> Đặt lại
                            </span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="item sml" style="margin-bottom: 0">
            <div class="box">
                <h1 class="item-header">Lưu lại</h1>
                <form method="post">
                    <input type="hidden" name="crop_x">
                    <input type="hidden" name="crop_y">
                    <input type="hidden" name="crop_width">
                    <input type="hidden" name="crop_height">
                    <input type="hidden" name="crop_rotate">
                    <input type="hidden" name="crop_scaleX">
                    <input type="hidden" name="crop_scaleY">
                    <button type="submit" class="btn btn-success" name="submit"><i class="fa fa-floppy-o fa-fw"></i> Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Show the cropped image in modal -->
<div class="modal fade docs-cropped" id="getCroppedCanvasModal" aria-hidden="true" aria-labelledby="getCroppedCanvasTitle" role="dialog" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" id="getCroppedCanvasTitle">Cropped</h4>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <a class="btn btn-primary" id="download" href="javascript:void(0);" download="cropped.jpg">Download</a>
                {*<a class="btn btn-primary" href="javascript:void(0);" download="cropped.jpg" onclick="abcghi();">Haha</a>*}
            </div>
        </div>
    </div>
</div><!-- /.modal -->