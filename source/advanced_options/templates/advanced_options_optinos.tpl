<input type="hidden" name="post_true" value="1">
<fieldset>
	<legend>Advanced Customization Options</legend>	
		<div {if Core_Acs::haveAccess( array( "Site Profit Bot Hosted", "NVSB Hosted",'Video Site Bot' ) )} style="display:none;" {/if}>
			<div class="form-group">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" {if $arrOpt.dams.flg_content} checked="checked" {/if} id="dams-show" value="1" />
					<label>Do you want to add a floating, top / bottom, or corner ad?</label>
				</div>
			</div>
			<div style="display:{if $arrOpt.dams.flg_content}block{else}none{/if};">
				<div>
					<div class="radio radio-primary">
						<input type="radio" value="2" id="campaigns" {if $arrOpt.dams.flg_content==2} checked="checked"{/if} name="arrOpt[dams][flg_content]" class="dams-selector" />
						<label>Campaigns</label>
					</div>
					<div class="radio radio-primary">
						<input type="radio" value="1" id="split" {if $arrOpt.dams.flg_content==1} checked="checked"{/if} name="arrOpt[dams][flg_content]" class="dams-selector" />
						<label>Split</label>	
					</div>
					<div class="content-block"></div>
				</div>
			</div>
			<div class="form-group">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" value="1" {if $arrOpt.flg_traking==1} checked="1" {/if} name="arrOpt[flg_traking]"  id="traking-checkbox" />
					<label>Tracking Code</label>
				</div>
			</div>
			<div id="traking-code" style="display: {if $arrOpt.flg_traking==1}block{else}none{/if};">
				<label>Code:</label>
				<textarea name="arrOpt[traking_code]" class="textarea text-input form-control"  style="width:400px; height:100px;">{$arrOpt.traking_code}</textarea>
			</div>
		</div>
