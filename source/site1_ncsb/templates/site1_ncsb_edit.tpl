<br />
<div align="center">
	<div  style="width:58%;">
		<a class="" href="{url name='site1_ncsb' action='edit'}?id={$smarty.get.id}"   rel="create_form">General</a> |
		<a class="" href="{url name='site1_ncsb' action='content'}?id={$smarty.get.id}"   rel="create_form">Posts</a>
	</div>
</div>
<br />
<table width="100%" border="0">
	<tr>
		<td width="200" valign="top" align="left">
			<h3>Sites</h3>
			<ul class="v-menu" style="padding: 0 0 0 17px;">
				{foreach from=$menuSites item=i}
				<li> <a href="./?id={$i.id}">{$i.main_keyword|ellipsis:"30"}</a> </li>
				{/foreach}
			</ul>
		</td>
		<td align="left" valign="top">
{include file='../../error.tpl' fields=['ftp_directory'=>'Homepage Folder','domain_id'=>'Domain','template_id'=>'Template',
'category_id'=>'Select Category','url'=>'Url','navigation_length'=>'Article Navigation Length',
'main_keyword'=>'Main Keyword','flg_snippet'=>'Display type','arrArticleIds'=>'Articles list']}
<form method="post" action="" class="wh validate" id="create_ncsb" >
<input type="hidden" name="arrNcsb[id]" value="{$arrNcsb.id}" />
	<p>Please complete the form below. Mandatory fields are marked with <em>*</em></p>
	{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641}<div style="display:none;">{/if}
	{module name='site1_hosting' action='select' selected=$arrNcsb arrayName='arrNcsb'}
	{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641}</div>{/if}
	<fieldset>
		<legend>Site template</legend>
		<div class="form-group">
			<input type="hidden" value="{$arrNcsb.template_id}" name="arrNcsb[old_template_id]">
			<label for="templates">Template <em>*</em></label>
			<select name="arrNcsb[template_id]" id="templates" class="required medium-input validate-custom-required btn-group selectpicker show-tick">
				<option value=''> - select - </option>
				{html_options options=$arrTemplates selected=$arrNcsb.template_id}
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
		<div class="form-group"{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641} style="display:none;"{/if}>
			<label>Select Category <em>*</em></label>
			<select id="category" class="required medium-input validate-custom-required emptyValue:'0' btn-group selectpicker show-tick">
				<option value="0"> - select -
				{foreach from=$arrCategories item=i}
					<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}
				{/foreach}</select><br/>
			<select name="arrNcsb[category_id]" class="required medium-input validate-custom-required emptyValue:'0' btn-group selectpicker show-tick" id="category_child" ></select>
		</div>
		<div class="form-group"{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641} style="display:none;"{/if}>
			<label for="adsenseid"><span>Adsense ID </span></label>
			<input name="arrNcsb[google_analytics]" type="text" class="medium-input text-input form-control" id="adsenseid" value="{if !empty($arrNcsb.google_analytics)}{$arrNcsb.google_analytics}{else}{Core_Users::$info['adsenseid']}{/if}"/>
		</div>
		<div class="form-group"><label for="mainkeyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrNcsb[main_keyword]" type="text" id="mainkeyword" value="{$arrNcsb.main_keyword}" class="required medium-input text-input form-control" />
		</div>
		<div class="form-group">
			<label></label>
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="arrNcsb[syndication]" {if $arrNcsb.syndication||(empty( $arrNcsb.id )&&empty( $arrErr ))} checked=""{/if} />
				<label>Add site to syndication network</label>
			</div>
		</div>
	</fieldset>
	<fieldset>
		<legend>Source settings</legend>
		<div class="form-group">
			<label for="articlenavigationlength"><span>Article Navigation Length <em>*</em></span></label>
			<input name="arrNcsb[navigation_length]" class="text-input medium-input form-control" type="text" id="articlenavigationlength" value="{if $arrNcsb.navigation_length==0&&$arrNcsb.id}5{else}{$arrNcsb.navigation_length}{/if}" />
			<p>(number of links to articles to display in the sidebar)</p>
		</div>
		<div class="form-group">
			<label>Display type <em>*</em></label>
			<div class="radio radio-primary">
				<input name="arrNcsb[flg_snippet]" type="radio" id="show_full" value="no"{if $arrNcsb.flg_snippet==0} checked="1"{/if}>
				<label>Full Article (display random article on the home page)</label>
			</div>
			<div class="radio radio-primary">
				<input name="arrNcsb[flg_snippet]" type="radio" id="flg_snippets" value="yes"{if $arrNcsb.flg_snippet=='1'} checked="1"{/if} class="validate-one-required">
				<label>Snippets (display article snippets on the home page)</label>
			</div>
		</div>
		<div class="form-group" style="display:{if $arrNcsb.flg_snippet == 'yes'}block{else}none{/if};" id="flg_snippets_1">
			<label for="snippet_number"><span>Number of article snippets</span>
			<input name="arrNcsb[snippet_number]" type="text" id="snippet_number" value="{$arrNcsb.snippet_number}"  class="text-input medium-input form-control"/>
		</div>
		<div class="form-group" style="display:{if $arrNcsb.flg_snippet == 'yes'}block{else}none{/if};" id="flg_snippets_2">
			<label for="snippet_length"><span>Length of each snippet</span>
			<input name="arrNcsb[snippet_length]" type="text" class="text-input medium-input form-control" id="snippet_length" value="{$arrNcsb.snippet_length}" />
		</div>
		<div class="form-group">
			{module name='site1_articles' action='multiboxplace' selected=$strJson place='content_wizard' type='multiple' required=0}
			<div id="articleList"></div>
		</div>
	</fieldset>
	{if !isset($arrNcsb.category_id) || $arrNcsb.category_id!=641}
	{module name='advanced_options' action='optinos' site_type=Project_Sites::NCSB site_data=$arrOpt}
	{/if}
	</span>
	<button class="button btn btn-success waves-effect waves-light" type="submit" {is_acs_write}>{if $smarty.get.id}Save site{else}Generate new site{/if}</button>
</form>
		</td>
	</tr>
</table>