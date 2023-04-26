<div class="panel panel-default"> 
    <div class="panel-heading"> 
        <h4 class="panel-title"> 
            <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTree-2" aria-expanded="false" class="collapsed">
               Select project post settings
            </a> 
        </h4> 
    </div>
     <div id="collapseTree-2" class="panel-collapse collapse"> 
        <div class="panel-body">
        	<fieldset>
				<div class="form-group">
					<label for="project_title">Project title <em>*</em></label>
					<input type="text" id="project_title" value="{$arrPrj.title}" name="arrPrj[title]" class="not_started completed required medium-input text-input form-control"/>
				</div>
				
				{*<div class="form-group">
					<label for="category">Select category <em>*</em></label>
					<select id="category" name="arrPrj[category_pid]" class="not_started in_progress cross_linking completed required validate-custom-required  medium-input btn-group selectpicker show-tick">
					<option value=""> - select -</option>
					{foreach from=$arrCategoryTree item=i}
					<option {if $smarty.get.cat == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}</option>
					{/foreach}
					</select>
				</div>
				<div class="form-group">
					<select  name="arrPrj[category_id]" id="category_child" class="not_started in_progress cross_linking completed required validate-custom-required  medium-input btn-group selectpicker show-tick">
						<option value=""> - select -</option>
					</select>
				</div>
				*}
				<input type="hidden" id="category" name="arrPrj[category_pid]" value="639" />
				<input type="hidden" id="category_child" name="arrPrj[category_id]" value="641" />
				{*<div class="form-group">
					<a id="msmb" href="{url name='site1_publisher' action='multiboxmanage'}">Check your site categories here</a>
				</div>*}
				
				<div class="no_child_category" {*if empty($arrPrj.category_id)}style="display:none;"{/if*}>
					<div class="radio radio-primary">
						<input type="radio" id="randomly_in_category" name="arrPrj[flg_posting]" {if $arrPrj.flg_posting=='1'}checked="checked"{/if} value="1" class="validate-one-required-names blog-list clear-blog-list not_started in_progress cross_linking completed"/>
						<label>Post randomly in this category</label>
					</div>
					<div class="fieldset-randomly_in_category fieldset-blog-list not_started in_progress cross_linking completed"{if $arrPrj.flg_posting!='1'} style="display:none; padding: 20px;"{/if}></div><br/>
					<div class="radio radio-primary">
						<input type="radio" id="select_below_list" class="validate-one-required-names blog-list clear-blog-list not_started in_progress cross_linking completed" {if $arrPrj.flg_posting=='3'}checked="checked"{/if} name="arrPrj[flg_posting]" value="3"/>
						<label>Select Site from below list</label>
					</div>
					<div class="fieldset-select_below_list fieldset-blog-list not_started in_progress cross_linking completed"{if $arrPrj.flg_posting!='3'} style="display:none; padding: 20px;"{/if}></div><br/>
					<div class="radio radio-primary">
						<input type="radio" id="select_list" class="validate-one-required-names blog-list clear-blog-list not_started in_progress cross_linking completed" {if $arrPrj.flg_posting=='2'}checked="checked"{/if} name="arrPrj[flg_posting]" value="2" />
						<label>Randomly in the selected sites</label>
					</div>
					 
					<div class="fieldset-select_list fieldset-blog-list not_started in_progress cross_linking completed"{if $arrPrj.flg_posting !='2'} style="display:none; padding: 20px;"{/if}></div><br/>
				</div>
				<p style="display: none;">
					<a href="#" class="acc_prev button" >Prev step</a> <a class="acc_next button" href="#" >Next step</a>
				</p>
			</fieldset>
        </div>
	</div>
</div>
{literal}<script type="text/javascript">
var ThirdPage = new Class( {
	initialize: function () {
		// changer для выбора типа категории
		var object=this;
	//	$('category_child').addEvent('change',function(event){
	//		object.categoryChildChange();
	//	});
	//	$('category').addEvent('change',function(event){
	//		object.categoryChange();
	//	});
	//	$('msmb').cerabox({
	//		group: false,
	//		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
	//		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
	//		displayTitle: true,
	//		titleFormat: '{title}'
	//	});
		
		object.categoryChange();
		object.categoryChildChange();
		
	},
	categoryChildChange:function(){
		if ($('category_child').value == "") 
			$$('.no_child_category').hide(); 
		else 
			$$('.no_child_category').show('block');
		$$('.clear-blog-list').each ( function ( element ) {
			element.checked = false;
		});
		$$('.fieldset-blog-list').hide();
	},
	categoryChange: function(){
		$$('.no_child_category').hide();
		$$('.clear-blog-list').each ( function ( element ) {
			element.checked = false;
		});
		$$('.fieldset-blog-list').hide();
	}
});
</script>{/literal}