</fieldset>
<fieldset id="parent-spot-fields" {if Core_Acs::haveAccess( 'Zonterest PRO' )} style="disply:none;" {/if}>
	<legend>You can now customize the following spots.</legend>
	{foreach from=$arrSpots item=i name=spot}
	{assign var=spot value="spot{$smarty.foreach.spot.iteration}"}
	<!-- Start spot-->
	<fieldset>
		<legend>
			<div class="checkbox checkbox-primary">
				<input type="checkbox" {if !empty($arrOpt.spots[$spot].spot_name)} checked="checked" {/if} name="arrOpt[spots][{$smarty.foreach.spot.index}][spot_name]" id="spot{$smarty.foreach.spot.index}" class="check-position" value="spot{$smarty.foreach.spot.iteration}" />
				<label>{$i.caption}{if $i.preview}<a href="#" onclick="" class="screenshot" rel="<img src='/skin/i/frontends/design/options/{Project_Sites::$code[$arrPrm.site_type]}_{$smarty.foreach.spot.iteration}.jpg'>" style="text-decoration:none"><b> ?</b></a>{/if}</label>
			</div>
		</legend>
		<div style="display:{if empty($arrOpt.spots[$spot].spot_name)}none{else}block{/if};">
			<div class="form-group">
				<div class="radio radio-primary">
					<input type="radio" class="select-default" name="arrOpt[spots][{$smarty.foreach.spot.index}][flg_default]" value="0" {if $arrOpt.spots[$spot].flg_default==0} checked="checked" {/if} />
					<label>Default Adsense ads</label>
				</div>
				<div class="radio radio-primary">
					<input type="radio" class="select-default" name="arrOpt[spots][{$smarty.foreach.spot.index}][flg_default]" value="1" {if $arrOpt.spots[$spot].flg_default==1} checked="checked" {/if} />
					<label>Replace by...</label>
				</div>
				<div class="radio radio-primary">
					<input type="radio" class="select-default" name="arrOpt[spots][{$smarty.foreach.spot.index}][flg_default]" value="2" {if $arrOpt.spots[$spot].flg_default==2} checked="checked" {/if} />
					<label>Remove</label>
				</div>
			</div>
			<div style="display:{if $arrOpt.spots[$spot].flg_default==1}block{else}none{/if};">
				<fieldset class="replace-border">
					<legend>Replace by</legend>
					<fieldset>
						<div class="swap">
							<div id="li1" class="position-div">
								<label style="margin-left:0;"><input type="checkbox" value="{$i.id}" id="{$smarty.foreach.spot.index}::{Project_Options::ARTICLE}" class="content-selector" {if !empty($arrOpt.spots[$spot].articles)} checked="checked" {/if}{if Core_Acs::haveRight( ['nvsb'=>['hosted']] ) && !Core_Acs::haveRight( ['nvsb'=>['hostedpro']] )} disabled="disabled"{/if}>&nbsp;Saved Article Selection:{if Core_Acs::haveRight( ['nvsb'=>['hosted']] ) && !Core_Acs::haveRight( ['nvsb'=>['hostedpro']] )} (Join the PRO level to activate this feature){/if}</label>
								<div class="change" id="1"><img src="/skin/i/frontends/design/down_arrow.gif" class="change-position" id="down" /></div>
								<img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" class="loader" />
								<div class="content-block" id="spot{$smarty.foreach.spot.iteration}-article"></div>
								<input class="position" type="hidden" name="arrOpt[spots][{$smarty.foreach.spot.index}][type_order][{Project_Options::ARTICLE}]" value="{if !empty($arrOpt.spots[$spot])}{$arrOpt.spots[{$spot}].type_order[{Project_Options::ARTICLE}]}{else}1{/if}">
							</div>
							<span id="li1"></span>
							<div id="li2"  class="position-div">
								<label style="margin-left:0;"><input type="checkbox" value="{$i.id}" id="{$smarty.foreach.spot.index}::{Project_Options::VIDEO}" class="content-selector" {if !empty($arrOpt.spots[$spot].video)} checked="checked" {/if}>&nbsp;Embed Video{$site_type} ( <input type="checkbox" {if $arrOpt.spots[{$spot}].flg_title==1} checked="checked" {/if} name="arrOpt[spots][{$smarty.foreach.spot.index}][flg_title]" value="1" > with title?)</label>
								<div class="change" id="2"><img src="/skin/i/frontends/design/up_arrow.gif" class="change-position" id="up" /><img id="down" src="/skin/i/frontends/design/down_arrow.gif" class="change-position" /></div>
								<img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" class="loader" />
								<div class="content-block" id="spot{$smarty.foreach.spot.iteration}-video"></div>
								<input class="position" type="hidden" name="arrOpt[spots][{$smarty.foreach.spot.index}][type_order][{Project_Options::VIDEO}]" value="{if !empty($arrOpt.spots[$spot])}{$arrOpt.spots[$spot].type_order[{Project_Options::VIDEO}]}{else}2{/if}">
							</div>
							<span id="li2"></span>
							<div id="li3"  class="position-div">
								<label style="margin-left:0;"><input type="checkbox" value="{$i.id}" id="{$smarty.foreach.spot.index}::{Project_Options::SNIPPET}" class="content-selector" {if !empty($arrOpt.spots[$spot].snippets)} checked='checked' {/if}{if Core_Acs::haveRight( ['nvsb'=>['hosted']] ) && !Core_Acs::haveRight( ['nvsb'=>['hostedpro']] )} disabled="disabled"{/if}>&nbsp;Rotating ad / snippets{if Core_Acs::haveRight( ['nvsb'=>['hosted']] ) && !Core_Acs::haveRight( ['nvsb'=>['hostedpro']] )} (Join the PRO level to activate this feature){/if}</label>
								<div class="change" id="3"><img src="/skin/i/frontends/design/up_arrow.gif" class="change-position" id="up" /><img id="down" src="/skin/i/frontends/design/down_arrow.gif" class="change-position" /></div>
								<img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" class="loader" />
								<div class="content-block" id="spot{$smarty.foreach.spot.iteration}-snippet"></div>
								<input class="position" type="hidden" name="arrOpt[spots][{$smarty.foreach.spot.index}][type_order][{Project_Options::SNIPPET}]" value="{if !empty($arrOpt.spots[$spot])}{$arrOpt.spots[$spot].type_order[{Project_Options::SNIPPET}]}{else}3{/if}">
							</div>
							<span id="li3"></span>
							<div id="li4"  class="position-div">
								<label style="margin-left:0;"><input type="checkbox" value="{$i.id}" id="{$smarty.foreach.spot.index}::{Project_Options::CUSTOMER}" class="customer-selector" {if !empty($arrOpt.spots[$spot].customer)} checked='checked' {/if}>&nbsp;Customer code</label>
								<div class="change" id="4"><img src="/skin/i/frontends/design/up_arrow.gif" class="change-position"  id="up" /></div>
								<img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" class="loader" />
								<div class="content-block"  id="spot{$smarty.foreach.spot.iteration}-customer">{if !empty($arrOpt.spots[{$spot}].customer)}<textarea name="arrOpt[spots][{$smarty.foreach.spot.index}][customer]" style="width:400px; height:100px;">{$arrOpt.spots[{$spot}].customer|escape}</textarea>{/if}</div>
								<input class="position" type="hidden" name="arrOpt[spots][{$smarty.foreach.spot.index}][type_order][{Project_Options::CUSTOMER}]" value="{if !empty($arrOpt.spots[$spot])}{$arrOpt.spots[{$spot}].type_order[{Project_Options::CUSTOMER}]}{else}4{/if}">
							</div>
							<span id="li4"></span>
						</div>
					</fieldset>
				</fieldset>
			</div>
		</div>
	</fieldset>
	<!-- End spot-->
	{/foreach}
