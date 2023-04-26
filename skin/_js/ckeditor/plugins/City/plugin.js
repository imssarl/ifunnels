(function() {
	CKEDITOR.TRISTATE_OFF;
	CKEDITOR.plugins.add('City', {
		init: function(editor) {
			editor.addCommand('City', { exec: function(e) {
				editor.insertHtml( '#city#' );
			}});
			editor.ui.addButton('City', {
				label: 'City Tag',
				icon: this.path + 'city.png',
				command: 'City'
			});
			CKEDITOR.dialog.add('dialogplugin', this.path + 'dialogs/dialogplugin.js');
		}
	});
})();