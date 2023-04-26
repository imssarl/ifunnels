/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {

	config.contentsCss = '/skin/_js/ckeditor/fonts.css';
	//the next line add the new font to the combobox in CKEditor
	config.font_names = 'Patua One/Patua One;' + config.font_names;
	config.font_names = 'Nanum Brush Script/Nanum Brush Script;' + config.font_names;
	config.font_names = 'Alegreya Sans/Alegreya Sans;' + config.font_names;
	config.font_names = 'Bree Serif/Bree Serif;' + config.font_names;
	config.font_names = 'Abril Fatface/Abril Fatface;' + config.font_names;
	config.font_names = 'Anton/Anton;' + config.font_names;
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.allowedContent = true;
	config.autoParagraph = false;
	
	config.extraPlugins = 'AffiliateLink,City,copyprophet,smartoptin,ClickThrough,lineheight';
	//config.toolbar = 'Full';

	config.toolbar_Full =
	[
		{ name: 'document', items : [ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ] },
		{ name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
		{ name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
		{ name: 'forms', items : [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton',
	        'HiddenField' ] },
		'/',
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
		'-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
		{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] },
		'/',
		{ name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'tools', items : [ 'Maximize', 'ShowBlocks','-','About' ] }
	];

	//config.toolbar = 'Clickbank';
	config.toolbar_Clickbank =
	[
		{ name: 'document', items : [ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ] },
		{ name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
		{ name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
		{ name: 'forms', items : [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton',
	        'HiddenField' ] },
		'/',
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
		'-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
		{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] },
		'/',
		{ name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'tools', items : [ 'Maximize', 'ShowBlocks','-','About' ] },
		{ name: 'clickbank', items : [ 'AffiliateLink' ] }
	];
	//config.toolbar = 'Basic_Posts';
	config.toolbar_Basic_Posts =
	[
		{ name: 'document', items : [ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ] },
		{ name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
		{ name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
		{ name: 'forms', items : [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton',
	        'HiddenField' ] },
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
		'-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
		{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] },
		{ name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'tools', items : [ 'Maximize', 'ShowBlocks','-','About' ] }
	];

	//config.toolbar = 'Basic_Squeeze_Header';
	config.toolbar_Basic_Squeeze_Header =
	[
		{ name: 'styles', items : [ 'Source','Styles','Format','Font','FontSize' ] },
		{ name: 'insert', items : [ 'Image' ] },
		{ name: 'clipboard', items : [ 'Undo' ] },
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'  ] },
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
		{ name: 'geoIp', items : [ 'City' ] },
		{ name: 'CP', items : [ 'copyprophet' ] },
		{ name: 'smartoptin', items : [ 'smartoptin', 'ClickThrough' ] }
	];

	//config.toolbar = 'Basic_Text';
	config.toolbar_Basic_Text =
	[
		{ name: 'styles', items : [ 'Source','Styles','Format','Font','FontSize' ] },
		{ name: 'clipboard', items : [ 'Undo' ] },
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] }
	];

	config.toolbar_Basic =
	[
		{ name: 'styles', items : [ 'Source','Styles','Format','Font','FontSize' ] },
		{ name: 'clipboard', items : [ 'Undo' ] },
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'  ] },
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] }

	];
	
	config.toolbar_Basic_Squeeze =
	[
		{ name: 'styles', items : [ 'Source','Styles','Format','Font','FontSize' ] },
		{ name: 'clipboard', items : [ 'Undo' ] },
		{ name: 'insert', items : [ 'Image' ] },
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'  ] },
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
		{ name: 'geoIp', items : [ 'City' ] },
		{ name: 'smartoptin', items : [ 'smartoptin', 'ClickThrough' ] }

	];
	
	config.toolbar_Contentbox =
	[
		{ name: 'styles', items : [ 'Source','Styles','Format','Font','FontSize' ] },
		{ name: 'clipboard', items : [ 'Undo' ] },
		{ name: 'insert', items : [ 'Image' ] },
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'  ] },
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
		{ name: 'geoIp', items : [ 'City' ] },
		{ name: 'lineheight', items : [ 'lineheight' ] },
		{ name: 'smartoptin', items : [ 'smartoptin', 'ClickThrough' ] }

	];
};
