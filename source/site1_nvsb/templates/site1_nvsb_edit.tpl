<br />
<div align="center">
	<div  style="width:58%;">
		<a class="" href="{url name='site1_nvsb' action='edit'}?id={$smarty.get.id}"   rel="create_form">General</a> |
		<a class="" href="{url name='site1_nvsb' action='content'}?id={$smarty.get.id}"   rel="create_form">Posts</a>
	</div>
</div>
<br />
<table width="100%" border="0">
	<tr>
		<td width="200" valign="top" align="left">
			<h3>Sites</h3>
			<ul class="v-menu">
				{foreach from=$menuSites item=i}
				<li> <a href="./?id={$i.id}">{$i.main_keyword|ellipsis:"30"}</a> </li>
				{/foreach}
			</ul>
		</td>
		<td align="left" valign="top">
{include file='../../error.tpl' fields=['ftp_directory'=>'Homepage Folder','domain_id'=>'Domain','template_id'=>'Template',
	'category_id'=>'Select Category','url'=>'Url','navigation_length'=>'Article Navigation Length',
	'main_keyword'=>'Main Keyword','flg_snippet'=>'Display type','arrArticleIds'=>'Articles list']}
<form method="post" action="" class="wh validate"  id="from-create" enctype="multipart/form-data">
<input type="hidden" name="arrNvsb[id]" value="{$arrNvsb.id}" />
	<p>Please complete the form below. Mandatory fields are marked with <em>*</em></p>
	{module name='site1_hosting' action='select' selected=$arrNvsb arrayName='arrNvsb'}
	<fieldset>
		<legend>Site template</legend>
		<div class="form-group">
			<input type="hidden" value="{$arrNvsb.template_id}" name="arrNvsb[old_template_id]" />
			<label>Template <em>*</em></label>
			<select class="required validate-custom-required medium-input btn-group selectpicker show-tick" id="select-template" name="arrNvsb[template_id]">
				<option value="" id=""> - select -</option>
				{foreach from=$arrTemplates item=i}
				<option {if $arrNvsb.template_id == $i.id}selected{/if} value="{$i.id}">{$i.title}
				{/foreach}
			</select>
		</div>
		<div class="form-group">
			<div align="center">
				<img src="" border="0" alt="" id="template_img" />
				<p id="divdesc"></p>
			</div>
		</div>
	</fieldset>
	<span{if $smarty.get.template} style="display:none;"{/if}>
	<fieldset>
		<legend>Configuration settings</legend>
		<div class="form-group">
			<label>Select Category <em>*</em></label>
			<select id="category" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick">
				<option value="0"> - select -
				{foreach from=$arrCategories item=i}
					<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}
				{/foreach}
			</select><br/>
			<select name="arrNvsb[category_id]" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick" id="category_child" ></select>
		</div>
		<div class="form-group">
			<label for="adsenseid"><span>Google Adsense ID </span></label>
			<input name="arrNvsb[google_analytics]" type="text" class="text-input medium-input form-control" id="adsenseid" value="{if !empty($arrNvsb.google_analytics)}{$arrNvsb.google_analytics}{else}{Core_Users::$info['adsenseid']}{/if}" />
			<br/><small>Format: pub-xxxxx; do not forget the pub-...</small>
		</div>
		<div class="form-group">
			<label for="mainkeyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrNvsb[main_keyword]"  class="required text-input medium-input form-control"  type="text" id="mainkeyword" value="{$arrNvsb.main_keyword}" />
			<br/><small>Example:Flower Gardening </small>
		</div>
		{if Core_Acs::haveRight( ['nvsb'=>['hosted','hostedpro']] )}
			<input type="hidden" name="arrNvsb[syndication]" value="on" />
		{else}
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="arrNvsb[syndication]" {if $arrNvsb.syndication||(empty( $arrNvsb.id )&&empty( $arrErr ))} checked=""{/if} />
				<label>Add site to syndication network</label>
			</div>
		</div>
		{/if}
	</fieldset>
	<fieldset>
		<legend id="in" style="cursor: pointer;">Advanced Settings</legend>
		<legend id="out" style="display: none;cursor: pointer;">Advanced Settings</legend>
		<div id="vertical_slide">
			<div class="form-group">
				<label>Do you want to add articles to the site now (they will show up in the Blog section of your site)?</label>	
				<div class="checkbox checkbox-primary">
					<input type="checkbox" {if $arrNvsb.flg_articles}checked=1{/if} name="arrNvsb[flg_articles]" id="source_type" />
					<label>Yes</label>
				</div>
			</div>
			<div id="source_block" style="display:{if $arrNvsb.flg_articles}block{else}none{/if};">
				{module name='site1_articles' action='multiboxplace' selected=$strJson place='content_wizard' type='multiple'}
				<div id="articleList"></div>
			</div>
			<div class="form-group">
				<label>Tag Cloud Word</label>
				<textarea name="arrNvsb[tag_cloud]" class="text-input textarea form-control" style="height:70px;" >{$arrNvsb.tag_cloud}</textarea>
				<br/><small>We recommend no more than 10 to 15 words. Separate each word with coma.</small>
			</div>
			<div class="form-group">
				<label>Related keywords</label>
				<div class="radio radio-primary">
					<input type="radio" value="0" name="arrNvsb[flg_related_keywords]"  {if $arrNvsb.flg_related_keywords==0} checked='1' {/if}>
					<label>hide</label>
				</div>
				<div class="radio radio-primary">
					<input type="radio" value="1" name="arrNvsb[flg_related_keywords]"   {if $arrNvsb.flg_related_keywords==1} checked='1' {/if}>
					<label>display</label>
				</div>
			</div>
			<div class="form-group">
				<label>Usage</label>
				<div class="radio radio-primary">
					<input type="radio" value="0" name="arrNvsb[flg_usage]" {if isset($arrNvsb.flg_usage) && $arrNvsb.flg_usage==0} checked='1' {/if}>
					<label>filter videos using mandatory keywords</label>
				</div>
				<div class="radio radio-primary">
					<input type="radio" value="1" name="arrNvsb[flg_usage]" {if !isset($arrNvsb.flg_usage) || $arrNvsb.flg_usage==1} checked='1' {/if}>
					<label>filter videos using banned keywords</label>
				</div>
			</div>
			<div class="form-group">
				<label>Mandatory keywords</label>
				<textarea name="arrNvsb[mandatory_keywords]"  class="text-input textarea form-control" style="height:70px;" >{$arrNvsb.mandatory_keywords}</textarea>
			</div>
			<div class="form-group">
				<label>Show comments</label>
				<div class="radio radio-primary">
					<input type="radio" value="0" name="arrNvsb[flg_comments]" {if $arrNvsb.flg_comments==0} checked='1' {/if}>
					<label>hide the comments</label>
				</div>
				<div class="radio radio-primary">
					<input type="radio" value="1" name="arrNvsb[flg_comments]" {if $arrNvsb.flg_comments==1} checked='1' {/if}>
					<label>show the comments and enable your vistors to add comments to your videos</label>
				</div>
			</div>
			{if $arrUser.id==1 || $arrUser.id==39180 || $arrUser.id==23551 || $arrUser.id==39182 || $arrUser.id==28832}
			<div class="form-group">
				<label>Keywords file</label>

				<input type="file" name="keywords" />
			</div>
			<div class="form-group">
				<label>Links file</label>
				<input type="file" name="links" />
			</div>
			{/if}
		</div>
	</fieldset>

	{module name='advanced_options' action='optinos' site_type=Project_Sites::NVSB site_data=$arrOpt}
	</span>
	<button type="submit" class="button btn btn-success waves-effect waves-light" id="create" {is_acs_write}>{if $smarty.get.id}Save site{else}Generate new site{/if}</button>
</form>
		</td>
	</tr>
</table>