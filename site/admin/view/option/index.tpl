<div class="body-head">
	<h1><i class="fa fa-cog fa-fw"></i> Thông tin cấu hình tổng quan</h1>
</div>
<div class="item sml">
	<div class="box">
		<form method="post" action="">
			<div class="row">
				<div class="col-xs-7">
					<div class="form-group">
						<h3>{$contact.name|default:''}</h3>
						<p>({$contact.name_short|default:''})</p>
					</div>
					<div class="form-group">
						<label>Slogan: {$contact.slogan|default:''}</label> 
					</div>
					<div class="form-group">
						<label>Điện thoại: {$contact.phone|default:''}</label>
					</div>
					<div class="form-group">
						<label>Email: {$contact.email|default:''}</label>
					</div>
					<div class="form-group">
						<label>Địa chỉ: {$contact.address|default:''}</label>
					</div>
					<a href="?mod=option&site=contact" class="btn btn-default">Chỉnh sửa thông tin liên hệ</a>
					<hr>
					
					<div class="form-group">
						<label>Meta title: {$seo.title|default:''}</label>
					</div>
					<div class="form-group">
						<label>Meta Keyword: </label>
						<p>{$seo.keyword|default:''}</p>
					</div>
					<div class="form-group">
						<label>Meta Descriotion: </label>
						<p>{$seo.description|default:''}</p>
					</div>
					<a href="?mod=option&site=seo" class="btn btn-default">Chỉnh sửa thông tin cấu hình seo</a>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label>Website</label> 
						<input type="text" class="form-control" value="{$link.website|default:''}">
					</div>
					<div class="form-group">
						<label>Facebook Link</label> 
						<input type="text" class="form-control" value="{$link.facebook|default:''}">
					</div>
					<div class="form-group">
						<label>Youtube Link</label> 
						<input type="text" class="form-control" value="{$link.youtube|default:''}">
					</div>
					<div class="form-group">
						<label>Twitter Link</label> 
						<input type="text" class="form-control" value="{$link.twitter|default:''}">
					</div>
					<div class="form-group">
						<label>Skype Chat Account</label> 
						<input type="text" class="form-control" value="{$link.skype|default:''}">
					</div>
					<div class="form-group">
						<label>Google+</label> 
						<input type="text" class="form-control" value="{$link.google|default:''}">
					</div>
					<a href="?mod=option&site=link" class="btn btn-default">Chỉnh sửa các link liên kết trên website</a>
				</div>
			</div>
		</form>
	</div>
</div>