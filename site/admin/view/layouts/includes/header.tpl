<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar">
				<span class="sr-only">Toggle navigation</span> 
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span>
			</button>
            <button id="toggle_sidebar" class="pull-left visible-xs-block"><i class="fa fa-list fa-lg"></i></button>
			<a class="navbar-brand" href="./">
                <img src="/site/upload/logo/admin_logo.png" alt="Daisan" width="96"/>
            </a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<ul class="nav navbar-nav">
				<li><a href="{$arg.domain}" target="_blank"><i class="fa fa-home fa-fw"></i> Home</a></li>
				<li><a href="?mod=posts&site=create"><i class="fa fa-plus fa-fw"></i> Thêm bài viết</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="?mod=home&site=content"><i class="fa fa-file-text-o fa-fw"></i> Nội dung</a></li>
				<li><a href="?mod=option&site=index"><i class="fa fa-cog fa-fw"></i> Cấu hình</a></li>
				<li><a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-life-ring fa-fw"></i> Trợ giúp <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="#"><i class="fa fa-user fa-fw"></i> Tài khoản</a></li>
                        <li><a href="javascript:void(0);" data-toggle="modal" data-target="#PassModal"><i class="fa fa-unlock-alt fa-fw"></i> Đổi mật khẩu</a></li>
						<li><a href="#" data-toggle="modal" data-target="#ChangeLanguage"><i class="fa fa-language fa-fw"></i> Ngôn ngữ</a></li>
						<li><a href="?mod=account&site=logout"><i class="fa fa-sign-out fa-fw"></i> Đăng xuất</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
</nav>

<!-- Change Language Modal -->
<div class="modal fade" id="ChangeLanguage">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Lựa chọn ngôn ngữ quản trị</h4>
            </div>
            <div class="modal-body">
            	<ul class="nav nav-pills nav-stacked">
            		{foreach from=$use_languages key=k item=data}
            		<li {if $k eq $arg.lang}class="active"{/if}><a href="javascript:void(0);" onclick="SetLanguage('{$k}');"><img alt="" src="{$arg.stylesheet}custom/flags/{$k}.png">&ensp;{$data} ({$k})</a></li>
            		{/foreach}
            	</ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- Change Password Modal -->
<div class="modal fade" tabindex="-1" role="dialog" id="PassModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form class="form-horizontal" id="PassForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Thay đổi mật khẩu quản trị</h4>
                </div>
                <div class="modal-body">
                    <p id="pass_error" class="text-center" style="color:#DE2728; display:none;"></p>
                    <div class="form-group">
                        <label for="oldPass" class="col-sm-4 control-label">Mật khẩu cũ</label>
                        <div class="col-sm-6">
                            <input type="password" name="oldpass" class="form-control pass_input" id="oldPass" placeholder="Nhập mật khẩu cũ">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="newPass" class="col-sm-4 control-label">Mật khẩu mới</label>
                        <div class="col-sm-6">
                            <input type="password" name="newpass" class="form-control pass_input" id="newPass" placeholder="Nhập mật khẩu mới">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="retypeNewPass" class="col-sm-4 control-label">Nhập lại mật khẩu mới</label>
                        <div class="col-sm-6">
                            <input type="password" name="renewpass" class="form-control pass_input" id="retypeNewPass" placeholder="Nhập lại mật khẩu mới">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="ChangePassword();">Lưu lại</button>
                </div>
            </form>
        </div>
    </div>
</div>

{literal}
<script>
function SetLanguage(lang){
	$.post('?mod=language&site=ajax_set_language_used', {'lang': lang}).done(function(){
		location.reload();
	});
}
</script>
{/literal}