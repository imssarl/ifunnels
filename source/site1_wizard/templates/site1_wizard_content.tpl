<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<span id="waite_creation" class="grn" style="display:none;">We're generating your Amazon Affiliate Website, adding content and scheduling new content publishing. Hold on, you will get your website URL in a few seconds!</span>
	<span id="end_creation" class="grn" style="display:none;">Process is finished and you can view the site:</span>
	<span id="end_warning" class="red" style="display:none;">There is few content on Amazon related to the keyword(s) you specified for the site. You might want to create a new content project with a different keyword to make sure your site is updated with new content regularly.</span>
	<span id="ajax_errors" class="red" style="display:none;"></span>
	{if isset($arrErr)}
		{if $arrErr.errFlow.0=='empty_settings'}
		<span class="red">Please fill in your personal details in Amazon <a href="{url name='site1_publisher' action='source_settings'}" target="_blank">Source Settings</a> to enable the Wizard. </span>
		{else}
			{if $arrErr.errFlow.0=='empty_credits'}
			<span class="red">You don't have enough credits on your balance for this project. You can purchase additional credits</span> <a href="{url name='site1_accounts' action='payment'}" target="_blank">here</a>.
			{/if}
		{/if}
	{/if}
	{if !isset($arrErr) || isset($arrData) }
	<form method="post" action="" class="wh validate" id="post_form">
	<input type="hidden" name="arrData[type]" value="{Project_Wizard_Domain_Rules::R_CONTENT}"  />
	<fieldset id="first_step">
		<legend>Step 1:</legend>
		<legend>Select your niche and main keyword</legend>
		<div class="form-group">
			<label>Select Category <em>*</em></label>
			<select id="category" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick">
				<option value="0"> - select -</option>
				{foreach from=$arrCategories item=i}<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}</option>
				{/foreach}
			</select>
		</div>
		<div class="form-group">
			<label>&nbsp;</label>
			<select id="category_child" name="arrData[category_id]" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick" >
			</select>
		</div>
		<div class="form-group">
			<label for="main_keyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrData[main_keyword]" type="text" id="main_keyword" value="{$arrData.main_keyword.0}" class="required medium-input text-input form-control"/>
		</div>
		<div class="form-group">
			<button type="button" id="step_button" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Step 2</button>
		</div>
	</fieldset>
	
	<div align="center">
		<img id="ajax_loader" src="/skin/i/frontends/design/ajax-loader-big.gif" style="display:none;">
	</div>
	
	<div id="second_step"{if !isset($arrData)} style="display:none;"{/if}>
	<fieldset>
		<legend>Step 2: Select Domain</legend>
		<fieldset id="domains">
		</fieldset>
		<label><img id="ajax_loader_small" src="/skin/i/frontends/design/ajax_loader_line.gif" style="display:none;"></label>
	</fieldset>
	<legend><a href="#" id="more_domains"style="{if isset($arrData)} display:none;{/if}padding:3px;">Suggest more</a></legend>
	<fieldset>
		<legend></legend>
		<div class="form-group">
			<label>Or you may also enter any domain name you want to register</label>
			<input type="text" name="arrData[domain_text]" id="domain_text" value="{$arrData.domain_http}" class="medium-input" style="width:200px;"><input type="button" id="check_domein" value="check" class="button">
		</div>
		<div class="form-group">
			<label>
			<span id="domain_check_wait" style="display:none;">Please wait..</span>
			<span class="grn" id="domain_available" style="display:none;">Available</span>
			<span class="red" id="domain_notavailable" style="display:none;">Not Available</span></label>
		</div>
		<button type="button" id="submit_button" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Voila</button>
	</fieldset>
	</div>
	</form>
	{/if}
{literal}<script type="text/javascript">
var jsonCategory = {/literal}{$treeJson}{literal};
var categoryId = {/literal}{$arrData.category_id|default:0}{literal};
var moreDomainsJson = null;
window.addEvent('domready', function(){
	var ClickbankSelects = new Categories({
		firstLevel: 'category',
		secondLevel: 'category_child',
		intCatId:categoryId,
		jsonTree:jsonCategory
	});
	$('step_button').addEvent('click',function(){
		if( validator.checker.validate() ){
			$('second_step').hide();
			$('first_step').hide();
			$('domain_text').value='';
			new Request.JSON({
				url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
				headers:{'X-Request':'JSON'},
				onRequest: function(){
					$('ajax_loader').style.display="block";
				},
				onSuccess: function(responseJson,text){
					$('domains').empty();
					Object.each( responseJson, function(arrData, key, object){
						if( key == 'x8' || key == 'x12' ){
							wizardObjectTable( arrData );
						}else{
							moreDomainsJson=arrData;
						}
					});
				}
			}).post($('post_form'));
		}
	});

	function wizardObjectTable( elt ){
		Object.each( elt, function(data, i, obj){
			var requestObjects=new Request({
				url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
				onSuccess: function(responseFlag){
					if( responseFlag=='true' ){
						new Element( 'label' )
							.grab( new Element( 'input[type="radio"][name="arrData[domain_http]"][class="select_domain"]' ).set('value',data) )
							.appendText( " "+data )
							.inject( $('domains') );
						$('second_step').show('inline');
						$('submit_button').disabled=false;
						$('ajax_loader').hide();
					}
				},
				onRequest: function(){
					$('ajax_loader_small').show('inline');
				},
				onComplete: function(){
					$('ajax_loader_small').hide();
				}
			}).post({'domenCheck':data});
		});
	}

	$('more_domains').addEvent('click',function(){
		wizardObjectTable( moreDomainsJson );
		$('more_domains').hide();
	});

	$('main_keyword').addEvent('change',function(){
		$('second_step').hide();
	});

	$('submit_button').addEvent('click',function(elt){
		if( validator.checker.validate() ){
			new Request({
				url: "{/literal}{url name='site1_wizard' action='content'}{literal}",
				onRequest: function(){
					$('ajax_errors').empty().hide();
					$('second_step').hide();
					$('first_step').hide();
					$('waite_creation').show("inline");
					$('ajax_loader').show("block");
				},
				onSuccess: function(response){
					response=JSON.decode(response);
					$('waite_creation').hide();
					if( response.result==true ){
						$('end_creation').show('block');
						new Element('br').inject($('end_creation'));
						new Element('br').inject($('end_creation'));
						new Element('a',{href:response.domain,html:response.domain,target:'_blank'}).inject($('end_creation'));
						if(response.contentCount<10){
							$('end_warning').show('block');
						}
					}else{
						$('ajax_errors').set('html',response.error).show("inline");
						$('second_step').show('inline');
					}
					$('ajax_loader').hide();
				}
			}).post($('post_form'));
		}
	});

	$('domain_text').addEvent('change',function(){
		$$('.select_domain').each(function(e){e.checked=false;});
	});

	$('check_domein').addEvent('click',function(){
		$('domain_available').hide();
		$('domain_notavailable').hide();
		$$('.select_domain').each(function(e){e.checked=false;});
		if( $('domain_text').value == '' ){
			return;
		}
		$('domain_check_wait').show('block');
		new Request({
			url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
			onSuccess: function(responseFlag){
				$('domain_check_wait').hide();
				if( responseFlag=='true' ){
					$('domain_available').show('block');
				}else{
					$('domain_notavailable').show('block');
				}
			},
		}).post({'domenCheck':$('domain_text').value});
	});
});

