(function() {
	CKEDITOR.TRISTATE_OFF;
	CKEDITOR.plugins.add('AffiliateLink', {
		init: function(editor) {
			editor.addCommand('AffiliateLink', { exec: function(e) {
				if(!confirm('Add affiliate link?')){
					return false;
				}
				if( editor.getSelection().getSelectedText().length < 1 ){
					return false;
				}
				element = editor.document.createElement( 'a' );
				element.setAttribute( 'href', 'http://#affiliateID#.#vendorID#.hop.clickbank.net' );
				element.setHtml( editor.getSelection().getSelectedText() );
				editor.insertElement( element );
			}});
			editor.ui.addButton('AffiliateLink', {
				label: 'Affiliate Link',
				icon: this.path + 'Affiliate.png',
				command: 'AffiliateLink'
			});
			CKEDITOR.dialog.add('dialogplugin', this.path + 'dialogs/dialogplugin.js');
		}
	});
})();