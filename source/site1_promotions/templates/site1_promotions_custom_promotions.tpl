{include file='../../box-top.tpl' title="Create new campaign"}
<div class="card-box">
{if $strMsg}{include file="../../message.tpl" type='info' message="Campaign is saved"}{/if}
{foreach from=$errFlow item=strError}
{include file="../../message.tpl" type='error' message=$strError}
{/foreach}
<table class="">
	<tr>
		<td width="75%">
			<form class="reg_form validate wh" style="width:90%" action="" method="post" id="submit_form">
				<div class="form-group">
					<label>Url <em>*</em></label>
					<input name="arrCampaign[settings][url]" id="input_select" autocomplete="off" type="text" class="required text-input medium-input form-control" value="{$arrCampaign.settings.url}"/>
					{if count($arrDomains)>0 }
					<div id="select_box">
						<ul>
							{foreach from=$arrDomains item=i}
							<li>{if $i.domain_http!=null}{$i.domain_http}{else}{$i.domain_ftp}{/if}</li>
							{/foreach}
						</ul>
					</div>
					{/if}
				</div>
				<div class="form-group">
					<label>Title <em>*</em></label>
					<input name="arrCampaign[settings][title]" type="text" id="request_title" class="required text-input medium-input form-control" value="{$arrCampaign.settings.title}"/>
					<a style="text-decoration:none" class="tooltip" title="Title must have a minimum of 4 words."><b> ?</b></a>
				</div>
				<div class="form-group">
					<label>Tags <em>*</em></label>
					<input name="arrCampaign[settings][tags]" type="text" id="request_keywords" class="required text-input medium-input form-control" value="{$arrCampaign.settings.tags}" />
					<a style="text-decoration:none" class="tooltip" title="A maximum of 5 tags can be added to a campaign. One tag has a maximum of 3 words. A tag must have at least 3 characters"><b> ?</b></a>
				</div>				
				<div class="form-group">
					<label>Description <em>*</em> <a style="text-decoration:none" class="tooltip" title="Description must have a minimum of 10 words."><b> ?</b></a></label>
					<textarea name="arrCampaign[settings][description]" rows="10" id="request_description" class="required textarea text-input form-control" >{$arrCampaign.settings.description}</textarea>
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
					<!--<input type="submit" class="submit button" id="submit_box" value="Submit" {is_acs_write} />-->
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
var flgRunn=true;
function getUrlRequest(){
	var siteurl=$('input_select').get('value');
	if( flgRunn && siteurl.test(/^((http|https):\/\/)?(([a-z0-9\-]*\.)+[a-z0-9\-]{2,})(\/([^#\?]+)?(\?[^#]*)?(#.*)?)?$/i) ){
		new Request.JSON({
			url: "{/literal}{url name='site1_promotions' action='request_url'}{literal}",
			onRequest: function(){
				var img=new Element( 'img[src="/skin/i/frontends/design/ajax_loader_line.gif"][id="loader"]' );
				img.inject($('input_select').getPrevious('label'),'bottom');
			},
			onSuccess: function( returnJson ){
				$("request_title").set('value',returnJson.title);
				$("request_description").set('value',returnJson.description);
				$("request_keywords").set('value',returnJson.tags);
			},
			onComplete: function(){
				if($('loader')){
					$('loader').destroy();
				}
			},
			onError:function(){
				if($('loader')){
					$('loader').destroy();
				}
			}
		}).post({'url':siteurl});
	}
};
$('input_select').addEvents({
	'focus': function(){
		if( $('input_select').get('value') == '' ){
			$('select_box').show();
		}
	},
	'keydown': function(){
		$('select_box').hide();
		flgRunn=true;
	},
	'blur': function(){
		getUrlRequest();
		flgRunn=true;
	}
});
$$('#select_box ul li').addEvent('click',function(e){
	$('input_select').set('value', e.target.get('html') );
	$('select_box').hide();
	getUrlRequest();
	flgRunn=false;
});
$$('.open_div').each(function(el){
	el.addEvent('click', function(e) {
		e.stop();
		if ($('part'+el.get('id_num')).getStyle('display') == 'none') {
			$('part'+el.get('id_num')).setStyle('display','inline');
			el.set({'title':'Click Here To Collapse'});
			el.getParent('tr').addClass('backcolor3');
		} else {
			$('part'+el.get('id_num')).setStyle('display','none');
			el.set({'title':'Click Here To Expand'});
			el.getParent('tr').removeClass('backcolor3');
		}
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
window.addEvent('domready',function(){
	$$('.slider_promotions').each(function(elt){
		slider_var[elt.get('id')]=new Slider( elt, elt.getElement('.knob'), {
			steps: 100,
			initialStep: elt.getNext('input').get('value'),
			onChange: function(value){
				elt.getNext('input').set('value', value);
				elt.getPrevious('label').getElement('span.text').set('html', value);
				checkPromotions();
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

</script>
{/literal}