</fieldset>



<script type="text/javascript">
var jsonOpt={$jsonOpt|json|replace:"'":"`"};
{literal}
var Advanced_Options=new Class({
	Implements: Options,
	options: {
		'siteType':{/literal}{$arrPrm.site_type}{literal},
		'siteId':false
	},
	initialize:function( options ){
		this.setOptions( options );
		this.initEvent();
		if( jsonOpt!='null' ){
			this.autorun();
		}
	},
	initEvent: function(){
		$$('.check-position').each(function(el){
			el.addEvent('click', function(){
				this.showDefault( el )
			}.bind(this))
		},this);
		$$('.select-default').each(function(el){
			el.addEvent('click', function(){
				this.showTypes( el )
			}.bind(this))
		},this);	
		$$('.content-selector').each(function(el){ 
			el.addEvent('click',function(){
				this.contentSelector(el)
			}.bind(this))
		},this);		
		$$('.select-all').each(function(el){
			el.addEvent('click',function(e){
				this.selectAll(el)
			}.bind(this))
		},this);		
		$$('.customer-selector').each(function(el){
			el.addEvent('click',function(){
				this.customerSelector(el)
			}.bind(this))
		},this);		
		$$('.dams-selector').each(function(el){
			el.addEvent('click',function(){
				this.damsSelector(el,new Array())
			}.bind(this))
		},this);
		$$('.change-position').each(function(el){
			el.addEvent('click',function(){
				this.position(el)
			}.bind(this))
		},this);
		$('dams-show').addEvent('click', function(e){
			this.damsShow($('dams-show'))
		}.bind(this) )
		$('traking-checkbox').addEvent('click',function(e){
			this.trakingShow($('traking-checkbox'));
		}.bind(this));
	},
	autorun: function(){
		var arrOpt=JSON.decode(jsonOpt);
		if($chk(arrOpt.dams)){
			var element=(arrOpt.dams.flg_content==1)?$('split'):$('campaigns');
			this.damsSelector(element,arrOpt.dams.ids);
		}
		if($chk(arrOpt.spots)){
		var hash= new Hash(arrOpt.spots);
		hash.each(function(item,index){
			index=parseInt(index.replace('spot',''))-1;
			if( $chk(item.articles) ){
				this.autoget(item.spot_name+'-article',1,item.articles,index);
			} 
			if ( $chk(item.video) ){
				this.autoget(item.spot_name+'-video',2,item.video,index);
			}
			if ( $chk(item.snippets) ){
				this.autoget(item.spot_name+'-snippet',3,item.snippets,index);
			}
		},this);
		this.checkPosition();
		}
	},
	autoget: function(block,type,content,index){
		var obj=this;
		if(!block){
			return;
		}
		var this_url;
		var this_post;
		if ( type != {/literal}{Project_Options::SNIPPET}{literal} ) {
			this_url = "{/literal}{url name='advanced_options' action='spots'}{literal}";
			this_post = {'type': type, 'site_type': obj.options.siteType, 'ids':content, 'spot_index': index };
		} else {
			this_url = "{/literal}{url name='site1_snippets' action='spots'}{literal}";
			this_post = {'spot_index': index, 'ids':content};
		}
		var req = new Request({
			url: this_url,
			onRequest: function(){
				$(block)
				.getPrevious('img.loader')
				.show('inline')
			},
			onSuccess: function(r){
				$( block ).set('html',r);
				$$('.select-all').each(function(el){
					el.addEvent('click',function(e){
						obj.selectAll(el)
					}.bind(obj))
				},obj)
			},
			onComplete: function(){
				$(block)
				.getPrevious('img.loader')
				.hide()
			}
		}).post(this_post)
	},	
	selectAll: function(element){
		$$('.item-'+element.value ).each(function(el){
			el.checked=element.checked;
		})
	},
	trakingShow: function(element){
		$('traking-code').setStyle('display',(element.checked)?'block':'none');
	},
	showDefault: function( element ){
		var block=element.getParent('legend').getNext('div');
		block.setStyle('display',(element.checked)?'block':'none')
	},
	showTypes: function( element ){
		var block=element.getParent('div').getNext('div');
		block.setStyle('display',(element.value==1)?'block':'none');
	},
	contentSelector: function( element ){
		var contentBlock=element.getParent('label').getNext('div.content-block');
		if(!$chk(element.checked)){
			contentBlock.empty();
			return false
		}
		var params=element.id.split('::');
		var obj=this;
		var this_url;
		var this_post;
		if ( params[1] != {/literal}{Project_Options::SNIPPET}{literal} ) {
			this_url = "{/literal}{url name='advanced_options' action='spots'}{literal}";
			this_post = {'type': params[1], 'site_type': this.options.siteType, 'spot_id': element.value, 'spot_index': params[0] };
		} else {
			this_url = "{/literal}{url name='site1_snippets' action='spots'}{literal}";
			this_post = {'spot_index': params[0], 'spot_id': element.value};
		}
		var req = new Request({
			url: this_url, 
			onRequest: function(){
				element
				.getParent('label')
				.getNext('img.loader')
				.show('inline')
			}, 
			onSuccess: function(r){
				contentBlock.set('html',r);
				$$('.select-all').each(function(el){
					el.addEvent('click',function(e){
						obj.selectAll(el)
					}.bind(obj))
				},obj)
			}, 
			onComplete: function(){
				element
				.getParent('label')
				.getNext('img.loader')
				.hide()
			}
		}).post(this_post)
	},
	customerSelector: function(element){
		var contentBlock=element.getParent('label').getNext('div.content-block');
		if(!$chk(element.checked)){
			contentBlock.empty();
			return false;
		}
		var params=element.id.split('::');
		var textarea = new Element('textarea',{
			'name':'arrOpt[spots]['+params[0]+'][customer]',
			'styles':{
				'width':'400px',
				'height':'100px'
			}
		});
		textarea.inject(contentBlock)
	},
	damsShow: function(element){
		element.getParent('div').getNext('div').setStyle('display',(element.checked)?'block':'none' )
	},
	damsSelector: function(element,ids){
		var contentBlock=element.getNext('div');
		var obj=this;
		var req = new Request({
			url: "{/literal}{url name='advanced_options' action='ad'}{literal}", 
			onRequest: function(){ }, 
			onSuccess: function(r){
				contentBlock.set('html',r);
				$$('.select-all').each(function(el){
					el.addEvent('click',function(e){
						obj.selectAll(el)
					}.bind(obj))
				},obj)
			}
		}).post({'site_type': this.options.siteType, 'flg_content': element.value,'ids':ids})
	},
	checkPosition: function(){
		$$('.swap').each(function(ol){
			ol.getChildren('li').each(function(li){
				var value=li.getChildren('input.position')[0].value;
				var position=li.getChildren('div.change')[0].id;
				if( !$chk(value)){
					li.getChildren('input.position')[0].value=position;
					value=position;
				}
				if( $chk(value) && value!=position ){
					var b4ch = ol.getChildren('span#li'+position)[0].getPrevious('div');
					var b2ch = ol.getChildren('span#li'+value)[0].getPrevious('div');
					var pre4=b4ch.getNext('span#li'+position);
					var pre2=b2ch.getNext('span#li'+value);
					ol.insertBefore(b4ch,pre2);
					ol.insertBefore(b2ch,pre4);
					var ch1=b4ch.getChildren('div.change')[0];
					var ch2=b2ch.getChildren('div.change')[0];
					b4ch.getChildren('input.position')[0].set('value',ch2.id);
					b2ch.getChildren('input.position')[0].set('value',ch1.id);
					b2ch.insertBefore(ch1,b2ch.getChildren('div.content-block')[0]);
					b4ch.insertBefore(ch2,b4ch.getChildren('div.content-block')[0]);
				}
			},this)
		},this)
	},
	position: function(element){
		var direction=element.id;
		var b4ch=element.getParent('div.position-div');
		if(direction=='down'){
			var b2ch=b4ch.getNext('div');
			if(!$chk(b2ch)){
				return;
			}
			b4ch.getParent('div').insertBefore(b2ch,b4ch)
		} else {
			var b2ch=b4ch.getPrevious('div');
			if(!$chk(b2ch)){
				return;
			}
			b4ch.getParent('div').insertBefore(b4ch,b2ch)
		}
		var ch1=b4ch.getChildren('div.change')[0];
		var ch2=b2ch.getChildren('div.change')[0];
		b4ch.getChildren('input.position')[0].set('value',ch2.id);
		b2ch.getChildren('input.position')[0].set('value',ch1.id);
		b2ch.insertBefore(ch1,b2ch.getChildren('div.content-block')[0]);
		b4ch.insertBefore(ch2,b4ch.getChildren('div.content-block')[0])
	}
});
window.addEvent('domready', function(){
	{/literal}
	  img_preload([
	  	{foreach from=$arrSpots  key=iKey item=aSpot} 
   			'/skin/i/frontends/design/options/{Project_Sites::$code[$arrPrm.site_type]}_{$iKey}.jpg',
   		{/foreach}
	  ]);
	{literal}
	var optTips = new Tips('.screenshot');
	$$('.screenshot').each(function(el){
		el.addEvent('click',function(e){
			e.stop()
		})
	});
	new Advanced_Options()
});
</script>
{/literal}
