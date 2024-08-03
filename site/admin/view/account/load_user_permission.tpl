<input type="hidden" name="id" value="{$id}">
<div class="permission">
{foreach from=$permission item=list}
    <div class="checkbox">
        <label>
            <input type="checkbox" name="active[]" value="{$list.permission_id}" {$list.active}> {$list.permission_name}
        </label>
    </div>
{/foreach}
</div>