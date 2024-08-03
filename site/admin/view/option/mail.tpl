<div class="body-head">
	<h1><i class="fa fa-cog fa-fw"></i> Cấu hình nhận/ gửi Email</h1>
</div>
<div class="item sml">
	<div class="box">
		<form method="post" action="">
			<div class="row">
				<div class="col-xs-6">
					<h3>Cấu hình email gửi</h3>
					<div class="form-group">
						<label>Email gửi *</label> 
						<input type="email" class="form-control" name="send_mail" value="{$values.send_mail|default:''}">
					</div>
					<div class="form-group">
						<label>Mật khẩu ứng dụng *</label> 
						<input type="password" class="form-control" name="send_pass" value="{$values.send_pass|default:''}">
					</div>
					<div class="form-group">
						<label>Tên người gửi</label> 
						<input type="text" class="form-control" name="send_name" value="{$values.send_name|default:''}">
					</div>
					<div class="form-group">
						<label>Tiêu đề Email</label> 
						<input type="text" class="form-control" name="send_title" value="{$values.send_title|default:''}">
					</div>
					<div class="checkbox">
						<label> 
							<input name="mail_on" {if isset($values.mail_on) && $values.mail_on eq 1}checked {/if}type="checkbox"> 
							Bật chức năng gửi Email
						</label>
					</div>
				</div>
				<div class="col-xs-5">
					<h3>Cấu hình email nhận</h3>
					<div class="form-group">
						<label>Email nhận *</label> 
						<input type="email" class="form-control" name="receive_mail" value="{$values.receive_mail|default:''}">
					</div>
					<div class="form-group">
						<label>Tên người nhận</label> 
						<input type="text" class="form-control" name="receive_name" value="{$values.receive_name|default:''}">
					</div>
		
				</div>
			</div>
			<hr>
			<div class="form-group">
				<button type="submit" class="btn btn-primary" name="submit">Lưu thông tin</button>
				<button type="reset" class="btn btn-default">Reset From</button>
			</div>
		</form>
	</div>
</div>
