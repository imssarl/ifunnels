(function() {
	CKEDITOR.TRISTATE_OFF;
	CKEDITOR.plugins.add('ClickThrough', {
		init: function(editor) {
			editor.addCommand('ClickThroughClick', {
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
						newElement.addClass('get-button');
						newElement.setAttributes({href: '#redirect-url', style: 'text-decoration:none;'});
						newElement.appendHtml( retval_string );
						editor.insertElement( newElement ); 
				}
			});
			editor.ui.addButton('ClickThrough', {
				label: 'Click Through',
				icon: this.path + 'ClickThrough.png',
				command: 'ClickThroughClick'
			});
		}
	});
})();