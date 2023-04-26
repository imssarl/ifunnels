<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
{foreach from=$errFlow item=strError}
{include file="../../message.tpl" type='error' message=$strError}
{/foreach}
{if $strMsg}{include file="../../message.tpl" type='info' message="Campaign is saved"}{/if}

{if isset($arrPromotions)}
	<h2>Post Promotion Report</h2>
	{if empty($arrPromotions) }
		Please choose your promotion type
	{else}
		<table>
			<thead>
			<tr>
				<th width="40%">&nbsp;</th>
				<th align="center" width="20%">Promotion Date</th>
				<th align="center" width="20%">In Queue</th>
				<th align="center" width="20%">Completed</th>
				<th align="center" width="20%">Error</th>
			</tr>
			</thead>
			<tbody>
				{foreach from=$arrPromotions item=i key=k}
					<tr {if $k%2=='0'} class="alt-row"{/if}>
						<td>{Project_Synnd::$promotionTypes.{$i.flg_type}.name}</td>
						<td>{$i.added|date_format:$config->date_time->dt_full_format}</td>
						<td align="center">{if $i.flg_status==0}{$i.promote_count}{/if}</td>
						<td align="center">{if $i.flg_status==1}{$i.promote_count}{/if}</td>
						<td align="center">{if $i.flg_status==2}<a class="Tips" title="{Project_Synnd_Reports::$_errorCode[$i.error_code]}">{$i.promote_count}</a>{/if}</td>
					</tr>
				{/foreach}
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2">{include file="../../pgg_frontend.tpl"}</td>
				</tr>
			</tfoot>
		</table>
	{/if}
{elseif isset($schedule)}
	<h2>Post Shedule Settings</h2>
	<form class="reg_form wh validate" action="" method="post">
		<input name="arrCampaign[id]" type="hidden" value="{$smarty.get.id}" />
		<p>
			<label>Automatic campaign submission:</label>
			<input name="arrCampaign[flg_type]" type="radio" value="0"{if $arrCampaign.flg_type==0} checked="checked"{/if} />&nbsp;one time<br />
			<input name="arrCampaign[flg_type]" type="radio" value="1"{if $arrCampaign.flg_type==1} checked="checked"{/if} />&nbsp;once a week<br />
			<input name="arrCampaign[flg_type]" type="radio" value="2"{if $arrCampaign.flg_type==2} checked="checked"{/if} />&nbsp;once a month
		</p>
		<p>
			<label>&nbsp;</label>
			<input type="submit" value="Start" name="save" class="button" />
		</p>
	</form>
{else}
	<h2>Post Promotion Settings</h2>
	<form class="reg_form wh validate" id="submit_popup_form" action="" method="post">
		<input name="arrCampaign[id]" type="hidden" value="{$smarty.get.id}"/>
		<input name="arrCampaign[settings][url]" type="hidden" value="{$arrCampaign.settings.url}" />
		<input name="arrCampaign[settings][synndSiteId]" type="hidden" value="{$arrCampaign.settings.synndSiteId}" />
		<input name="arrCampaign[settings][synndCampaignId]" type="hidden" value="{$arrCampaign.settings.synndCampaignId}" />
		<input name="arrCampaign[settings][titleId]" type="hidden" value="{$arrCampaign.settings.titleId}" />
		<input name="arrCampaign[settings][descriptionId]" type="hidden" value="{$arrCampaign.settings.descriptionId}" />
		{foreach from=$arrCampaign.settings.tagsIds item=i key=k}<input name="arrCampaign[settings][tagsIds][{$k}]" type="hidden" value="{$i}" />
		{/foreach}
		<fieldset>
		<p>
			<label>Title <em>*</em></label>
			<input name="arrCampaign[settings][title]" type="text" id="request_title" class="required text-input medium-input" value="{$arrCampaign.settings.title}"/>
		</p>
		<p>
			<label>Tags <em>*</em></label>
			<input name="arrCampaign[settings][tags]" type="text" id="request_keywords" class="required text-input medium-input" value="{$arrCampaign.settings.tags}" />
		</p>				
		<p>
			<label>Description <em>*</em></label>
			<textarea name="arrCampaign[settings][description]" id="request_description" class="required" >{$arrCampaign.settings.description}</textarea>
		</p>
		<p>
			Url: {$arrCampaign.settings.url}
		</p>
		<p>
			<label>Category: </label>
			<select name="arrCampaign[settings][category_id]" type="text" class="required" >
				{if isset($lastCategoryId)}{$lastcategory=$lastCategoryId}{else}{$lastcategory=$arrCampaign.settings.category_id}{/if}
				{foreach from=$arrCategories item=i key=k}<option value="{$i.id}"{if $lastcategory==$i.id} selected="selected"{/if}>{$i.title}</option>{/foreach}
			</select>
		</p>
		<p style="font-size:14px;font-family:Verdana">
			- You should run a <b> Social Bookmarking</b> campaign on all your content for SEO benefits<br/>
			<br/>
			- You should run a <b>Social News / Voting</b> campaign on all your best, non- promotional content that is appropriate for human voting activities.<br/>
			(benefit is then indirect: people share your best content, which drives traffic to your content and then funnel it into your money pageS)<br/>
			<br/>
			In summary, with <b>Social News</b> campaigns you have to link to content that is of social interest and you have to link to "specific" content within your domain. This content cannot be promotional in nature. With <b>Social bookmarking</b>, you can link to any content.<br/>
		</p>
		{include file="site1_promotions_types.tpl"}
		<p>
			<span id="promote_cost"></span>
		</p>
		<p>
			<label>Automatic campaign submission:</label>
			<input name="arrCampaign[flg_type]" type="radio" value="0"{if $arrCampaign.flg_type==0} checked="checked"{/if} />&nbsp;one time<br />
			<input name="arrCampaign[flg_type]" type="radio" value="1"{if $arrCampaign.flg_type==1} checked="checked"{/if} />&nbsp;once a week<br />
			<input name="arrCampaign[flg_type]" type="radio" value="2"{if $arrCampaign.flg_type==2} checked="checked"{/if} />&nbsp;once a month
		</p>
		<p>
			<label>&nbsp;</label>
			<input {is_acs_write} type="submit" value="Create Campaign" id="submit_popup_box" name="save" class="button" />
		</p>
		</fieldset>
	</form>

