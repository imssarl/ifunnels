{include file='../../box-top.tpl' title=$arrNest.title}

<form  class="wh" action="" method="post" id="opt-form">
<fieldset>
	<div class="form-group">
		<label>Include Code</label>
		<div class="radio radio-primary">
			<input type="radio" name="optArt" id="select"  class="opt-radio select_one" title="radio"  value="art">
			<label>Display single article</label>
		</div>
		<div class="radio radio-primary">
			<input type="radio" name="optArt"  class="opt-radio"  value="randart">
			<label>Display random articles from the category</label>
		</div>
		<div class="radio radio-primary">

		</div>
		<div class="radio radio-primary">
			<input type="radio" name="optArt" id="select"  class="opt-radio select_two" title="checkbox" class="opt-radio"   value="artcat">
			<label>Display a number of articles from the category</label>
		</div>
		<div class="radio radio-primary">
			<input type="radio" name="optArt"   class="opt-radio"  value="kwdart">
			<label>Display keyword relevant article</label>
		</div>
		<div class="radio radio-primary">
			<input type="radio" name="optArt"  class="opt-radio"   value="artsnip">
			<label>Display article snippets</label>
		</div>
	</div>
</fieldset>

<fieldset>
		<div class="form-group">
			<!--start Multibox-->
			<div id="multibox-select">
				{module name='site1_articles' action='multiboxplace'  place='select_one' type='single'}
				{module name='site1_articles' action='multiboxplace'  place='select_two' type='single'}
				<div id="articleList"></div>
			</div>
			<!--end Multibox-->
			
			<div id="manager-box" style="display:none;">

				<div class="manage-item-block" id="randart-box" style="display:none;">
					<div class="form-group">
						<label>Enter the number of random articles</label>
						<input type="text" name="random_number" id="random_number" class=" small-input form-control"/>
					</div>
					<div class="form-group">
						<label>Select Category</label>
						<select name="category_randart" id='category-filter' class=" medium-input btn-group selectpicker show-tick">
							<option value='all'> All category </option>
							{html_options options=$arrSelect.category selected=$smarty.post.category}
						</select>
					</div>
				</div>
				
				<div class="manage-item-block" id="kwdart-box" style="display:none;">
					<div class="form-group">
						<label>Enter a keyword</label>
						<input type="text" name="keyword" id="keyword" class=" medium-input form-control"/>
					</div>
					<div class="form-group">
						<label>Select Category</label>
						<select name="category_kwdart" id='category-filter' class=" medium-input btn-group selectpicker show-tick">
							<option value='all'> All category </option> 
							{html_options options=$arrSelect.category selected=$smarty.post.category}
						</select>
					</div>
				</div>
				
				<div class="manage-item-block" id="artsnip-box" style="display:none;">
					<div class="form-group">
						<label>Enter the number of article snippets</label>
						<input type="text" name="snippets_number" id="snippets_number" class=" small-input form-control" />
					</div>
					<div class="form-group">
						<label>Select Category</label>
						<select name="category_artsnip" id='category-filter' class=" medium-input btn-group selectpicker show-tick">
							<option value='all'> All category </option>
							{html_options options=$arrSelect.category selected=$smarty.post.category}
						</select>
					</div>
				</div>
				
			</div>
			
		</div>
		<div class="form-group">
			<button class="btn btn-success waves-effect waves-light" type="button" id="get_code" style="display:none;">Get Code</button>
			<!--<input type="button" class="button" value="Get Code" id="get_code" {is_acs_write} style="display:none;" >-->
		</div>
		<div id="block_php_code" style="display:none;">
			<div class="form-group">
				<textarea id="php_code" name="php_code" class=" text-input textarea form-control" style="width:100%; height:400px;"></textarea>
			</div>
			<div class="form-group">
				<button type="button" class="button btn btn-success waves-effect waves-light" id="save_code_view" {is_acs_write}>Save Generated Code</button>
			</div>
		</div>
		<div id="code_save_params" style="display:none;">
			<legend><b>Save Selected Code</b></legend>
			<p>
				<label>Add Code Title</label>
				<input type="text" name="code_title" id="code_name" class=" medium-input" />
			</p>
			<p>
				<label>Add Code Description</label>
				<textarea name="code_desc" id="code_desc" class=" text-input textarea" style="height:150px;"></textarea>
			</p>
			<p>
				<input type="button" {is_acs_write} value="Save" class="button" id="save_code"/>
			</p>
		</div>
		<div id="saved_code_message"></div>
</fieldset>

</form>
{include file='../../box-bottom.tpl'}

