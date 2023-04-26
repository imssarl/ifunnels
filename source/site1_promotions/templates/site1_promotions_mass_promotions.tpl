{include file='../../box-top.tpl' title="Create mass campaigns"}
<div class="card-box">
{if $strMsg}{include file="../../message.tpl" type='info' message="Campaigns is saved"}{/if}
<table>
	<tr>
		<td width="75%">
			<form class="reg_form validate wh" style="width:90%" action="" method="post" id="submit_form">
				<div class="form-group">
					<label>Urls <em>*</em></label>
					<textarea name="arrCampaign[urls]" rows="10" id="mass_promotions_urls" class="required textarea text-input form-control" ></textarea>
				</div>
				<div class="form-group">
					<button type="button" class="button btn btn-success waves-effect waves-light" id="check_urls">Check</button>
				</div>
				<div class="form-group">
					<label>Category:</label>
					<select name="arrCampaign[settings][category_id]" type="text" class="required medium-input btn-group selectpicker show-tick" >
						{foreach from=$arrCategories item=i key=k}<option value="{$i.id}"{if $arrCampaign.settings.category_id==$i.id} selected="selected"{/if}>{$i.title}</option>{/foreach}
					</select>
				</div>
				{include file="site1_promotions_types.tpl"}
				<div class="form-group">
					<label>Automatic campaign submission:</label>
					<div class="radio radio-primary">
						<input name="arrCampaign[flg_type]" type="radio" value="0"{if $arrCampaign.flg_type==0} checked="checked"{/if} />
						<label>one time</label>
					</div>
					<div class="radio radio-primary">
						<input name="arrCampaign[flg_type]" type="radio" value="1"{if $arrCampaign.flg_type==1} checked="checked"{/if} />
						<label>once a week</label>
					</div>
					<div class="radio radio-primary">
						<input name="arrCampaign[flg_type]" type="radio" value="2"{if $arrCampaign.flg_type==2} checked="checked"{/if} />
						<label>once a month</label>
					</div>
				</div>
				<div class="form-group">
					<span id="promote_cost"></span>
				</div>
				<div class="form-group">
					<button type="submit" class="submit button btn btn-success waves-effect waves-light" id="submit_box" {is_acs_write}>Submit</button>
				</div>
				<div class="form-group" style="font-size:14px;font-family:Verdana;">
					Important: for <b>SEO effectiveness</b> following all recent and future Google updates, your Social Media Campaign will be grown at a natural pace and all social signals drip fed within days or weeks. The drip feeding rate will be determined after a thorough analysis of your website and its current backlinking structure (if any) to ensure we create a truly <b>effective Social Media Campaign</b>. Of course, you have nothing to do and we handle the whole process on our end. Enjoy!
				</div>
			</form>
		</td>
		<td valign="top" style="font-size:12px;font-family:Verdana">
			- You should run a <b> Social Bookmarking</b> campaign on all your content for SEO benefits<br/>
			<br/>
			- You should run a <b>Social News / Voting</b> campaign on all your best, non- promotional content that is appropriate for human voting activities.<br/>
			(benefit is then indirect: people share your best content, which drives traffic to your content and then funnel it into your money pageS)<br/>
			<br/>
			In summary, with <b>Social News</b> campaigns you have to link to content that is of social interest and you have to link to "specific" content within your domain. This content cannot be promotional in nature. With <b>Social bookmarking</b>, you can link to any content.<br/>	
		</td>
	</tr>
</table>
</div>
{include file='../../box-bottom.tpl'}


{literal}
<script type="text/javascript">

var request_activated=false;

