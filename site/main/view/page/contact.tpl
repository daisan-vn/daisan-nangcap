<div class="container">
    <div class="my-5">
        <div class="row justify-content-md-center">
            <div class="col-md-10">
                <div class="card shadow">
                    <div class="card-body">
                        <h1 class="mb-4 text-nm-2">Để lại yêu cầu tư vấn cho sản phẩm</h1>
                        <hr> {if $product}
                        <p class="mb-1">Thông tin sản phẩm</p>
                        <div class="row row-sm">
                            <div class="col-md-2 col-5">
                                <a href="{$product.url}"> <img alt="{$product.name}" src="{$product.avatar}" class="w-100 img-thumbnail rounded-0">
                                </a>
                            </div>
                            <div class="col-md-10 col-7">
                                <h4 class="text-nm">
                                    <a href="{$product.url}">{$product.name}</a>
                                </h4>
                                <p><i class="fa fa-diamond"></i> {$page.name}</p>
                            </div>
                        </div>
                        <hr> {/if}

                        <p class="mb-3">* Thông báo: Nhập chi tiết sản phẩm như màu sắc, kích thước, vật liệu, vv và các yêu cầu cụ thể khác để nhận báo giá chính xác.</p>
                        {if $product}
                        <div class="form-group row">
                            <label for="staticEmail" class="col-sm-2 col-form-label">Số
								lượng:</label>
                            <div class="col-sm-2 col-6">
                                <input type="text" class="form-control rounded-0" name="number" value="{$product.minorder}">
                            </div>
                            <div class="col-sm-2 col-6">
                                <select class="form-control rounded-0" name="unit_id">
									{$product_unit}
								</select>
                            </div>
                        </div>
                        {/if}
                        <div>
                            <input type="hidden" name="page_id" value="{$page.pid|default:0}">
                            <input type="hidden" name="product_id" value="{$product.id|default:0}">
                            <div class="form-group row">
                                <label for="staticEmail" class="col-sm-2 col-form-label">Nội
									dung<sup>*</sup>:</label>
                                <div class="col-sm-10">
                                    <textarea rows="6" class="form-control rounded-0 mb-1" name="message" placeholder="Nội dung liên hệ...">{if isset($smarty.get.mes)}{$smarty.get.mes}{/if}</textarea>
                                    <small class="col-gray">Vui lòng nhập nội dung liên hệ
										20 đến 1000 ký tự.</small>
                                </div>

                            </div>

                        </div>
                        <div class="text-right mt-3">
                            <button type="button" class="btn btn-contact-o" onclick="SendContact();">
								<i class="fa fa-fw fa-envelope-o"></i>Gửi yêu cầu ngay
							</button>
                        </div>
                        <hr>


                        <div class="form-group form-check">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1" checked> <label class="form-check-label" for="exampleCheck1"> <b>Tôi đồng ý chia sẻ thông tin
									của mình cho nhà cung cấp.</b></label>
                        </div>

                        <p>Vui lòng đảm bảo thông tin liên hệ của bạn là chính xác (Xem và Chỉnh sửa). Tin nhắn của bạn sẽ được gửi trực tiếp đến người nhận và sẽ không được hiển thị công khai. Lưu ý rằng nếu người nhận là Nhà cung cấp Vàng, họ có thể xem
                            thông tin liên hệ của bạn, bao gồm địa chỉ email đã đăng ký của bạn.Daisan sẽ không bao giờ phân phối hoặc bán thông tin cá nhân của bạn cho bên thứ ba mà không có sự cho phép rõ ràng của bạn.</p>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

{literal}
<script type="text/javascript">
    function SendContact() {
        var data = {};
        data['page_id'] = $page_id = $("input[name=page_id]").val();
        data['product_id'] = $product_id = $("input[name=product_id]").val();
        data['message'] = $message = $("textarea[name=message]").val();
        data['number'] = $("input[name=number]").val();
        data['unit_id'] = $("select[name=unit_id]").val();
        data['ajax_action'] = 'send_contact';

        var url = "?mod=account&site=login_socical&url=back_url_contact&page_id=" + $page_id + "&product_id=" + $product_id + "&mes=" + $message;

        if (data.message.length < 2 || data.message.length > 1000) {
            noticeMsg('Thông báo', 'Vui lòng nhập nội dung ít nhất 2 ký tự.',
                'error');
            $("textarea[name=message]").focus();
            return false;
        }
        loading();
        $.post('?mod=page&site=contact', data).done(function(e) {
            var data = JSON.parse(e);
            if (data.code == 2) {
                location.href = url;
            } else if (data.code == 1) {
                noticeMsg('System Message', data.msg, 'success');
                $("textarea[name=message]").val('');
                location.href = "?mod=page&site=contact_confirm";
                endloading();
            } else {
                noticeMsg('System Message', data.msg, 'error');
                endloading();
            }
        });
    }
</script>
{/literal}