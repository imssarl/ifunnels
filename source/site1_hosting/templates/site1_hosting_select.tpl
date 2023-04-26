<fieldset>
	<legend>{if $arrPrm.flg_bf!=1}Hosting settings{/if}</legend>
		<div class="form-group">
			<label for="domain-settings-id">Domains: <em>*</em></label>
			{if !in_array($placement.domain_http,$arrPlacements['Domains hosted with us'])&&$placement.flg_type!=Project_Placement::REMOTE_HOSTING}
				{$placement.domain_http}<input  id="domain-settings-id" type="hidden" value="{$placement.id}" name="{$arrayName}[placement_id]" />
			{else}
			<select class="required btn-group selectpicker show-tick" name="{$arrayName}[placement_id]" id="domain-settings-id" >
			<option value="">- select -</option>
			{html_options options=$arrPlacements selected=$placement.id}
			</select>
			{/if}
		</div>

		<div class="form-group" id="hosting-settings-url-block" style="display: {if !empty($placement)&&$placement.flg_type==Project_Placement::REMOTE_HOSTING}block{else}none{/if};">
			<label>Url: <em>*</em></label>
			<input type="text" name="{$arrayName}[url]" id="hosting-settings-url" value="{$arrPrm.selected.url}" class="form-control" />
			<br/><small>Example: http://www.mydomain.com/myfolder/ </small>
		</div>
		{if empty($arrPrm.show_browse) && empty($arrPrm.with_file)}
		<div class="form-group" id="hosting-set-root-block" {if !empty($placement)&&$placement.flg_type!=Project_Placement::REMOTE_HOSTING&&$arrPrm.selected.ftp_directory=='/'} style="diaply: block;" {else} style="display: none;"{/if}>
			<div class="checkbox checkbox-primary">
				<input type="checkbox" {if !empty($placement)&&$placement.flg_type!=Project_Placement::REMOTE_HOSTING&&$arrPrm.selected.ftp_directory=='/'}checked="1"{/if} value="1" id="hosting-set-root" name="{$arrayName}[ftp_root]" />
				<label>Install at root level</label>
			</div>
		</div>
		{/if}
		<div class="form-group" id="hosting-settings-dir-block" {if !empty($placement)&&$placement.flg_type!=Project_Placement::REMOTE_HOSTING&&$arrPrm.selected.ftp_directory=='/'} style="display: none;" {else}style="display: {if !empty($placement)}block{else}none{/if};"{/if}>
			<div class="form-group">
				{if empty($arrPrm.with_file)}
				<label>Homepage Folder: <em>*</em></label>
				{else}
				<label>Select Page File/Folder: <em>*</em></label>
				{/if}
				<input type="text" class="required form-control" id="domain-settings-directory" name="{$arrayName}[ftp_directory]" readonly="1" value="{$arrPrm.selected.ftp_directory}">&nbsp;<a {if !empty($placement)&&$placement.flg_type==Project_Placement::REMOTE_HOSTING}style="display: none;"{/if} href="" id="hosting-directory-tips" class="Tips" title='If folder does not exist, it will be automatically created. For example: "forex-software"'>?</a><a href="{url name='site1_hosting' action='browse'}{if $arrPrm.with_file}?mode=with_files{/if}" class="popup_mb mb" title="Browse FTP" rel=",type:iframe" id="href" {if empty($arrPrm.show_browse)&& empty($arrPrm.with_file)&&(!empty($placement)&&$placement.flg_type!=Project_Placement::REMOTE_HOSTING)}style="display: none;"{/if}><span id="browse">Browse</span></a>
				<div id="hosting-directory-helper"  {if !empty($placement)&&$placement.flg_type!=Project_Placement::REMOTE_HOSTING}style="display: none;"{/if}>
				{if empty($arrPrm.with_file)}
				<small>Сlick 'Browse' link and select the folder of your site install. It will fill in the path to your folder automatically.
				<br/>If you are creating a site in a root of domain (e.g. www.mydomain.com), select 'public_html' folder in the popup.
				<br/>If you are creating a site in a subfolder (e.g. mydomain.com/site), click the 'public_html' folder title (not the icon), and it will open a list of your subfolders. Select the subfolder, where your site should be installed, by clicking the folder icon next to it.</small>
				{else}
				<small>Сlick 'Browse' link and select the file you would like to edit.
				<br/>If you are creating a new file, select folder or subfolder in the popup.</small>
				{/if}
				</div>
			</div>
		</div>
		{if $arrPrm.flg_bf==1}
		<p>
			 <a href="#" class="acc_next button" rel="1">Next step</a>
		</p>
		{/if}
