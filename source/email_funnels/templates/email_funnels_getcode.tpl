<!DOCTYPE html>
<html>
<head>
	{module name='site1' action='head' type='mini'}
<style>{literal}
input[type="text"]{
	margin-right: 4px;
	width: 200px;
	display: inline-block;
}
 {/literal}</style>
</head>
<body>
	<div class="card-box">
        <div class="form-group">
            <button class="btn btn-default waves-effect waves-light" type="button" id="add_new">Add New Element</button>
        </div>
			<div class="form-group update_group" rel="0">
				<label>Redirect URL (after submitting the form)</label>
				<input type="hidden" value="ef_redirect_url" class="get_name form-control hidden" />
				<input type="text" value=""class="get_value update_elements_0 form-control" />
				<input type="hidden" value=""class="get_placeholder update_elements_0 form-control" disabled />
			</div>
			<ul id="sortable" class="connectedSortable" style="list-style-type:none;-webkit-padding-start:0px;">
				<li class="form-group update_group" rel="1">
					<input type="text" value="email" class="get_name form-control" disabled />
					<input type="text" value="Input Your Email Address Here" placeholder="Email Placeholder" class="get_placeholder update_elements_1 form-control" />
				</li>
				<li class="form-group update_group" rel="2">
					<input type="text" value="tags" class="get_name form-control" disabled />
					<input type="text" value="" placeholder="" class="get_value update_elements_2 form-control" />
					<input type="text" value="" placeholder="Hidden element" class="get_placeholder update_elements_2 form-control" disabled />
				</li>
			</ul>
        <div class="form-group" id="new_elements">
        	<textarea class="form-control" id="form"><form action="https://fasttrk.net/email-funnels/getcode/" method="POST" enctype="multipart/form-data"><input type="hidden" name="code" value="{$code}" /><input type="hidden" name="ef_redirect_url" rel="0" /><input type="email" name="email" value="" placeholder="Input Your Email Address Here" /><input type="hidden" name="tags" value="" /><input type="submit" value="Submit" /></form></textarea>
			<div id="update_form" style="width:1px;height:1px;overflow:hidden;"></div>
        </div>
        <div class="form-group">
            <button class="btn btn-default waves-effect waves-light clipboard" type="button" data-clipboard-target="#form">Copy to clipboard</button>
        </div>
	</div>
<script type="text/javascript" src="/skin/_js/clipboard.min.js"></script>
<link rel="stylesheet" href="/skin/_js/jquery-ui/jquery-ui.css">
<script type="text/javascript" src="/skin/_js/jquery-ui/jquery-ui.js"></script>

 {literal}
<script type="text/javascript">
// sortable code
jQuery( "#sortable" ).sortable({
	connectWith: ".connectedSortable",
	placeholder: "ui-state-highlight form-group"
});
var sortAction=function(){
	jQuery( '#sortable li' ).each( function( _index, item ){
		var childName=jQuery(item).children( '.get_name' ).val();
		if( childName != '' ){
			var moveElement=jQuery( '#update_form form' ).children( '[name='+childName+']' ).clone( true );
			jQuery( '#update_form form' ).children( '[name='+childName+']' ).remove();
			moveElement.clone( true );
			jQuery( '#update_form form input[type="submit"]' )
				.before(moveElement);
		}
	});
	jQuery('#form').text( jQuery( '#update_form' ).html() );
}
jQuery( "#sortable" ).bind( "sortstop", function(){sortAction();});

var clipboard = new ClipboardJS('.clipboard');
clipboard.on('success', function(e) {
	jQuery( '.clipboard' ).html( 'Copied to clipboard' );
	e.clearSelection();
});
var updateElements=function( parent ){
	var getParentRel=jQuery(parent).attr('rel');
	if( jQuery(parent).children( '.get_name' ).val() == '' ){
		jQuery( '#update_form form' ).children( '[rel="'+getParentRel+'"]' ).remove();
	}
	if( jQuery( '#update_form form' ).children( '[rel="'+getParentRel+'"]' ).length == 0 ){
		var addElement='';
		if( jQuery(parent).children( '.get_name' ).val() != '' ){
			addElement=addElement+' name="'+jQuery(parent).children( '.get_name' ).val()+'"';
		}
		if( jQuery(parent).children( '.get_value' ).val() != '' ){
			addElement=addElement+' value="'+jQuery(parent).children( '.get_value' ).val()+'"';
		}
		if( jQuery(parent).children( '.get_placeholder' ).val() != '' ){
			addElement=addElement+' placeholder="'+jQuery(parent).children( '.get_placeholder' ).val()+'"';
		}
		if( addElement != '' ){
			addElement='<input rel="'+getParentRel+'" type="text"'+addElement+' />';
		}
		jQuery( '#update_form form input[type="submit"]' )
			.before(addElement);
	}else{
		var updateElt=jQuery( '#update_form form' ).children( '[rel="'+getParentRel+'"]' );
		updateElt.attr( 'name', jQuery(parent).children( '.get_name' ).val() );
		if( jQuery(parent).children( '.get_value' ).val() != '' ){
			updateElt.attr( 'value', jQuery(parent).children( '.get_value' ).val() );
		}else{
			updateElt.removeAttr('value');
		}
		if( jQuery(parent).children( '.get_placeholder' ).val() != '' ){
			updateElt.attr( 'placeholder', jQuery(parent).children( '.get_placeholder' ).val() );
		}else{
			updateElt.removeAttr('placeholder');
		}
	}
	jQuery( '#update_form form' ).children( '[name=""]' ).remove();
	jQuery('#form').text( jQuery( '#update_form' ).html() );
	sortAction();
}