{literal}
<script type="text/javascript">
var slider_var=new Array();
function checkPromotions() {
	var static_amount=0;
	$$('.check_promotion').each( function( e ) {
		if( e.getStyle('display') != 'none' ) {
			static_amount+=parseFloat( e.getElement('input').value) * parseFloat( e.get('rel') );
		}
	});
	$('promote_cost').set('html', 'Cost of campaign '+Math.ceil( static_amount )+' credit(s).');
}
(function() {
	$$('.slider_promotions').each(function(elt) {
		slider_var[elt.get('id')]=new Slider( elt, elt.getElement('.knob'), {
			steps: 100,
			initialStep: elt.getNext('input').get('value'),
			onChange: function(value) {
				if (value) {
					elt.getNext('input').set('value', value);
					elt.getPrevious('label').getElement('span.text').set('html', value);
					checkPromotions();
				}
			}
		});
	});
	$$('.check').addEvent('change', function(elt) {
		$('checkeddiv_'+this.get('rel')).show();
		if( !this.checked ) {
			$('checked_'+this.get('rel')).value=0;
			slider_var['slider_'+this.get('rel')].setKnobPosition(0);
			$('slider_'+this.get('rel')).getPrevious('label').getElement('span.text').set('html', 0);
			$('checkeddiv_'+this.get('rel')).hide();
		}
		checkPromotions();
	});
	$$('.check_promotion').addEvent('change', function( elt ) {
		checkPromotions();
	});
	checkPromotions();
	$('submit_popup_box').addEvent('click',function(elt){
		elt.stop();
		if( validator.checker.validate() ){
			$('submit_popup_form').submit();
		}
		$$('.check').addEvent('change', function(elt){
			$('checkeddiv_'+this.get('rel')).show();
			if( !this.checked ){
				$('checked_'+this.get('rel')).value=0;
				slider_var['slider_'+this.get('rel')].setKnobPosition(0);
				$('slider_'+this.get('rel')).getPrevious('label').getElement('span.text').set('html', 0);
				$('checkeddiv_'+this.get('rel')).hide();
			}
			checkPromotions();
		});
	});
}).delay(100);

</script>
{/literal}
{/if}
{literal}
<script type="text/javascript">
{/literal}{if $strMsg=='saved'}{literal}
window.parent.location.reload();
{/literal}{/if}{literal}


			var Tips3 = new Tips($$('.Tips'), {
				fixed: true
			});

$$('.Tips').each(function(a){
	a.addEvent('click', function(e){
		if ( e.get('href') != null )
			e.stop()
	})
});
</script>
{/literal}
</div>
</body>
</html>