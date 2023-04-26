<h3>{$arrPrm.title} only iFunnels - Business Program</h3>
<div class="row">
	<div class="col-lg-12">
		{if $msg!=''}
		<div class="alert alert-success alert-dismissable">
			<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
			<div>{$msg}</a></div>
		</div>
		{/if}
		{if $error!=''}
			{include file='../../message.tpl' type='error' message=$error}
		{/if}
	</div>   
</div>   

<input type="text" id="email" placeholder="Search by email:" value="{$smarty.get.email}">
<input type="button" value="Search" id="search"/>
<input type="button" value="Stop Check" id="stop"/>

<table class="table table-striped">
	<thead>
		<tr>
			<th><span id="load_percent_title">Users Checked</span> <span id="load_percent">0%</span></th>
		</tr>
	</thead>
	<tbody>
		{foreach $arrUsers as $item}
		<tr class="{if ($item@iteration-1) is div by 2} matros{/if} add_user_id user_ids" rel="{$item.id}" style="display:none;">
			<td>{$item.email}</td>
		</tr>
		{foreachelse}
		<tr class="matros"><td class="text-center">Empty</td></tr>
		{/foreach}
	</tbody>
</table>
{literal}
<script type="text/javascript">
var allUsers=$$('.user_ids').length;
var allChecked=0;
var flgStopCheck=false;
$('stop').addEvent( 'click', function() {
	flgStopCheck=true;
});
$('search').addEvent( 'click', function(){
	if( !flgStopCheck ){
		$$('.add_user_id').addClass( 'user_ids' );
		$$('.user_ids').hide();
		$('load_percent').set('html', '0%' );
	}
	flgStopCheck=false;
	loadData();
});
var loadData=function(){
	if( flgStopCheck ){
		return;
	}
	var counter = $$('.user_ids').length;
	if( counter > 0 ){
		new Request({
			url: '',
			onComplete:function( string ){
				if( string == 1 ){
					$$('.user_ids')[0].show();
					$$('.user_ids')[0].removeClass('user_ids');
				}else{
					$$('.user_ids')[0].removeClass('user_ids');
				}
				$('load_percent').set('html', ( (allUsers-counter+1)*100/allUsers ).toFixed(2)+'%' );
				loadData();
			}
		}).post({ 'user_id':$$('.user_ids')[0].get('rel'), 'email': $('email').get('value') });
	}
}
</script>
{/literal}