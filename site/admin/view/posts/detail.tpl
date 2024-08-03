<h1>{$post.title}</h1>
<p class="text-small">
	<span><i class="fa fa-user fa-fw"></i>{$post.username}</span>
	<span><i class="fa fa-clock-o fa-fw"></i>{$post.created|date_format:'%H:%I %d/%m/%Y'}</span>
	<span><i class="fa fa-eye fa-fw"></i>{$post.views} lượt xem</span>
	<span><i class="fa fa-folder-open-o fa-fw"></i>{$post.categories}</span>
</p>
<div class="text-center">
	<img alt="" src="{$post.avatar}" style="max-width: 100%; min-width: 68%;">
</div>
<h3>{$post.description}</h3>
<div>{$post.content}</div>