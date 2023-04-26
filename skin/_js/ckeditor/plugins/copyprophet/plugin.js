CKEDITOR.plugins.add( 'copyprophet', {
    icons: 'copyprophet',
    init: function( editor ) {
        editor.addCommand( 'copyprophet', new CKEDITOR.dialogCommand( 'copyprophetDialog' ) );
        editor.ui.addButton( 'copyprophet', {
            label: 'Copy Prophet',
            command: 'copyprophet',
            toolbar: 'insert'
        });
        CKEDITOR.dialog.add( 'copyprophetDialog', function( alt ) {
			var cpfunctions={
				hexnib: function ( d ){
					if( d < 10 ) { 
						return d; 
					} else {
						return String.fromCharCode( 65 + d - 10 );
					}
				},
				hexcode: function( url ){
					var result="";
					for( var i=0; i < url.length; i++ ){
						var cc=url.charCodeAt(i);
						var hex= this.hexnib((cc&240)>>4)+""+this.hexnib(cc&15);
						result+=hex;
					}
					return result;		
				},
				convertHtmlToText: function ( returnText ) {
					returnText=returnText.replace(/<br*>/gi, "\n");
					returnText=returnText.replace(/<p*>/gi, "\n");
					returnText=returnText.replace(/<a*href="(.*?)"*>(.*?)<\/a>/gi, " $2 ($1)");
					returnText=returnText.replace(/<script*>[\w\W]{1,}(.*?)[\w\W]{1,}<\/script>/gi, "");
					returnText=returnText.replace(/<style*>[\w\W]{1,}(.*?)[\w\W]{1,}<\/style>/gi, "");
					returnText=returnText.replace(/<(?:.|\s)*?>/g, "");
					returnText=returnText.replace(/(?:(?:\r\n|\r|\n)\s*){2,}/gim, "\n\n");
					returnText = returnText.replace(/ +(?= )/g,'');
					returnText=returnText.replace(/&#39;/gi,"'");
					returnText=returnText.replace(/&nbsp;/gi," ");
					returnText=returnText.replace(/&amp;/gi,"&");
					returnText=returnText.replace(/&quot;/gi,'"');
					returnText=returnText.replace(/&lt;/gi,'<');
					returnText=returnText.replace(/&gt;/gi,'>');
					return returnText;
				}
			};
			return {
				title: 'Copy Prophet',
				minWidth: 400,
				minHeight: 200,
				contents: [{
					id: 'content_scores',
					label: 'Copy Prophet',
					elements: [{
						type: 'text',
						label: 'Score',
						id: 'score',
						value: '0',
						validate: function(){return true}
					},{
						type: 'textarea',
						id: 'parse',
						label: 'Text',
						value: '0',
						validate: function(){return true}
					}]
				}],
				onShow: function() {
					var stringData=cpfunctions.convertHtmlToText( CKEDITOR.instances[CKEDITOR.currentInstance.name].getData() );
					if( typeof ckeditorCopyProphetLink == 'undefined' ){
						this.setValueOf( 'content_scores', 'score', '0' );
						this.setValueOf( 'content_scores', 'parse', '' );
						return false;
					}
					var obj=this;
					new Request({
						url: ckeditorCopyProphetLink,
						method: 'post',
						data:"s="+cpfunctions.hexcode( stringData ),
						onSuccess: function( score ){
							obj.setValueOf( 'content_scores', 'score', score );
							obj.setValueOf( 'content_scores', 'parse', stringData );
						}
					}).send();
					return true;
				},
				buttons: [ CKEDITOR.dialog.okButton ]
			}
		});
    }
});