</fieldset>

<script type="text/javascript">
var flg_bf={$arrPrm.flg_bf|default:0};
var show_browse={$arrPrm.show_browse|default:0};
var with_file={$arrPrm.with_file|default:0};
{literal}
var placementType=0;
window.addEvent('domready', function(){
	{/literal}
	{if !empty($placement)&&$placement.flg_type!=Project_Placement::REMOTE_HOSTING&&$arrPrm.flg_bf==1}
		blogFushSwitcher(1);
	{/if}
	{literal}
	var init=function(){
		$('domain-settings-id').addEvent('change',function(){
			$('domain-settings-directory').set('value','');
			Object.each(this.options,function(option){
				if( option.value==''){
					$('hosting-settings-url-block').setStyle('display','none');
					$('hosting-settings-dir-block').setStyle('display','none');
					$('domain-settings-directory').set('readonly',true);
					if( show_browse==0 && with_file==0 )
						$('hosting-set-root-block').setStyle('display','none');
					$('hosting-directory-tips').setStyle('display','none');
					$('hosting-directory-helper').setStyle('display','none');
					if( flg_bf==1 ){
						blogFushSwitcher(0);
					}
					placementType=1;
				}
				if( option.selected&&option.getParent().get('label')=='Domains hosted with us' ){
					$('hosting-settings-url-block').setStyle('display','none');
					$('hosting-settings-url').removeClass('required');
					$('hosting-settings-dir-block').setStyle('display',( show_browse==0 && with_file==0 )?'none':'block');
					if( show_browse==0 && with_file==0 )
						$('hosting-set-root-block').setStyle('display','block');
					$('hosting-directory-tips').setStyle('display',( show_browse==0 && with_file==0)?'inline':'none');
					if( show_browse==0 && with_file==0 )
						$('hosting-set-root').set('checked',true);
					$('domain-settings-directory').set('value','/');
					$('hosting-directory-helper').setStyle('display',( show_browse==0 && with_file==0 )?'none':'block');
					if( flg_bf==1 ){
						blogFushSwitcher(1);
					}
					placementType=1;
				}
				if( option.selected&&option.getParent().get('label')=='Domains you host externally' ){
					$('hosting-settings-url-block').setStyle('display',( show_browse==0 )?'block':'none');
					$('hosting-settings-dir-block').setStyle('display','block');
					$('hosting-directory-helper').setStyle('display','block');
					if( show_browse==0 && with_file==0 )
						$('hosting-set-root-block').setStyle('display','none');
					$('hosting-directory-tips').setStyle('display','none');
					$('href').setStyle('display','inline');
					$('hosting-settings-url').addClass('required');
					$('domain-settings-directory').addClass('required');
					$('domain-settings-directory').set('readonly',true);
					if( flg_bf==1 ){
						blogFushSwitcher(0);
					}
					placementType=0;
				}
				$('hosting-settings-url').set('value','');
				$('domain-settings-directory').set('value','');
			});
			if( placementType==0 && show_browse==0 && with_file==0 ){
				$('browse').click();
			}
		});
		if( show_browse==0 && with_file==0 )
		$('hosting-set-root').addEvent('click',function(){
			if( this.checked ){
				$('hosting-settings-dir-block').setStyle('display','none');
				$('href').setStyle('display','inline');
				$('domain-settings-directory').set('readonly',true);
				$('domain-settings-directory').set('value','/');
			} else {
				$('hosting-settings-dir-block').setStyle('display','block');
				$('href').setStyle('display','none');
				$('domain-settings-directory').set('value','');
				$('domain-settings-directory').set('readonly',false);
			}
		});
	}
	init();
	$('browse').addEvent('click',function(e) {
		if( $('domain-settings-id').value != '' && parseInt( $('domain-settings-id').value )==0 ){
			e.stop();
			init();
			return false;
		}
		var myURI=new URI($('href').href);
		myURI.setData({
			placement_id:$('domain-settings-id').value,
			url:$('hosting-settings-url').value,
			ftp_directory:$('domain-settings-directory').value
		},true);
		$('href').href=myURI.toString();
		init();
	});
	var optTips = new Tips('.Tips', {className: 'tips'});
	$$('.Tips').each(function(a){
		a.addEvent('click', function(e){
			if ( e.get('href') != null )
				e.stop()
		})
	});
});

var placePath=function(path) {
	$('domain-settings-directory').value=path;
}
</script>
{/literal}