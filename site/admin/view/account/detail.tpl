<div class="widget widget-table action-table">
	<div class="widget-header">
		<i class="icon-th-list"></i>
		<h3>Cập nhật thông tin</h3>
	</div>
	<!-- /widget-header -->
	<div class="widget-content">

		<div>
			<form id="edit-profile" method="post" class="form-horizontal form">
				<fieldset>

					<div class="control-group">
						<label class="control-label" for="firstname">Tên đầy đủ</label>
						<div class="controls">
							<input type="text" class="span4" name="name" id="firstname" value="{$value.name}">
						</div>
						<!-- /controls -->
					</div>
					<!-- /control-group -->



					<div class="control-group">
						<label class="control-label" for="selectError3">Sinh nhật</label>
						<div class="controls">
							<select id="" name="day" class="span1 required">
								{$out.birthday.day}
							</select>
							<select id="" name="month" class="span1 required">
								{$out.birthday.month}
							</select>
							<select id="" name="year" class="span1 required">
								{$out.birthday.year}
							</select>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label" for="selectError3">Giới tính</label>
						<div class="controls">
							<select id="" name="gender" class="span2 required">
								{$out.gender}
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label" for="firstname">Địa chỉ</label>
						<div class="controls">
							<input type="text" class="span4" name="address" id="firstname" value="{$value.address}">
						</div>
						<!-- /controls -->
					</div>
					<!-- /control-group -->
					<br /> <br />


					<div class="control-group">
						<label class="control-label" for="firstname">Email</label>
						<div class="controls">
							<input type="text" class="span4" name="email" id="firstname" value="{$value.email}">
						</div>
						<!-- /controls -->
					</div>
					<!-- /control-group -->

					<div class="control-group">
						<label class="control-label" for="firstname">Điện thoại</label>
						<div class="controls">
							<input type="text" class="span4" name="phone" id="firstname" value="{$value.phone}">
						</div>
						<!-- /controls -->
					</div>
					<!-- /control-group -->
					<br /> <br />


					<div class="form-actions">
						<button type="submit" class="btn btn-primary" name="submit">Lưu lại</button>
						<button type="reset" class="btn">Hủy bỏ</button>
					</div>
					<!-- /form-actions -->
				</fieldset>
			</form>
		</div>
	</div>
</div>