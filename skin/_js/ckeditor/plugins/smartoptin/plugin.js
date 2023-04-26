(function() {
	CKEDITOR.TRISTATE_OFF;
	CKEDITOR.plugins.add('smartoptin', {
		init: function(editor) {
			editor.addCommand('trigger_smart_optin_run', { 
				exec: function(e) {
					var selection = editor.getSelection();
					if( selection ){
						var bookmarks = selection.createBookmarks(),
							range = selection.getRanges()[ 0 ],
							fragment = range.clone().cloneContents();
						selection.selectBookmarks( bookmarks );
						var retval = "",
							childList = fragment.getChildren(),
							childCount = childList.count();
						for ( var i = 0; i < childCount; i++ ){
							var child=childList.getItem( i );
							retval+=( child.getOuterHtml?child.getOuterHtml():child.getText() );
						}
					}
					var retval_string=retval.replace(/<a[^>]*>([^<]*)<\/a>/img, '$1');
					var newElement = new CKEDITOR.dom.element('a');
						newElement.addClass('fancybox');
						newElement.addClass('get-button');
						newElement.setAttributes({href: '#fancybox-form', style: 'text-decoration:none;'});
						newElement.appendHtml( retval_string );
						editor.insertElement( newElement ); 
				}
			});
			editor.ui.addButton('smartoptin', {
				label: 'Trigger Smart Optin',
				icon: this.path + 'button.jpg',
				command: 'trigger_smart_optin_run'
			});
			//CKEDITOR.dialog.add('dialogplugin', this.path + 'dialogs/dialogplugin.js');
		}
	});
})();