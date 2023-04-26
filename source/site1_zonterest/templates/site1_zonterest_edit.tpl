<br />
<link rel="stylesheet" type="text/css" href="/skin/light/css/card.css">
<div align="center">
	<div style="width:58%;">
		<a class="" href="{url name='site1_zonterest' action='edit'}?id={$smarty.get.id}" rel="create_form" style="color: #5fbeaa;">General</a>
		{if Core_Acs::haveAccess( array('Zonterest PRO 2.0') )} |
		<a class="" href="{url name='site1_zonterest' action='content'}?id={$smarty.get.id}"
		 rel="create_form">Posts</a>
		{/if}
	</div>
</div>
<br />
<table width="100%" border="0">
	<tr>
		<td width="200" valign="top" align="left">
			<h3>Sites</h3>
			<ul class="v-menu" style="padding: 0 0 0 17px;">
				{foreach from=$menuSites item=i}
				<li{if $i.id == $arrNcsb.id} style="color: #5fbeaa;"{/if}>
					<a href="./?id={$i.id}"{if $i.id == $arrNcsb.id} style="color: #5fbeaa;"{/if}>{$i.main_keyword|ellipsis:"30"}</a>
				</li>
				{/foreach}
			</ul>
		</td>
		<td align="left" valign="top">
			{include file='../../error.tpl' fields=['ftp_directory'=>'Homepage Folder','domain_id'=>'Domain','template_id'=>'Template',
			'category_id'=>'Select Category','url'=>'Url','navigation_length'=>'Article Navigation Length', 'main_keyword'=>'Title','flg_snippet'=>'Display
			type','arrArticleIds'=>'Articles list']}
			<form method="post" action="" class="wh validate" id="create_ncsb">
				<input type="hidden" name="arrNcsb[id]" value="{$arrNcsb.id}" />
				<p>Please complete the form below. Mandatory fields are marked with
					<em>*</em>
				</p>
				{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641}
				<div style="display:none;">{/if} {module name='site1_hosting' action='select' selected=$arrNcsb arrayName='arrNcsb'} {if isset($arrNcsb.category_id)
					&& $arrNcsb.category_id==641}</div>{/if}
				<fieldset>
					{if count( $arrTemplates ) > 1}
					<legend>Site template</legend>
					<div class="form-group">
						<label for="templates">Template
							<em>*</em>
						</label>
						<a href="#" class="btn btn-default waves-effect waves-light m-l-10" data-toggle="modal" data-target="#select-template">Select Template</a>
						{if !empty($arrNcsb.template_id)}
						<div class="row m-t-10">
							<div class="col-md-3">
								<div class="card m-b-20" data-template>
									<img class="card-img-top img-fluid img-responsive" src="{$arrTemplates[$selectedTemplate].preview}">
									<div class="card-body">
										<p class="card-text">{$arrTemplates[$selectedTemplate].description}</p>
									</div>
								</div>
							</div>
						</div>
						{/if}
						<input type="hidden" value="{$arrNcsb.template_id}" name="arrNcsb[template_id]" />
					</div>
					{else}
					<input type="hidden" value="{$arrNcsb.template_id}" name="arrNcsb[template_id]"> {/if}
					<div>
						<div align="center">
							<img src="" border="0" alt="" id="template_img" />
							<p id="divdesc"></p>
						</div>
					</div>
				</fieldset>
				<span{if $smarty.get.template} style="display:none;" {/if}>
					<fieldset>
						<input type="hidden" name="arrNcsb[category_id]" value="{$arrNcsb.category_id}" />
						<legend>Configuration settings</legend>
						<!--<div class="form-group"{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641} style="display:none;"{/if}>
			<label>Select Category <em>*</em></label>
			<select id="category" class="required medium-input validate-custom-required emptyValue:'0' btn-group selectpicker show-tick">
				<option value="0"> - select -
				{foreach from=$arrCategories item=i}
					<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}
				{/foreach}</select><br/>
			<select name="arrNcsb[category_id]" class="required medium-input validate-custom-required emptyValue:'0' btn-group selectpicker show-tick" id="category_child" ></select>
		</div>-->
						<div class="form-group" {if isset($arrNcsb.category_id) && $arrNcsb.category_id==641} style="display:none;" {/if}>
							<label for="adsenseid">
								<span>Adsense ID </span>
							</label>
							<input name="arrNcsb[google_analytics]" type="text" class="medium-input text-input form-control" id="adsenseid" value="{if !empty($arrNcsb.google_analytics)}{$arrNcsb.google_analytics}{else}{Core_Users::$info['adsenseid']}{/if}"
							/>
						</div>
						<div class="form-group">
							<label for="mainkeyword">
								<span>Title
									<em>*</em>
								</span>
							</label>
							<input name="arrNcsb[main_keyword]" type="text" id="mainkeyword" value="{$arrNcsb.main_keyword}" class="required medium-input text-input form-control"
							/>
						</div>
					</fieldset>
					<fieldset>
						<legend>Source settings</legend>
						<div class="form-group">
							<label for="articlenavigationlength">
								<span>Article Navigation Length
									<em>*</em>
								</span>
							</label>
							<input name="arrNcsb[navigation_length]" class="text-input medium-input form-control" type="text" id="articlenavigationlength"
							 value="{if $arrNcsb.navigation_length==0&&$arrNcsb.id}5{else}{$arrNcsb.navigation_length}{/if}" />
							<p>(number of links to articles to display in the sidebar)</p>
						</div>
						<input type="hidden" name="arrNcsb[flg_snippet]" value="no" /> {if Core_Acs::haveAccess( array('Zonterest PRO 2.0') )}
						<div class="form-group">
							{module name='site1_articles' action='multiboxplace' selected=$strJson place='content_wizard' type='multiple' required=0}
							<div id="articleList"></div>
						</div>
						{/if}
					</fieldset>
					{if !isset($arrNcsb.category_id) || $arrNcsb.category_id!=641} {module name='advanced_options' action='optinos' site_type=Project_Sites::NCSB
					site_data=$arrOpt} {/if}
					</span>
					<button class="button btn btn-success waves-effect waves-light" type="submit" {is_acs_write}>{if $smarty.get.id}Save site{else}Generate new site{/if}</button>
			</form>
		</td>
	</tr>
</table>

<div id="select-template" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="full-width-modalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog" style="width:55%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="full-width-modalLabel">AzonFunnels Templates</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					{foreach  from=$arrTemplates item=template}
					<div class="col-md-4">
						<div class="card m-b-20">
							<img class="card-img-top img-fluid img-responsive" src="{$template.preview}" style="height: 235px; width: auto; max-width: 100%;" />
							<div class="card-body">
								<p class="card-text">{$template.description}</p>
							</div>
							<div class="form-group text-center">
								<button class="btn btn-default waves-effect waves-light" data-template="{$template.id}" data-dismiss="modal">Select</button>
							</div>
						</div>
					</div>
					{/foreach}
				</div>
			</div>
		</div>
	</div>
</div></script>
{literal}
<script type="text/javascript">
	var templates = {/literal}{json_encode($arrTemplates)}{literal};
	jQuery( document ).ready( function(){
		jQuery( 'button[data-template]' ).on( 'click', function(){
			var self = this;
			jQuery( 'input[name="arrNcsb[template_id]"]' ).prop( 'value', jQuery( this ).data( 'template' ) );
			Object.keys( templates ).forEach( function( item ){
				if( templates[item].id == jQuery( self ).data( 'template' ) ){
					jQuery( 'div[data-template] .card-img-top' ).prop( 'src', templates[item].preview );
					jQuery( 'div[data-template] .card-text' ).html( templates[item].description );
				}
			} );
			jQuery('#select-template').modal( 'hide' );
			return false;
		} );
	} );
</script>
{/literal}