function inputElements( returnJson, siteurl ){
	var input_type='hidden';
	if( returnJson.errors==undefined ){
		new Element('p',{'class':'remove_if_recheck'})
			.adopt([
				new Element('label',{'html':siteurl+' have succesful values!'}).setStyle('color','green'),
				new Element('input',{'type':input_type,'name':'arrCampaigns[title][]','value':returnJson.title} ),
				new Element('input',{'type':input_type,'name':'arrCampaigns[description][]','value':returnJson.description} ),
				new Element('input',{'type':input_type,'name':'arrCampaigns[tags][]','value':returnJson.tags} ),
				new Element('input',{'type':input_type,'name':'arrCampaigns[url][]','value':returnJson.url} )
			])
			.inject( $('mass_promotions_urls').getParent('p'), 'before');
	}else{
		var errorsStr='';
		new Object.each( returnJson.errors, function(str){
			errorsStr+="<br/>"+str;
		});
		input_type='text';
		new Element('p',{'class':'remove_if_recheck'})
			.adopt(new Element('label',{'html':siteurl+' have errors:'+errorsStr}))
			.setStyle('color','red')
			.inject( $('mass_promotions_urls').getParent('p'), 'before');
		
		new Element('p',{'class':'remove_if_recheck'})
			.adopt([
				new Element('label',{'html':'Url'}).adopt(new Element('em',{'html':'*'})),
				new Element('input',{'type':input_type,'class':'remove_if_recheck required text-input medium-input','name':'arrCampaigns[url][]','value':returnJson.url} )
			])
			.inject( $('mass_promotions_urls').getParent('p'), 'before');
		new Element('p',{'class':'remove_if_recheck'})
			.adopt([
				new Element('label',{'html':'Title'}).adopt(new Element('em',{'html':'*'})),
				new Element('input',{'type':input_type,'class':'remove_if_recheck required text-input medium-input','name':'arrCampaigns[title][]','value':returnJson.title} ),
				new Element('a',{'style':"text-decoration:none",'class':"tooltip",'title':"Title must have a minimum of 4 words."}).adopt(new Element('b',{'html':'?'}))
			])
			.inject( $('mass_promotions_urls').getParent('p'), 'before');
		new Element('p',{'class':'remove_if_recheck'})
			.adopt([
				new Element('label',{'html':'Tags'}).adopt(new Element('em',{'html':'*'})),
				new Element('input',{'type':input_type,'class':'remove_if_recheck required text-input medium-input','name':'arrCampaigns[tags][]','value':returnJson.tags} ),
				new Element('a',{'style':"text-decoration:none",'class':"tooltip",'title':"A maximum of 5 tags can be added to a campaign. One tag has a maximum of 3 words. A tag must have at least 3 characters"}).adopt(new Element('b',{'html':'?'}))
			])
			.inject( $('mass_promotions_urls').getParent('p'), 'before');
		new Element('p',{'class':'remove_if_recheck'})
			.adopt([
				new Element('label',{'html':'Description'}).adopt(new Element('em',{'html':'*'})),
				new Element('textarea',{'type':input_type,'class':'remove_if_recheck required','name':'arrCampaigns[description][]','value':returnJson.description} )
			])
			.inject( $('mass_promotions_urls').getParent('p'), 'before');
	}
}

var jsonWithErrors='{/literal}{if isset($errFlow)}{$errFlow}{/if}{literal}';
if( jsonWithErrors!='' ){
	new Object.each( JSON.decode( jsonWithErrors ), function( elt ){
		inputElements( elt, elt.url );
	});
	validator=new WhValidator({className:'validate'});
}

function getUrlRequest( siteurl ){
	if( siteurl.test(/^((http|https):\/\/)?(([a-z0-9\-]*\.)+[a-z0-9\-]{2,})(\/([^#\?]+)?(\?[^#]*)?(#.*)?)?$/i) ){
		if( request_activated ){
			setTimeout('getUrlRequest("'+siteurl+'")',50);
			return;
		}
		new Request.JSON({
			url: "{/literal}{url name='site1_promotions' action='request_url'}{literal}",
			onRequest: function(){
				request_activated=true;
				var img=new Element( 'img[src="/skin/i/frontends/design/ajax_loader_line.gif"][id="loader"]' );
				img.inject($('mass_promotions_urls').getPrevious('label'),'bottom');
			},
			onSuccess: function( json ){
				inputElements( json, siteurl )
			},
			onComplete: function(){
				if($('loader')){
					$('loader').destroy();
				}
				request_activated=false;
				validator=new WhValidator({className:'validate'});
			},
			onError:function(){
				if($('loader')){
					$('loader').destroy();
				}
				new Element('p',{'class':'remove_if_recheck'})
					.adopt(new Element('label',{'html':siteurl+' have time limit error'}))
					.setStyle('color','red')
					.inject( $('mass_promotions_urls').getParent('p'), 'before');
				request_activated=false;
			}
		}).post({'url':siteurl});
	}
};

$('check_urls').addEvent('click',function(e){
	$$('.remove_if_recheck').destroy();
	var value=$('mass_promotions_urls').get('value');
	value=value.split('\n');
	value.each(function(elt){
		getUrlRequest( elt );
	});
	var optTips = new Tips('.Tips', {className: 'tips'});
	$$('.Tips').each(function(a){
		a.addEvent('click', function(e){
			if ( e.get('href') != null )
				e.stop()
		})
	});
});

var slider_var=new Array();
function checkPromotions(){
	var static_amount=0;
	$$('.check_promotion').each( function( e ){
		if( e.getStyle('display') != 'none' ){
			static_amount+=parseFloat( e.getElement('input').value)*parseFloat( e.get('rel') );
		}
	});
	$('promote_cost').set('html', 'Cost of campaign '+Math.ceil( static_amount )+' credit(s).');
}

$('submit_box').addEvent('click',function(elt){
	elt.stop();
	if( validator.checker.validate() ){
		$('submit_form').submit();
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

window.addEvent('domready',function(){
	$$('.slider_promotions').each(function(elt){
		slider_var[elt.get('id')]=new Slider( elt, elt.getElement('.knob'), {
			steps: 100,
			initialStep: elt.getNext('input').get('value'),
			onChange: function(value){
				if (value) {
					elt.getNext('input').set('value', value);
					elt.getPrevious('label').getElement('span.text').set('html', value);
					checkPromotions();
				}
			}
		});
	});
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
	$$('.check_promotion').addEvent('change', function( elt ){
		checkPromotions();
	});
	checkPromotions();
});
var optTips = new Tips('.Tips', {className: 'tips'});
$$('.Tips').each(function(a){
	a.addEvent('click', function(e){
		if ( e.get('href') != null )
			e.stop()
	})
});
</script>
{/literal}