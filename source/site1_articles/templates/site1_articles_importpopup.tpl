<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
{module name='site1_articles' action='import' return=$return_type} 
{literal}<script type="text/javascript">
var choose = function(){
	var hashIds = JSON.decode(Ids);
	hashIds.each(function(value,key){
		if( !$chk( value['flg_type'] ) )
			value['flg_type']="0";
	});
	hash.each(function(value,key){
		value['flg_type']="0";
		hashIds.include(value);
	});
	Ids = JSON.encode(hashIds);
	new window.parent.multiboxArticle( {jsonData:Ids, place:'{/literal}{$smarty.get.place}{literal}'} );
}

var hash = new Hash({});	
window.addEvent('load', function(){
	if( window.parent.$('multibox_ids_{/literal}{$smarty.get.place}{literal}') && window.parent.$('multibox_ids_{/literal}{$smarty.get.place}{literal}').value ) {
		hash = JSON.decode( window.parent.$('multibox_ids_{/literal}{$smarty.get.place}{literal}').value );
	}	
	if(saveArticleTrue == 1) {
		choose();
		window.parent.multibox_article.boxWindow.close();
	}
});
</script>{/literal}
</body>
</html>