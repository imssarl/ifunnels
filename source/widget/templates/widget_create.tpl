<script type="text/javascript" src="/skin/_js/typedtags.js"></script>
<form action="" method="POST" enctype="multipart/form-data" class="wh validate" >
{if !empty($arrErrors)}<p class="error">Error! Fill all required fields.</p>{/if}
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label>Primary Keyword <em>*</em></label><input type="text"  id="primary_keyword" name="arrData[primary_keyword]" value="{$arrData.primary_keyword}" class="required" />{if $arrErrors.primary_keyword}<span class="error">this fields can't be empty</span>{/if}
		</li>
		<li>
			<label>Sorting <a href="" id="add">Add</a></label>
				<input type="text" id="sort_by" name="arrData[sort_by]" value="{$arrData.sort_by|escape:'htmlall'}" class="required" style="display:none;"/>
				<fieldset style="padding:0px;">
					<ol id="add_sorting" style="padding-start-value: 0px;"></ol>
				</fieldset>
		</li>
		<li style="padding:5px 230px;">
			Only return keywords with <input type="text" id="wordInKeyword" value="0" style="width:40px;"/> words or less.
		</li>
		<li style="padding:5px 230px;">
			Return <input type="text" id="keywordNeed" value="300" style="width:40px;"/> keywords.
		</li>
		<li>
			<label>Keywords List <em>*</em></label><textarea rows="15" id="keywords" name="arrData[keywords_list]" WRAP="OFF" style="width:750px;">{$arrData.keywords_list}</textarea>{if $arrErrors.keywords_list}<span class="error">this fields can't be empty</span>{/if}
		</li>
		<p>If you are creating more than one tag, Separate Each Tags with (,) comma or newline separated</p>
		<li>
			<label>&nbsp;</label><input type="button"  id="get" disabled="disabled" value="Get"/>
		</li>
	</ol>
	<ol>
		<li>
			<label></label><input type="submit" value="Submit"  />
		</li>
	</ol>
</fieldset>
</form>
{literal}
<script type="text/javascript">
var Selecter = new Class({
	Implements: Options,
	options: {
		injectTo: null,
		addButton: null,
		jsonSortList: null,
		jsonOrderList: null,
		jsonSort: null
	},
	initialize: function(options){
		this.setOptions(options);
		this.options['arrFields'] = new Hash(JSON.decode( this.options.jsonSortList ));
		this.options['arrOrders'] = new Hash(JSON.decode( this.options.jsonOrderList ));
		this.options['arrSort'] = new Hash(JSON.decode( this.options.jsonSort ));
		new Element ( 'li[style="padding-left:0px;"]' )
		.adopt(
			this.options['select'] = new Element( 'select#changer' ),
			new Element( 'span[html=" sorting by: "]' ),
			this.options['select_type'] = new Element( 'select#types[style="width: 150px;"]' )
		)
		.inject( $(this.options.injectTo) );
		this.options.arrOrders.each( function (v,id) {
			this.options.select_type.adopt(
				new Element('option[value="'+id+'"][html="'+v+'"]')
			)
		}.bind(this));
		this.options.arrSort.each ( function (val, id) {
			if ( id != 'wordInKeyword' && id != 'keywordNeed' ) {
				this.addDelete( id, this.options.arrFields[id], this.options.select_type.getElement('option[value='+val+']').get('text') );
				delete ( this.options.arrFields[id] );
			} else {
				$(id).set({'value':val});
			}
		}.bind( this ));
		this.injectOptions();
		$(this.options.addButton).addEvent ( 'click' , function (el) {
			this.clickAdd (el);
		}.bind( this ));
	},
	injectOptions: function() {
		this.options.select.empty();
		this.options.arrFields.each( function (v,id) {
			this.options.select.adopt(
				new Element( 'option[value="'+id+'"][html="'+v+'"]' )
			);
		},this);
		if ( this.options.arrFields.length == 0 ) {
			$('changer').setStyle("display","none");
			$('types').setStyle("display","none");
			$(this.options.addButton).setStyle("display","none");
		}
	},
	clickDelete: function ( _event ) {
		_event.stop();
		this.options.arrFields[_event.target.getParent().get('pid')]=_event.target.getParent().getChildren( '.title_text' ).get('text');
		this.options.arrSort.erase( _event.target.getParent().get('pid') );
		_event.target.getParent().destroy();
		this.injectOptions();
		$('changer').setStyle("display","inline");
		$('types').setStyle("display","inline");
		$(this.options.addButton).setStyle("display","inline");
	},
	clickAdd: function ( _event ) {
		_event.stop();
		var selectOption = $('changer').getSelected();
		var selectType = $('types').getSelected();
		if ( selectOption.get('value') == '' ) {
			return false;
		}
		this.addDelete( selectOption.get('value'), selectOption[0].innerHTML, selectType[0].innerHTML);
		var jsonObj = '{"'+selectOption.get('value')+'":"'+selectType.get('value')+'"}';
		this.options.arrSort.extend(JSON.decode( jsonObj ));
		this.options.arrSort.extend({});
		delete ( this.options.arrFields[selectOption.get('value')] );
		this.injectOptions();
	},
	sendJson: function () {
		this.options.arrSort.extend({'wordInKeyword':$('wordInKeyword').value, 'keywordNeed':$('keywordNeed').value});
		$('sort_by').set('value', JSON.encode(this.options.arrSort));
		var send_object=new Object( {'ordering':JSON.decode(JSON.encode(this.options.arrSort))} );
		return send_object;
	},
	addDelete: function ( pid, title, sort) {
		new Element ( 'li[pid="'+pid+'"]' )
		.adopt(
			new Element( 'span[html="Sorting by \""]' ),
			new Element( 'span[html="'+title+'"][class="title_text"]' ),
			new Element( 'span[html="\" field ('+sort+'). "]' ),
			new Element( 'a', { href:'','class':'del',html: 'Remove',
				events: {
					click: function( el ){
						this.clickDelete ( el );
					}.bind( this )
				}
			})
		)
		.inject( $(this.options.injectTo) );
	}
});


window.addEvent('domready',function(){
	var selectSorting = new Selecter({
		injectTo: "add_sorting",
		addButton: "add",
		jsonSortList: '{/literal}{$arrFields|json}{literal}',
		jsonOrderList: '{/literal}{$arrOrder|json}{literal}',
		jsonSort: '{/literal}{$arrData.sort_by}{literal}'
	});
	$('primary_keyword').addEvent('keyup', function(){
		if( this.value != ''){
			$('get').disabled=false;
			return;
		}
		$('get').disabled=true;
	});
	$('get').addEvent('click',function(e){
		var request=new Request({
			url:'{/literal}{url name='widget' action='ajax_get'}{literal}',
			onComplete: function(){
				$('keywords').setStyle('background',"#F9F9F9");
			},
			onLoadstart: function(){
				$('keywords').setStyle('background',"url('/skin/i/frontends/design/ajax-loader-big.gif') center no-repeat");
			},
			onSuccess: function( r ){
				r=JSON.decode(r);
				var str='';
				if ( r != null ) {
					r.keywords.each(function(el){
						str+=el+"\n";
					});
				}
				$('keywords').set( 'value', str );
			}
		}).post(Hash.toQueryString( {keyword:$('primary_keyword').value} ) +"&"+Hash.toQueryString( selectSorting.sendJson() ));
	})
});


</script>
{/literal}