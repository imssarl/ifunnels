{if $error=='delete'}
{include file='../../message.tpl' type='error' message="Can't delete project."}
{/if}
{if $msg=='success'}
{include file='../../message.tpl' type='success' message="Project was deleted."}
{/if}

<a class="btn btn-success btn-rounded waves-effect waves-light" href="{url name='site1_contentbox' action='create'}" >Create new </a>

{if $arrList}
<table class="table table-striped">
<thead>
	<tr>
		<th>Box Name</th>
		<!--<th>Input Code</th>-->
		<th>Edited{include file="../../ord_backend.tpl" field='d.edited'}</th>
		<th>Added{include file="../../ord_backend.tpl" field='d.added'}</th>
		<th>Options</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td colspan="4">{include file="../../pgg_backend.tpl"}</td>
	</tr>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<td>{$v.name}</td>
		<!--<td>{$v.jscode}</td>-->
		<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
		<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td class="option">
			<a href="{url name='site1_contentbox' action='create'}?id={$v.id}" title="Edit"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
			<a href="{url name='site1_contentbox' action='manage'}?delete={$v.id}" class="delete" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
			<a href="#mb" class="mb" rel="type:element,width:400" title="Get Code"><i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;"></i><span class="hidden">{$v.jscode}</span></a>
		</td>
	</tr>
	{/foreach}
	<tr>
		<td colspan="4">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
<div  style="display:none;">
<div id="mb">
	<div class="card-box">
		<p>It is necessary to add the following line to the head tag: <span style="color: #f00;">&lt;meta name="viewport" content="width=device-width, initial-scale=1"&gt;</span></p>
		<div id="code" style="display:block;">
			<textarea class="clipboard-text clipboard-id-2 form-control" id="code-input" rows="5" cols="80"></textarea>
			<br/>
			<!--<center><a class="clipboard-click clipboard-id-2 btn btn-success waves-effect waves-light" href="#">Copy to clipboard</a></center>
			<br/> 
			<div id="clipboard_content"></div>
			<button type="button" {is_acs_write} id="close" class="button btn btn-success waves-effect waves-light">Close</button>-->
		</div>
	</div>
</div>
</div>
{else}
<div>No items found</div>
{/if}
{literal}
<script type="text/javascript" src="/skin/_js/clipboard/clipboard.js"></script>
<script type="text/javascript">
var multibox;
var managerClass = new Class({
	initialize: function(){
		if( $$('.popup') !== null ){
			multibox=new CeraBox( $$('.popup'), {
				group: false,
				width:'950px',
				height:'620px',
				displayTitle: true,
				titleFormat: '{title}'
			});
		}
	}
});
window.addEvent('domready', function() {
new managerClass();
	jQuery('a.mb').click(function(){
		jQuery('#code-input').html(jQuery(this).children('span').html());
	});
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		displayTitle: true,
		titleFormat: '{title}',
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%'
	});
	var _clipboard = {};
	$('close').addEvent( 'click', function() {
		CeraBoxWindow.close();
	});
	window.addEvent("domready", function(){
		_clipboard=new Clipboard($$('.clipboard-click'));
	});
});
</script>
{/literal}