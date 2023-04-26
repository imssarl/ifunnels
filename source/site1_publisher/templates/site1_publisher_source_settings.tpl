<script type="text/javascript" src="/skin/_js/categories.js"></script>	
{literal}
<script type="text/javascript">
var arrErrors = new Hash();
var multiboxnoerrors;
var SourceObject = new Class({
	seeErrors: function(e) {
		if ( this.errors.getLength() > 0 ) {
			this.errors = '';
			this.add_event();
			return false;
		}
		if ( e.target.id != 'create' && e.target.id != 'content-filter' ) {
			$(e.target.id).erase('class');
			$(e.target.id).set('class', 'noerrors');
			validator.checker.reset();
			var arrquery = new Hash();
			$('content_'+this.source_id).getElements('input, select, textarea').each(function(el){
				if  ( ((el.type == "radio" || el.type == "checkbox" )&&(el.checked))|| ( el.type!="radio" && el.type!="checkbox" ) ) {
					arrquery.set( (el.name).replace( /arrCnt\[\d{1,}]\[settings\]/ , 'arrFlt') , el.value);
				}
			});
			arrquery.set('flg_source',this.source_id);
			arrquery.set('id',true);
			var newURI = new URI($(e.target.id).get('href'));
			if( $(e.target.id).get('data-href') == null ){
				$(e.target.id).set('data-href', $(e.target.id).get('href'))
			}else{
				newURI = new URI($(e.target.id).get('data-href'));
			}
			$(e.target.id).set('href', newURI.setData(arrquery).toString());
			multiboxnoerrors=new CeraBox( $(e.target.id), {
				group: false,
				width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
				height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
				fullSize:true
			});
			multiboxnoerrors.currentItem=0;
			multiboxnoerrors.boxWindow.loading(multiboxnoerrors);
			multiboxnoerrors.showIframe();
			this.add_event();
			return true;
		}else{
			this.add_event();
			return true;
		}
	},
	checkErrors: function(e){
		e.stop();
		validator.checker.reset();
		validator.reinit($$('form.validate')[0]);
		$(e.target.id).removeEvents('click');
		this.errors = new Hash();
		$('content_'+this.source_id).getElements('input.required, textarea.required').each(function(el){
			if  ( (((el.type == "radio")&&(el.checked))||el.type!="radio" ) && (el.value == "") ) {
				validator.checker.validateField( el , true);
				this.errors.set( el.getProperty('alt') );
			}
		},this);
		$('content_'+this.source_id).getElements('select.required').each(function(el){
			if ( el.value == "" || el.value == "0" ) {
				validator.checker.validateField( el , true);
				this.errors.set( el.getProperty('alt') );
			}
		},this);
		return this.seeErrors(e);
	},
	add_event: function(){
		if ($('add_multibox') != null) {
			$('add_multibox').addEvent('click', function(evt) {
				window.parent.visual.jsonValue = null;
				this.source_id = $('select_content').value;
				selectedSource.checkErrors(evt);
			}.bind(this));
		}
		if ( $('content-filter') != null ) {
			$('content-filter').addEvent('click',function(evt){
				window.parent.visual.jsonValue = null;
				var popup_url = new URI(window.location);
				var arrquery = new Hash();
				$('content_'+this.source_id).getElements('input, select, textarea').each(function(el){
					if  ( ((el.type == "radio")&(el.checked))||(el.type!="radio") ) 
						arrquery.set( el.name.replace( /arrCnt\[\d{1,}\]\[settings\]/ , 'arrFlt') , el.value);
				});
				arrquery.set('flg_source',this.source_id);
				arrquery.set('id',true);
				if (selectedSource.checkErrors(evt)) {
					popup_url.setData(arrquery);
					window.location=popup_url.toString();
					
					
//					$('filter_form').set('action', popup_url.toString());
//					$('filter_form').submit();
				}
			}.bind(this));
		}
	}
});
var SourceTypeObject = new Array();
</script>
{/literal}
{if $arrPrm.modelSettings == 0 || empty($arrPrm.modelSettings)}
<div class="card-box">
<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Subscriptions</h3>
	</div>
	<div class="content-box-content">
		<form action="" method="post" class="wh" id="externaldata" enctype="multipart/form-data">
			<div id="accordion-test-2" class="panel-group">
				{foreach Project_Content::toLabelArray() as $i}
				{if $i.title!='Articles' 
					&& $i.title!='Videos' 
					&& $i.title!='Keywords' 
					&& $i.title!='Pure Articles' 
					&& $i.title!='Pure Videos' 
					&& $i.title!='RSS' 
					&& $i.title!='PLR Articles'
					
					
					&& $i.title!='Clickbank'
					&& $i.title!='Ebay'
					&& $i.title!='Commision Junction'
					&& $i.title!='LinkShare'
					&& $i.title!='ShopZilla'
					&& $i.title!='Yahoo answers'}
				<div class="panel panel-default">
					<div class="panel-heading">
						<h4 class="panel-title">
							<a href="#collapseOne-{$i.flg_source}" data-toggle="collapse" data-parent="#accordion-test-2" aria-expanded="false" class="collapsed">{$i.title} Options</a>
						</h4>
					</div>
					<div id="collapseOne-{$i.flg_source}" class="panel-collapse collapse">
						<div class="panel-body">
							{include file="external/{$i.label}.tpl" type="edit"}
						</div>
					</div>
				</div>
				{/if}
				{/foreach}
			</div>
			<button type="submit" id="editExtend" class="btn btn-success waves-effect waves-light">Save</button>
		</form>
	</div>
</div>
<div class="block2" id="mess"></div>
</div>
{else}
	{$arrCnt.{$arrPrm.selectedSource}.settings = $arrPrm.settings}
	{foreach Project_Content::toLabelArray() as $i}
		{if empty($arrPrm.selectedSource)}
			<div id="content_{$i.flg_source}" class="option_content" {if $arrPrm.selectedSource != {$i.flg_source}}style="display:none;"{/if} >{include file="external/{$i.label}.tpl"}</div>
		{elseif $arrPrm.selectedSource == {$i.flg_source}}
			<div id="content_{$i.flg_source}" class="option_content" >{include file="external/{$i.label}.tpl"}</div>
		{/if}
	{/foreach}
{/if}

{literal}
<script type="text/javascript">
var objAccordion = {};
var selectedSource;
var SourceSettings = new Class ({
	initialize: function(){
		// Acordion functions
		objAccordion = new Fx.Accordion($('accordion'), $$('.toggler'), $$('.element'), {
			display: {/literal}{if isset($arrPrm.selectedSource)}{$arrPrm.selectedSource}{else}0{/if}{literal}
		});
		// Title functions
		var optTips = new Tips('.Tips', {className: 'tips'});
		$$('.Tips').each(function(a){
			a.addEvent('click', function(e){
				if ( e.get('href') != null )
					e.stop()
			})
		});
		{/literal}{if !empty($arrPrm.selectedSource)}{literal}
		selectedSource=new SourceTypeObject[{/literal}{$arrPrm.selectedSource}{literal}];
		selectedSource.add_event();
		{/literal}{/if}
		{if $arrPrm.modelSettings == 0 || empty($arrPrm.modelSettings)}{literal}
		var activateSource=function(){
			this.removeEvent('click',activateSource);
			var id=this.get('alt');
			selectedSource = new SourceTypeObject[id];
			objAccordion.display(id);
		}
		$$('h3.toggler').addEvent('click', activateSource);
		{/literal}{/if}{literal}
	}
});
window.addEvent('domready', function(){
	new SourceSettings();
});
</script>
{/literal}