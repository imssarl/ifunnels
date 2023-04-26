<div class="card-box">
<form action="" method="get" id="form-filter">
	<div class="input-group">
        <span class="input-group-btn">
        	<button type="button" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
        </span>
        <input type="text" name="arrFilter[domain_http]" id="domain_http" class="form-control" placeholder="Domain" value="{$smarty.get.arrFilter.domain_http}">
    </div>
	<!--Domain: <input type="text" name="arrFilter[domain_http]" class="small-input text-input" id="domain_http" value="{$smarty.get.arrFilter.domain_http}" />&nbsp;<input type="submit" value="Search" class="button" />{if !empty($smarty.get.arrFilter.domain_http)}&nbsp;<input type="button" value="Reset" id="reset" class="button" />{/if}-->
</form>
<form action="" method="post" id="form-domains">
<table class="table  table-striped">
	<thead>
	<tr>
		<th width="20" >
			<div class="checkbox checkbox-primary" style="margin-bottom: 0;">
				<input type="checkbox" id="select-all" />
				<label style="min-height: 14px;"></label>	
			</div>
		</th>
		<th align="center">Domain{include file="../../ord_frontend.tpl" field='d.domain_http'}</th>
		<th width="15%" align="center">Status{include file="../../ord_frontend.tpl" field='d.flg_checked'}</th>
		<th width="10%" align="center">Action</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i}
	{if $i.flg_type==Project_Placement::LOCAL_HOSTING||$i.flg_type==Project_Placement::LOCAL_HOSTING_DOMEN}
	{assign var=k value=$k+1}
	<tr {if $k%2=='0'} class="alt-row"{/if}>
		<td align="center">
			<div class="checkbox checkbox-primary">
				<input class="checkbox-del" type="checkbox" name="del[]" value="{$i.id}" />
				<label></label>	
			</div>
			
		</td>
		<td>{$i.domain_http}</td>
		<td align="center">{if $i.flg_checked==1}<span class="grn">available</span>{elseif $i.flg_checked==2}<span class="red cursor-help Tips" title="Please make sure DNS were propery set for your domain.">not verified</span>{else}<span class="red cursor-help Tips" title="Domain is registered and we're checking DNS transfer to CNM Hosting.<br/> In the meantime, you can generate websites on this domain, even<br/>  though there might be some delay before you can browse them from your location.">checking</span>{/if}</td>
		<td align="center"><a href="?del={$i.id}" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a></td>
	</tr>
	{/if}
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4">
				
			</td>
		</tr>
	</tfoot>
</table>
<button type="button" value="" id="delete" class="button btn btn-success waves-effect waves-light">Delete</button>
</form>
{literal}
<script type="text/javascript">
	window.addEvent('domready',function(){
		$('select-all').addEvent('click',function(e){
			$$('.checkbox-del').each(function(el){
				el.set('checked',$('select-all').checked);
			});
		});
		$('delete').addEvent('click',function(e){
			if(!confirm('Delete domains?')){
				e.stop();
				return;
			}
			$('form-domains').submit();
		});
		$('reset').addEvent('click',function(){
			$('domain_http').set('value','');
			$('form-filter').submit();
		});
	});
</script>
{/literal}
</div>