{literal}
<script type="text/javascript">
var articleList = new Class({
	Implements: Options,
	options: {
		jsonData:'',
		place:'',
		contentDiv:$('articleList')
	},
	initialize: function( options ){
		this.setOptions( options );
		this.hash = JSON.decode( this.options.jsonData );
	},
	set: function(){
		this.options.contentDiv.empty();
		$('multibox_ids_' + this.options.place ).value = JSON.encode( this.hash );
		var header = new Element( 'div' );
		var b = new Element( 'b' ).set( 'html','<br /><br />Selected articles' ).inject( header );
		header.inject( this.options.contentDiv );
		this.hash.each( function( value, key ) {
			key++ ;
			var div = new Element( 'div' );
			var name = new Element( 'p' );
			name.set( 'html',key + '. ' + value.title.substr( 0, 50 ) + ' <a href="#" class="delete_article_' + this.options.place + '" rel="' + value.id + '">Delete from list</a>' );
			name.inject( div );
			div.inject( this.options.contentDiv );
		},this );	
		this.initDeleteArticle();
	},
	initDeleteArticle: function() {
		$$( '.delete_article_' + this.options.place ).each( function( el ) {
			el.addEvent( 'click',function( e ) {
				e && e.stop();
				var arr = new Array();
				var i = 0;
				this.hash.each( function( value, key ) {
					if( value.id != el.rel ) {
						arr[ i ] = value;
						i++;
					}
				} );
				this.hash = arr;
				this.set();
			}.bind( this ) );
		},this );
	}	
	
});

var activeRadio = {};

$('save_code_view').addEvent('click',function(){
	$('code_save_params').style.display='block';
	$('saved_code_message').empty();
});

$$('.opt-radio').each(function(el){
	el.addEvent('click', function(){
		activeRadio = el;
		$$('.manage-item-block').each(function(block){
			block.style.display='none';
		});
		$('articleList').empty();
		$('multibox_ids_select_one').value='';
		$('multibox_ids_select_two').value='';
		$('opt-block-multimanage_select_two').style.display='none';
		$('opt-block-multimanage_select_one').style.display='none';
		$('get_code').style.display='none';
		$('block_php_code').style.display='none';
		$('code_save_params').style.display='none';
		$('saved_code_message').empty();		
		
		if(el.hasClass('select_one')) { // if multibox-select
			$('multibox-select').style.display='block';
			$('manager-box').style.display='block';
			if( $(el.value+'-box') ) { $(el.value+'-box').style.display = 'block';	}
			$('get_code').style.display='block';			
			$('opt-block-multimanage_select_one').style.display='block';
			$('opt-block-multimanage_select_two').style.display='noen';
		} else if(el.hasClass('select_two')) { // if multibox-select
			$('multibox-select').style.display='block';
			$('manager-box').style.display='block';
			if( $(el.value+'-box') ) { $(el.value+'-box').style.display = 'block';	}
			$('get_code').style.display='block';			
			$('opt-block-multimanage_select_two').style.display='block';
			$('opt-block-multimanage_select_one').style.display='none';
		} else	{
			$('multibox-select').style.display='none';
			$('manager-box').style.display='block';
			$('get_code').style.display='block';
			if( $(el.value+'-box') ) { $(el.value+'-box').style.display = 'block'; }
		}
	});
});

/*
 * 
 */
$('get_code').addEvent('click', function(){
	if(activeRadio.hasClass('select_one')) { // if multibox-select
		
		var hash = new Hash( JSON.decode($('multibox_ids_select_one').value ) );
		var numIds = hash.getLength();
		if(numIds <= 0) { alert("Please select one row.");	return false; }
		
	}else if(activeRadio.hasClass('select_two')) { // if multibox-select
		
		var hash = new Hash( JSON.decode($('multibox_ids_select_two').value ) );
		var numIds = hash.getLength();
		if(numIds <= 0) { alert("Please select one row.");	return false; }
		
	} else {
		
		var anum=/(^\d+$)|(^\d+\.\d+$)/;
		 if( activeRadio.value == 'randart' ) {
		 	if( !parseInt($('random_number').value) ) {  alert("Enter a valid positive number.");	return false; 	}
		 } else if(  activeRadio.value == 'kwdart' ) {
		 	if( $('keyword').value == '' || anum.test($('keyword').value) ) {  alert("Enter a valid keyword.");	return false; 	}
		 } else if(  activeRadio.value == 'artsnip' ) {
		 	if( !parseInt($('snippets_number').value) ) {  alert("Enter a valid positive number.");	return false; 	}
		 }
	}
	
	$('block_php_code').style.display='block';
	var req = new Request({url: "{/literal}{url name='site1_articles' action='generatecode'}{literal}", onSuccess: function(responseText){
	 	$('php_code').value = responseText;
	} }).post($('opt-form'));
});



/* 
 *	Save php code.
 */
$('save_code').addEvent('click', function(){
	if($('code_name').value == '' || $('code_desc').value == '' ) {
		alert('Please enter both details before saving the code');
		return false;
	}
	var req = new Request({url: "{/literal}{url name='site1_articles' action='generatecode'}?save_code=1{literal}", onSuccess: function(responseText){
	 	$('saved_code_message').set('html',responseText);
	 	$('code_save_params').style.display = 'none';
	 	$('code_name').value = '';
	 	$('code_desc').value = '';
	} }).post($('opt-form'));	
});


</script>
{/literal}
