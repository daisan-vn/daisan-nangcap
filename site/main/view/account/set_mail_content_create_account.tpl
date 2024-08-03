<div style="max-width: 600px; margin: 0 auto; font-family: arial">
	<section id="header"
		style="background-color: #ffec04 !important; padding: 10px 20px">
		<div
			style="display: -ms-flexbox; display: flex; -ms-flex-align: start; align-items: flex-start;">
			<img style="margin-right: 1rem; height: 45px"
				src="https://imgs.daisan.vn/media/images/logo/1539832552_bf1588c00ac381a6989aff08a51dff92.png"
				alt="Sàn TMĐT Chuyên biệt lĩnh vực Xây dựng">
			<div style="-ms-flex: 1; flex: 1;">
				<h5 style="margin: 0; font-size: 1rem">DAISAN - CHUYÊN BIỆT ĐỂ
					KHÁC BIỆT</h5>
				<p
					style="margin-bottom: 0; padding-bottom: 0; font-size: 13px; font-weight: 300; margin-top: 2px; font-style: italic;">Hotline:
					{$option.contact.phone}</p>
				<p
					style="margin-bottom: 0; padding-bottom: 0; font-size: 13px; font-weight: 300; margin-top: 2px; font-style: italic;">Email:
					{$option.contact.email}</p>
			</div>
		</div>
	</section>
	<section id="content">
		<div style="padding: 0.5rem 1.5rem">
			<p>
				Xin chào <b>{$data.name}</b>
			</p>
			<p>Cảm ơn quý khách đã đăng ký làm thành viên của Daisan.vn.</p>
			<p>Chúng tôi đã nhận được yêu cầu đăng ký của quý khách theo thông tin:</p>
		</div>
		<div
			style="padding: 1.5rem; position: relative; padding: .75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: .25rem; color: #004085; background-color: #cce5ff; border-color: #b8daff;">
			<p style="font-size: 1rem; font-weight: 300;">
				<i>Họ tên: <b>{$data.name}</b></i>
			</p>
			<p style="font-size: 1rem; font-weight: 300;">
				<i>SĐT: <b>{$data.phone}</b></i>
			</p>
			<p style="font-size: 1rem; font-weight: 300;">
				<i>Email: <b>{$data.email}</b></i>
			</p>
		</div>
		<div style="padding: 0 1.5rem">
			<p>Vui lòng nhấn vào nút kích hoạt tài khoản dưới đây để kích hoạt tài khoản.</p>
			<p style="display: flex; justify-content: center">
				<a href="{$data.url}"
					style="isplay: inline-block; font-weight: 400; text-align: center; white-space: nowrap; vertical-align: middle; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; border: 1px solid transparent; padding: 0.5rem 1rem; font-size: 1rem; line-height: 1.5; border-radius: .25rem; transition: color .15s ease-in-out, background-color .15s ease-in-out, border-color .15s ease-in-out, box-shadow .15s ease-in-out; color: #fff; background-color: #007bff; border-color: #007bff; text-decoration: none">Kích hoạt tài khoản</a>
			</p>
		</div>
		<hr
			style="margin-top: 1rem; margin-bottom: 1rem; border: 0; border-top: 1px solid rgba(0, 0, 0, .1);border-bottom-style: dotted;">
		<div
			style="position: relative; padding: .75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: .25rem; color: #856404; background-color: #fff3cd; border-color: #ffeeba;">
			<i>Lưu ý: Đây là email gửi tự động, bạn không nên trả lời lại
				e-mail này.</i>
		</div>
		<p style="padding: .25rem 1.25rem;">Trân trọng !</p>
	</section>
	<footer
		style="background-color: #f8f9fa !important; padding: 10px 20px">
		{$option.contact.description} </footer>
</div>