<div class="body-head">
	<h1><i class="fa fa-cog fa-fw"></i> Cấu hình thông tin các link liên kết trên website</h1>
</div>
<div class="item sml">
	<div class="box">
		<form method="post" action="">
			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label>Facebook Link</label> 
						<input type="text" class="form-control" name="facebook" value="{$values.facebook|default:''}">
					</div>
					<div class="form-group">
						<label>Youtube Link</label> 
						<input type="text" class="form-control" name="youtube" value="{$values.youtube|default:''}">
					</div>
					<div class="form-group">
						<label>Twitter Link</label> 
						<input type="text" class="form-control" name="twitter" value="{$values.twitter|default:''}">
					</div>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label>Website</label> 
						<input type="text" class="form-control" name="website" value="{$values.website|default:''}">
					</div>
					<div class="form-group">
						<label>Skype Chat</label> 
						<input type="text" class="form-control" name="skype" value="{$values.skype|default:''}">
					</div>
					<div class="form-group">
						<label>Google+</label> 
						<input type="text" class="form-control" name="google" value="{$values.google|default:''}">
					</div>
				</div>
			</div>
			<hr>
			<button type="submit" class="btn btn-primary" name="submit">Lưu thông tin</button>
			<button type="reset" class="btn btn-default">Reset From</button>
		</form>
	</div>
</div>
