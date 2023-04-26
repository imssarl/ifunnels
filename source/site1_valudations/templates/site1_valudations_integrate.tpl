<div class="card-box">
	<div class="form-group" id="new_elements">
		<textarea class="form-control" id="form"><script src="{Zend_Registry::get( 'config' )->domain->url}/validations/widget/?code={$code}"></script></textarea>
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
var clipboard = new ClipboardJS('.clipboard');
clipboard.on('success', function(e) {
	jQuery( '.clipboard' ).html( 'Copied to clipboard' );
	e.clearSelection();
});

 </script>
{/literal}
