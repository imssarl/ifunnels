<div class="panel panel-default"> 
    <div class="panel-heading"> 
        <h4 class="panel-title"> 
            <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseOne-2" aria-expanded="false" class="collapsed">
               Source select
            </a> 
        </h4> 
    </div> 
    <div id="collapseOne-2" class="panel-collapse collapse"> 
        <div class="panel-body">
           <fieldset>
				<div class="form-group">
					<label>Select content: <em>*</em></label>
					<select class="not_started in_progress cross_linking completed required validate-custom-required medium-input btn-group selectpicker show-tick" id="select_content" name="arrPrj[flg_source]">
					<option value="0">- select content -</option>
					{html_options options=Project_Content::toOptgroupSelect({$projectType}) selected={$arrPrj.flg_source}}
					</select>
				</div>
				{module name='site1_publisher' action='source_settings' modelSettings='1' selectedSource=$arrPrj.flg_source settings=$arrPrj.settings flg_status=$arrPrj.flg_status}
				<div class="no_source_selected"{if empty($arrPrj.flg_source)} style="display:none;"{/if}>
					<div>
						<label>Content selection: <em>*</em></label>
						<div class="radio radio-primary ">
							<input type="radio" id="manual" name="arrPrj[flg_mode]" {if $arrPrj.flg_mode =='1'}checked{/if} value="1" class="content_select not_started in_progress cross_linking completed" {if $arrPrj.flg_source == '6'} style="display:none;"{/if} />
							<label for="manual">Manual</label>
						</div>
						<div class="radio radio-primary">
							<input type="radio" id="automat" name="arrPrj[flg_mode]" {if !isset($arrPrj.flg_mode) || $arrPrj.flg_mode == '0'}checked{/if} value="0" class="validate-one-required content_select not_started in_progress cross_linking completed no_select_automat" {if $arrPrj.flg_source == '3'} style="display:none;"{/if} />
							<label for="automat">Automatic</label>
						</div>
					</div>
					<p {if $arrPrj.flg_mode != '1' || empty($arrPrj.flg_mode) || $arrPrj.flg_source == '3'}style="display:none;"{/if} id="content_multibox">
						<a href="{url name='site1_publisher' action='selectcontent'}"{if $arrPrj.flg_status == 3} style="display:none;"{/if} title="Select content" id="add_multibox">Select content</a>
					</p>
				</div>
				<div>
					<div id="place_content"{if $arrPrj.flg_mode == '1'} style="display:none;"{/if} ></div>
					<p></p>
				</div>
				{if {$projectType}== Project_Sites::BF}
				<p class="no_source_selected">
					<label>Post tags: </label>
					<input class="not_started in_progress cross_linking completed form-control" name="arrPrj[tags]" type="text" value="{if !empty($arrPrj.tags)}{$arrPrj.tags}{/if}"/>
				</p>
				{/if}
				<!--<p>
					<a href="#" class="acc_next button" rel="1">Next step</a>
				</p>-->
			</fieldset>
        </div> 
    </div> 
</div>
{literal}
<script type="text/javascript">
var FirstPage = new Class( {
	initialize: function () {
		if ( $('select_content').value != '0' ) {
			selectedSource = new SourceTypeObject[$('select_content').value];
			selectedSource.add_event();
		}
		// changer для выбора типа контента
		$('select_content').addEvent('change',function(event){
			if ( $('select_content').value != '0' ) {
				var sourse_id = this.value;
				selectedSource = new SourceTypeObject[sourse_id];
				selectedSource.add_event();
			}
			visual.jsonContentIds.empty();
			$( 'jsonContentIds' ).value = '';
			visual.placeParam={};
			$('place_content').empty();
			
			$$('.option_content').hide();
			if (this.value != "0") {
				$('content_'+this.value).show('block');
				
				//default
				$('content_multibox').hide();
				$$('.no_select_automat').show('inline');
				$$('.no_select_manual').show('inline');
				$$('.no_source_selected').show('block');
				$$('h3.novideo').show('block');
				$$('.nonet').show('inline-block');
				$('add_multibox').set('html', 'Select content ');
			//	$('automat').erase('checked');
				$('manual').erase('checked');

				switch (this.value) {
					case '1'://articles
						break		
					case '2'://videos
						$$('h3.novideo').hide();
						$('add_multibox').set('html', 'Upload content');
						$$('.no_select_manual').show('inline');
						break
					case '4'://articles
						break		

					case '6'://rss
						$$('.no_select_manual').hide();
						$('automat').set('checked','true');
						$$('.nonet').hide();
						$('manual').erase('checked');
						break
				}
			} else {
				$('add_multibox').set('html', 'Select content ');
				$$('.no_source_selected').hide();
			}
		});
		// changer для выбора completedntent selection
		$$('.content_select').addEvent('click',function(event){
			if (this.value == 1)	{
				if ( $('select_content').value != '3' ) {
					$('content_multibox').show('block');
					$$('.contents_manual').show('block');
					$$('.contents_automat').hide();
					$$('.nonet').show('inline-block');
				}
			}	else	{
				$('content_multibox').hide();
				$$('.contents_manual').hide();
				$$('.contents_automat').show('block');
				$$('.nonet').hide();
				visual.jsonContentIds.empty();
				$( 'jsonContentIds' ).value = '';
				visual.placeParam={};
				$('place_content').empty();
			}
		});
	}
});
</script>
{/literal}