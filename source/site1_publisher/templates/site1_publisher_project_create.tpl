{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
<div align="center" style="padding:10px 0 0 0; ">
	<a href="{url name='site1_publisher' action='projects_manage'}">Manage</a> | <a href="{url name='site1_publisher' action='project_create'}">Create</a>
</div>
{literal}
<script type="text/javascript">
var objAccordion={};
window.addEvent('domready',function(){
	//objAccordion=new myAccordion($('accordion'),$$('.toggler'),$$('.element'),{fixedHeight:false});
});
</script>
{/literal}
{include file='../../error.tpl'}
<form action="" method="post" class="wh validate" id="submit_form"  >
	<input type="hidden" name="arrPrj[id]" value="{$arrPrj.id}" />
	<input type="hidden" name="arrPrj[flg_type]" value="1" />
	<input type="hidden" name="arrPrj[flg_status]" value="{$arrPrj.flg_status}" />
	<input type="hidden" name="arrPrj[flg_source]" value="{$arrPrj.flg_source}" />
	
	<div class="panel-group" id="accordion-test-2">
		{include file="create/step1.tpl"}
		{*{if Core_Acs::haveRight( ['article'=>['options']] )}
		{include file="create/step2.tpl"}
		{/if}*}
		{include file="create/step3.tpl"}
		{include file="create/step4.tpl"}
		{include file="create/step5.tpl"}
		<input type="hidden" name="arrPrj[jsonContentIds]" id="jsonContentIds" />
	</div>
	{if $arrPrj.flg_status==2}
	<fieldset>
		<p>
			<input type="checkbox" name="arrPrj[restart]" value="1" /> re-start project
		</p>
	</fieldset>
	{/if}
	<fieldset>
		<div class="form-group">
			<button type="submit" {is_acs_write} id="create" class="button btn btn-success waves-effect waves-light" style="{if $arrPrj.flg_status==3}display:none;{/if}">{if $arrPrj.id}Save{else}Add{/if} project</button>
		</div>
	</fieldset>
</form>
<div style="clear:both;"></div>
</div>
{include file='../../box-bottom.tpl'}

{literal}
<script type="text/javascript">
var Visual=new Class({
	Implements:Options,
	options:{
		jsonShedule:null,
		flgStatus:null
	},
	initialize:function(options){
		this.setOptions(options);
		this.placeParam=new Array ();
		this.jsonValue=new Array ();
		this.jsonContentIds=new Array();
		this.initEventTypeContent('content-type');
		this.initSchedulingType();
		this.placingContent();
		new FirstPage();
		var thirdPageObject=new ThirdPage();
		new QuarterPage();
		new CategoriesContent({firstLevel:'category',secondLevel:'category_child',intCatId:categoryId});
		$$('div.element').each(function(div,index){
			div.set('id',index);
		});	
		var optTips=new Tips('.Tips',{className:'tips'});
		$$('.Tips').each(function(a){
			a.addEvent('click',function(e){
				if (e.get('href')==null){
					e.stop();
				}
			})
		});
		new FifthPage({
			jsonSitesList:'{/literal}{$arrSitesList|json|replace:"'":"`"|replace:'\n':''}{literal}',
			flgStatus:this.flgStatus,
			masterBlogId:{/literal}{$arrPrj.masterblog_id|default:0}{literal},
			jsonSheduleId:{/literal}{$arrPrj.arrSheduleSites|json}{literal}
		});
		thirdPageObject.categoryChildChange();
		var status='{/literal}{$arrPrj.flg_status}{literal}';
		$$('.not_started').erase('disabled');//not started
		switch (status){
			case '1':$$('.in_progress').set('disabled','disabled');break;//in progress
			case '2':$$('.cross_linking').set('disabled','disabled');break;//cross linking
			case '3':$$('.completed').set('disabled','disabled');break;//completed
		};
	},
	placingContent :function(chosenContent){
		var Ids=new Array();
		if (chosenContent==null){
			chosenContent=new Array();
		}
		this.placeParam=chosenContent;
		$('place_content').empty();
		$('place_content').hide();
		if ($$('select#select_content').get('value')=='3'){
			return true;
		}
		if(this.options.jsonShedule!=null||this.placeParam.toString()!=''){
			var index=1;	
			var b=new Element('b[html="Selected content"]');
			b.inject($('place_content'));
			this.placeParam.each(function(v,i){
				new Element('p[rel="'+v.title+'"][html="'+index+'. '+(v.title)+'"]')
				.inject($('place_content'))
				.adopt(
					new Element('a.content-delete-list[href="#"][rel="'+v.id+'"][html="Delete from list"]')
						.addEvent('click',function(e){
							e&&e.stop();
							var temp=this.placeParam;
							if(temp==null){
								return false;
							}
							var k=0;
							this.placeParam=new Array();
							Object.each(temp,function(val){
								if(val.id!=v.id){
									this.placeParam[k]={'id':val.id,'title':val.title};
									k++;
								}
							},this);
							this.placingContent(this.placeParam);
						}.bind(this)));
				Ids.include(v.id);
				index++;
			},this);
			if (this.options.jsonShedule!=null){
				this.options.jsonShedule.each(function (v,i){
					new Element('p.content-delete-list[rel="'+v.title+'"][html="'+index+'. '+(v.title)+'"]')
					.inject($('place_content'));
					index++;
				});
			}
		}
		if ($$('.content-delete-list').length>0){
			$('place_content').show('block');
		}
		var jsonIds='';
		if (Ids.length > 0){
			var jsonIds=JSON.encode(Ids);
			this.jsonContentIds=JSON.decode(jsonIds);
			$('jsonContentIds').value=jsonIds;
		}
		return true;
	},
	initSchedulingType:function(){
		$$('.scheduling-type').each(function(el){
			el.addEvent('click',function(){
				$('start-date').setStyle('display',(el.value==2)?'block':'none');
			});
		});
	},
	initEventTypeContent:function(elements){
		$$('.'+elements).each(function(el){
			el.addEvent('click',function(e){
				$('rss_fields').hide();
				$('video_wizard').hide();
				$('article_wizard').hide();
				switch(el.id){
					case 'rss':
						$('rss_fields').show('block');
						$('not-rss').hide();
						$('select-rss').show('block');
						$('networking').hide();
						$('to_networking').hide();
					break;
					case 'article':
						$('article_wizard').show('block');
						$('not-rss').show('block');
						$('select-rss').hide();							
						$('networking').show('block');
						$('to_networking').show('block');
					break;
					case 'video':
						$('video_wizard').show('block');
						$('not-rss').show('block');
						$('select-rss').hide();
						$('networking').show('block');							
						$('to_networking').show('block');				
					break;
				}
			});
		});
	},
	jsonPopupEdit:function(json_from_popup){
		$('content_'+(new Hash(json_from_popup).get('flg_source')))
			.getElements('input,select,textarea')
			.each(function (elt){
				(new Hash(json_from_popup))
					.each(function(val,key){
						if ((elt.name).replace(/arrCnt\[\d{1,}\]\[settings\]/,'arrFlt')==key){
							$$(document.getElementsByName(elt.name))
								.set('value',val);
							return;
						}
				});
			});
	}
});



var categoryId={/literal}{if isset($arrPrj.category_id)}{$arrPrj.category_id|default:'null'}{else}{if Core_Acs::haveAccess( array( 'Zonterest 2.0','Zonterest PRO 2.0' ) )}641{else}null{/if}{/if}{literal} ;
var jsonCategory={/literal}{$arrCategoryTree|json}{literal};
var CategoriesContent=new Class({
	Implements:Options,
	options:{
		firstLevel:'category',
		secondLevel:'category_child',
		intCatId:categoryId
	},
	initialize:function(options){
		this.setOptions(options);
		this.arrContentCategories=new Hash(jsonCategory);
		$(this.options.firstLevel).addEvent('change',function(){
			this.setFromFirstLevel($(this.options.firstLevel).value)
		}.bind(this));
		if((this.options.intCatId!=null)&&this.checkLevel(this.options.intCatId)){
			this.setFromFirstLevel(this.options.intCatId)
		} else if(this.options.intCatId!=null){
			this.setFromSecondLevel(this.options.intCatId)
		}
	},
	checkLevel:function(id){
		this.arrContentCategories.each(function(el){
			if(el.id==id){
				return true
			}
		});
		return false;
	},
	setFromFirstLevel:function(id){
		if(!id){
			$(this.options.secondLevel).empty();
			new Element('option[value=""][html="- select -"]')
				.inject($(this.options.secondLevel));			
			return false
		}
		this.arrContentCategories.each(function(item){
			if(item.id==id){
				Array.from($(this.options.firstLevel).options).each(function(i){
					if(i.value==id){
						i.set('selected','selected');
					}
				});
				$(this.options.secondLevel).empty();
				new Element('option[value=""][html="- select -"]')
					.inject($(this.options.secondLevel));
				new Hash(item.node).each(function (i){
					new Element('option[value="'+i.id+'"][html="'+i.title+'"]'+((i.id==this.options.intCatId)?'[selected="selected"]':''))
						.inject($(this.options.secondLevel))
				},this)
				jQuery('#category_child').selectpicker('refresh');
			}
		},this)
	},
	setFromSecondLevel:function(id){
		this.arrContentCategories.each(function(item){
			new Hash(item.node).each(function(el){
				if (id==el.id){
					this.setFromFirstLevel(el.pid)
				}
			},this)
		},this)
	}
});
var visual;
window.addEvent('domready',function(){
	visual=new Visual({
		jsonShedule:{/literal}{$arrPrj.arrSheduleContent|json}{literal},
		flgStatus:{/literal}{$arrPrj.flg_status|default:0}{literal}
	});
	var zonterest={/literal}{if Core_Acs::haveAccess( 'Zonterest PRO' )}1{else}0{/if};{literal}
	if(zonterest==1){
		$('select_content').set('value',9);
		$('select_content').fireEvent('click');
		$('select_content').fireEvent('change');
	}
});
</script>
{/literal}