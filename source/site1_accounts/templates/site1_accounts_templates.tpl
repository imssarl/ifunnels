<div class="card-box">
{include file='../../box-top.tpl' title=$arrNest.title}
<form method="post" action="" class="wh" id="create_ncsb" >
	<fieldset>
		<div class="form-group">
			<label>Manage Template:</label>
			<select id="links" class="medium-input btn-group selectpicker show-tick">
			<option value="">Please Select One Option
			<option value="{url name='site1_ncsb' action='templates'}">Niche Content Site Builder
			<option value="{url name='site1_nvsb' action='templates'}">Niche Video Site Builder
			</select>
		</div>
	</fieldset>
</form>
{include file='../../box-bottom.tpl'}
</div>
{literal}
<script>
	window.addEvent('domready',function(){
		$('links').addEvent('change', function(){
			if( $chk($('links').value) ){
				location.href=$('links').value;
			}
		});
	});
</script>
{/literal}