jQuery( '#add_new' ).click(function(){
	var updateCounter=1;
	if( jQuery('.update_group').length > 0 ){
		updateCounter=parseInt( jQuery( jQuery('.update_group')[jQuery('.update_group').length-1] ).attr('rel') )+1; 
	}
	jQuery( '#sortable' ).append(
		'<li class="form-group update_group ui-sortable-handle" rel="'+updateCounter+'">'+
			'<input type="text" value="" placeholder="Element Name" class="get_name form-control update_elements_'+updateCounter+'" />'+
			'<input type="text" value="" placeholder="Element Value" class="get_value form-control update_elements_'+updateCounter+'" />'+
			'<input type="text" value="" placeholder="Element Placeholder" class="get_placeholder form-control update_elements_'+updateCounter+'" />'+
			'<a href="#'+updateCounter+'" data-id="'+updateCounter+'" class="element_'+updateCounter+'_delete" style="display:inline-block;width:10%;"><i class="ion-trash-a" style="font-size:20px;vertical-align:bottom;color: #AC1111;margin:2px 5px;"></i></a>'+
		'</li>'
	);
	jQuery( '.element_'+updateCounter+'_delete' ).click(function(){
		elementOldName=jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val();
		jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val('');
		updateElements( jQuery( this ).parent('li')[0] );
		jQuery('li.form-group[rel="'+updateCounter+'"]').remove();
	});
	jQuery( '#update_form' ).html( jQuery('#form').text() );
	jQuery( '.update_elements_'+updateCounter).on( 'keyup', function(){
		updateElements( jQuery( this ).parent('li')[0] );
	});
	jQuery( '.update_elements_'+updateCounter).on( 'focusout', function(){
		updateElements( jQuery( this ).parent('li')[0] );
	});
	jQuery( '.update_elements_'+updateCounter).on( "keydown", function(){
		elementOldName=jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val();
	});
	jQuery( '.update_elements_'+updateCounter).on( "focus", function(){
		elementOldName=jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val();
	});
});

// redirect element
jQuery( '#update_form' ).html( jQuery('#form').text() );
jQuery( '.update_elements_0').on( 'keyup', function(){
	updateElements( jQuery( this ).parent('div')[0] );
});
jQuery( '.update_elements_0').on( 'keydown', function(){
	elementOldName=jQuery( jQuery( this ).parent('div')[0] ).children( '.get_name' ).val();
});
jQuery( '.update_elements_0').on( "focus", function(){
	elementOldName=jQuery( jQuery( this ).parent('div')[0] ).children( '.get_name' ).val();
});
jQuery( '.update_elements_0').on( "focusout", function(){
	updateElements( jQuery( this ).parent('div')[0] );
});

// email element
jQuery( '#update_form' ).html( jQuery('#form').text() );
jQuery( '.update_elements_1').on( 'keyup', function(){
	updateElements( jQuery( this ).parent('li')[0] );
});
jQuery( '.update_elements_1').on( 'keydown', function(){
	elementOldName=jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val();
});
jQuery( '.update_elements_1').on( "focus", function(){
	elementOldName=jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val();
});
jQuery( '.update_elements_1').on( "focusout", function(){
	updateElements( jQuery( this ).parent('li')[0] );
});

// tags element
jQuery( '.update_elements_2').on( 'keyup', function(){
	updateElements( jQuery( this ).parent('li')[0] );
});
jQuery( '.update_elements_2').on( 'keydown', function(){
	elementOldName=jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val();
});
jQuery( '.update_elements_2').on( "focus", function(){
	elementOldName=jQuery( jQuery( this ).parent('li')[0] ).children( '.get_name' ).val();
});
jQuery( '.update_elements_2').on( "focusout", function(){
	updateElements( jQuery( this ).parent('li')[0] );
});

 </script>
{/literal}
</body>
</html>