</script>
<script src="/skin/light/js/bootstrap.min.js"></script>
    <script src="/skin/light/js/detect.js"></script>
    <script src="/skin/light/js/fastclick.js"></script>

    <script src="/skin/light/js/jquery.slimscroll.js"></script>
    <script src="/skin/light/js/jquery.blockUI.js"></script>
    <script src="/skin/light/js/waves.js"></script>
    <script src="/skin/light/js/wow.min.js"></script>
    <script src="/skin/light/js/jquery.nicescroll.js"></script>
    <script src="/skin/light/js/jquery.scrollTo.min.js"></script>

    <script src="/skin/light/plugins/peity/jquery.peity.min.js"></script>

    <!-- jQuery  -->
    <script src="/skin/light/plugins/waypoints/lib/jquery.waypoints.js"></script>
    <script src="/skin/light/plugins/counterup/jquery.counterup.min.js"></script>
    
    

    <script src="/skin/light/plugins/jquery-knob/jquery.knob.js"></script>
    <script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>

   

    <script src="/skin/light/js/jquery.core.js"></script>
    <script src="/skin/light/js/jquery.app.js"></script>

    <script type="text/javascript">
        jQuery(document).ready(function($) {
            $('.counter').counterUp({
                delay: 100,
                time: 1200
            });
			$('.selectpicker').selectpicker({
			  	style: 'btn-info',
			  	size: 4
			});

			$('select').change(function(){
				$('.selectpicker').selectpicker('refresh');
			});
            //$(".knob").knob();

        });
    </script>
{/literal}
</div>
</body>
</html>