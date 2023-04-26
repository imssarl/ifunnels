<div>
{if !$arrList}
	<div style="float:left; width: 100%">
		Select IAM templates <a href="{url name='iam' action='manage_templates'}">HERE</a>
	</div>
{else}
{if $arrExpiry}
	{if $arrExpiry.Hosting}
	<div style="float:left; width: 100%">
		{foreach from=$arrExpiry.Hosting item='s'}
			Hosting {$s.domain_http} {if $s.expiry_hosting_timer > 0}expire after {$s.expiry_hosting_timer|date_format:"%d"} days{else}expired {$s.expiry_hosting_timer|date_format:"%d"} days ago{/if}<br/>
		{/foreach}
	{/if}
	{if $arrExpiry.Domain}
		{foreach from=$arrExpiry.Domain item='s'}
			Domain {$s.domain_http} {if $s.expiry_domain_timer > 0}expire after {$s.expiry_domain_timer|date_format:"%d"} days{else}expired {$s.expiry_domain_timer|date_format:"%d"} days ago{/if} <br/>
		{/foreach}
	</div>
	{/if}
{/if}
{if $arrUpdate}
<div style="float:left; width: 100%">
	{foreach from=$arrUpdate item='s'}
		Update Domain data from Namecheap {$s.domain_http} to data {$s.expiry_domain|date_format:"%d"}<br/>
	{/foreach}
</div>
{/if}
<table class="info glow" style="width:90%;">
<form action="" id="current-form" method="post">
	<input type="hidden" name="mode" value="" id="mode" />
	<tr><td colspan="5">
	{include file="../../pgg_frontend.tpl"}
	</td></tr>
<thead>
<tr>
	<th style="padding-right:0;" width="1px"><input type="checkbox" id="activate" class="tooltip" title="Activate in IAM" rel="Check to select all" /></th>
	<th>Site type</th>
	<th style="width:120px;">Category</th>
	<th>URL
		{if $arrPg.recall>1}
			{if $arrFilter.order!='url--up'}<a href="{url name='site1_syndication' action='manage_sites' wg='order=url--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='url--dn'}<a href="{url name='site1_syndication' action='manage_sites' wg='order=url--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	<th>Last modified
		{if $arrPg.recall>1}
			{if $arrFilter.order!='catedit--up'}<a href="{url name='site1_syndication' action='manage_sites' wg='order=catedit--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='catedit--dn'}<a href="{url name='site1_syndication' action='manage_sites' wg='order=catedit--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	<th>Options</th>
</tr>
</thead>
<tbody>
{foreach from=$arrList key='k' item='v'}
<tr{if $k%2=='0'} class="alt-row"{/if}>
	<td style="padding-right:0;">
		<input type="checkbox" name="active[{$v.id}-{$v.site_type}]" class="check-me-activate check-{$v.id}" {if $v.flg_iam>0}checked{/if} />
		<input type="hidden" name="old[{$v.id}-{$v.site_type}]" value="{if $v.flg_iam>0}on{/if}"  />
	</td>
	<td>{if $v.site_type==Project_Sites::NCSB}NCSB{elseif $v.site_type==Project_Sites::BF}Blog Fusion{elseif $v.site_type==Project_Sites::NVSB}NVSB{/if}</td>
	<td>{if $v.category_id}{$v.category_name}{else}not selected{/if}</td>
	<td><a href="{$v.url}" target="_blank">{$v.url}</a></td>
	<td>{$v.edited|date_format:$config->date_time->dt_full_format|default:'not changed'}</td>
	<td>
		{if $v.site_type==Project_Sites::NCSB}
			<a href="{url name='iam' action='manage_site'}?site_id={$v.id}&user_id={$v.user_id}&update_template=true" class="update_template">Update template</a> | 
		{/if}
		{if $v.flg_iam>0}
		<a href="{url name='iam' action='create_form'}?site_id_type={$v.id}_{$v.site_type}">Create form</a> | 
		{/if}
		<a href="{url name='iam' action='manage_site'}?site_id={$v.id}&download=true" target="_blank">Download Pages</a> | 
		<a href="{$v.url}" class="open_pages" rel="{$v.id}">Pages</a>
		<div class="pages_block" style="display:none;">
			<p>{$v.url}index-z-[MM_Member_Data name='customField_1'].html</p>
		</div>
	</td>
</tr>
{/foreach}
</tbody>
<tfoot>
	<tr><td colspan="5">
		<div class="bulk-actions align-left">
			<input type="submit" value="Activate in IAM" id="activate_run" class="button"/>
		</div>
		{include file="../../pgg_frontend.tpl"}
	</td></tr>
</tfoot>
</form>
</table>

{/if}
</div>
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){

	checkboxToggle($('activate'));
	
	$('activate_run').addEvent('click',function(e){
		e && e.stop();
		if(!confirm('Are you sure you want to activate/deactivate this sites for IAM?')) {
			return;
		}
		$('mode').set('value','activate');
		$('current-form').submit();
	});
	
	$$('.update_template').each(
		function(elt){
			elt.addEvent('click',function(e){
				e && e.stop();
				new Request({
					url: elt.get('href'),
					onSuccess: function( response ){
						alert( 'success' );
					}
				}).send();
			});
		}
	);
	
	$$('.open_pages').addEvent('click',function(e){
		e && e.stop();
		if( e.target.getNext().getStyle('display') == 'none' ){
			if( e.target.get('href') != '#' ){
				new Request({
					url: '{/literal}{url name="iam" action="manage_sites_pages"}{literal}',
					onComplete:function( string ){
						//console.log('next load ');
						//console.log($$('.home_page')[0]);
						Array.each( JSON.decode( string ), function(item){
							//console.log( $$('.home_page')[0].get('href')+item.link+"-z-[MM_Member_Data name='customField_1'].html" );
							new Element('p',{html: e.target.get('href')+item.link+"-z-[MM_Member_Data name='customField_1'].html"})
								.inject(
									e.target.getNext()
								);
						});
						e.target.getNext().show();
						e.target.set('href','#');
						e.target.empty().appendText( 'Close' );
					}
				}).post({ 'site_id':e.target.get('rel') });
			}else{
				e.target.getNext().show();
				e.target.empty().appendText( 'Close' );
			}
		}else{
			e.target.getNext().hide();
			e.target.empty().appendText( 'Pages' );
		}
	});

	$$('.click-me-activate').addEvent('click',function(e){
		e && e.stop();
		var el='check-'+this.get('id');
		if ( !$(el).get('checked') ) {
			$(el).set('checked',true);
			if ($(el).get('checked')) {
				$('activate_run').fireEvent('click');
			}
			$(el).set('checked',false);
		}
	});
});
</script>
{/literal}