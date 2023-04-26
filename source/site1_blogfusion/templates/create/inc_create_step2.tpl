<div class="form-group">
	<fieldset>
		<!--start 1-->
		<h3>&nbsp;&nbsp;1) Header graphics</h3>
		<p>
			<label>Upload Header [960 X 180 px]</label>
			<div style="margin: -16px 0 0 180px">
				{if !empty($arrBlog.prop_settings.header)}{module name='files' action='view_file' file_id=$arrBlog.prop_settings.header.id prefix="Blogfusion"}{/if}
			</div>
			<input type="file" name="header" style="margin: 0 0 0 180px" />
			<input type="hidden" name="arrBlog[prop_settings][header][id]" value="{$arrBlog.prop_settings.header.id}"/>
		</p>
		<!--end 1-->
		<!--start 2-->
		<h3>&nbsp;&nbsp;2) Below header and navigation bar</h3>
		<p>
			<label></label>
			<input type="radio" name="arrBlog[prop_settings][bar]" {if $arrBlog.prop_settings.bar == 'upload_banner'}checked='checked'{/if} class="header_bar"  value="upload_banner" /> Upload banner<br/>
			<input type="radio" name="arrBlog[prop_settings][bar]" {if $arrBlog.prop_settings.bar == 'code'}checked='checked'{/if} class="header_bar" value="code" /> Code snippet<br/>
			<input type="radio" name="arrBlog[prop_settings][bar]" {if $arrBlog.prop_settings.bar == 'adsense_code'}checked='checked'{/if} class="header_bar" value="adsense_code" /> Adsense code<br/>
		</p>
		<div id="upload_banner" class="header_bar_block" style="display:{if $arrBlog.prop_settings.bar == 'upload_banner'}block{else}none{/if};">
			<p>
				<label>Upload Banner <em>*</em></label>
				<div style="margin: -16px 0px 0px 180px">
					{if !empty($arrBlog.prop_settings.banner)}{module name='files' action='view_file' file_id=$arrBlog.prop_settings.banner.id prefix="Blogfusion"}{/if}
				</div>
				<input type="file" name="banner" class="required" style="margin: 0 0 0 180px"/>
				<input type="hidden" name="arrBlog[prop_settings][banner][id]" value="{$arrBlog.prop_settings.banner.id}"/>
			</p>
			<p>
				<label>Hyperlink URL <em>*</em></label>
				<textarea name="arrBlog[prop_settings][url]" class="required text-input textarea" style="height:45px;" >{$arrBlog.prop_settings.url}</textarea>
			</p>
		</div>
		<div id="code" class="header_bar_block"  style="display:{if $arrBlog.prop_settings.bar == 'code'}block{else}none{/if};">
			<p>
				<label>Code <em>*</em></label>
				<textarea name="arrBlog[prop_settings][code]" class="required text-input textarea" style="height:100px;">{$arrBlog.prop_settings.code}</textarea>
			</p>
		</div>
		<div id="adsense_code" class="header_bar_block"  style="display:{if $arrBlog.prop_settings.bar == 'adsense_code'}block{else}none{/if};">
			<p>
				<label>Adsense ID <em>*</em></label>
				<input name="arrBlog[prop_settings][adsense]" class="required text-input medium-input" value="{$arrBlog.prop_settings.adsense}" type="text" />
				<small>For your Adsense ads to be displayed properly, you need to provide your Google Adsense ID</small>
			</p>
		</div>
		<!--end 2-->
		<!--start 3-->
		<h3>&nbsp;&nbsp;3) Links </h3>
		<p>
			<label>Links to External site</label>
			<textarea name="arrBlog[prop_settings][links]" style="height:100px;" >{$arrBlog.prop_settings.links}</textarea>
			<small>Please enter here links with anchor tag like
			{assign var = links value="<a href='http://www.xyz.com'> My another site</a>"}{$links|escape},
			If you want to open this link in new window then use "target='_blank'" in anchor tag.
			If you are creating more than one link, Separate Each Link with (,) comma</small>
		</p>
		<!--end 3-->
				
		<!--start 4-->
		<h3>&nbsp;&nbsp;4) Configure sidebar </h3>
		<div>
			<input type="hidden" class="initShuf" name="arrBlog[prop_settings][place][]" value="{if isset($arrBlog.prop_settings.place)}{$arrBlog.prop_settings.place[0]}{else}affiliate{/if}"   id="affilate_place">
			<a href="#" class="shuffel" rel="1"><img src="/skin/i/frontends/design/down_arrow.gif" border="0"></a>
			<div  id="affiliate" class="shuffCont">
				<label>Affilated Programs</label>
				<textarea  id="affilated_programs" name="arrBlog[prop_settings][affiliate]" class="text-input textarea" style="height:100px;">{$arrBlog.prop_settings.affiliate}</textarea>
			</div>
		</div>
		<div>
			<input type="hidden" class="initShuf" name="arrBlog[prop_settings][place][]" value="{if isset($arrBlog.prop_settings.place)}{$arrBlog.prop_settings.place[1]}{else}subscription{/if}" id="subscription_place" >
			<a href="#" class="shuffel" rel="2"><img src="/skin/i/frontends/design/up_arrow.gif"  border="0"></a><br/>
			<a href="#" class="shuffel" rel="1"><img border="0" src="/skin/i/frontends/design/down_arrow.gif"></a>
			<div id="subscription" class="shuffCont">
				<label>Subscription Form</label>
				<textarea id="subscription_form" name="arrBlog[prop_settings][subscription]" class="text-input textarea" style="height:100px;">{$arrBlog.prop_settings.subscription}</textarea>
			</div>
		</div>
		<div>
			<input type="hidden" class="initShuf" name="arrBlog[prop_settings][place][]" value="{if isset($arrBlog.prop_settings.place)}{$arrBlog.prop_settings.place[2]}{else}adsense_sky{/if}"  id="adsense_sky_place">
			<a href="#" class="shuffel" rel="3"><img src="/skin/i/frontends/design/up_arrow.gif"  border="0"></a>
			<div  id="adsense_sky" class="shuffCont">
				<label>Adsense Skycraper</label>
				<textarea  id="adsense_skycraper" name="arrBlog[prop_settings][adsense_sky]" class="text-input textarea" style="height:100px;">{$arrBlog.prop_settings.adsense_sky}</textarea>
			</div>
		</div>
		<p><a href="#" class="acc_prev button">Prev step</a>  <a href="#" class="acc_next button">Next step</a></p>
		<!--end 4-->
	</fieldset>
</div>