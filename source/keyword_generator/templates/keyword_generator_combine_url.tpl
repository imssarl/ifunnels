<form action="#res" method="POST" class="wh" >
	<fieldset>
		<legend>URL Mixer</legend>
		<div class="form-group">
			<label>URLs</label>
			<textarea id="urls" style="height:100px;" class="medium-input form-control"></textarea>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="regular" checked='1' name="regular" value="1"/>
				<label>Regular</label>
			</div>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="quotes" name="quotes" value="2"/>
				<label>Quotes</label>
			</div>
			 
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="brackets" name="brackets" value="3"/>
				<label>Brackets</label>
			</div>
		</div>
		<div class="form-group">
			<button type="button" class="button btn btn-success waves-effect waves-light" id="generate" {is_acs_write}>Generate</button>
		</div>
	</fieldset>
	<fieldset style="display:none;" id="field_res">
		<div class="form-group">
			<label>Result</label>
			<textarea id="res" name="result" class="medium-input form-control" style="height:200px;"></textarea>
		</div>
		<div class="form-group">
			<label>File name</label>
			<input type="text" class="text-input medium-input form-control" name="name" />
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" name="export" {is_acs_write}>Export</button>
		</div>
	</fieldset>
</form>
<script type="text/javascript">
{literal}
	window.addEvent('domready', function(){
		$('generate').addEvent('click',function(){
			if(!$('urls').value) {
				r.alert( 'Warning', 'Field URLs can not be empty' , 'roar_warning' );
				return false;
			}
			var obj = new Generate($('urls'));
		});
	});
	var Generate = new Class({
		initialize: function(textarea){
			this.el = textarea;
			this.resEl = $('res');
			this.urls = textarea.value;
			this.view = {'regular':true, 'quotes': false, 'brackets': false};
			this.initTypeView(); 
			this.generateUrl();
		},
		initTypeView:function(){
			if( $('regular').checked )
				this.view.regular = true;
			else this.view.regular = false;
			if( $('quotes').checked )
				this.view.quotes = true;
			else this.view.quotes = false;
			if( $('brackets').checked )
				this.view.brackets = true;
			else this.view.brackets = false;
			if (!$('brackets').checked && !$('quotes').checked && !$('regular').checked ){
				this.view.regular = true;
			}
		},
		getUrl:function(){
			var urls = new String(this.urls);
			urls = urls.replace(/\n/ig,'@');
			var arrUrls = this.explode('@',urls);
			var i=0;
			var arrRes = new Array();
			arrUrls.each( function( s ){
				if( s ) {
					arrRes[i] = s.replace( 'www.', '' );
					i++;
				};
			});
			return arrRes;
		}, 
		explode: function( delimiter, string ) {    
    		return string.toString().split ( delimiter.toString() );
		},
		generateUrl: function(){
			var strRes = '';	
			var URLs = this.getUrl();
			if( this.view.regular ) {
				strRes += this.print(URLs,'','');
			}
			if( this.view.quotes ) {
				strRes += this.print(URLs,'"','"');
			}
			if( this.view.brackets ) {
				strRes += this.print(URLs,'[',']');
			}
			this.resEl.value = strRes; 
			$('field_res').show('block');
		},
		print: function(URLs,left,right){
			var strRes = '';
			URLs.each(function(value){
				var str = new String(value);
				match = str.match(/(.*)\.(.*)/i);
				if( !match ) {
					match = str.match(/(.*)/i);
				}
				if( match ) {
					var name = match[1];
					if( !match[2] ) { match[2] = '' }
					var domen = match[2];
					strRes = strRes + left + value + right + '\n';
					strRes = strRes + left +'www.' + value + right +'\n'; 
					strRes = strRes + left + name + ' ' + domen + right +'\n';
					strRes = strRes + left +'www ' + name + ' ' + domen + right +'\n';
					strRes = strRes + left + '' + name + '' + domen + right +'\n';
					strRes = strRes + left + 'www' + name + '' + domen + right +'\n';
				};
			});
			return strRes;
		}
	});
{/literal}	
</script>