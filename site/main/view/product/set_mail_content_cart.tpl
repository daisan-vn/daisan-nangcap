<div style="max-width: 600px; margin: 0 auto; font-family: arial">
	<section id="header"
		style="background-color: #ffec04 !important; padding: 10px 20px">
		<div
			style="display: -ms-flexbox; display: flex; -ms-flex-align: start; align-items: flex-start;">
			<img style="margin-right: 1rem; height: 45px"
				src="https://khoedep.daisan.vn/site/upload/media/images/images/1681359542_990e2b1dfa7acdb692c02b82ae5f120d.png"
				alt="Sàn TMĐT Chuyên biệt lĩnh vực Xây dựng">
			<div style="-ms-flex: 1; flex: 1;">
				<h5 style="margin: 0; font-size: 1rem">DAISAN - VIETNAM TRADE STARTS HERE</h5>
				<p
					style="margin-bottom: 0; padding-bottom: 0; font-size: 13px; font-weight: 300; margin-top: 2px; font-style: italic;">Hotline<a href="0964.36.8282">
					0964.36.8282</a></p>
				<p
					style="margin-bottom: 0; padding-bottom: 0; font-size: 13px; font-weight: 300; margin-top: 2px; font-style: italic;">Email:
					{$option.contact.email|default:'info@daisan.vn'}</p>
			</div>
		</div>
	</section>
	<section id="content">
		<div style="padding: 0 1.5rem">
			<h3>Đơn hàng mới từ Daisan.vn</h3>
		</div>
		<div style="padding: 0 1.5rem">
			<p>
				Xin chào <b>{$data.name}</b>
			</p>
			<p>Bạn đã nhận được một đơn đặt hàng mới trong Trung tâm người
				bán</p>
			<p>Chi tiết đơn đặt hàng:</p>
		</div>
		<div
			style="padding: 1.5rem; position: relative; padding: .75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: .25rem; color: #004085; background-color: #cce5ff; border-color: #b8daff;">
			<p style="font-size: 1rem; font-weight: 300;">
				<i>Mã đơn hàng: <b>{$data.codeorder} </b></i>
			</p>
			<p style="font-size: 1rem; font-weight: 300;">
				<i>Danh sách sản phẩm:<b></b></i>
			</p>
			<ol type="1">
				{foreach from=$detail item=data}
				<li>{$data.productname}</li> {/foreach}
			</ol>
		</div>
		<div style="padding: 0 1.5rem">
			<p>
				Vui lòng theo liên kết dưới đây để truy cập tổng quan về đơn hàng
				của tài khoản của bạn <a href="{$data.url}">{$data.url}</a>
			</p>
			<p>Best regards,</p>
			<p>
				<b>Happy Selling!<br> Daisan Vietnam
				</b>
			</p>
		</div>
		<hr
			style="margin-top: 1rem; margin-bottom: 1rem; border: 0; border-top: 1px solid rgba(0, 0, 0, .1); border-bottom-style: dotted;">
		<div
			style="position: relative; padding: .75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: .25rem; color: #856404; background-color: #fff3cd; border-color: #ffeeba;">
			<i>Lưu ý: Đây là email gửi tự động, bạn không nên trả lời lại
				e-mail này.</i>
		</div>
		<p style="padding: .25rem 1.25rem;">Trân trọng !</p>
	</section>
	<footer
		style="background-color: #f8f9fa !important; padding: 10px 20px">
		{$option.contact.description|default:''} </footer>
</div>